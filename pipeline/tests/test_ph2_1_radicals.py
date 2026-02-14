"""Tests for Phase 2.1 radical extraction (Passes 0-2)."""

import json
from pathlib import Path

import pandas as pd
import pytest

from src.extractors.ph2_1_radicals import (
    build_keep_set,
    build_official_set,
    build_scope_set,
    count_frequencies,
    extract_radicals,
    scan_and_register,
)
from src.extractors.shared import parse_component_tree

# ---------------------------------------------------------------------------
# Helper: build a KanjiVG-style component tree dict
# ---------------------------------------------------------------------------

def _tree(element, position=None, radical=None, original=None, variant=False,
          stroke_count=1, children=None, part=None):
    """Build a component tree node dict matching KanjiVG parser output."""
    return {
        "element": element,
        "position": position,
        "radical": radical,
        "original": original,
        "variant": variant,
        "phon": None,
        "part": part,
        "partial": False,
        "stroke_count": stroke_count,
        "children": children or [],
    }


def _kvg_row(character, tree_dict):
    """Build a KanjiVG DataFrame row."""
    return {"character": character, "component_tree": json.dumps(tree_dict, ensure_ascii=False)}


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture
def kanjivg_df():
    """Minimal KanjiVG DataFrame with scope, ghost, variant, leaf cases.

    Characters:
    - 休 (rest): 亻(variant of 人, general radical, left) + 木(right)
    - 一 (one): leaf, no children
    - 語 (language): 言(general radical, left) + 吾(right) → 五(top) + 口(bottom)
    - 燐 (phosphorus): 火(left) + 粦(GHOST, right) → 米(top) + 舛(bottom)
    - 人 (person): leaf — master entry for 亻 variant
    - 木 (tree): leaf
    - 言 (speech): leaf — needed for tree_map
    - 吾 (myself): 五(top) + 口(bottom)
    - 五 (five): leaf
    - 口 (mouth): leaf
    - 火 (fire): leaf
    - 粦 (ghost): 米(top) + 舛(bottom) — NOT in scope
    - 米 (rice): leaf
    - 舛 (dance): leaf — official radical in out-of-scope entry
    - 罕 (rare, out of scope): 干(child) + 冂(kamae, radical=general)
    """
    rows = [
        _kvg_row("休", _tree("休", stroke_count=6, children=[
            _tree("亻", position="left", radical="general", variant=True,
                  original="人", stroke_count=2),
            _tree("木", position="right", stroke_count=4),
        ])),
        _kvg_row("一", _tree("一", stroke_count=1)),
        _kvg_row("語", _tree("語", stroke_count=14, children=[
            _tree("言", position="left", radical="general", stroke_count=7),
            _tree("吾", position="right", stroke_count=7, children=[
                _tree("五", position="top", stroke_count=4),
                _tree("口", position="bottom", stroke_count=3),
            ]),
        ])),
        _kvg_row("燐", _tree("燐", stroke_count=17, children=[
            _tree("火", position="left", stroke_count=4),
            _tree("粦", position="right", stroke_count=13, children=[
                _tree("米", position="top", stroke_count=6),
                _tree("舛", position="bottom", stroke_count=6),
            ]),
        ])),
        _kvg_row("人", _tree("人", stroke_count=2)),
        _kvg_row("木", _tree("木", stroke_count=4)),
        _kvg_row("言", _tree("言", stroke_count=7)),
        _kvg_row("吾", _tree("吾", stroke_count=7, children=[
            _tree("五", position="top", stroke_count=4),
            _tree("口", position="bottom", stroke_count=3),
        ])),
        _kvg_row("五", _tree("五", stroke_count=4)),
        _kvg_row("口", _tree("口", stroke_count=3)),
        _kvg_row("火", _tree("火", stroke_count=4)),
        _kvg_row("粦", _tree("粦", stroke_count=13, children=[
            _tree("米", position="top", stroke_count=6),
            _tree("舛", position="bottom", stroke_count=6),
        ])),
        _kvg_row("米", _tree("米", stroke_count=6)),
        _kvg_row("舛", _tree("舛", stroke_count=6)),
        # Out-of-scope entry with radical='general' on 冂
        _kvg_row("罕", _tree("罕", stroke_count=7, children=[
            _tree("冂", position="kamae", radical="general", stroke_count=2),
            _tree("干", stroke_count=3),
        ])),
    ]
    return pd.DataFrame(rows)


