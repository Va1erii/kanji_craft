"""Tests for Phase 2.2 kanji composition (Steps 1-3)."""

import json

import pandas as pd
import pytest

from src.extractors.ph2_2_kanji import extract_kanji

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _kanjidic_row(
    literal,
    stroke_count=4,
    grade=None,
    frequency=None,
    ja_on=None,
    ja_kun=None,
    nanori=None,
    meanings=None,
):
    """Build a kanjidic DataFrame row with JSON-encoded nested fields."""
    readings = {}
    if ja_on is not None:
        readings["ja_on"] = ja_on
    if ja_kun is not None:
        readings["ja_kun"] = ja_kun
    return {
        "literal": literal,
        "stroke_count": stroke_count,
        "grade": grade,
        "jlpt": None,
        "frequency": frequency,
        "readings": json.dumps(readings, ensure_ascii=False),
        "nanori": json.dumps(nanori or [], ensure_ascii=False),
        "meanings": json.dumps(meanings or {}, ensure_ascii=False),
    }


def _make_kanjidic_df(rows):
    df = pd.DataFrame(rows)
    df["grade"] = df["grade"].astype("Int32")
    df["frequency"] = df["frequency"].astype("Int32")
    return df


def _make_jlpt_df(entries):
    """entries: list of (character, level) tuples."""
    return pd.DataFrame(entries, columns=["character", "level"])


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------


@pytest.fixture
def basic_kanjidic_df():
    """Minimal KANJIDIC with 日, 人, 龍 (unranked)."""
    return _make_kanjidic_df([
        _kanjidic_row(
            "日", stroke_count=4, grade=1, frequency=1,
            ja_on=["ニチ", "ジツ"], ja_kun=["ひ", "-び", "-か"],
            meanings={"en": ["day", "sun", "Japan"], "es": ["día", "sol"]},
        ),
        _kanjidic_row(
            "人", stroke_count=2, grade=1, frequency=5,
            ja_on=["ジン", "ニン"], ja_kun=["ひと"],
            meanings={"en": ["person", "human"]},
        ),
        _kanjidic_row(
            "龍", stroke_count=16, grade=None, frequency=None,
            ja_on=["リュウ", "リョウ", "ロウ"], ja_kun=["たつ"],
            meanings={"en": ["dragon", "imperial"]},
        ),
    ])


@pytest.fixture
def basic_jlpt_df():
    """JLPT lookup: 日→5, 人→5."""
    return _make_jlpt_df([("日", 5), ("人", 5)])


# ---------------------------------------------------------------------------
# Step 1: Kanji row creation
# ---------------------------------------------------------------------------


