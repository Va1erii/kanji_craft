"""Tests for Phase 3.0 radical classification."""

from pathlib import Path

import pandas as pd

from src.enrichers.ph3_0_classify_radicals import classify_radicals

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_RADICAL_DEFAULTS = {
    "master_symbol": "一",
    "family_symbol": "",
    "positions": "[]",
    "is_official": False,
    "stroke_count": 1,
    "visual_group": "",
    "svg_file_name": "",
    "svg_file_url": "",
    "svg_hash": "",
    "impact_score": 1,
    "min_grade": "",
    "min_jlpt_level": "",
}

_KANJI_DEFAULTS = {
    "character": "一",
    "stroke_count": 1,
    "min_grade": "",
    "min_jlpt_level": "",
    "frequency_rank": 10001,
    "svg_file_name": "",
    "svg_file_url": "",
    "svg_hash": "",
}

_COMPONENT_DEFAULTS = {
    "character": "二",
    "master_symbol": "一",
    "position": "unknown",
    "logic_hint": "semantic",
    "radical_type": "general",
    "is_primary": True,
}


def _make_radicals_csv(csv_dir: Path, rows: list[dict]) -> None:
    """Write radicals.csv with defaults overridden by each row dict."""
    data = [{**_RADICAL_DEFAULTS, **r} for r in rows]
    df = pd.DataFrame(data)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "radicals.csv", index=False)


def _make_kanji_csv(csv_dir: Path, rows: list[dict]) -> None:
    """Write kanji.csv with defaults overridden by each row dict."""
    data = [{**_KANJI_DEFAULTS, **r} for r in rows]
    df = pd.DataFrame(data) if data else pd.DataFrame(columns=_KANJI_DEFAULTS.keys())
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji.csv", index=False)


def _make_components_csv(csv_dir: Path, rows: list[dict]) -> None:
    """Write kanji_components.csv with defaults overridden by each row dict."""
    data = [{**_COMPONENT_DEFAULTS, **r} for r in rows]
    df = pd.DataFrame(data) if data else pd.DataFrame(columns=_COMPONENT_DEFAULTS.keys())
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji_components.csv", index=False)


def _make_manual_keep(tmp_path: Path, chars: list[str]) -> Path:
    """Write manual_keep.txt and return its path."""
    path = tmp_path / "manual_keep.txt"
    path.write_text("\n".join(chars) + "\n", encoding="utf-8")
    return path


def _setup(tmp_path: Path) -> tuple[Path, Path, Path]:
    """Return (csv_dir, warnings_dir, manual_keep_path). Creates empty manual_keep.txt."""
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"
    manual_keep_path = _make_manual_keep(tmp_path, [])
    return csv_dir, warnings_dir, manual_keep_path


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


