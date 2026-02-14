"""Tests for KANJIDIC parser."""

import gzip
import json
import tempfile
from pathlib import Path

import pandas as pd

from src.parsers.kanjidic import parse_kanjidic

FIXTURES = Path(__file__).parent / "fixtures"


def _make_gz(xml_path: Path) -> Path:
    """Gzip an XML file for the parser."""
    tmp = Path(tempfile.mkdtemp())
    gz_path = tmp / "kanjidic2.xml.gz"
    with open(xml_path, "rb") as f_in, gzip.open(gz_path, "wb") as f_out:
        f_out.write(f_in.read())
    return gz_path


def test_row_count():
    df = parse_kanjidic(_make_gz(FIXTURES / "kanjidic_sample.xml"))
    assert len(df) == 3


def test_columns():
    df = parse_kanjidic(_make_gz(FIXTURES / "kanjidic_sample.xml"))
    expected = [
        "literal", "stroke_count", "stroke_count_misstrokes",
        "grade", "jlpt", "frequency",
        "codepoints", "radicals", "variants", "dict_refs", "query_codes",
        "readings", "meanings", "nanori", "radical_names",
    ]
    assert list(df.columns) == expected


def test_nichi_entry():
    """日 — fully populated entry."""
    df = parse_kanjidic(_make_gz(FIXTURES / "kanjidic_sample.xml"))
    row = df[df["literal"] == "日"].iloc[0]

    assert row["stroke_count"] == 4
    assert row["grade"] == 1
    assert row["jlpt"] == 4
    assert row["frequency"] == 1
    assert pd.isna(row["stroke_count_misstrokes"])

    # Codepoints
    cp = json.loads(row["codepoints"])
    assert cp["ucs"] == "65e5"
    assert cp["jis208"] == "38-92"

    # Radicals
    rad = json.loads(row["radicals"])
    assert rad["classical"] == 72
    assert rad["nelson_c"] == 72

    # Variants
    assert row["variants"] is not None
    variants = json.loads(row["variants"])
    assert len(variants) == 1
    assert variants[0]["var_type"] == "jis208"

    # Dict refs
    assert row["dict_refs"] is not None
    refs = json.loads(row["dict_refs"])
    assert refs["nelson_c"] == "2097"
    assert refs["moro"]["value"] == "14311"
    assert refs["moro"]["volume"] == "5"
    assert refs["moro"]["page"] == "0555"

    # Query codes
    qc = json.loads(row["query_codes"])
    assert qc["skip"] == "3-3-1"
    assert qc["four_corner"] == "6010.0"

    # Readings
    readings = json.loads(row["readings"])
    assert "ニチ" in readings["ja_on"]
    assert "ジツ" in readings["ja_on"]
    assert "ひ" in readings["ja_kun"]
    assert readings["pinyin"] == ["ri4"]

    # Meanings
    meanings = json.loads(row["meanings"])
    assert "day" in meanings["en"]
    assert "jour" in meanings["fr"]
    assert "día" in meanings["es"]

    # Nanori
    nanori = json.loads(row["nanori"])
    assert "あ" in nanori
    assert "あき" in nanori

    # Radical names
    rn = json.loads(row["radical_names"])
    assert "にち" in rn
    assert "ひ" in rn


def test_rare_entry():
    """𠂇 — rare kanji with minimal fields (no grade, jlpt, freq, etc.)."""
    df = parse_kanjidic(_make_gz(FIXTURES / "kanjidic_sample.xml"))
    row = df[df["literal"] == "𠂇"].iloc[0]

    assert row["stroke_count"] == 2
    assert pd.isna(row["grade"])
    assert pd.isna(row["jlpt"])
    assert pd.isna(row["frequency"])
    assert pd.isna(row["variants"])
    assert pd.isna(row["dict_refs"])
    assert pd.isna(row["nanori"])
    assert pd.isna(row["radical_names"])


def test_misstrokes():
    """嗢 — kanji with misstrokes."""
    df = parse_kanjidic(_make_gz(FIXTURES / "kanjidic_sample.xml"))
    row = df[df["literal"] == "嗢"].iloc[0]

    assert row["stroke_count"] == 13
    misstrokes = json.loads(row["stroke_count_misstrokes"])
    assert misstrokes == [12]


def test_nullable_int_types():
    df = parse_kanjidic(_make_gz(FIXTURES / "kanjidic_sample.xml"))
    assert str(df["grade"].dtype) == "Int32"
    assert str(df["jlpt"].dtype) == "Int32"
    assert str(df["frequency"].dtype) == "Int32"
    assert str(df["stroke_count"].dtype) == "int32"
