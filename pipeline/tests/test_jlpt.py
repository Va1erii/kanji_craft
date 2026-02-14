"""Tests for JLPT kanji and vocabulary parsers."""

from pathlib import Path

import pandas as pd

from src.parsers.jlpt import parse_jlpt_kanji, parse_jlpt_vocab

FIXTURES = Path(__file__).parent / "fixtures"


def test_jlpt_kanji_row_count():
    df = parse_jlpt_kanji(FIXTURES / "jlpt_mapping.csv")
    assert len(df) == 4


def test_jlpt_kanji_columns():
    df = parse_jlpt_kanji(FIXTURES / "jlpt_mapping.csv")
    assert list(df.columns) == ["character", "level"]


def test_jlpt_kanji_types():
    df = parse_jlpt_kanji(FIXTURES / "jlpt_mapping.csv")
    assert pd.api.types.is_string_dtype(df["character"])
    assert str(df["level"].dtype) == "int32"


def test_jlpt_kanji_values():
    df = parse_jlpt_kanji(FIXTURES / "jlpt_mapping.csv")
    assert df.iloc[0]["character"] == "日"
    assert df.iloc[0]["level"] == 5
    assert df.iloc[2]["character"] == "大"
    assert df.iloc[2]["level"] == 4


def test_jlpt_vocab_row_count():
    """Tests dedup: 食べる appears in both n4 and n5, should keep n5 (easier = max)."""
    # We need n1-n5 but our fixture only has n4 and n5.
    # Create a temp dir with n1-n5 files (n1-n3 empty with headers).
    import tempfile

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp = Path(tmpdir)
        # Copy our fixture files as n4 and n5
        for level in (1, 2, 3):
            (tmp / f"n{level}.csv").write_text("expression,reading,meaning,tags,guid\n")
        (tmp / "n4.csv").write_text((FIXTURES / "jlpt_vocab_n4.csv").read_text())
        (tmp / "n5.csv").write_text((FIXTURES / "jlpt_vocab_n5.csv").read_text())

        df = parse_jlpt_vocab(tmp)
        # 食べる/たべる: in both n4 and n5, keep n5 (level=5, easiest)
        # 走る/はしる: only in n4
        # 飲む/のむ: only in n5
        # 水/水: only in n5 (reading filled from expression)
        assert len(df) == 4


def test_jlpt_vocab_dedup_keeps_easiest():
    import tempfile

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp = Path(tmpdir)
        for level in (1, 2, 3):
            (tmp / f"n{level}.csv").write_text("expression,reading,meaning,tags,guid\n")
        (tmp / "n4.csv").write_text((FIXTURES / "jlpt_vocab_n4.csv").read_text())
        (tmp / "n5.csv").write_text((FIXTURES / "jlpt_vocab_n5.csv").read_text())

        df = parse_jlpt_vocab(tmp)
        taberu = df[df["expression"] == "食べる"]
        assert len(taberu) == 1
        assert taberu.iloc[0]["level"] == 5  # Easiest level kept


def test_jlpt_vocab_empty_reading_filled():
    import tempfile

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp = Path(tmpdir)
        for level in (1, 2, 3):
            (tmp / f"n{level}.csv").write_text("expression,reading,meaning,tags,guid\n")
        (tmp / "n4.csv").write_text((FIXTURES / "jlpt_vocab_n4.csv").read_text())
        (tmp / "n5.csv").write_text((FIXTURES / "jlpt_vocab_n5.csv").read_text())

        df = parse_jlpt_vocab(tmp)
        mizu = df[df["expression"] == "水"]
        assert len(mizu) == 1
        assert mizu.iloc[0]["reading"] == "水"  # Filled from expression


def test_jlpt_vocab_columns():
    import tempfile

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp = Path(tmpdir)
        for level in (1, 2, 3):
            (tmp / f"n{level}.csv").write_text("expression,reading,meaning,tags,guid\n")
        (tmp / "n4.csv").write_text("expression,reading,meaning,tags,guid\n")
        (tmp / "n5.csv").write_text("expression,reading,meaning,tags,guid\n")

        df = parse_jlpt_vocab(tmp)
        assert list(df.columns) == ["expression", "reading", "level"]
