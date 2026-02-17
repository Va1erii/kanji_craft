"""Tests for Phase 3.1 logic hint refinement."""

import json
from pathlib import Path

import pandas as pd

from src.enrichers.ph3_1_logic_hints import refine_logic_hints

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _make_kanjidic_parquet(parquet_dir: Path, entries: list[dict]) -> None:
    """Write kanjidic.parquet. entries: list of {"literal": str, "readings": dict}."""
    rows = []
    for e in entries:
        readings = e.get("readings", {})
        rows.append({
            "literal": e["literal"],
            "stroke_count": e.get("stroke_count", 5),
            "stroke_count_misstrokes": None,
            "grade": e.get("grade"),
            "jlpt": e.get("jlpt"),
            "frequency": e.get("frequency"),
            "codepoints": "{}",
            "radicals": "{}",
            "variants": "[]",
            "dict_refs": "{}",
            "query_codes": "{}",
            "readings": json.dumps(readings, ensure_ascii=False),
            "meanings": "{}",
            "nanori": "[]",
            "radical_names": "[]",
        })
    df = pd.DataFrame(rows)
    parquet_dir.mkdir(parents=True, exist_ok=True)
    df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)


def _make_radicals_csv(csv_dir: Path, rows: list[str]) -> None:
    """Write radicals.csv. rows: list of master_symbol strings."""
    data = []
    for ms in rows:
        data.append({
            "master_symbol": ms,
            "is_official": False,
            "stroke_count": 3,
            "visual_group": "",
            "svg_file_name": "",
            "svg_file_url": "",
            "svg_hash": "",
            "impact_score": 1,
            "min_grade": 1,
            "min_jlpt_level": 5,
        })
    df = pd.DataFrame(data)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "radicals.csv", index=False)


def _make_kanji_readings_csv(csv_dir: Path, rows: list[tuple]) -> None:
    """Write kanji_readings.csv. rows: list of (character, reading, reading_type, priority)."""
    data = []
    for char, reading, rtype, priority in rows:
        data.append({
            "character": char,
            "reading": reading,
            "reading_type": rtype,
            "priority": priority,
        })
    df = pd.DataFrame(data)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji_readings.csv", index=False)


def _make_kanji_components_csv(csv_dir: Path, rows: list[dict]) -> None:
    """Write kanji_components.csv. rows: list of component dicts."""
    df = pd.DataFrame(rows)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji_components.csv", index=False)


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


