"""Tests for Phase 3.2 radical i18n creation."""

import json
from pathlib import Path

import pandas as pd

from src.enrichers.ph3_2_radical_i18n import create_radical_i18n

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _make_kanjidic_parquet(parquet_dir: Path, entries: list[dict]) -> None:
    """Write kanjidic.parquet. entries: list of {"literal": str, "meanings": dict, ...}."""
    rows = []
    for e in entries:
        meanings = e.get("meanings", {})
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
            "meanings": json.dumps(meanings, ensure_ascii=False),
            "nanori": "[]",
            "radical_names": "[]",
        })
    df = pd.DataFrame(rows)
    parquet_dir.mkdir(parents=True, exist_ok=True)
    df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)


def _make_radicals_csv(csv_dir: Path, rows: list[dict]) -> None:
    """Write radicals.csv. rows: list of dicts with at least id, master_symbol."""
    data = []
    for r in rows:
        data.append({
            "id": r["id"],
            "master_symbol": r["master_symbol"],
            "is_official": r.get("is_official", False),
            "stroke_count": r.get("stroke_count", 3),
            "visual_group": r.get("visual_group", ""),
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


def _make_visual_rules_json(data_dir: Path, rules: dict) -> None:
    """Write visual_rules.json."""
    data_dir.mkdir(parents=True, exist_ok=True)
    (data_dir / "visual_rules.json").write_text(
        json.dumps(rules, ensure_ascii=False), encoding="utf-8"
    )


def _make_ai_csv(ai_dir: Path, rows: list[dict]) -> None:
    """Write radical_i18n_ai.csv."""
    ai_dir.mkdir(parents=True, exist_ok=True)
    df = pd.DataFrame(rows)
    if df.empty:
        cols = ["master_symbol", "lang_code", "name", "system_mnemonic", "search_tags"]
        df = pd.DataFrame(columns=cols)
    df.to_csv(ai_dir / "radical_i18n_ai.csv", index=False)


def _make_kanji_csv(csv_dir: Path, rows: list[dict]) -> None:
    """Write kanji.csv."""
    data = []
    for r in rows:
        data.append({
            "id": r["id"],
            "character": r["character"],
            "stroke_count": r.get("stroke_count", 5),
            "min_grade": r.get("min_grade"),
            "min_jlpt_level": r.get("min_jlpt_level"),
            "frequency_rank": r.get("frequency_rank", 10001),
            "svg_file_name": "",
            "svg_file_url": "",
            "svg_hash": "",
        })
    df = pd.DataFrame(data)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji.csv", index=False)


def _make_kanji_i18n_csv(csv_dir: Path, rows: list[dict]) -> None:
    """Write kanji_i18n.csv."""
    data = []
    for r in rows:
        data.append({
            "kanji_id": r["kanji_id"],
            "lang_code": r["lang_code"],
            "meanings": json.dumps(r.get("meanings", []), ensure_ascii=False),
            "system_mnemonic": r.get("system_mnemonic", ""),
            "search_tags": r.get("search_tags", "[]"),
        })
    df = pd.DataFrame(data)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji_i18n.csv", index=False)


def _setup_dirs(tmp_path: Path) -> tuple[Path, Path, Path, Path, Path]:
    """Create standard directory layout and return paths."""
    parquet_dir = tmp_path / "parquet"
    data_dir = tmp_path  # visual_rules.json lives here
    csv_dir = data_dir / "csv"
    warnings_dir = csv_dir / "warnings"
    ai_dir = data_dir / "ai"
    return parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


class TestScaffoldCreatesAllRows:
    def test_scaffold_creates_all_rows(self, tmp_path):
        """2 radicals × 3 langs = 6 rows."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "水", "meanings": {"en": ["water"]}},
            {"literal": "火", "meanings": {"en": ["fire"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "水"},
            {"id": 2, "master_symbol": "火"},
        ])
        _make_visual_rules_json(data_dir, {})

        result = create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)
        df = result["radical_i18n"]

        assert len(df) == 6
        assert set(df["lang_code"]) == {"en", "es", "ru"}
        assert set(df["radical_id"]) == {1, 2}


class TestEnNameFromKanjidic:
    def test_en_name_from_kanjidic(self, tmp_path):
        """EN name comes from KANJIDIC first English meaning."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "水", "meanings": {"en": ["water", "liquid"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "水"},
        ])
        _make_visual_rules_json(data_dir, {})

        result = create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)
        df = result["radical_i18n"]

        en_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "en")].iloc[0]
        assert en_row["name"] == "water"

        # ES/RU should be empty
        es_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "es")].iloc[0]
        assert es_row["name"] == ""
        ru_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "ru")].iloc[0]
        assert ru_row["name"] == ""


