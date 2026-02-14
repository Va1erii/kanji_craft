"""Tests for KanjiVG parser."""

import gzip
import json
import tempfile
from pathlib import Path

from src.parsers.kanjivg import parse_kanjivg

FIXTURES = Path(__file__).parent / "fixtures"


def _make_gz(xml_path: Path) -> Path:
    """Gzip an XML file for the parser."""
    tmp = Path(tempfile.mkdtemp())
    gz_path = tmp / "kanjivg-test.xml.gz"
    with open(xml_path, "rb") as f_in, gzip.open(gz_path, "wb") as f_out:
        f_out.write(f_in.read())
    return gz_path


def test_row_count():
    df = parse_kanjivg(_make_gz(FIXTURES / "kanjivg_sample.xml"))
    assert len(df) == 3


def test_columns():
    df = parse_kanjivg(_make_gz(FIXTURES / "kanjivg_sample.xml"))
    assert list(df.columns) == ["character", "component_tree"]


def test_kari_entry():
    """仮 (U+4EEE) — left-right with radical, variant, original."""
    df = parse_kanjivg(_make_gz(FIXTURES / "kanjivg_sample.xml"))
    row = df[df["character"] == "仮"].iloc[0]
    tree = json.loads(row["component_tree"])

    assert tree["element"] == "仮"
    assert tree["stroke_count"] == 6
    assert tree["position"] is None
    assert tree["radical"] is None
    assert len(tree["children"]) == 2

    # Left child: 亻 (radical, variant of 人)
    left = tree["children"][0]
    assert left["element"] == "亻"
    assert left["position"] == "left"
    assert left["radical"] == "general"
    assert left["original"] == "人"
    assert left["variant"] is True
    assert left["stroke_count"] == 2
    assert left["children"] == []

    # Right child: 反
    right = tree["children"][1]
    assert right["element"] == "反"
    assert right["position"] == "right"
    assert right["stroke_count"] == 4
    # 反 has a nested child 又
    assert len(right["children"]) == 1
    assert right["children"][0]["element"] == "又"
    assert right["children"][0]["stroke_count"] == 2


def test_ichi_entry():
    """一 (U+4E00) — simplest kanji, single stroke."""
    df = parse_kanjivg(_make_gz(FIXTURES / "kanjivg_sample.xml"))
    row = df[df["character"] == "一"].iloc[0]
    tree = json.loads(row["component_tree"])

    assert tree["element"] == "一"
    assert tree["stroke_count"] == 1
    assert tree["children"] == []


def test_go_entry():
    """語 (U+8A9E) — deeper nesting with phon attribute."""
    df = parse_kanjivg(_make_gz(FIXTURES / "kanjivg_sample.xml"))
    row = df[df["character"] == "語"].iloc[0]
    tree = json.loads(row["component_tree"])

    assert tree["element"] == "語"
    assert tree["stroke_count"] == 14

    # Left: 言 (radical)
    left = tree["children"][0]
    assert left["element"] == "言"
    assert left["position"] == "left"
    assert left["radical"] == "general"
    assert left["stroke_count"] == 7

    # Right: 吾 (with phon)
    right = tree["children"][1]
    assert right["element"] == "吾"
    assert right["position"] == "right"
    assert right["phon"] == "ゴ"
    assert right["stroke_count"] == 7
    assert len(right["children"]) == 2  # 五 and 口


def test_variant_false_default():
    """Non-variant elements should have variant=False."""
    df = parse_kanjivg(_make_gz(FIXTURES / "kanjivg_sample.xml"))
    row = df[df["character"] == "一"].iloc[0]
    tree = json.loads(row["component_tree"])
    assert tree["variant"] is False