class TestPhoneticMatch:
    def test_phonetic_match(self, tmp_path):
        """Kanji 清(SEI) + radical 青(SEI,SHOU) → phonetic."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # 青 is a radical with onyomi セイ, ショウ
        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "青", "readings": {"ja_on": ["セイ", "ショウ"]}},
        ])
        _make_radicals_csv(csv_dir, ["青"])
        # Kanji 清 has onyomi セイ
        _make_kanji_readings_csv(csv_dir, [
            ("清", "セイ", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "清", "master_symbol": "青", "position": "tsukuri",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        assert df.iloc[0]["logic_hint"] == "phonetic"


class TestNoMatchStaysSemantic:
    def test_no_match_stays_semantic(self, tmp_path):
        """Kanji 休(KYUU) + radical 人(JIN,NIN) → semantic (no onyomi overlap)."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "人", "readings": {"ja_on": ["ジン", "ニン"]}},
        ])
        _make_radicals_csv(csv_dir, ["人"])
        _make_kanji_readings_csv(csv_dir, [
            ("休", "キュウ", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "休", "master_symbol": "人", "position": "hen",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        assert df.iloc[0]["logic_hint"] == "semantic"


class TestMultipleOnyomiAnyMatch:
    def test_multiple_onyomi_any_match(self, tmp_path):
        """Radical has 3 readings, kanji has 2 — one pair matches → phonetic."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "工", "readings": {"ja_on": ["コウ", "ク", "グ"]}},
        ])
        _make_radicals_csv(csv_dir, ["工"])
        _make_kanji_readings_csv(csv_dir, [
            ("功", "コウ", "onyomi", "primary"),
            ("功", "ギョウ", "onyomi", "secondary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "功", "master_symbol": "工", "position": "tsukuri",
             "logic_hint": "semantic", "radical_type": "component", "is_primary": False},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        assert df.iloc[0]["logic_hint"] == "phonetic"


class TestRadicalNotInKanjidic:
    def test_radical_not_in_kanjidic(self, tmp_path):
        """Radical master_symbol not in KANJIDIC → stays semantic + low warning."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # kanjidic has no entry for ⺍
        _make_kanjidic_parquet(parquet_dir, [])
        _make_radicals_csv(csv_dir, ["⺍"])
        _make_kanji_readings_csv(csv_dir, [
            ("清", "セイ", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "清", "master_symbol": "⺍", "position": "kanmuri",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        assert df.iloc[0]["logic_hint"] == "semantic"

        # Check warning
        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
        low = w_df[w_df["severity"] == "low"]
        assert len(low) >= 1
        assert "not found in KANJIDIC" in low.iloc[0]["message"]


class TestKanjiNoOnyomi:
    def test_kanji_no_onyomi(self, tmp_path):
        """Kanji with only kunyomi → all components stay semantic."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "木", "readings": {"ja_on": ["モク", "ボク"]}},
        ])
        _make_radicals_csv(csv_dir, ["木"])
        # Only kunyomi readings for this kanji
        _make_kanji_readings_csv(csv_dir, [
            ("休", "やす.む", "kunyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "休", "master_symbol": "木", "position": "tsukuri",
             "logic_hint": "semantic", "radical_type": "component", "is_primary": False},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        assert df.iloc[0]["logic_hint"] == "semantic"


class TestPositionConflictWarning:
    def test_position_conflict_warning(self, tmp_path):
        """Phonetic match at 'hen' position → medium warning logged."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "青", "readings": {"ja_on": ["セイ", "ショウ"]}},
        ])
        _make_radicals_csv(csv_dir, ["青"])
        _make_kanji_readings_csv(csv_dir, [
            ("清", "セイ", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "清", "master_symbol": "青", "position": "hen",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        # Still marked phonetic (position doesn't override)
        assert df.iloc[0]["logic_hint"] == "phonetic"

        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
        medium = w_df[w_df["severity"] == "medium"]
        assert len(medium) >= 1
        assert "typically semantic" in medium.iloc[0]["message"]


class TestPositionAgreementNoWarning:
    def test_position_agreement_no_warning(self, tmp_path):
        """Phonetic match at 'tsukuri' position → no position warning."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "青", "readings": {"ja_on": ["セイ"]}},
        ])
        _make_radicals_csv(csv_dir, ["青"])
        _make_kanji_readings_csv(csv_dir, [
            ("清", "セイ", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "清", "master_symbol": "青", "position": "tsukuri",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        assert df.iloc[0]["logic_hint"] == "phonetic"

        # No medium (position-conflict) warnings
        if (warnings_dir / "ph3_warnings.csv").exists():
            w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
            medium = w_df[w_df["severity"] == "medium"]
            assert len(medium) == 0


class TestUnknownPositionNoWarning:
    def test_unknown_position_no_warning(self, tmp_path):
        """Phonetic match at 'unknown' position → no position warning."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "工", "readings": {"ja_on": ["コウ"]}},
        ])
        _make_radicals_csv(csv_dir, ["工"])
        _make_kanji_readings_csv(csv_dir, [
            ("功", "コウ", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "功", "master_symbol": "工", "position": "unknown",
             "logic_hint": "semantic", "radical_type": "component", "is_primary": False},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        assert df.iloc[0]["logic_hint"] == "phonetic"

        if (warnings_dir / "ph3_warnings.csv").exists():
            w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
            medium = w_df[w_df["severity"] == "medium"]
            assert len(medium) == 0


class TestSameRadicalDifferentKanji:
    def test_same_radical_different_kanji(self, tmp_path):
        """Same radical is phonetic in one kanji, semantic in another."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # Radical 青 has onyomi セイ, ショウ
        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "青", "readings": {"ja_on": ["セイ", "ショウ"]}},
        ])
        _make_radicals_csv(csv_dir, ["青"])
        _make_kanji_readings_csv(csv_dir, [
            # Kanji 清 has onyomi セイ → matches
            ("清", "セイ", "onyomi", "primary"),
            # Kanji 漢 has onyomi カン → no match
            ("漢", "カン", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "清", "master_symbol": "青", "position": "tsukuri",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
            {"character": "漢", "master_symbol": "青", "position": "tsukuri",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
        ])

        result = refine_logic_hints(parquet_dir, csv_dir, warnings_dir)
        df = result["kanji_components"]

        row_sei = df[df["character"] == "清"].iloc[0]
        row_kan = df[df["character"] == "漢"].iloc[0]

        assert row_sei["logic_hint"] == "phonetic"
        assert row_kan["logic_hint"] == "semantic"


class TestWarningsAppended:
    def test_warnings_appended_to_existing(self, tmp_path):
        """Warnings are appended to existing ph3_warnings.csv, not overwritten."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"
        warnings_dir.mkdir(parents=True, exist_ok=True)

        # Pre-existing warning from Step 3.0
        existing = pd.DataFrame([{
            "severity": "low",
            "phase": "3.0",
            "entity": "⺍",
            "message": "Radical not used in any kanji component",
        }])
        existing.to_csv(warnings_dir / "ph3_warnings.csv", index=False)

        # Set up a case that produces a warning (radical not in KANJIDIC)
        _make_kanjidic_parquet(parquet_dir, [])
        _make_radicals_csv(csv_dir, ["⺍"])
        _make_kanji_readings_csv(csv_dir, [
            ("清", "セイ", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "清", "master_symbol": "⺍", "position": "kanmuri",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
        ])

        refine_logic_hints(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
        # Should have both the pre-existing (3.0) and new (3.1) warnings
        assert len(w_df) >= 2
        phases = set(str(p) for p in w_df["phase"].tolist())
        assert "3.0" in phases
        assert "3.1" in phases


class TestOutputWrittenToCsv:
    def test_output_written_to_csv(self, tmp_path):
        """Updated CSV file exists and has correct content."""
        parquet_dir = tmp_path / "parquet"
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "青", "readings": {"ja_on": ["セイ"]}},
        ])
        _make_radicals_csv(csv_dir, ["青"])
        _make_kanji_readings_csv(csv_dir, [
            ("清", "セイ", "onyomi", "primary"),
        ])
        _make_kanji_components_csv(csv_dir, [
            {"character": "清", "master_symbol": "青", "position": "tsukuri",
             "logic_hint": "semantic", "radical_type": "general", "is_primary": True},
        ])

        refine_logic_hints(parquet_dir, csv_dir, warnings_dir)

        # Read back the written CSV
        csv_df = pd.read_csv(csv_dir / "kanji_components.csv")
        assert len(csv_df) == 1
        assert csv_df.iloc[0]["logic_hint"] == "phonetic"
        # All original columns preserved
        assert "character" in csv_df.columns
        assert "master_symbol" in csv_df.columns
        assert "position" in csv_df.columns
        assert "radical_type" in csv_df.columns
        assert "is_primary" in csv_df.columns