@pytest.fixture
def kanjidic_df():
    """Minimal KANJIDIC DataFrame. Grade ≤ 8 = in scope."""
    return pd.DataFrame({
        "literal": ["休", "一", "語", "燐", "人", "木", "言", "吾", "五", "口", "火", "米", "罕"],
        "grade": pd.array([3, 1, 2, None, 1, 1, 2, None, 1, 1, 1, 2, 9], dtype="Int32"),
    })


@pytest.fixture
def jlpt_kanji_df():
    """Minimal JLPT kanji DataFrame. All listed characters are in scope."""
    return pd.DataFrame({
        "character": ["休", "一", "語", "燐", "人", "木", "言", "五", "口", "火", "米"],
    })


@pytest.fixture
def scope_set(kanjidic_df, jlpt_kanji_df):
    return build_scope_set(kanjidic_df, jlpt_kanji_df)


@pytest.fixture
def tree_map(kanjivg_df):
    tree_map = {}
    for _, row in kanjivg_df.iterrows():
        tree_map[row["character"]] = parse_component_tree(row["component_tree"])
    return tree_map


# ---------------------------------------------------------------------------
# Pass 0: Scope set
# ---------------------------------------------------------------------------


class TestBuildScopeSet:
    def test_includes_graded_kanji(self, kanjidic_df, jlpt_kanji_df):
        scope = build_scope_set(kanjidic_df, jlpt_kanji_df)
        assert "休" in scope  # grade 3
        assert "一" in scope  # grade 1
        assert "語" in scope  # grade 2

    def test_includes_jlpt_kanji(self, kanjidic_df, jlpt_kanji_df):
        scope = build_scope_set(kanjidic_df, jlpt_kanji_df)
        assert "燐" in scope  # no grade, but in JLPT list

    def test_excludes_grade_9(self, kanjidic_df, jlpt_kanji_df):
        """Grade 9 (Jinmeiyō) excluded unless also in JLPT."""
        # 罕 has grade 9 and is NOT in jlpt_kanji_df
        scope = build_scope_set(kanjidic_df, jlpt_kanji_df)
        assert "罕" not in scope

    def test_union_of_graded_and_jlpt(self, kanjidic_df, jlpt_kanji_df):
        scope = build_scope_set(kanjidic_df, jlpt_kanji_df)
        # 吾 has no grade and is not in JLPT list → not in scope
        assert "吾" not in scope


# ---------------------------------------------------------------------------
# Pass 1a: Official set
# ---------------------------------------------------------------------------


class TestBuildOfficialSet:
    def test_finds_official_radicals(self, tree_map):
        official = build_official_set(tree_map)
        # 人 (master of 亻) and 言 both have radical='general'
        assert "人" in official
        assert "言" in official

    def test_scans_out_of_scope_entries(self, tree_map):
        """Official set scans ALL entries, not just scope."""
        official = build_official_set(tree_map)
        # 冂 is radical='general' in out-of-scope 罕
        assert "冂" in official

    def test_non_radical_excluded(self, tree_map):
        official = build_official_set(tree_map)
        # 木 is never marked radical='general' in our fixtures
        assert "木" not in official


# ---------------------------------------------------------------------------
# Pass 1b: Frequency counting
# ---------------------------------------------------------------------------


class TestCountFrequencies:
    def test_counts_direct_children(self, kanjivg_df, scope_set, tree_map):
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        # 人 (master of 亻) appears in 休 → freq=1
        assert freq.get("人", 0) >= 1
        # 木 appears in 休 → freq=1
        assert freq.get("木", 0) >= 1

    def test_counts_before_ghost_flattening(self, kanjivg_df, scope_set, tree_map):
        """Raw frequency counts ghosts as direct children (before flattening)."""
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        # 粦 is a direct child of 燐 → counted
        assert freq.get("粦", 0) >= 1

    def test_excludes_out_of_scope(self, kanjivg_df, scope_set, tree_map):
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        # 干 and 冂 are children of out-of-scope 罕
        # They're only children of 罕 which is not in scope
        # So they only count if they're also children of in-scope entries
        # 冂 is not a child of any in-scope entry
        assert freq.get("冂", 0) == 0

    def test_leaf_kanji_no_children(self, kanjivg_df, scope_set, tree_map):
        count_frequencies(kanjivg_df, scope_set, tree_map)
        # 一 is a leaf — no children to count