class TestKeepKangxi:
    def test_official_radical_classified_as_keep_kangxi(self, tmp_path):
        """Official Kangxi radical → keep_kangxi even if it has a kanji form."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "人", "is_official": True},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "人", "min_jlpt_level": 5},
        ])
        _make_components_csv(csv_dir, [
            {"character": "大", "master_symbol": "人"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "人"].iloc[0]
        assert row["classification"] == "keep_kangxi"


class TestKeepRadicalOnly:
    def test_radical_not_in_kanji(self, tmp_path):
        """Radical master_symbol not in kanji.csv → keep_radical_only."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "⺍"},
        ])
        _make_kanji_csv(csv_dir, [])  # No kanji at all
        _make_components_csv(csv_dir, [
            {"character": "清", "master_symbol": "⺍"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "⺍"].iloc[0]
        assert row["classification"] == "keep_radical_only"


class TestKeepCrossJlpt:
    def test_n1_component_in_n5_parent(self, tmp_path):
        """N1 component used in N5 parent → keep_cross_jlpt."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "龍"},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "龍", "min_jlpt_level": 1},
            {"character": "滝", "min_jlpt_level": 5},
        ])
        _make_components_csv(csv_dir, [
            {"character": "滝", "master_symbol": "龍"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "龍"].iloc[0]
        assert row["classification"] == "keep_cross_jlpt"
        assert "N1" in row["reason"]
        assert "N5" in row["reason"]

    def test_null_jlpt_component_in_jlpt_parent(self, tmp_path):
        """Null-JLPT component used in N5 parent → keep_cross_jlpt (play safe)."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "甲"},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "甲"},  # No JLPT
            {"character": "押", "min_jlpt_level": 5},
        ])
        _make_components_csv(csv_dir, [
            {"character": "押", "master_symbol": "甲"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "甲"].iloc[0]
        assert row["classification"] == "keep_cross_jlpt"
        assert "Null-JLPT" in row["reason"]

    def test_easier_component_in_harder_parent_not_cross(self, tmp_path):
        """N5 component in N1 parent → NOT cross-JLPT."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "日"},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "日", "min_jlpt_level": 5},
            {"character": "曜", "min_jlpt_level": 1},
        ])
        _make_components_csv(csv_dir, [
            {"character": "曜", "master_symbol": "日"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "日"].iloc[0]
        assert row["classification"] != "keep_cross_jlpt"

    def test_both_null_jlpt_not_cross(self, tmp_path):
        """Component and parent both have null JLPT → not cross-JLPT."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "甲"},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "甲"},  # No JLPT
            {"character": "胛"},  # No JLPT
        ])
        _make_components_csv(csv_dir, [
            {"character": "胛", "master_symbol": "甲"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "甲"].iloc[0]
        assert row["classification"] != "keep_cross_jlpt"


class TestKeepHighFreq:
    def test_high_usage_same_jlpt(self, tmp_path):
        """Same JLPT, high usage count → keep_high_freq."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "口"},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "口", "min_jlpt_level": 3},
        ])
        # Create 15+ parent kanji at same JLPT level
        parents = [
            {"character": f"呂{i}", "min_jlpt_level": 3} for i in range(15)
        ]
        _make_kanji_csv(csv_dir, [{"character": "口", "min_jlpt_level": 3}] + parents)
        components = [
            {"character": f"呂{i}", "master_symbol": "口"} for i in range(15)
        ]
        _make_components_csv(csv_dir, components)

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "口"].iloc[0]
        assert row["classification"] == "keep_high_freq"


class TestConvertToKanji:
    def test_low_usage_same_jlpt(self, tmp_path):
        """Low usage, same JLPT → convert_to_kanji."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "田"},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "田", "min_jlpt_level": 3},
            {"character": "男", "min_jlpt_level": 3},
        ])
        _make_components_csv(csv_dir, [
            {"character": "男", "master_symbol": "田"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "田"].iloc[0]
        assert row["classification"] == "convert_to_kanji"


class TestNoParents:
    def test_no_parents_still_classified(self, tmp_path):
        """Radical not used in any component → usage_count=0, still classified."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "⺍"},
        ])
        _make_kanji_csv(csv_dir, [])
        _make_components_csv(csv_dir, [])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        assert len(df) == 1
        row = df.iloc[0]
        assert row["usage_count"] == 0
        assert row["classification"] == "keep_radical_only"


class TestKeepManual:
    def test_manual_keep_overrides_convert(self, tmp_path):
        """Radical in manual_keep.txt → keep_manual even if it would be convert_to_kanji."""
        csv_dir, warnings_dir, _ = _setup(tmp_path)
        mk_path = _make_manual_keep(tmp_path, ["田"])

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "田"},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "田", "min_jlpt_level": 3},
            {"character": "男", "min_jlpt_level": 3},
        ])
        _make_components_csv(csv_dir, [
            {"character": "男", "master_symbol": "田"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "田"].iloc[0]
        assert row["classification"] == "keep_manual"
        assert "manual_keep.txt" in row["reason"]

    def test_manual_keep_beats_kangxi(self, tmp_path):
        """Manual keep has higher priority than Kangxi."""
        csv_dir, warnings_dir, _ = _setup(tmp_path)
        mk_path = _make_manual_keep(tmp_path, ["人"])

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "人", "is_official": True},
        ])
        _make_kanji_csv(csv_dir, [])
        _make_components_csv(csv_dir, [])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        row = df[df["master_symbol"] == "人"].iloc[0]
        assert row["classification"] == "keep_manual"


class TestOutputFormat:
    def test_columns_complete(self, tmp_path):
        """Output CSV has all expected columns."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "人", "is_official": True, "impact_score": 42},
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "人", "min_jlpt_level": 5},
        ])
        _make_components_csv(csv_dir, [
            {"character": "大", "master_symbol": "人"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        expected_cols = {
            "master_symbol", "family_symbol", "is_official", "is_kanji",
            "kanji_jlpt", "min_parent_jlpt", "usage_count", "impact_score",
            "classification", "reason",
        }
        assert set(df.columns) == expected_cols

    def test_csv_written(self, tmp_path):
        """radical_classification.csv is written and readable."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "人", "is_official": True},
        ])
        _make_kanji_csv(csv_dir, [])
        _make_components_csv(csv_dir, [])

        classify_radicals(csv_dir, warnings_dir, mk_path)

        csv_path = csv_dir / "radical_classification.csv"
        assert csv_path.exists()
        df = pd.read_csv(csv_path)
        assert len(df) == 1

    def test_sorted_by_classification_then_symbol(self, tmp_path):
        """Output is sorted by classification then master_symbol."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "田"},           # Will be convert_to_kanji
            {"master_symbol": "人", "is_official": True},  # keep_kangxi
            {"master_symbol": "⺍"},           # keep_radical_only (not a kanji)
        ])
        _make_kanji_csv(csv_dir, [
            {"character": "人", "min_jlpt_level": 5},
            {"character": "田", "min_jlpt_level": 3},
            {"character": "男", "min_jlpt_level": 3},
        ])
        _make_components_csv(csv_dir, [
            {"character": "男", "master_symbol": "田"},
        ])

        result = classify_radicals(csv_dir, warnings_dir, mk_path)
        df = result["radical_classification"]

        classifications = df["classification"].tolist()
        # Sorted alphabetically: convert_to_kanji, keep_kangxi, keep_radical_only
        assert classifications == sorted(classifications)


class TestWarnings:
    def test_unused_radical_low_warning(self, tmp_path):
        """Radical not used in any component → low warning."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "⺍"},
        ])
        _make_kanji_csv(csv_dir, [])
        _make_components_csv(csv_dir, [])

        classify_radicals(csv_dir, warnings_dir, mk_path)

        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
        low = w_df[w_df["severity"] == "low"]
        assert len(low) >= 1
        assert "not used in any kanji" in low.iloc[0]["message"]

    def test_null_jlpt_high_usage_medium_warning(self, tmp_path):
        """Null-JLPT component with high usage classified as cross-JLPT → medium warning."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "甲"},
        ])
        # 甲 has no JLPT, but many parents do
        parents = [
            {"character": f"甲{i}", "min_jlpt_level": 3} for i in range(15)
        ]
        _make_kanji_csv(csv_dir, [{"character": "甲"}] + parents)
        components = [
            {"character": f"甲{i}", "master_symbol": "甲"} for i in range(15)
        ]
        _make_components_csv(csv_dir, components)

        classify_radicals(csv_dir, warnings_dir, mk_path)

        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
        medium = w_df[w_df["severity"] == "medium"]
        assert len(medium) >= 1
        assert "Null-JLPT" in medium.iloc[0]["message"]
        assert "high usage" in medium.iloc[0]["message"]

    def test_warnings_appended_to_existing(self, tmp_path):
        """Warnings are appended to existing ph3_warnings.csv, not overwritten."""
        csv_dir, warnings_dir, mk_path = _setup(tmp_path)
        warnings_dir.mkdir(parents=True, exist_ok=True)

        # Pre-existing warning from another phase
        existing = pd.DataFrame([{
            "severity": "high",
            "phase": "3.1",
            "entity": "test",
            "message": "Pre-existing warning",
        }])
        existing.to_csv(warnings_dir / "ph3_warnings.csv", index=False)

        _make_radicals_csv(csv_dir, [
            {"master_symbol": "⺍"},
        ])
        _make_kanji_csv(csv_dir, [])
        _make_components_csv(csv_dir, [])

        classify_radicals(csv_dir, warnings_dir, mk_path)

        w_df = pd.read_csv(warnings_dir / "ph3_warnings.csv")
        # Should have both the pre-existing and new warnings
        assert len(w_df) >= 2
        phases = set(str(p) for p in w_df["phase"].tolist())
        assert "3.0" in phases
        assert "3.1" in phases
