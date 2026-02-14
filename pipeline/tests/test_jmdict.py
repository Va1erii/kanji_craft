"""Tests for JMdict parser."""

import gzip
import json
import tempfile
from pathlib import Path

import pandas as pd

from src.parsers.jmdict import parse_jmdict, parse_jmdict_examples

FIXTURES = Path(__file__).parent / "fixtures"


def _make_gz(xml_path: Path) -> Path:
    """Gzip an XML file for the parser."""
    tmp = Path(tempfile.mkdtemp())
    gz_path = tmp / (xml_path.stem + ".gz")
    with open(xml_path, "rb") as f_in, gzip.open(gz_path, "wb") as f_out:
        f_out.write(f_in.read())
    return gz_path


def test_jmdict_row_count():
    df = parse_jmdict(_make_gz(FIXTURES / "jmdict_sample.xml"))
    assert len(df) == 3


def test_jmdict_columns():
    df = parse_jmdict(_make_gz(FIXTURES / "jmdict_sample.xml"))
    assert list(df.columns) == ["ent_seq", "k_ele", "r_ele", "senses"]


def test_jmdict_ent_seq_type():
    df = parse_jmdict(_make_gz(FIXTURES / "jmdict_sample.xml"))
    assert df["ent_seq"].dtype == "int64"


def test_taberu_entry():
    """食べる — normal entry with kanji and reading."""
    df = parse_jmdict(_make_gz(FIXTURES / "jmdict_sample.xml"))
    row = df[df["ent_seq"] == 1358280].iloc[0]

    k_ele = json.loads(row["k_ele"])
    assert len(k_ele) == 1
    assert k_ele[0]["keb"] == "食べる"
    assert "ichi1" in k_ele[0]["ke_pri"]

    r_ele = json.loads(row["r_ele"])
    assert len(r_ele) == 1
    assert r_ele[0]["reb"] == "たべる"
    assert r_ele[0]["re_nokanji"] is False

    senses = json.loads(row["senses"])
    assert len(senses) == 1
    # Entity reference should be resolved
    assert senses[0]["pos"] == ["noun (common) (futsuumeishi)"]
    assert any(g["text"] == "to eat" for g in senses[0]["gloss"])
    # French gloss
    assert any(g["lang"] == "fre" and g["text"] == "manger" for g in senses[0]["gloss"])


def test_suru_entry():
    """する — kana-only entry (no k_ele)."""
    df = parse_jmdict(_make_gz(FIXTURES / "jmdict_sample.xml"))
    row = df[df["ent_seq"] == 1157170].iloc[0]

    assert pd.isna(row["k_ele"])  # No kanji elements

    r_ele = json.loads(row["r_ele"])
    assert r_ele[0]["reb"] == "する"

    senses = json.loads(row["senses"])
    assert len(senses) == 2
    # Entity reference resolved
    assert senses[0]["pos"] == ["noun or participle which takes the aux. verb suru"]
    assert senses[0]["misc"] == ["word usually written using kana alone"]


def test_ookii_entry():
    """大きい — verify non-en/fr/es/pt meanings excluded."""
    df = parse_jmdict(_make_gz(FIXTURES / "jmdict_sample.xml"))
    row = df[df["ent_seq"] == 1221850].iloc[0]

    senses = json.loads(row["senses"])
    # German gloss should still be present (we don't filter in jmdict parser)
    gloss_langs = {g["lang"] for g in senses[0]["gloss"]}
    assert "eng" in gloss_langs
    assert "ger" in gloss_langs


# --- Examples tests ---


def test_examples_row_count():
    df = parse_jmdict_examples(_make_gz(FIXTURES / "jmdict_examp_sample.xml"))
    assert len(df) == 2  # Two examples for entry 1358280


def test_examples_columns():
    df = parse_jmdict_examples(_make_gz(FIXTURES / "jmdict_examp_sample.xml"))
    assert list(df.columns) == ["ent_seq", "source_id", "word_form", "sentence_ja", "sentence_en"]


def test_examples_values():
    df = parse_jmdict_examples(_make_gz(FIXTURES / "jmdict_examp_sample.xml"))
    row0 = df.iloc[0]
    assert row0["ent_seq"] == 1358280
    assert row0["source_id"] == "220148"
    assert row0["word_form"] == "食べ"
    assert row0["sentence_ja"] == "何か食べたい。"
    assert row0["sentence_en"] == "I want to eat something."


def test_examples_no_examples_entry():
    """Entry without examples should produce no rows."""
    df = parse_jmdict_examples(_make_gz(FIXTURES / "jmdict_examp_sample.xml"))
    suru_rows = df[df["ent_seq"] == 1157170]
    assert len(suru_rows) == 0
