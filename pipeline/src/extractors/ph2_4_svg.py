"""Phase 2.4: SVG Processing, Hashing & Upload.

Populates svg_file_name, svg_file_url, svg_hash on radicals.csv,
radical_variants.csv, and kanji.csv from the KanjiVG ZIP archive.
Uploads new SVGs to Supabase Storage.

Usage:
    Called from src.extract as part of the Phase 2 pipeline.
"""

import hashlib
import logging
import os
import zipfile
from pathlib import Path

import pandas as pd

from src.extractors.shared import char_to_kvg_filename, char_to_svg_filename, write_csv_atomic

log = logging.getLogger(__name__)

SOURCES_DIR = Path(__file__).resolve().parent.parent.parent.parent / "sources"

BUCKET_NAME = "svg"


def _discover_zip() -> Path:
    """Find the KanjiVG ZIP archive in sources/."""
    candidates = sorted(SOURCES_DIR.glob("kanjivg-*/kanjivg-*-main.zip"))
    if not candidates:
        msg = f"No KanjiVG ZIP found in {SOURCES_DIR}/kanjivg-*/kanjivg-*-main.zip"
        raise FileNotFoundError(msg)
    if len(candidates) > 1:
        log.warning("Multiple KanjiVG ZIPs found, using latest: %s", candidates[-1])
    return candidates[-1]


def _build_svg_map(zip_path: Path) -> dict[str, tuple[bytes, str]]:
    """Build map: kvg_filename → (raw_bytes, sha256_hex) from ZIP.

    Only includes entries matching ``kanji/*.svg``.
    """
    svg_map: dict[str, tuple[bytes, str]] = {}
    with zipfile.ZipFile(zip_path, "r") as zf:
        for entry in zf.namelist():
            if not entry.endswith(".svg"):
                continue
            # Entries are like "kanji/04e00.svg" — extract the filename part
            filename = entry.rsplit("/", 1)[-1]
            raw = zf.read(entry)
            sha = hashlib.sha256(raw).hexdigest()
            svg_map[filename] = (raw, sha)
    log.info("Built SVG map: %d files from %s", len(svg_map), zip_path.name)
    return svg_map


def _load_old_hashes(
    csv_path: Path,
    name_col: str = "svg_file_name",
    hash_col: str = "svg_hash",
) -> dict[str, str]:
    """Read current CSV to build svg_file_name → old_svg_hash map."""
    if not csv_path.exists():
        return {}
    try:
        df = pd.read_csv(csv_path)
    except pd.errors.EmptyDataError:
        return {}
    if name_col not in df.columns or hash_col not in df.columns:
        return {}
    subset = df[[name_col, hash_col]].dropna()
    return dict(zip(subset[name_col], subset[hash_col], strict=False))


def _list_remote_files(client, folder: str) -> set[str]:
    """List filenames in a Supabase storage folder."""
    try:
        result = client.storage.from_(BUCKET_NAME).list(folder)
        return {item["name"] for item in result if item.get("name")}
    except Exception:
        log.exception("Failed to list remote files in %s/%s", BUCKET_NAME, folder)
        return set()


def _upload_file(client, folder: str, filename: str, data: bytes) -> None:
    """Upload a single SVG file to Supabase storage. Raises on failure."""
    path = f"{folder}/{filename}"
    client.storage.from_(BUCKET_NAME).upload(
        path, data, {"content-type": "image/svg+xml"}
    )


def _create_supabase_client():
    """Create Supabase client from env vars."""
    from supabase import create_client

    url = os.environ["SUPABASE_URL"]
    key = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
    return create_client(url, key)