class TestKanjiRowCreation:
    def test_basic_field_mapping(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """Fields correctly mapped from kanjidic source."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        kanji_df = result["kanji"]

        nichi = kanji_df[kanji_df["character"] == "日"].iloc[0]
        assert nichi["stroke_count"] == 4
        assert nichi["min_grade"] == 1
        assert nichi["frequency_rank"] == 1

    def test_jlpt_lookup(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """JLPT level correctly mapped from jlpt_kanji.parquet."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        kanji_df = result["kanji"]

        nichi = kanji_df[kanji_df["character"] == "日"].iloc[0]
        assert nichi["min_jlpt_level"] == 5

    def test_jlpt_null_when_missing(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """Kanji not in JLPT set gets null min_jlpt_level."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        kanji_df = result["kanji"]

        dragon = kanji_df[kanji_df["character"] == "龍"].iloc[0]
        assert pd.isna(dragon["min_jlpt_level"])

    def test_synthetic_frequency(self, tmp_path):
        """Unranked kanji get 10001+ ranks, ordered by codepoint."""
        # A (U+0041), B (U+0042), C (U+0043) — all unranked
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row("C", stroke_count=3, ja_on=["C"], meanings={"en": ["c"]}),
            _kanjidic_row("A", stroke_count=1, ja_on=["A"], meanings={"en": ["a"]}),
            _kanjidic_row("B", stroke_count=2, frequency=100, ja_on=["B"], meanings={"en": ["b"]}),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        kanji_df = result["kanji"]

        # Sorted by codepoint: A, B, C
        a_row = kanji_df[kanji_df["character"] == "A"].iloc[0]
        b_row = kanji_df[kanji_df["character"] == "B"].iloc[0]
        c_row = kanji_df[kanji_df["character"] == "C"].iloc[0]

        assert b_row["frequency_rank"] == 100  # real rank preserved
        assert a_row["frequency_rank"] == 10001  # first unranked (by codepoint)
        assert c_row["frequency_rank"] == 10002  # second unranked

    def test_svg_fields_empty(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """SVG fields are null (populated by Phase 2.4)."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        kanji_df = result["kanji"]

        assert kanji_df["svg_file_name"].isna().all()
        assert kanji_df["svg_file_url"].isna().all()
        assert kanji_df["svg_hash"].isna().all()

    def test_grade_values_preserved(self, tmp_path):
        """Grade values 1-6, 8, 9, 10 and null are preserved as-is."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row("A", stroke_count=1, grade=1, ja_on=["A"], meanings={"en": ["a"]}),
            _kanjidic_row("B", stroke_count=2, grade=8, ja_on=["B"], meanings={"en": ["b"]}),
            _kanjidic_row("C", stroke_count=3, grade=9, ja_on=["C"], meanings={"en": ["c"]}),
            _kanjidic_row("D", stroke_count=4, grade=None, ja_on=["D"], meanings={"en": ["d"]}),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        kanji_df = result["kanji"]

        a = kanji_df[kanji_df["character"] == "A"].iloc[0]
        assert a["min_grade"] == 1

        b = kanji_df[kanji_df["character"] == "B"].iloc[0]
        assert b["min_grade"] == 8

        c = kanji_df[kanji_df["character"] == "C"].iloc[0]
        assert c["min_grade"] == 9

        d = kanji_df[kanji_df["character"] == "D"].iloc[0]
        assert pd.isna(d["min_grade"])


# ---------------------------------------------------------------------------
# Step 2: Reading rows
# ---------------------------------------------------------------------------


class TestReadingRows:
    def test_onyomi_kunyomi(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """Correct reading_type assignment for onyomi and kunyomi."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        readings_df = result["kanji_readings"]

        nichi_readings = readings_df[readings_df["character"] == "日"]

        onyomi = nichi_readings[nichi_readings["reading_type"] == "onyomi"]
        kunyomi = nichi_readings[nichi_readings["reading_type"] == "kunyomi"]

        assert set(onyomi["reading"]) == {"ニチ", "ジツ"}
        assert set(kunyomi["reading"]) == {"ひ", "-び", "-か"}
        assert (nichi_readings["priority"] == "primary").all()

    def test_preserve_okurigana(self, tmp_path):
        """Dots and dashes in kunyomi are preserved."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row(
                "休", stroke_count=6, ja_on=["キュウ"],
                ja_kun=["やす.む", "やす.まる", "やす.める"],
                meanings={"en": ["rest"]},
            ),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        readings_df = result["kanji_readings"]

        kunyomi = readings_df[readings_df["reading_type"] == "kunyomi"]
        reading_values = set(kunyomi["reading"])
        assert "やす.む" in reading_values
        assert "やす.まる" in reading_values
        assert "やす.める" in reading_values

    def test_nanori_readings(self, tmp_path):
        """Nanori readings get reading_type='nanori'."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row(
                "日", stroke_count=4, ja_on=["ニチ"], ja_kun=["ひ"],
                nanori=["あき", "くさ"],
                meanings={"en": ["day"]},
            ),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        readings_df = result["kanji_readings"]

        nanori = readings_df[readings_df["reading_type"] == "nanori"]
        assert set(nanori["reading"]) == {"あき", "くさ"}
        assert (nanori["priority"] == "primary").all()


# ---------------------------------------------------------------------------
# Step 3: I18n rows
# ---------------------------------------------------------------------------


class TestI18nRows:
    def test_all_languages(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """Rows created for all non-empty language meanings."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        i18n_df = result["kanji_i18n"]

        nichi_i18n = i18n_df[i18n_df["character"] == "日"]

        # 日 has en + es meanings
        assert set(nichi_i18n["lang_code"]) == {"en", "es"}

        en_row = nichi_i18n[nichi_i18n["lang_code"] == "en"].iloc[0]
        assert json.loads(en_row["meanings"]) == ["day", "sun", "Japan"]
        assert en_row["system_mnemonic"] == ""
        assert en_row["search_tags"] == "[]"

    def test_skip_empty_meanings(self, tmp_path):
        """No i18n row created for empty meanings array."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row(
                "日", stroke_count=4, ja_on=["ニチ"],
                meanings={"en": ["day"], "es": []},
            ),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        i18n_df = result["kanji_i18n"]

        # es has empty array → no row
        lang_codes = set(i18n_df["lang_code"])
        assert "en" in lang_codes
        assert "es" not in lang_codes

    def test_filter_non_target_langs(self, tmp_path):
        """Languages not in TARGET_LANGS are excluded from i18n output."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row(
                "日", stroke_count=4, ja_on=["ニチ"],
                meanings={"en": ["day"], "fr": ["jour"], "pt": ["dia"]},
            ),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        i18n_df = result["kanji_i18n"]

        # fr and pt are not in TARGET_LANGS → filtered out
        assert set(i18n_df["lang_code"]) == {"en"}

    def test_system_mnemonic_empty(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """system_mnemonic is empty string (Phase 3 placeholder)."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)
        i18n_df = result["kanji_i18n"]

        assert (i18n_df["system_mnemonic"] == "").all()
        assert (i18n_df["search_tags"] == "[]").all()


# ---------------------------------------------------------------------------
# Warnings
# ---------------------------------------------------------------------------


class TestWarnings:
    def test_no_readings_high_for_jlpt(self, tmp_path):
        """Kanji with no readings: high severity if JLPT-mapped."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row("日", stroke_count=4, meanings={"en": ["day"]}),
        ])
        jlpt_df = _make_jlpt_df([("日", 5)])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        extract_kanji(parquet_dir, csv_dir, warnings_dir)

        # Read warnings CSV
        w_df = pd.read_csv(warnings_dir / "ph2_2_warnings.csv")
        no_reading = w_df[
            (w_df["entity"] == "日") & (w_df["message"].str.contains("no readings"))
        ]
        assert len(no_reading) == 1
        assert no_reading.iloc[0]["severity"] == "high"

    def test_no_readings_low_for_non_jlpt(self, tmp_path):
        """Kanji with no readings: low severity if not JLPT-mapped."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row("龍", stroke_count=16, meanings={"en": ["dragon"]}),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        extract_kanji(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph2_2_warnings.csv")
        no_reading = w_df[
            (w_df["entity"] == "龍") & (w_df["message"].str.contains("no readings"))
        ]
        assert len(no_reading) == 1
        assert no_reading.iloc[0]["severity"] == "low"

    def test_missing_english_high_for_jlpt(self, tmp_path):
        """Missing English meanings: high severity if JLPT-mapped."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row(
                "日", stroke_count=4, ja_on=["ニチ"],
                meanings={"es": ["día"]},  # no English!
            ),
        ])
        jlpt_df = _make_jlpt_df([("日", 5)])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        extract_kanji(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph2_2_warnings.csv")
        no_en = w_df[
            (w_df["entity"] == "日") & (w_df["message"].str.contains("English"))
        ]
        assert len(no_en) == 1
        assert no_en.iloc[0]["severity"] == "high"

    def test_missing_english_low_for_non_jlpt(self, tmp_path):
        """Missing English meanings: low severity if not JLPT-mapped."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row(
                "龍", stroke_count=16, ja_on=["リュウ"],
                meanings={"es": ["dragón"]},  # no English
            ),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        extract_kanji(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph2_2_warnings.csv")
        no_en = w_df[
            (w_df["entity"] == "龍") & (w_df["message"].str.contains("English"))
        ]
        assert len(no_en) == 1
        assert no_en.iloc[0]["severity"] == "low"

    def test_jlpt_missing_from_kanjidic(self, tmp_path):
        """JLPT-mapped kanji not in kanjidic → high warning."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row("日", stroke_count=4, ja_on=["ニチ"], meanings={"en": ["day"]}),
        ])
        # 月 is JLPT-mapped but not in kanjidic
        jlpt_df = _make_jlpt_df([("日", 5), ("月", 4)])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        extract_kanji(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph2_2_warnings.csv")
        missing = w_df[
            (w_df["entity"] == "月")
            & (w_df["message"].str.contains("missing from KANJIDIC"))
        ]
        assert len(missing) == 1
        assert missing.iloc[0]["severity"] == "high"

    def test_no_readings_high_for_grade(self, tmp_path):
        """Kanji with no readings: high severity if grade 1-7 (even without JLPT)."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row("A", stroke_count=1, grade=3, meanings={"en": ["a"]}),
        ])
        jlpt_df = _make_jlpt_df([])  # not JLPT-mapped

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        extract_kanji(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph2_2_warnings.csv")
        no_reading = w_df[
            (w_df["entity"] == "A") & (w_df["message"].str.contains("no readings"))
        ]
        assert len(no_reading) == 1
        assert no_reading.iloc[0]["severity"] == "high"

    def test_no_readings_low_for_high_grade(self, tmp_path):
        """Kanji with no readings: low severity if grade > 7 and no JLPT."""
        kanjidic_df = _make_kanjidic_df([
            _kanjidic_row("A", stroke_count=1, grade=9, meanings={"en": ["a"]}),
        ])
        jlpt_df = _make_jlpt_df([])

        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        extract_kanji(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph2_2_warnings.csv")
        no_reading = w_df[
            (w_df["entity"] == "A") & (w_df["message"].str.contains("no readings"))
        ]
        assert len(no_reading) == 1
        assert no_reading.iloc[0]["severity"] == "low"


# ---------------------------------------------------------------------------
# Integration
# ---------------------------------------------------------------------------


class TestIntegration:
    def test_full_pipeline(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """Full pipeline with temp dirs: verify CSV output files."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_kanji(parquet_dir, csv_dir, warnings_dir)

        # CSVs should exist
        assert (csv_dir / "kanji.csv").exists()
        assert (csv_dir / "kanji_readings.csv").exists()
        assert (csv_dir / "kanji_i18n.csv").exists()

        # Load and verify round-trip
        kanji_csv = pd.read_csv(csv_dir / "kanji.csv")
        readings_csv = pd.read_csv(csv_dir / "kanji_readings.csv")
        i18n_csv = pd.read_csv(csv_dir / "kanji_i18n.csv")

        assert len(kanji_csv) == 3  # 日, 人, 龍
        assert len(readings_csv) > 0
        assert len(i18n_csv) > 0

        # Unique characters
        assert kanji_csv["character"].is_unique

        # Result dict matches
        assert len(result["kanji"]) == 3
        assert len(result["kanji_readings"]) == len(readings_csv)
        assert len(result["kanji_i18n"]) == len(i18n_csv)

    def test_deterministic_output(self, basic_kanjidic_df, basic_jlpt_df, tmp_path):
        """Running twice produces identical output."""
        for run in ("run1", "run2"):
            parquet_dir = tmp_path / "parquet"
            parquet_dir.mkdir(exist_ok=True)
            csv_dir = tmp_path / run / "csv"
            warnings_dir = csv_dir / "warnings"

            basic_kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
            basic_jlpt_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

            extract_kanji(parquet_dir, csv_dir, warnings_dir)

        kanji1 = pd.read_csv(tmp_path / "run1" / "csv" / "kanji.csv")
        kanji2 = pd.read_csv(tmp_path / "run2" / "csv" / "kanji.csv")
        pd.testing.assert_frame_equal(kanji1, kanji2)

        readings1 = pd.read_csv(tmp_path / "run1" / "csv" / "kanji_readings.csv")
        readings2 = pd.read_csv(tmp_path / "run2" / "csv" / "kanji_readings.csv")
        pd.testing.assert_frame_equal(readings1, readings2)

        i18n1 = pd.read_csv(tmp_path / "run1" / "csv" / "kanji_i18n.csv")
        i18n2 = pd.read_csv(tmp_path / "run2" / "csv" / "kanji_i18n.csv")
        pd.testing.assert_frame_equal(i18n1, i18n2)