# ---------------------------------------------------------------------------
# Pass 1c: Keep set
# ---------------------------------------------------------------------------


class TestBuildKeepSet:
    def test_includes_scope(self, scope_set):
        keep, _ = build_keep_set(scope_set, set(), {})
        assert scope_set <= keep

    def test_includes_official(self, scope_set):
        official = {"冂", "ZZZ"}
        keep, _ = build_keep_set(scope_set, official, {})
        assert "冂" in keep
        assert "ZZZ" in keep

    def test_includes_high_freq(self, scope_set):
        freq = {"rare_elem": 10}
        keep, _ = build_keep_set(scope_set, set(), freq)
        assert "rare_elem" in keep

    def test_excludes_below_threshold(self, scope_set):
        freq = {"rare_elem": 4}
        keep, _ = build_keep_set(scope_set, set(), freq)
        if "rare_elem" not in scope_set:
            assert "rare_elem" not in keep

    def test_manual_keep(self, scope_set, tmp_path):
        keep_file = tmp_path / "keep.txt"
        keep_file.write_text("特\n")
        flatten_file = tmp_path / "flatten.txt"
        flatten_file.write_text("")
        keep, _ = build_keep_set(scope_set, set(), {}, keep_file, flatten_file)
        assert "特" in keep

    def test_manual_flatten_wins(self, scope_set, tmp_path):
        """manual_flatten removes even scope-set members."""
        keep_file = tmp_path / "keep.txt"
        keep_file.write_text("休\n")
        flatten_file = tmp_path / "flatten.txt"
        flatten_file.write_text("休\n")
        keep, warnings = build_keep_set(scope_set, set(), {}, keep_file, flatten_file)
        assert "休" not in keep
        assert any("both manual_keep and manual_flatten" in w["message"] for w in warnings)


# ---------------------------------------------------------------------------
# Pass 1d + Pass 2: Scan and register
# ---------------------------------------------------------------------------


class TestScanAndRegister:
    def test_registers_radicals(self, kanjivg_df, scope_set, tree_map):
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        rad_df, var_df, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}
        )
        # Should have radicals rows
        assert len(rad_df) > 0
        masters = set(rad_df["master_symbol"])
        # 人 should be registered (master of variant 亻)
        assert "人" in masters
        # 木 should be registered
        assert "木" in masters

    def test_deduplicates_by_master_symbol(self, kanjivg_df, scope_set, tree_map):
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        rad_df, _, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})
        # master_symbol should be unique
        assert rad_df["master_symbol"].is_unique

    def test_variant_registration(self, kanjivg_df, scope_set, tree_map):
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        rad_df, var_df, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        # Find radical_id for 人
        person_row = rad_df[rad_df["master_symbol"] == "人"]
        assert len(person_row) == 1
        person_id = person_row.iloc[0]["id"]

        # Check variant: 亻 is a shape of 人
        person_variants = var_df[var_df["radical_id"] == person_id]
        shapes = set(person_variants["shape"])
        assert "亻" in shapes
        # 人 is only seen via 亻 in fixtures, so no self-variant created
        # (self-variants are only for radicals NOT seen as variants)

    def test_variant_positions_are_json_arrays(self, kanjivg_df, scope_set, tree_map):
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        _, var_df, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        for _, row in var_df.iterrows():
            positions = json.loads(row["positions"])
            assert isinstance(positions, list)
            assert all(isinstance(p, str) for p in positions)

    def test_is_official_flag(self, kanjivg_df, scope_set, tree_map):
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        rad_df, _, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        person = rad_df[rad_df["master_symbol"] == "人"].iloc[0]
        assert person["is_official"] == True  # noqa: E712

        speech = rad_df[rad_df["master_symbol"] == "言"].iloc[0]
        assert speech["is_official"] == True  # noqa: E712

        tree = rad_df[rad_df["master_symbol"] == "木"].iloc[0]
        assert tree["is_official"] == False  # noqa: E712

    def test_stroke_count_from_master_entry(self, kanjivg_df, scope_set, tree_map):
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        rad_df, _, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        # 人 master entry has stroke_count=2
        person = rad_df[rad_df["master_symbol"] == "人"].iloc[0]
        assert person["stroke_count"] == 2

    def test_ghost_flattening_produces_correct_children(self, kanjivg_df, scope_set, tree_map):
        """燐: 粦 is ghost (not in scope, not official, freq < 5) → 米 and 舛 promoted."""
        # Build keep set where 粦 is NOT included
        keep = scope_set | {"冂", "舛"}  # 舛 needed since it might not be in scope
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        rad_df, _, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        masters = set(rad_df["master_symbol"])
        # 米 and 舛 should be registered (promoted from 粦 ghost)
        assert "米" in masters
        assert "舛" in masters

    def test_nullable_fields_empty(self, kanjivg_df, scope_set, tree_map):
        """SVG fields and Pass 4 metadata should be null."""
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        rad_df, var_df, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        # Radical nullable fields
        assert rad_df["svg_file_name"].isna().all()
        assert rad_df["svg_file_url"].isna().all()
        assert rad_df["svg_hash"].isna().all()
        assert rad_df["visual_group"].isna().all()
        assert rad_df["impact_score"].isna().all()
        assert rad_df["min_grade"].isna().all()
        assert rad_df["min_jlpt_level"].isna().all()

        # Variant nullable fields
        assert var_df["svg_file_name"].isna().all()
        assert var_df["svg_file_url"].isna().all()
        assert var_df["svg_hash"].isna().all()

    def test_every_radical_has_at_least_one_variant(self, kanjivg_df, scope_set, tree_map):
        """Every radical should have at least one variant row (including self-variants)."""
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        rad_df, var_df, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        radical_ids_with_variants = set(var_df["radical_id"])
        for _, row in rad_df.iterrows():
            assert row["id"] in radical_ids_with_variants, (
                f"Radical {row['master_symbol']} (id={row['id']}) has no variant rows"
            )

    def test_variant_unique_constraint(self, kanjivg_df, scope_set, tree_map):
        """No duplicate (radical_id, shape) pairs."""
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)
        _, var_df, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        pairs = var_df[["radical_id", "shape"]].apply(tuple, axis=1)
        assert pairs.is_unique