def _process_entity(
    df: pd.DataFrame,
    char_col: str,
    svg_map: dict[str, tuple[bytes, str]],
    base_url: str,
    url_folder: str,
    entity_label: str,
    old_hashes: dict[str, str],
    remote_files: set[str],
    client,
    warnings: list[dict],
    jlpt_series: pd.Series | None = None,
) -> pd.DataFrame:
    """Update SVG fields on a DataFrame and upload new files.

    Args:
        df: Entity DataFrame to update in-place.
        char_col: Column name containing the character (master_symbol/shape/character).
        svg_map: kvg_filename → (bytes, sha256).
        base_url: SVG_BASE_URL for URL construction.
        url_folder: 'radicals' or 'kanji' for URL path.
        entity_label: For logging ('radical', 'radical_variant', 'kanji').
        old_hashes: svg_file_name → old sha256 from previous CSV.
        remote_files: Set of filenames already in remote storage folder.
        client: Supabase client (or None to skip uploads).
        warnings: Accumulator for warning dicts.
        jlpt_series: Optional Series of JLPT levels aligned with df index for severity.

    Returns:
        Updated DataFrame.
    """
    # Ensure SVG columns are object dtype (they start as float64 when all NaN)
    for col in ("svg_file_name", "svg_hash", "svg_file_url"):
        if col in df.columns:
            df[col] = df[col].astype(object)

    uploaded = 0
    skipped = 0
    changed = 0
    missing = 0

    for idx, row in df.iterrows():
        char = row[char_col]
        if pd.isna(char) or not char:
            continue

        kvg_name = char_to_kvg_filename(char)
        storage_name = char_to_svg_filename(char)

        if kvg_name not in svg_map:
            missing += 1
            has_jlpt = (
                jlpt_series is not None
                and idx in jlpt_series.index
                and pd.notna(jlpt_series[idx])
            )
            warnings.append({
                "severity": "high" if has_jlpt else "low",
                "phase": "2.4",
                "entity": char,
                "message": f"Missing SVG for {entity_label} '{char}' (expected {kvg_name})",
            })
            continue

        raw_bytes, sha256 = svg_map[kvg_name]

        # Set all three fields atomically
        df.at[idx, "svg_file_name"] = storage_name
        df.at[idx, "svg_hash"] = sha256
        df.at[idx, "svg_file_url"] = f"{base_url}/{url_folder}/{storage_name}"

        # Upload decision
        if client is not None:
            if storage_name not in remote_files:
                _upload_file(client, url_folder, storage_name, raw_bytes)
                uploaded += 1
                remote_files.add(storage_name)
            else:
                old_hash = old_hashes.get(storage_name)
                if old_hash and sha256 != old_hash:
                    changed += 1
                    warnings.append({
                        "severity": "high",
                        "phase": "2.4",
                        "entity": char,
                        "message": (
                            f"SVG content changed since last upload for {entity_label} "
                            f"'{char}' ({storage_name}). Admin must re-upload manually."
                        ),
                    })
                else:
                    skipped += 1

    log.info(
        "  %s: %d uploaded, %d skipped, %d changed (admin review), %d missing, %d total",
        entity_label,
        uploaded,
        skipped,
        changed,
        missing,
        len(df),
    )
    return df


