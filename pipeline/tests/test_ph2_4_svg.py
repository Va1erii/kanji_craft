"""Tests for Phase 2.4 SVG processing, hashing & upload."""

import hashlib
import json
import zipfile
from io import BytesIO
from pathlib import Path
from unittest.mock import MagicMock

import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import pytest
from lxml import etree

from src.extractors.ph2_4_svg import (
    _compute_bbox_from_paths,
    _generate_extracted_svg,
    extract_svg,
)
from src.extractors.shared import char_to_kvg_filename, char_to_svg_filename


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

MINIMAL_SVG = b'<svg xmlns="http://www.w3.org/2000/svg"><path d="M0 0"/></svg>'

SVG_BASE_URL = "https://test.supabase.co/storage/v1/object/public/kanji-craft"


def _make_zip(entries: dict[str, bytes], tmp_path: Path) -> Path:
    """Create a ZIP file with kanji/*.svg entries.

    entries: kvg_filename (e.g. '04e00.svg') → raw bytes
    """
    zip_path = tmp_path / "kanjivg-test-main.zip"
    buf = BytesIO()
    with zipfile.ZipFile(buf, "w") as zf:
        for name, data in entries.items():
            zf.writestr(f"kanji/{name}", data)
    zip_path.write_bytes(buf.getvalue())
    return zip_path


def _make_radicals_csv(csv_dir: Path, radicals: list[tuple]) -> pd.DataFrame:
    """Write radicals.csv. radicals: list of (master_symbol, stroke_count, jlpt) tuples."""
    columns = [
        "master_symbol", "is_official", "stroke_count", "visual_group",
        "svg_file_name", "svg_file_url", "svg_hash", "impact_score",
        "min_grade", "min_jlpt_level",
    ]
    rows = []
    for ms, sc, jlpt in radicals:
        rows.append({
            "master_symbol": ms,
            "is_official": False,
            "stroke_count": sc,
            "visual_group": None,
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
            "impact_score": None,
            "min_grade": None,
            "min_jlpt_level": jlpt,
        })
    df = pd.DataFrame(rows, columns=columns)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "radicals.csv", index=False)
    return df


def _make_variants_csv(csv_dir: Path, variants: list[tuple]) -> pd.DataFrame:
    """Write radical_variants.csv. variants: list of (master_symbol, shape) tuples."""
    columns = ["master_symbol", "shape", "positions", "svg_file_name", "svg_file_url", "svg_hash"]
    rows = []
    for ms, shape in variants:
        rows.append({
            "master_symbol": ms,
            "shape": shape,
            "positions": "hen",
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
        })
    df = pd.DataFrame(rows, columns=columns)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "radical_variants.csv", index=False)
    return df


def _make_kanji_csv(csv_dir: Path, kanji_list: list[tuple]) -> pd.DataFrame:
    """Write kanji.csv. kanji_list: list of (char, stroke_count, grade, jlpt) tuples."""
    columns = [
        "character", "stroke_count", "min_grade", "min_jlpt_level",
        "frequency_rank", "svg_file_name", "svg_file_url", "svg_hash",
    ]
    rows = []
    for char, sc, grade, jlpt in kanji_list:
        rows.append({
            "character": char,
            "stroke_count": sc,
            "min_grade": grade,
            "min_jlpt_level": jlpt,
            "frequency_rank": 1,
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
        })
    df = pd.DataFrame(rows, columns=columns)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji.csv", index=False)
    return df


def _mock_client(remote_radicals: list[str] | None = None, remote_kanji: list[str] | None = None):
    """Create a mock Supabase client.

    remote_radicals/remote_kanji: filenames already in storage.
    """
    client = MagicMock()
    bucket_mock = MagicMock()

    rad_files = [{"name": f} for f in (remote_radicals or [])]
    kanji_files = [{"name": f} for f in (remote_kanji or [])]

    def list_folder(folder, *_args, **_kwargs):
        if folder == "radicals":
            return rad_files
        if folder == "kanji":
            return kanji_files
        return []

    bucket_mock.list.side_effect = list_folder
    bucket_mock.upload.return_value = None
    client.storage.from_.return_value = bucket_mock
    return client, bucket_mock


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------