class TestNoKanjidicEntryEmptyName:
    def test_no_kanjidic_entry_empty_name(self, tmp_path):
        """No KANJIDIC entry → empty EN name + low warning."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [])  # No entries
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "⺍"},
        ])
        _make_visual_rules_json(data_dir, {})

        result = create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)
        df = result["radical_i18n"]

        en_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "en")].iloc[0]
        assert en_row["name"] == ""

        # Check warning
        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv", dtype=str, keep_default_na=False)
        low_32 = w_df[(w_df["severity"] == "low") & (w_df["phase"] == "3.2")]
        kanjidic_warnings = low_32[low_32["message"].str.contains("not found in KANJIDIC")]
        assert len(kanjidic_warnings) >= 1


class TestDisambiguationNoteFromVisualRules:
    def test_disambiguation_note_from_visual_rules(self, tmp_path):
        """Disambiguation note populated per language from visual_rules.json."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "肉", "meanings": {"en": ["meat"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "肉", "visual_group": "月"},
        ])
        _make_visual_rules_json(data_dir, {
            "肉": {
                "visual_group": "月",
                "disambiguation_note": {
                    "en": "Left or bottom means flesh",
                    "es": "Izquierda o abajo significa carne",
                    "ru": "Слева или снизу означает плоть",
                },
            },
        })

        result = create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)
        df = result["radical_i18n"]

        en_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "en")].iloc[0]
        assert en_row["disambiguation_note"] == "Left or bottom means flesh"

        es_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "es")].iloc[0]
        assert es_row["disambiguation_note"] == "Izquierda o abajo significa carne"

        ru_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "ru")].iloc[0]
        assert ru_row["disambiguation_note"] == "Слева или снизу означает плоть"


class TestNoVisualGroupNullNote:
    def test_no_visual_group_null_note(self, tmp_path):
        """No visual_group → empty disambiguation note."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "水", "meanings": {"en": ["water"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "水"},
        ])
        _make_visual_rules_json(data_dir, {})

        result = create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)
        df = result["radical_i18n"]

        for lang in ["en", "es", "ru"]:
            row = df[(df["radical_id"] == 1) & (df["lang_code"] == lang)].iloc[0]
            assert row["disambiguation_note"] == ""


class TestAiMergeOverridesFields:
    def test_ai_merge_overrides_fields(self, tmp_path):
        """AI file overrides name, mnemonic, tags."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "水", "meanings": {"en": ["water"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "水"},
        ])
        _make_visual_rules_json(data_dir, {})
        _make_ai_csv(ai_dir, [
            {
                "master_symbol": "水",
                "lang_code": "en",
                "name": "Water",
                "system_mnemonic": "Drops flowing down a stream",
                "search_tags": '["liquid", "splash"]',
            },
            {
                "master_symbol": "水",
                "lang_code": "es",
                "name": "Agua",
                "system_mnemonic": "Gotas que caen",
                "search_tags": '["liquido", "rio"]',
            },
        ])

        result = create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)
        df = result["radical_i18n"]

        en_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "en")].iloc[0]
        assert en_row["name"] == "Water"
        assert en_row["system_mnemonic"] == "Drops flowing down a stream"
        assert en_row["search_tags"] == '["liquid", "splash"]'

        es_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "es")].iloc[0]
        assert es_row["name"] == "Agua"
        assert es_row["system_mnemonic"] == "Gotas que caen"