def extract_svg(
    csv_dir: Path,
    warnings_dir: Path,
    *,
    supabase_client=None,
    zip_path: Path | None = None,
) -> dict:
    """Phase 2.4 entry point: populate SVG fields and upload to storage.

    Args:
        csv_dir: Directory containing radicals.csv, radical_variants.csv, kanji.csv.
        warnings_dir: Directory for ph2_4_warnings.csv.
        supabase_client: Optional pre-built Supabase client (for testing).
            If None, creates from env vars.
        zip_path: Optional explicit path to KanjiVG ZIP (for testing).
            If None, discovers via glob in sources/.

    Returns:
        Dict with updated DataFrames: radicals, radical_variants, kanji.
    """
    # Config from env
    svg_base_url = os.environ.get("SVG_BASE_URL")
    if not svg_base_url:
        msg = "SVG_BASE_URL environment variable is required"
        raise OSError(msg)

    # Strip trailing slash
    svg_base_url = svg_base_url.rstrip("/")

    # Step 1: Build SVG map from ZIP
    if zip_path is None:
        zip_path = _discover_zip()
    svg_map = _build_svg_map(zip_path)

    # Step 2: Load old hashes + list remote files
    old_radical_hashes = _load_old_hashes(csv_dir / "radicals.csv")
    old_variant_hashes = _load_old_hashes(csv_dir / "radical_variants.csv")
    old_kanji_hashes = _load_old_hashes(csv_dir / "kanji.csv")

    # Create/use Supabase client
    client = supabase_client
    if client is None:
        supabase_url = os.environ.get("SUPABASE_URL")
        service_key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
        if supabase_url and service_key:
            client = _create_supabase_client()
        else:
            log.warning("SUPABASE_URL/SUPABASE_SERVICE_ROLE_KEY not set — skipping uploads")

    remote_radicals: set[str] = set()
    remote_kanji: set[str] = set()
    if client is not None:
        remote_radicals = _list_remote_files(client, "radicals")
        remote_kanji = _list_remote_files(client, "kanji")

    warnings: list[dict] = []

    # Step 3: Radicals
    radicals_path = csv_dir / "radicals.csv"
    radicals_df = pd.read_csv(radicals_path)

    jlpt_radicals = (
        radicals_df["min_jlpt_level"] if "min_jlpt_level" in radicals_df.columns else None
    )

    radicals_df = _process_entity(
        radicals_df,
        "master_symbol",
        svg_map,
        svg_base_url,
        "radicals",
        "radical",
        old_radical_hashes,
        remote_radicals,
        client,
        warnings,
        jlpt_series=jlpt_radicals,
    )
    write_csv_atomic(radicals_df, radicals_path)

    # Step 4: Radical variants
    variants_path = csv_dir / "radical_variants.csv"
    variants_df = pd.read_csv(variants_path)

    # Variants inherit JLPT from parent radical
    variant_jlpt = None
    if "radical_id" in variants_df.columns and "min_jlpt_level" in radicals_df.columns:
        rad_jlpt_map = dict(zip(radicals_df["id"], radicals_df["min_jlpt_level"], strict=False))
        variant_jlpt = variants_df["radical_id"].map(rad_jlpt_map)

    variants_df = _process_entity(
        variants_df,
        "shape",
        svg_map,
        svg_base_url,
        "radicals",
        "radical_variant",
        old_variant_hashes,
        remote_radicals,  # variants share the radicals/ folder
        client,
        warnings,
        jlpt_series=variant_jlpt,
    )
    write_csv_atomic(variants_df, variants_path)

    # Step 5: Kanji
    kanji_path = csv_dir / "kanji.csv"
    kanji_df = pd.read_csv(kanji_path)

    jlpt_kanji = kanji_df["min_jlpt_level"] if "min_jlpt_level" in kanji_df.columns else None

    kanji_df = _process_entity(
        kanji_df,
        "character",
        svg_map,
        svg_base_url,
        "kanji",
        "kanji",
        old_kanji_hashes,
        remote_kanji,
        client,
        warnings,
        jlpt_series=jlpt_kanji,
    )
    write_csv_atomic(kanji_df, kanji_path)

    # Unmatched SVGs in archive
    matched_kvg = set()
    for _, row in radicals_df.iterrows():
        if pd.notna(row.get("svg_file_name")):
            matched_kvg.add(char_to_kvg_filename(row["master_symbol"]))
    for _, row in variants_df.iterrows():
        if pd.notna(row.get("svg_file_name")):
            matched_kvg.add(char_to_kvg_filename(row["shape"]))
    for _, row in kanji_df.iterrows():
        if pd.notna(row.get("svg_file_name")):
            matched_kvg.add(char_to_kvg_filename(row["character"]))

    unmatched_count = len(svg_map) - len(matched_kvg)
    if unmatched_count > 0:
        warnings.append({
            "severity": "low",
            "phase": "2.4",
            "entity": "-",
            "message": f"{unmatched_count} SVG files in archive with no matching entity",
        })

    # Write warnings
    if warnings:
        warnings_df = pd.DataFrame(warnings, columns=["severity", "phase", "entity", "message"])
        write_csv_atomic(warnings_df, warnings_dir / "ph2_4_warnings.csv")
        high_count = sum(1 for w in warnings if w["severity"] == "high")
        log.info("Warnings: %d total (%d high severity)", len(warnings), high_count)

    return {
        "radicals": radicals_df,
        "radical_variants": variants_df,
        "kanji": kanji_df,
    }