# ---------------------------------------------------------------------------
# Determinism + stroke count fixes
# ---------------------------------------------------------------------------


class TestDeterministicOutput:
    """Verify that scan_and_register produces identical output across runs."""

    def test_identical_across_runs(self, kanjivg_df, scope_set, tree_map):
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)

        rad1, var1, warn1 = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}
        )
        rad2, var2, warn2 = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}
        )

        pd.testing.assert_frame_equal(rad1, rad2)
        pd.testing.assert_frame_equal(var1, var2)
        assert warn1 == warn2


class TestStrokeCountNoComponentFallback:
    """Radicals without a standalone KanjiVG entry should get stroke_count=0,
    not an unreliable value from a component node."""

    def test_no_kvg_entry_gets_zero(self):
        """A radical that only appears as a component (no own KanjiVG entry)
        should have stroke_count=0 without manual override."""
        # 'Z' appears as a component in 'A' but has no standalone KanjiVG entry
        rows = [
            _kvg_row("A", _tree("A", stroke_count=10, children=[
                _tree("Z", position="left", stroke_count=7),
                _tree("B", position="right", stroke_count=3),
            ])),
            _kvg_row("B", _tree("B", stroke_count=3)),
            # No standalone entry for Z
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"Z", "B"}
        freq = {"Z": 1, "B": 1}

        rad_df, _, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        z_row = rad_df[rad_df["master_symbol"] == "Z"]
        assert len(z_row) == 1
        assert z_row.iloc[0]["stroke_count"] == 0

    def test_with_kvg_entry_gets_correct_count(self):
        """A radical with its own KanjiVG entry should get that stroke_count."""
        rows = [
            _kvg_row("A", _tree("A", stroke_count=10, children=[
                _tree("Z", position="left", stroke_count=99),  # wrong component value
            ])),
            _kvg_row("Z", _tree("Z", stroke_count=5)),  # standalone = correct
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"Z"}
        freq = {"Z": 1}

        rad_df, _, _ = scan_and_register(kanjivg_df, scope_set, keep, tree_map, freq, {})

        z_row = rad_df[rad_df["master_symbol"] == "Z"]
        assert z_row.iloc[0]["stroke_count"] == 5