class TestAiMergeEmptyFieldsPreserved:
    def test_ai_merge_empty_fields_preserved(self, tmp_path):
        """Empty AI fields don't overwrite scaffold values."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "水", "meanings": {"en": ["water"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "水"},
        ])
        _make_visual_rules_json(data_dir, {})
        # AI row with empty name and mnemonic — should NOT overwrite scaffold
        _make_ai_csv(ai_dir, [
            {
                "master_symbol": "水",
                "lang_code": "en",
                "name": "",
                "system_mnemonic": "",
                "search_tags": "",
            },
        ])

        result = create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)
        df = result["radical_i18n"]

        en_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "en")].iloc[0]
        # Scaffold EN name from KANJIDIC should be preserved
        assert en_row["name"] == "water"
        assert en_row["system_mnemonic"] == ""
        assert en_row["search_tags"] == "[]"


class TestAiMergeMissingFile:
    def test_ai_merge_missing_file(self, tmp_path):
        """No AI file → scaffold-only, no error."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "水", "meanings": {"en": ["water"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "水"},
        ])
        _make_visual_rules_json(data_dir, {})
        # Do NOT create AI file

        result = create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)
        df = result["radical_i18n"]

        assert len(df) == 3  # 1 radical × 3 langs
        en_row = df[(df["radical_id"] == 1) & (df["lang_code"] == "en")].iloc[0]
        assert en_row["name"] == "water"


class TestRadicalKanjiConsistencyWarning:
    def test_radical_kanji_consistency_warning(self, tmp_path):
        """Radical name ≠ kanji meaning → high warning."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "水", "meanings": {"en": ["water"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "水"},
        ])
        _make_visual_rules_json(data_dir, {})
        # AI gives a different EN name than KANJIDIC
        _make_ai_csv(ai_dir, [
            {
                "master_symbol": "水",
                "lang_code": "en",
                "name": "Aqua",
                "system_mnemonic": "",
                "search_tags": "",
            },
        ])
        # Kanji 水 exists with meaning "water"
        _make_kanji_csv(csv_dir, [
            {"id": 10, "character": "水"},
        ])
        _make_kanji_i18n_csv(csv_dir, [
            {"kanji_id": 10, "lang_code": "en", "meanings": ["water"]},
        ])

        create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)

        # Check for high warning about mismatch
        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv", dtype=str, keep_default_na=False)
        high = w_df[(w_df["severity"] == "high") & (w_df["phase"] == "3.2")]
        assert len(high) >= 1
        assert "differs from" in high.iloc[0]["message"]


class TestOutputColumnsAndCsv:
    def test_output_columns_and_csv(self, tmp_path):
        """CSV written with correct columns."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [
            {"literal": "水", "meanings": {"en": ["water"]}},
        ])
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "水"},
        ])
        _make_visual_rules_json(data_dir, {})

        create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)

        # Read back the written CSV
        csv_df = pd.read_csv(csv_dir / "radical_i18n.csv")
        expected_cols = [
            "radical_id", "lang_code", "name", "system_mnemonic",
            "search_tags", "disambiguation_note",
        ]
        assert list(csv_df.columns) == expected_cols
        assert len(csv_df) == 3


class TestWarningsAppendedToExisting:
    def test_warnings_appended_to_existing(self, tmp_path):
        """New 3.2 warnings merge with existing ph3 warnings."""
        parquet_dir, data_dir, csv_dir, warnings_dir, ai_dir = _setup_dirs(tmp_path)

        _make_kanjidic_parquet(parquet_dir, [])  # No entries → triggers warning
        _make_radicals_csv(csv_dir, [
            {"id": 1, "master_symbol": "⺍"},
        ])
        _make_visual_rules_json(data_dir, {})

        # Pre-populate existing warnings from step 3.1
        warnings_dir.mkdir(parents=True, exist_ok=True)
        existing_df = pd.DataFrame([{
            "severity": "low",
            "phase": "3.1",
            "entity": "⺍",
            "message": "Radical master_symbol not found in KANJIDIC",
        }])
        existing_df.to_csv(warnings_dir / "ph3_warnings.csv", index=False)

        create_radical_i18n(parquet_dir, csv_dir, warnings_dir, ai_dir)

        # Warnings should contain both 3.1 and 3.2 entries
        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
        phases = set(w_df["phase"].astype(str))
        assert "3.1" in phases
        assert "3.2" in phases
        assert len(w_df) > 1