@pytest.fixture
def basic_setup(tmp_path, monkeypatch):
    """Standard setup: 一(radical), 氵(variant of 水), 休(kanji).

    ZIP has SVGs for all three characters.
    """
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"

    # 一 = U+4E00 → 04e00.svg, 水 = U+6C34 → 06c34.svg,
    # 氵 = U+6C35 → 06c35.svg, 休 = U+4F11 → 04f11.svg
    zip_path = _make_zip({
        "04e00.svg": MINIMAL_SVG,
        "06c34.svg": MINIMAL_SVG,
        "06c35.svg": MINIMAL_SVG,
        "04f11.svg": MINIMAL_SVG,
    }, tmp_path)

    _make_radicals_csv(csv_dir, [("一", 1, 4), ("水", 4, 3)])
    _make_variants_csv(csv_dir, [("水", "氵")])
    _make_kanji_csv(csv_dir, [("休", 6, 2, 4)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)

    return csv_dir, warnings_dir, zip_path


# ---------------------------------------------------------------------------
# Tests: char_to_svg_filename / char_to_kvg_filename
# ---------------------------------------------------------------------------


@pytest.mark.parametrize(
    "char, expected",
    [
        ("一", "4e00.svg"),       # U+4E00 — BMP, 4-digit hex
        ("休", "4f11.svg"),       # U+4F11
        ("水", "6c34.svg"),       # U+6C34
        ("𠂉", "20089.svg"),     # U+20089 — SMP, 5-digit hex, no padding
        ("𠀋", "2000b.svg"),     # U+2000B — SMP, 5-digit hex
        ("龍", "9f8d.svg"),       # U+9F8D — BMP high range
        ("a", "61.svg"),          # U+0061 — ASCII (edge case, short hex)
    ],
    ids=["ichi", "yasumu", "mizu", "smp_20089", "smp_2000b", "ryuu", "ascii"],
)
def test_char_to_svg_filename(char, expected):
    """Storage filename: unpadded hex."""
    assert char_to_svg_filename(char) == expected


@pytest.mark.parametrize(
    "char, expected",
    [
        ("一", "04e00.svg"),      # U+4E00 — zero-padded to 5 digits
        ("休", "04f11.svg"),      # U+4F11
        ("水", "06c34.svg"),      # U+6C34
        ("𠂉", "20089.svg"),     # U+20089 — already 5 digits, no extra padding
        ("𠀋", "2000b.svg"),     # U+2000B — already 5 digits
        ("龍", "09f8d.svg"),      # U+9F8D — padded to 5 digits
        ("a", "00061.svg"),       # U+0061 — padded to 5 digits
    ],
    ids=["ichi", "yasumu", "mizu", "smp_20089", "smp_2000b", "ryuu", "ascii"],
)
def test_char_to_kvg_filename(char, expected):
    """KanjiVG filename: 5-digit zero-padded."""
    assert char_to_kvg_filename(char) == expected


# ---------------------------------------------------------------------------
# Tests: SVG field population
# ---------------------------------------------------------------------------


def test_basic_radical_svg(basic_setup):
    """Radical SVG fields populated correctly."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client, _ = _mock_client()

    result = extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    rad = result["radicals"]
    row = rad[rad["master_symbol"] == "一"].iloc[0]
    assert row["svg_file_name"] == "4e00.svg"
    assert row["svg_hash"] == hashlib.sha256(MINIMAL_SVG).hexdigest()
    assert row["svg_file_url"] == f"{SVG_BASE_URL}/radicals/4e00.svg"


def test_radical_variant_svg(basic_setup):
    """Variant shape matched and fields populated."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client, _ = _mock_client()

    result = extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    var = result["radical_variants"]
    row = var[var["shape"] == "氵"].iloc[0]
    assert row["svg_file_name"] == "6c35.svg"
    assert row["svg_hash"] == hashlib.sha256(MINIMAL_SVG).hexdigest()
    assert row["svg_file_url"] == f"{SVG_BASE_URL}/radicals/6c35.svg"


def test_kanji_svg(basic_setup):
    """Kanji character matched and fields populated."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client, _ = _mock_client()

    result = extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    kan = result["kanji"]
    row = kan[kan["character"] == "休"].iloc[0]
    assert row["svg_file_name"] == "4f11.svg"
    assert row["svg_hash"] == hashlib.sha256(MINIMAL_SVG).hexdigest()
    assert row["svg_file_url"] == f"{SVG_BASE_URL}/kanji/4f11.svg"


def test_sha256_deterministic():
    """Known bytes produce known hash."""
    data = b"test svg content"
    expected = hashlib.sha256(data).hexdigest()
    assert len(expected) == 64
    # Same bytes → same hash
    assert hashlib.sha256(data).hexdigest() == expected


def test_url_construction_radicals(basic_setup):
    """URL for radicals uses /radicals/ prefix."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client, _ = _mock_client()

    result = extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    rad = result["radicals"]
    row = rad[rad["master_symbol"] == "水"].iloc[0]
    assert row["svg_file_url"] == f"{SVG_BASE_URL}/radicals/6c34.svg"


def test_url_construction_kanji(basic_setup):
    """URL for kanji uses /kanji/ prefix."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client, _ = _mock_client()

    result = extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    kan = result["kanji"]
    row = kan[kan["character"] == "休"].iloc[0]
    assert row["svg_file_url"] == f"{SVG_BASE_URL}/kanji/4f11.svg"


# ---------------------------------------------------------------------------
# Tests: Missing SVG
# ---------------------------------------------------------------------------


def test_missing_svg_null_fields(tmp_path, monkeypatch):
    """No SVG → all three fields stay null."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"

    # Empty ZIP — no SVGs
    zip_path = _make_zip({}, tmp_path)

    _make_radicals_csv(csv_dir, [("一", 1, None)])
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [("休", 6, 2, None)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    result = extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    rad = result["radicals"].iloc[0]
    assert pd.isna(rad["svg_file_name"])
    assert pd.isna(rad["svg_hash"])
    assert pd.isna(rad["svg_file_url"])

    kan = result["kanji"].iloc[0]
    assert pd.isna(kan["svg_file_name"])
    assert pd.isna(kan["svg_hash"])
    assert pd.isna(kan["svg_file_url"])


def test_all_or_nothing(tmp_path, monkeypatch):
    """SVG fields are either all set or all null — never partial."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"

    # ZIP has 一 but not 木
    zip_path = _make_zip({"04e00.svg": MINIMAL_SVG}, tmp_path)

    _make_radicals_csv(csv_dir, [("一", 1, None), ("木", 4, None)])
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    result = extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    for _, row in result["radicals"].iterrows():
        svg_fields = [row["svg_file_name"], row["svg_hash"], row["svg_file_url"]]
        non_null = [f for f in svg_fields if pd.notna(f)]
        assert len(non_null) in (0, 3), f"Partial SVG fields: {svg_fields}"


# ---------------------------------------------------------------------------
# Tests: Warnings
# ---------------------------------------------------------------------------


def test_warning_missing_jlpt(tmp_path, monkeypatch):
    """Missing SVG for JLPT-mapped entity → high severity."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"

    zip_path = _make_zip({}, tmp_path)

    _make_radicals_csv(csv_dir, [("一", 1, 4)])  # JLPT 4
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [("休", 6, 2, 3)])  # JLPT 3

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    warnings_df = pd.read_csv(warnings_dir / "ph2_4_warnings.csv")
    high = warnings_df[warnings_df["severity"] == "high"]
    assert len(high) >= 2  # At least radical + kanji


def test_warning_missing_non_jlpt(tmp_path, monkeypatch):
    """Missing SVG for non-JLPT entity → low severity."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"

    zip_path = _make_zip({}, tmp_path)

    _make_radicals_csv(csv_dir, [("一", 1, None)])  # No JLPT
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [("休", 6, 2, None)])  # No JLPT

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    warnings_df = pd.read_csv(warnings_dir / "ph2_4_warnings.csv")
    entity_warnings = warnings_df[warnings_df["entity"] != "-"]
    assert all(entity_warnings["severity"] == "low")


# ---------------------------------------------------------------------------
# Tests: Upload behavior
# ---------------------------------------------------------------------------


def test_upload_called_for_new_files(basic_setup):
    """Mock client: upload called for files not in remote."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client, bucket_mock = _mock_client()  # Empty remote

    extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    upload_calls = bucket_mock.upload.call_args_list
    uploaded_paths = {call.args[0] for call in upload_calls}
    assert "radicals/4e00.svg" in uploaded_paths
    assert "radicals/6c34.svg" in uploaded_paths
    assert "radicals/6c35.svg" in uploaded_paths  # variant
    assert "kanji/4f11.svg" in uploaded_paths


def test_upload_skipped_for_existing(basic_setup):
    """Mock client: existing files with matching hash are skipped."""
    csv_dir, warnings_dir, zip_path = basic_setup
    expected_hash = hashlib.sha256(MINIMAL_SVG).hexdigest()

    # Pre-populate CSVs with existing hashes so old_hashes will match
    rad_df = pd.read_csv(csv_dir / "radicals.csv")
    for col in ("svg_file_name", "svg_hash", "svg_file_url"):
        rad_df[col] = rad_df[col].astype(object)
    rad_df.loc[rad_df["master_symbol"] == "一", "svg_file_name"] = "4e00.svg"
    rad_df.loc[rad_df["master_symbol"] == "一", "svg_hash"] = expected_hash
    rad_df.to_csv(csv_dir / "radicals.csv", index=False)

    # Remote has the file already
    client, bucket_mock = _mock_client(remote_radicals=["4e00.svg"])

    extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    uploaded_paths = {call.args[0] for call in bucket_mock.upload.call_args_list}
    assert "radicals/4e00.svg" not in uploaded_paths  # Skipped


# ---------------------------------------------------------------------------
# Tests: Disk write
# ---------------------------------------------------------------------------


def test_svg_files_written_to_disk(basic_setup):
    """SVG files written to svg_dir/radicals/ and svg_dir/kanji/."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client, _ = _mock_client()

    extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    svg_dir = csv_dir.parent / "svg"
    assert (svg_dir / "radicals" / "4e00.svg").exists()  # 一
    assert (svg_dir / "radicals" / "6c34.svg").exists()  # 水
    assert (svg_dir / "radicals" / "6c35.svg").exists()  # 氵 (variant)
    assert (svg_dir / "kanji" / "4f11.svg").exists()     # 休


def test_svg_disk_content_matches_zip(basic_setup):
    """Written bytes match ZIP source exactly."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client, _ = _mock_client()

    extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    svg_dir = csv_dir.parent / "svg"
    assert (svg_dir / "radicals" / "4e00.svg").read_bytes() == MINIMAL_SVG
    assert (svg_dir / "radicals" / "6c35.svg").read_bytes() == MINIMAL_SVG
    assert (svg_dir / "kanji" / "4f11.svg").read_bytes() == MINIMAL_SVG


def test_svg_disk_idempotent(basic_setup):
    """Second run doesn't error; files still correct."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client1, _ = _mock_client()
    client2, _ = _mock_client()

    extract_svg(csv_dir, warnings_dir, supabase_client=client1, zip_path=zip_path)
    extract_svg(csv_dir, warnings_dir, supabase_client=client2, zip_path=zip_path)

    svg_dir = csv_dir.parent / "svg"
    assert (svg_dir / "radicals" / "4e00.svg").read_bytes() == MINIMAL_SVG
    assert (svg_dir / "kanji" / "4f11.svg").read_bytes() == MINIMAL_SVG


# ---------------------------------------------------------------------------
# Tests: Idempotency & integration
# ---------------------------------------------------------------------------


def test_idempotent(basic_setup):
    """Two runs produce identical CSV output."""
    csv_dir, warnings_dir, zip_path = basic_setup
    client1, _ = _mock_client()
    client2, _ = _mock_client()

    result1 = extract_svg(csv_dir, warnings_dir, supabase_client=client1, zip_path=zip_path)
    result2 = extract_svg(csv_dir, warnings_dir, supabase_client=client2, zip_path=zip_path)

    pd.testing.assert_frame_equal(result1["radicals"], result2["radicals"])
    pd.testing.assert_frame_equal(result1["radical_variants"], result2["radical_variants"])
    pd.testing.assert_frame_equal(result1["kanji"], result2["kanji"])


def test_integration(tmp_path, monkeypatch):
    """Full pipeline: ZIP + CSVs → updated CSVs with SVG fields."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"

    svg_a = b'<svg xmlns="http://www.w3.org/2000/svg"><path d="M1 1"/></svg>'
    svg_b = b'<svg xmlns="http://www.w3.org/2000/svg"><path d="M2 2"/></svg>'
    svg_c = b'<svg xmlns="http://www.w3.org/2000/svg"><path d="M3 3"/></svg>'
    svg_d = b'<svg xmlns="http://www.w3.org/2000/svg"><path d="M4 4"/></svg>'

    # 人 = U+4EBA → 04eba.svg, 亻 = U+4EBB → 04ebb.svg
    # 木 = U+6728 → 06728.svg, 休 = U+4F11 → 04f11.svg
    zip_path = _make_zip({
        "04eba.svg": svg_a,
        "04ebb.svg": svg_b,
        "06728.svg": svg_c,
        "04f11.svg": svg_d,
        "099ff.svg": MINIMAL_SVG,  # Unmatched file
    }, tmp_path)

    _make_radicals_csv(csv_dir, [("人", 2, 4), ("木", 4, 3)])
    _make_variants_csv(csv_dir, [("人", "亻")])
    _make_kanji_csv(csv_dir, [("休", 6, 2, 4)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, bucket_mock = _mock_client()

    result = extract_svg(csv_dir, warnings_dir, supabase_client=client, zip_path=zip_path)

    # Verify all SVG fields populated
    rad = result["radicals"]
    assert rad["svg_file_name"].notna().all()
    assert rad["svg_hash"].notna().all()
    assert rad["svg_file_url"].notna().all()

    var = result["radical_variants"]
    assert var["svg_file_name"].notna().all()
    assert var["svg_hash"].notna().all()

    kan = result["kanji"]
    assert kan["svg_file_name"].notna().all()
    assert kan["svg_hash"].notna().all()

    # Verify hashes are correct
    assert rad[rad["master_symbol"] == "人"].iloc[0]["svg_hash"] == hashlib.sha256(svg_a).hexdigest()
    assert var[var["shape"] == "亻"].iloc[0]["svg_hash"] == hashlib.sha256(svg_b).hexdigest()
    assert kan[kan["character"] == "休"].iloc[0]["svg_hash"] == hashlib.sha256(svg_d).hexdigest()

    # Verify uploads happened
    upload_calls = bucket_mock.upload.call_args_list
    assert len(upload_calls) == 4  # 2 radicals + 1 variant + 1 kanji

    # Verify CSV files were written to disk
    assert (csv_dir / "radicals.csv").exists()
    assert (csv_dir / "radical_variants.csv").exists()
    assert (csv_dir / "kanji.csv").exists()

    # Re-read from disk to verify persistence
    disk_rad = pd.read_csv(csv_dir / "radicals.csv")
    assert disk_rad["svg_file_name"].notna().all()

    # Verify SVG files written to disk
    svg_dir = csv_dir.parent / "svg"
    assert (svg_dir / "radicals" / "4eba.svg").read_bytes() == svg_a
    assert (svg_dir / "radicals" / "4ebb.svg").read_bytes() == svg_b
    assert (svg_dir / "radicals" / "6728.svg").read_bytes() == svg_c
    assert (svg_dir / "kanji" / "4f11.svg").read_bytes() == svg_d

    # Verify warnings (unmatched file)
    assert (warnings_dir / "ph2_4_warnings.csv").exists()
    w_df = pd.read_csv(warnings_dir / "ph2_4_warnings.csv")
    unmatched = w_df[w_df["message"].str.contains("no matching entity")]
    assert len(unmatched) == 1


# ---------------------------------------------------------------------------
# Pass 2: Component Extraction — Helpers
# ---------------------------------------------------------------------------

# KanjiVG namespace constants
_SVG_NS = "http://www.w3.org/2000/svg"
_KVG_NS = "http://kanjivg.tagaini.net"


def _make_parent_svg(hex_code: str, root_element: str, children_xml: str) -> bytes:
    """Build a KanjiVG-style SVG with namespace and nested <g kvg:element> groups."""
    svg = (
        f'<svg xmlns="{_SVG_NS}" xmlns:kvg="{_KVG_NS}" width="109" height="109">'
        f'<g id="kvg:{hex_code}" kvg:element="{root_element}">'
        f"{children_xml}"
        f"</g></svg>"
    )
    return svg.encode("utf-8")


def _make_kanjivg_parquet(parquet_dir: Path, entries: list[tuple[str, dict]]) -> None:
    """Write kanjivg.parquet from list of (character, component_tree_dict) tuples."""
    parquet_dir.mkdir(parents=True, exist_ok=True)
    rows = []
    for char, tree in entries:
        rows.append({"character": char, "component_tree": json.dumps(tree)})
    df = pd.DataFrame(rows)
    table = pa.Table.from_pandas(df)
    pq.write_table(table, parquet_dir / "kanjivg.parquet")


# Parent kanji 亶 (U+4EB6) containing radical 㐭 (U+342D)
_PARENT_CHAR = "亶"
_PARENT_HEX = "04eb6"
_TARGET_RADICAL = "㐭"  # component inside 亶
_TARGET_RADICAL_HEX = f"{ord(_TARGET_RADICAL):x}"

# Simplified component tree for 亶 with 㐭 as a child
_PARENT_TREE = {
    "element": _PARENT_CHAR,
    "children": [
        {"element": _TARGET_RADICAL, "children": []},
    ],
}

# SVG for parent kanji with target radical group containing paths
_PARENT_SVG = _make_parent_svg(
    _PARENT_HEX,
    _PARENT_CHAR,
    (
        f'<g kvg:element="{_TARGET_RADICAL}">'
        '<path d="M10 20 C30 40 50 60 70 80"/>'
        '<path d="M15 25 C35 45 55 65 75 85"/>'
        "</g>"
    ),
)


# ---------------------------------------------------------------------------
# Pass 2: Test Cases
# ---------------------------------------------------------------------------


def test_pass2_basic_extraction(tmp_path, monkeypatch):
    """Missing radical extracted from parent → SVG fields populated."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"

    # ZIP has parent 亶 but NOT target radical 㐭
    zip_path = _make_zip({_PARENT_HEX + ".svg": _PARENT_SVG}, tmp_path)

    _make_radicals_csv(csv_dir, [(_TARGET_RADICAL, 8, None)])
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [])

    _make_kanjivg_parquet(parquet_dir, [(_PARENT_CHAR, _PARENT_TREE)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    result = extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    rad = result["radicals"]
    row = rad[rad["master_symbol"] == _TARGET_RADICAL].iloc[0]
    assert row["svg_file_name"] == f"{_TARGET_RADICAL_HEX}.svg"
    assert pd.notna(row["svg_hash"])
    assert row["svg_file_url"] == f"{SVG_BASE_URL}/radicals/{_TARGET_RADICAL_HEX}.svg"


def test_pass2_original_fallback(tmp_path, monkeypatch):
    """Radical found via kvg:original when kvg:element uses the variant form."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"

    # Simulate 確's SVG: element="寉" original="隺"
    original_char = "隺"  # canonical master_symbol
    variant_elem = "寉"  # visual variant stored as kvg:element
    parent_char = "確"
    parent_hex = f"{ord(parent_char):05x}"
    original_hex = f"{ord(original_char):x}"

    # Component tree uses element="寉" with original="隺"
    parent_tree = {
        "element": parent_char,
        "children": [{
            "element": variant_elem,
            "original": original_char,
            "variant": True,
            "children": [],
        }],
    }

    # SVG has kvg:element="寉" kvg:original="隺"
    parent_svg_str = (
        f'<svg xmlns="{_SVG_NS}" xmlns:kvg="{_KVG_NS}" width="109" height="109">'
        f'<g id="kvg:{parent_hex}" kvg:element="{parent_char}">'
        f'<g kvg:element="{variant_elem}" kvg:variant="true" kvg:original="{original_char}">'
        '<path d="M50 10 C60 20 70 30 80 40"/>'
        '<path d="M55 15 C65 25 75 35 85 45"/>'
        '</g>'
        '</g></svg>'
    )
    parent_svg = parent_svg_str.encode("utf-8")

    zip_path = _make_zip({parent_hex + ".svg": parent_svg}, tmp_path)

    # Radical uses canonical form 隺 as master_symbol
    _make_radicals_csv(csv_dir, [(original_char, 10, 3)])
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [])

    _make_kanjivg_parquet(parquet_dir, [(parent_char, parent_tree)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    result = extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    rad = result["radicals"]
    row = rad[rad["master_symbol"] == original_char].iloc[0]
    assert row["svg_file_name"] == f"{original_hex}.svg"
    assert pd.notna(row["svg_hash"])
    assert row["svg_file_url"] == f"{SVG_BASE_URL}/radicals/{original_hex}.svg"

    # Warning should be "Extracted" (low), not "Missing" (high)
    w_df = pd.read_csv(warnings_dir / "ph2_4_warnings.csv")
    entity_w = w_df[w_df["entity"] == original_char]
    assert all(entity_w["severity"] == "low")
    assert all(entity_w["message"].str.contains("Extracted SVG"))


def test_pass2_variant_extraction(tmp_path, monkeypatch):
    """Missing variant extracted via shape column."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"

    # Variant shape ⺮ (U+2EAE) inside parent 竹 (U+7AF9)
    variant_char = "⺮"
    parent_char = "竹"
    parent_hex = f"{ord(parent_char):05x}"
    variant_hex = f"{ord(variant_char):x}"

    parent_tree = {
        "element": parent_char,
        "children": [{"element": variant_char, "children": []}],
    }

    parent_svg = _make_parent_svg(
        parent_hex, parent_char,
        (
            f'<g kvg:element="{variant_char}">'
            '<path d="M5 10 C20 30 40 50 60 70"/>'
            "</g>"
        ),
    )

    zip_path = _make_zip({parent_hex + ".svg": parent_svg}, tmp_path)

    # Radical exists with an SVG (竹 in ZIP) but variant ⺮ has no standalone SVG
    _make_radicals_csv(csv_dir, [(parent_char, 6, None)])
    _make_variants_csv(csv_dir, [(parent_char, variant_char)])
    _make_kanji_csv(csv_dir, [])

    _make_kanjivg_parquet(parquet_dir, [(parent_char, parent_tree)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    result = extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    var = result["radical_variants"]
    row = var[var["shape"] == variant_char].iloc[0]
    assert row["svg_file_name"] == f"{variant_hex}.svg"
    assert pd.notna(row["svg_hash"])


def test_pass2_warning_replacement(tmp_path, monkeypatch):
    """Pass 1 'Missing SVG' (high) replaced by 'Extracted SVG' (low)."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"

    zip_path = _make_zip({_PARENT_HEX + ".svg": _PARENT_SVG}, tmp_path)

    _make_radicals_csv(csv_dir, [(_TARGET_RADICAL, 8, 3)])  # JLPT → would be high
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [])

    _make_kanjivg_parquet(parquet_dir, [(_PARENT_CHAR, _PARENT_TREE)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    w_df = pd.read_csv(warnings_dir / "ph2_4_warnings.csv")
    entity_warnings = w_df[w_df["entity"] == _TARGET_RADICAL]
    # Should have "Extracted SVG" (low), NOT "Missing SVG" (high)
    assert all(entity_warnings["severity"] == "low")
    assert all(entity_warnings["message"].str.contains("Extracted SVG"))
    assert not any(entity_warnings["message"].str.contains("Missing SVG"))


def test_pass2_no_parent(tmp_path, monkeypatch):
    """Radical not in any parent → 'Missing SVG' warning remains."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"

    zip_path = _make_zip({}, tmp_path)  # Empty ZIP

    _make_radicals_csv(csv_dir, [(_TARGET_RADICAL, 8, None)])
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [])

    # Parquet with no entries containing target
    _make_kanjivg_parquet(parquet_dir, [])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    w_df = pd.read_csv(warnings_dir / "ph2_4_warnings.csv")
    missing = w_df[w_df["message"].str.contains("Missing SVG")]
    assert len(missing) >= 1
    assert _TARGET_RADICAL in missing["entity"].values


def test_pass2_kanji_not_extracted(tmp_path, monkeypatch):
    """Kanji missing from ZIP stays missing — only radicals/variants extracted."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"

    # ZIP has parent 亶 but not target kanji 休
    zip_path = _make_zip({_PARENT_HEX + ".svg": _PARENT_SVG}, tmp_path)

    _make_radicals_csv(csv_dir, [])
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [("休", 6, 2, 4)])

    # Even if parquet maps 休 as a child of something, kanji should not be extracted
    _make_kanjivg_parquet(parquet_dir, [(_PARENT_CHAR, {
        "element": _PARENT_CHAR,
        "children": [{"element": "休", "children": []}],
    })])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    result = extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    kan = result["kanji"].iloc[0]
    assert pd.isna(kan["svg_file_name"])


def test_pass2_disk_output(tmp_path, monkeypatch):
    """Extracted files go to svg_dir/extracted/radicals/, not svg_dir/radicals/."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"

    zip_path = _make_zip({_PARENT_HEX + ".svg": _PARENT_SVG}, tmp_path)

    _make_radicals_csv(csv_dir, [(_TARGET_RADICAL, 8, None)])
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [])

    _make_kanjivg_parquet(parquet_dir, [(_PARENT_CHAR, _PARENT_TREE)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    svg_dir = csv_dir.parent / "svg"
    extracted_file = svg_dir / "extracted" / "radicals" / f"{_TARGET_RADICAL_HEX}.svg"
    assert extracted_file.exists()
    # Should NOT be in the Pass 1 folder
    assert not (svg_dir / "radicals" / f"{_TARGET_RADICAL_HEX}.svg").exists()


def test_pass2_idempotent(tmp_path, monkeypatch):
    """Two runs produce identical output."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"

    zip_path = _make_zip({_PARENT_HEX + ".svg": _PARENT_SVG}, tmp_path)

    _make_radicals_csv(csv_dir, [(_TARGET_RADICAL, 8, None)])
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [])

    _make_kanjivg_parquet(parquet_dir, [(_PARENT_CHAR, _PARENT_TREE)])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)

    client1, _ = _mock_client()
    result1 = extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client1, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    client2, _ = _mock_client()
    result2 = extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client2, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    pd.testing.assert_frame_equal(result1["radicals"], result2["radicals"])
    pd.testing.assert_frame_equal(result1["radical_variants"], result2["radical_variants"])


def test_pass2_no_parquet_graceful(tmp_path, monkeypatch):
    """Missing kanjivg.parquet → Pass 2 skipped, Pass 1 warnings unchanged."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    parquet_dir = tmp_path / "parquet"  # No parquet file created

    zip_path = _make_zip({}, tmp_path)

    _make_radicals_csv(csv_dir, [(_TARGET_RADICAL, 8, 3)])  # JLPT → high severity
    _make_variants_csv(csv_dir, [])
    _make_kanji_csv(csv_dir, [])

    monkeypatch.setenv("SVG_BASE_URL", SVG_BASE_URL)
    client, _ = _mock_client()

    result = extract_svg(
        csv_dir, warnings_dir,
        supabase_client=client, zip_path=zip_path, parquet_dir=parquet_dir,
    )

    # Radical should still be missing — no extraction happened
    rad = result["radicals"].iloc[0]
    assert pd.isna(rad["svg_file_name"])

    # Warning should be high (JLPT, not extracted)
    w_df = pd.read_csv(warnings_dir / "ph2_4_warnings.csv")
    entity_w = w_df[w_df["entity"] == _TARGET_RADICAL]
    assert len(entity_w) == 1
    assert entity_w.iloc[0]["severity"] == "high"
    assert "Missing SVG" in entity_w.iloc[0]["message"]


def test_bbox_computation():
    """Direct test of _compute_bbox_from_paths with known path data."""
    d_values = ["M10 20 C30 40 50 60 70 80"]
    min_x, min_y, max_x, max_y = _compute_bbox_from_paths(d_values)
    assert min_x == 10.0
    assert min_y == 20.0
    assert max_x == 70.0
    assert max_y == 80.0


def test_bbox_computation_relative():
    """Relative commands (m, c) correctly track current point."""
    d_values = ["M10 20 c10 10 20 20 30 30"]
    min_x, min_y, max_x, max_y = _compute_bbox_from_paths(d_values)
    assert min_x == 10.0
    assert min_y == 20.0
    # c is relative: control points at (20,30), (30,40), endpoint at (40,50)
    assert max_x == 40.0
    assert max_y == 50.0


def test_bbox_empty_fallback():
    """Empty path list falls back to (0, 0, 109, 109)."""
    assert _compute_bbox_from_paths([]) == (0.0, 0.0, 109.0, 109.0)


def test_svg_output_structure():
    """Generated SVG has correct xmlns, viewBox with padding, style, paths."""
    d_values = ["M10 20 C30 40 50 60 70 80", "M15 25 C35 45 55 65 75 85"]
    bbox = _compute_bbox_from_paths(d_values)
    svg_bytes = _generate_extracted_svg(d_values, bbox)

    root = etree.fromstring(svg_bytes)
    assert root.tag == f"{{{_SVG_NS}}}svg"

    # Check viewBox has padding
    vb = root.get("viewBox")
    assert vb is not None
    parts = [float(x) for x in vb.split()]
    assert len(parts) == 4
    assert parts[0] == 10.0 - 2.0  # min_x - padding
    assert parts[1] == 20.0 - 2.0  # min_y - padding

    # Check paths
    paths = root.findall(f"{{{_SVG_NS}}}path")
    assert len(paths) == 2
    assert paths[0].get("d") == d_values[0]
    assert paths[1].get("d") == d_values[1]

    # Check style includes KanjiVG stroke properties
    style = paths[0].get("style")
    assert "stroke-width:3" in style
    assert "stroke-linecap:round" in style