class TestManualStrokeOverrides:
    """manual_strokes.txt overrides any other stroke count source."""

    def test_overrides_kvg_value(self):
        """Manual stroke count wins over KanjiVG standalone entry."""
        rows = [
            _kvg_row("A", _tree("A", stroke_count=10, children=[
                _tree("Z", position="left", stroke_count=4),
            ])),
            _kvg_row("Z", _tree("Z", stroke_count=9)),  # KanjiVG says 9
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"Z"}
        freq = {"Z": 1}
        manual_strokes = {"Z": 5}  # override to 5

        rad_df, _, _ = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, manual_strokes
        )

        z_row = rad_df[rad_df["master_symbol"] == "Z"]
        assert z_row.iloc[0]["stroke_count"] == 5

    def test_fills_missing_stroke_count(self):
        """Manual stroke count fills in for radicals with no KanjiVG entry."""
        rows = [
            _kvg_row("A", _tree("A", stroke_count=10, children=[
                _tree("Z", position="left", stroke_count=7),
            ])),
            # No standalone entry for Z
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"Z"}
        freq = {"Z": 1}
        manual_strokes = {"Z": 7}

        rad_df, _, _ = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, manual_strokes
        )

        z_row = rad_df[rad_df["master_symbol"] == "Z"]
        assert z_row.iloc[0]["stroke_count"] == 7


class TestMissingStrokeCountWarning:
    """Radicals with stroke_count=0 and no manual override emit a high warning."""

    def test_warns_on_missing(self):
        rows = [
            _kvg_row("A", _tree("A", stroke_count=10, children=[
                _tree("Z", position="left", stroke_count=7),
            ])),
            # No standalone entry for Z → stroke_count stays 0
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"Z"}
        freq = {"Z": 1}

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}
        )

        stroke_warnings = [
            w for w in warnings
            if w["entity"] == "Z" and "Missing stroke count" in w["message"]
        ]
        assert len(stroke_warnings) == 1
        assert stroke_warnings[0]["severity"] == "high"

    def test_no_warning_when_manual_provided(self):
        rows = [
            _kvg_row("A", _tree("A", stroke_count=10, children=[
                _tree("Z", position="left", stroke_count=7),
            ])),
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"Z"}
        freq = {"Z": 1}
        manual_strokes = {"Z": 7}

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, manual_strokes
        )

        stroke_warnings = [
            w for w in warnings if "Missing stroke count" in w["message"]
        ]
        assert len(stroke_warnings) == 0

    def test_no_warning_when_kvg_entry_exists(self, kanjivg_df, scope_set, tree_map):
        """Radicals with their own KanjiVG entry should never warn."""
        keep = scope_set | {"冂"}
        freq = count_frequencies(kanjivg_df, scope_set, tree_map)

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}
        )

        # 人 has its own KanjiVG entry → stroke_count=2, no warning
        person_warnings = [
            w for w in warnings
            if w.get("entity") == "人" and "Missing stroke count" in w.get("message", "")
        ]
        assert len(person_warnings) == 0


# ---------------------------------------------------------------------------
# load_manual_strokes
# ---------------------------------------------------------------------------


class TestLoadManualStrokes:
    def test_nonexistent_file(self):
        from src.extractors.shared import load_manual_strokes
        assert load_manual_strokes(Path("/nonexistent/file.txt")) == {}

    def test_basic_format(self, tmp_path):
        from src.extractors.shared import load_manual_strokes
        f = tmp_path / "strokes.txt"
        f.write_text("电  5  # Lightning\n㕣 5\n")
        result = load_manual_strokes(f)
        assert result == {"电": 5, "㕣": 5}

    def test_comments_and_blanks(self, tmp_path):
        from src.extractors.shared import load_manual_strokes
        f = tmp_path / "strokes.txt"
        f.write_text("# header\n\n电 5\n# comment\n木 4\n\n")
        result = load_manual_strokes(f)
        assert result == {"电": 5, "木": 4}

    def test_empty_file(self, tmp_path):
        from src.extractors.shared import load_manual_strokes
        f = tmp_path / "strokes.txt"
        f.write_text("")
        assert load_manual_strokes(f) == {}


# ---------------------------------------------------------------------------
# Integration: extract_radicals end-to-end
# ---------------------------------------------------------------------------


class TestExtractRadicalsIntegration:
    def test_end_to_end(self, kanjivg_df, kanjidic_df, jlpt_kanji_df, tmp_path):
        """Write Parquet fixtures → run extract_radicals → verify CSV outputs."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # Write Parquet fixtures
        kanjivg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)
        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_kanji_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_radicals(parquet_dir, csv_dir, warnings_dir)

        # CSVs should exist
        assert (csv_dir / "radicals.csv").exists()
        assert (csv_dir / "radical_variants.csv").exists()

        # Load and verify
        rad_csv = pd.read_csv(csv_dir / "radicals.csv")
        var_csv = pd.read_csv(csv_dir / "radical_variants.csv")

        assert len(rad_csv) > 0
        assert len(var_csv) > 0
        assert rad_csv["master_symbol"].is_unique

        # Scope set should be correct
        scope = result["scope_set"]
        assert "休" in scope
        assert "罕" not in scope  # grade 9

    def test_sequential_ids(self, kanjivg_df, kanjidic_df, jlpt_kanji_df, tmp_path):
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kanjivg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)
        kanjidic_df.to_parquet(parquet_dir / "kanjidic.parquet", index=False)
        jlpt_kanji_df.to_parquet(parquet_dir / "jlpt_kanji.parquet", index=False)

        result = extract_radicals(parquet_dir, csv_dir, warnings_dir)

        rad_df = result["radicals"]
        var_df = result["radical_variants"]

        # IDs should be sequential from 1
        assert list(rad_df["id"]) == list(range(1, len(rad_df) + 1))
        assert list(var_df["id"]) == list(range(1, len(var_df) + 1))


# ---------------------------------------------------------------------------
# Visual rules loading
# ---------------------------------------------------------------------------


class TestLoadVisualRules:
    def test_nonexistent_file(self):
        from src.extractors.shared import load_visual_rules
        assert load_visual_rules(Path("/nonexistent/file.json")) == {}

    def test_basic_format(self, tmp_path):
        from src.extractors.shared import load_visual_rules
        f = tmp_path / "visual_rules.json"
        f.write_text(json.dumps({
            "肉": {"visual_group": "月", "disambiguation_note": {"en": "flesh"}},
            "月": {"visual_group": "月", "disambiguation_note": {"en": "moon"}},
        }))
        result = load_visual_rules(f)
        assert result["肉"]["visual_group"] == "月"
        assert result["月"]["visual_group"] == "月"

    def test_empty_object(self, tmp_path):
        from src.extractors.shared import load_visual_rules
        f = tmp_path / "visual_rules.json"
        f.write_text("{}")
        assert load_visual_rules(f) == {}


# ---------------------------------------------------------------------------
# Visual group + ambiguity warnings
# ---------------------------------------------------------------------------


class TestVisualGroup:
    """Tests for visual_group field population and ambiguity warnings.

    Fixtures: kanji A uses 月-shape as variant of 肉, kanji B uses 月 directly.
    This creates a shape collision on "月" between masters 肉 and 月.
    """

    @staticmethod
    def _build_collision_fixtures():
        rows = [
            _kvg_row("A", _tree("A", stroke_count=10, children=[
                _tree("月", position="left", variant=True, original="肉",
                      stroke_count=4),
                _tree("Z", position="right", stroke_count=3),
            ])),
            _kvg_row("B", _tree("B", stroke_count=8, children=[
                _tree("月", position="right", stroke_count=4),
                _tree("W", position="left", stroke_count=4),
            ])),
            _kvg_row("肉", _tree("肉", stroke_count=6)),
            _kvg_row("月", _tree("月", stroke_count=4)),
            _kvg_row("Z", _tree("Z", stroke_count=3)),
            _kvg_row("W", _tree("W", stroke_count=4)),
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A", "B"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"肉", "月", "Z", "W"}
        freq = {"肉": 1, "月": 1, "Z": 1, "W": 1}
        return kanjivg_df, scope_set, keep, tree_map, freq

    def test_visual_group_populated(self):
        """visual_group set from visual_rules for matching master_symbol."""
        kanjivg_df, scope_set, keep, tree_map, freq = self._build_collision_fixtures()
        visual_rules = {
            "肉": {"visual_group": "月", "disambiguation_note": {"en": "flesh"}},
            "月": {"visual_group": "月", "disambiguation_note": {"en": "moon"}},
        }

        rad_df, _, _ = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, visual_rules
        )

        flesh = rad_df[rad_df["master_symbol"] == "肉"].iloc[0]
        assert flesh["visual_group"] == "月"

        moon = rad_df[rad_df["master_symbol"] == "月"].iloc[0]
        assert moon["visual_group"] == "月"

    def test_visual_group_null_when_not_in_rules(self):
        """visual_group is null for radicals not in visual_rules."""
        kanjivg_df, scope_set, keep, tree_map, freq = self._build_collision_fixtures()
        visual_rules = {
            "肉": {"visual_group": "月", "disambiguation_note": {"en": "flesh"}},
            "月": {"visual_group": "月", "disambiguation_note": {"en": "moon"}},
        }

        rad_df, _, _ = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, visual_rules
        )

        z_row = rad_df[rad_df["master_symbol"] == "Z"].iloc[0]
        assert pd.isna(z_row["visual_group"])

    def test_ambiguity_warning_when_uncovered(self):
        """High warning when shape collision exists but visual_rules is empty."""
        kanjivg_df, scope_set, keep, tree_map, freq = self._build_collision_fixtures()

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, {}
        )

        ambiguity_warnings = [
            w for w in warnings
            if "Visually ambiguous" in w["message"] and w["entity"] == "月"
        ]
        assert len(ambiguity_warnings) == 1
        assert ambiguity_warnings[0]["severity"] == "high"

    def test_no_ambiguity_warning_when_covered(self):
        """No warning when all colliding radicals have visual_group entries."""
        kanjivg_df, scope_set, keep, tree_map, freq = self._build_collision_fixtures()
        visual_rules = {
            "肉": {"visual_group": "月", "disambiguation_note": {"en": "flesh"}},
            "月": {"visual_group": "月", "disambiguation_note": {"en": "moon"}},
        }

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, visual_rules
        )

        ambiguity_warnings = [
            w for w in warnings if "Visually ambiguous" in w["message"]
        ]
        assert len(ambiguity_warnings) == 0

    def test_partial_coverage_still_warns(self):
        """Warning fires when only some colliding radicals are covered."""
        kanjivg_df, scope_set, keep, tree_map, freq = self._build_collision_fixtures()
        visual_rules = {
            "肉": {"visual_group": "月", "disambiguation_note": {"en": "flesh"}},
            # 月 is missing — partial coverage
        }

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, visual_rules
        )

        ambiguity_warnings = [
            w for w in warnings if "Visually ambiguous" in w["message"]
        ]
        assert len(ambiguity_warnings) == 1

    def test_singleton_visual_group_warns(self):
        """High warning when a visual_group has only 1 member (likely typo)."""
        kanjivg_df, scope_set, keep, tree_map, freq = self._build_collision_fixtures()
        visual_rules = {
            "肉": {"visual_group": "月", "disambiguation_note": {"en": "flesh"}},
            # 月 is NOT in visual_rules → only 肉 has visual_group "月"
        }

        rad_df, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, visual_rules
        )

        singleton_warnings = [
            w for w in warnings
            if "only 1 member" in w["message"]
        ]
        assert len(singleton_warnings) == 1
        assert singleton_warnings[0]["severity"] == "high"
        assert singleton_warnings[0]["entity"] == "肉"

    def test_no_singleton_warning_when_group_complete(self):
        """No warning when visual_group has 2+ members."""
        kanjivg_df, scope_set, keep, tree_map, freq = self._build_collision_fixtures()
        visual_rules = {
            "肉": {"visual_group": "月", "disambiguation_note": {"en": "flesh"}},
            "月": {"visual_group": "月", "disambiguation_note": {"en": "moon"}},
        }

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, visual_rules
        )

        singleton_warnings = [
            w for w in warnings if "only 1 member" in w["message"]
        ]
        assert len(singleton_warnings) == 0

    def test_unregistered_visual_rules_entry_warns(self):
        """Medium warning when visual_rules.json has an entry for a non-radical."""
        kanjivg_df, scope_set, keep, tree_map, freq = self._build_collision_fixtures()
        visual_rules = {
            "肉": {"visual_group": "月", "disambiguation_note": {"en": "flesh"}},
            "月": {"visual_group": "月", "disambiguation_note": {"en": "moon"}},
            "FAKE": {"visual_group": "X", "disambiguation_note": {"en": "nope"}},
        }

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, visual_rules
        )

        unregistered = [
            w for w in warnings
            if w["entity"] == "FAKE" and "not a registered radical" in w["message"]
        ]
        assert len(unregistered) == 1
        assert unregistered[0]["severity"] == "medium"

    def test_no_collision_no_warning(self):
        """No warning when no shapes are shared between radicals."""
        rows = [
            _kvg_row("A", _tree("A", stroke_count=5, children=[
                _tree("X", position="left", stroke_count=2),
                _tree("Y", position="right", stroke_count=3),
            ])),
            _kvg_row("X", _tree("X", stroke_count=2)),
            _kvg_row("Y", _tree("Y", stroke_count=3)),
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"X", "Y"}
        freq = {"X": 1, "Y": 1}

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}, {}
        )

        ambiguity_warnings = [
            w for w in warnings if "Visually ambiguous" in w["message"]
        ]
        assert len(ambiguity_warnings) == 0


# ---------------------------------------------------------------------------
# Force-drop via manual_flatten
# ---------------------------------------------------------------------------


class TestManualFlattenForceDrop:
    """manual_flatten entries should be silently dropped during ghost flattening,
    even when they are unflattenable (no KanjiVG entry)."""

    @staticmethod
    def _build_fixtures_with_unflattenable_ghost():
        """Kanji A has child G (ghost, no KanjiVG entry) + child X (keep).

        Without force_drop, G becomes an unflattenable leaf radical.
        With force_drop={'G'}, G is silently discarded.
        """
        rows = [
            _kvg_row("A", _tree("A", stroke_count=8, children=[
                _tree("G", position="left", stroke_count=3),
                _tree("X", position="right", stroke_count=5),
            ])),
            _kvg_row("X", _tree("X", stroke_count=5)),
            # No standalone entry for G — unflattenable ghost
        ]
        kanjivg_df = pd.DataFrame(rows)
        scope_set = {"A"}
        tree_map = {}
        for _, row in kanjivg_df.iterrows():
            tree_map[row["character"]] = parse_component_tree(row["component_tree"])
        keep = scope_set | {"X"}
        freq = {"G": 1, "X": 1}
        return kanjivg_df, scope_set, keep, tree_map, freq

    def test_unflattenable_ghost_registered_without_flatten(self):
        """Without manual_flatten, unflattenable ghost G becomes a leaf radical."""
        kanjivg_df, scope_set, keep, tree_map, freq = (
            self._build_fixtures_with_unflattenable_ghost()
        )

        rad_df, _, _ = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {}
        )

        masters = set(rad_df["master_symbol"])
        assert "G" in masters

    def test_force_drop_removes_unflattenable_ghost(self):
        """With manual_flatten={'G'}, G is dropped — not registered as a radical."""
        kanjivg_df, scope_set, keep, tree_map, freq = (
            self._build_fixtures_with_unflattenable_ghost()
        )

        rad_df, _, _ = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {},
            visual_rules=None, manual_flatten={"G"},
        )

        masters = set(rad_df["master_symbol"])
        assert "G" not in masters
        assert "X" in masters

    def test_force_drop_no_unflattenable_warning(self):
        """Dropped ghosts should not emit 'unflattenable' warnings."""
        kanjivg_df, scope_set, keep, tree_map, freq = (
            self._build_fixtures_with_unflattenable_ghost()
        )

        _, _, warnings = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {},
            visual_rules=None, manual_flatten={"G"},
        )

        unflattenable = [
            w for w in warnings
            if w["entity"] == "G" and "unflattenable" in w["message"]
        ]
        assert len(unflattenable) == 0

    def test_force_drop_does_not_affect_keep_set_members(self):
        """manual_flatten should not drop elements that are in the keep set."""
        kanjivg_df, scope_set, keep, tree_map, freq = (
            self._build_fixtures_with_unflattenable_ghost()
        )

        # X is in keep set — force_drop is checked before keep_set,
        # but keep_set members pass through the keep_set branch first
        rad_df, _, _ = scan_and_register(
            kanjivg_df, scope_set, keep, tree_map, freq, {},
            visual_rules=None, manual_flatten={"X"},
        )

        masters = set(rad_df["master_symbol"])
        assert "X" in masters
