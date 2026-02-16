"""Tests for Phase 2.3 component linking + radical metadata."""

import json
from pathlib import Path

import pandas as pd
import pytest

from src.extractors.ph2_3_components import extract_components
from src.extractors.shared import map_radical_type


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _tree(
    element,
    position=None,
    radical=None,
    original=None,
    variant=False,
    stroke_count=1,
    children=None,
    part=None,
):
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
    return {
        "character": character,
        "component_tree": json.dumps(tree_dict, ensure_ascii=False),
    }


def _make_kanjivg_df(rows):
    return pd.DataFrame(rows)


def _make_radicals_csv(csv_dir, radicals):
    """Write radicals.csv. radicals: list of (master_symbol, stroke_count) tuples."""
    rows = []
    for ms, sc in radicals:
        rows.append({
            "master_symbol": ms,
            "is_official": False,
            "stroke_count": sc,
            "visual_group": None,
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
            "impact_score": None,
            "min_grade": None,
            "min_jlpt_level": None,
        })
    df = pd.DataFrame(rows)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "radicals.csv", index=False)
    return df


def _make_kanji_csv(csv_dir, kanji_list):
    """Write kanji.csv. kanji_list: list of (char, stroke_count, grade, jlpt) tuples."""
    columns = [
        "character", "stroke_count", "min_grade", "min_jlpt_level",
        "frequency_rank", "svg_file_name", "svg_file_url", "svg_hash",
    ]
    rows = []
    for char, sc, grade, jlpt in kanji_list:
        rows.append({
            "character": char,
            "stroke_count": sc,
            "min_grade": grade,
            "min_jlpt_level": jlpt,
            "frequency_rank": 1,
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
        })
    df = pd.DataFrame(rows, columns=columns)
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji.csv", index=False)
    return df


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------


@pytest.fixture
def basic_setup(tmp_path):
    """Standard setup: 休 = 亻 + 木, plus leaf entries.

    Scope: {休}  Keep: {亻, 木, 休}
    Radicals: 亻(2 strokes), 木(4 strokes)
    Kanji: 休(grade=2, jlpt=4)
    """
    parquet_dir = tmp_path / "parquet"
    parquet_dir.mkdir()
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"

    kvg_df = _make_kanjivg_df([
        _kvg_row("休", _tree("休", stroke_count=6, children=[
            _tree("亻", position="left", radical="general", variant=True,
                  original="人", stroke_count=2),
            _tree("木", position="right", stroke_count=4),
        ])),
        _kvg_row("人", _tree("人", stroke_count=2)),
        _kvg_row("木", _tree("木", stroke_count=4)),
    ])
    kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

    _make_radicals_csv(csv_dir, [("亻", 2), ("木", 4)])
    _make_kanji_csv(csv_dir, [("休", 6, 2, 4)])

    scope_set = {"休"}
    keep_set = {"亻", "木", "休"}

    return parquet_dir, csv_dir, warnings_dir, scope_set, keep_set


# ---------------------------------------------------------------------------
# Step 1+2: Component linking
# ---------------------------------------------------------------------------


class TestBasicComponentLinking:
    def test_basic_component_linking(self, basic_setup):
        """休 produces two component rows: 亻@hen + 木@tsukuri."""
        parquet_dir, csv_dir, warnings_dir, scope_set, keep_set = basic_setup

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope_set, keep_set)
        comp_df = result["kanji_components"]

        assert len(comp_df) == 2

        person = comp_df[comp_df["master_symbol"] == "亻"].iloc[0]
        assert person["character"] == "休"
        assert person["position"] == "hen"

        tree = comp_df[comp_df["master_symbol"] == "木"].iloc[0]
        assert tree["character"] == "休"
        assert tree["position"] == "tsukuri"


class TestElementUsedDirectly:
    def test_element_used_directly(self, basic_setup):
        """亻 element used directly as master_symbol (flattened model)."""
        parquet_dir, csv_dir, warnings_dir, scope_set, keep_set = basic_setup

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope_set, keep_set)
        comp_df = result["kanji_components"]

        person_row = comp_df[comp_df["master_symbol"] == "亻"].iloc[0]
        assert person_row["position"] == "hen"


class TestPositionMapping:
    def test_position_mapping(self, tmp_path):
        """All KanjiVG position values mapped correctly."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # Kanji X with children at various positions
        kvg_df = _make_kanjivg_df([
            _kvg_row("X", _tree("X", stroke_count=10, children=[
                _tree("A", position="left", stroke_count=2),
                _tree("B", position="right", stroke_count=2),
                _tree("C", position="top", stroke_count=2),
                _tree("D", position="bottom", stroke_count=2),
                _tree("E", position="kamae", stroke_count=2),
            ])),
            _kvg_row("A", _tree("A", stroke_count=2)),
            _kvg_row("B", _tree("B", stroke_count=2)),
            _kvg_row("C", _tree("C", stroke_count=2)),
            _kvg_row("D", _tree("D", stroke_count=2)),
            _kvg_row("E", _tree("E", stroke_count=2)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [
            ("A", 2), ("B", 2), ("C", 2), ("D", 2), ("E", 2),
        ])
        _make_kanji_csv(csv_dir, [("X", 10, 1, 5)])

        scope = {"X"}
        keep = {"A", "B", "C", "D", "E", "X"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        comp_df = result["kanji_components"]

        pos_map = dict(zip(comp_df["master_symbol"], comp_df["position"]))
        assert pos_map["A"] == "hen"
        assert pos_map["B"] == "tsukuri"
        assert pos_map["C"] == "kanmuri"
        assert pos_map["D"] == "ashi"
        assert pos_map["E"] == "kamae"


class TestRadicalTypeMapping:
    def test_radical_type_mapping(self, tmp_path):
        """general/tradit/nelson/jis/null mapped correctly."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kvg_df = _make_kanjivg_df([
            _kvg_row("X", _tree("X", stroke_count=10, children=[
                _tree("A", position="left", radical="general", stroke_count=2),
                _tree("B", position="right", radical="tradit", stroke_count=2),
                _tree("C", position="top", radical="nelson", stroke_count=2),
                _tree("D", position="bottom", radical="jis", stroke_count=2),
                _tree("E", position="kamae", radical=None, stroke_count=2),
            ])),
            _kvg_row("A", _tree("A", stroke_count=2)),
            _kvg_row("B", _tree("B", stroke_count=2)),
            _kvg_row("C", _tree("C", stroke_count=2)),
            _kvg_row("D", _tree("D", stroke_count=2)),
            _kvg_row("E", _tree("E", stroke_count=2)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [
            ("A", 2), ("B", 2), ("C", 2), ("D", 2), ("E", 2),
        ])
        _make_kanji_csv(csv_dir, [("X", 10, 1, 5)])

        scope = {"X"}
        keep = {"A", "B", "C", "D", "E", "X"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        comp_df = result["kanji_components"]

        type_map = dict(zip(comp_df["master_symbol"], comp_df["radical_type"]))
        assert type_map["A"] == "general"
        assert type_map["B"] == "tradit"
        assert type_map["C"] == "nelson"
        assert type_map["D"] == "jis"
        assert type_map["E"] == "component"

    def test_map_radical_type_function(self):
        """Unit test for map_radical_type."""
        assert map_radical_type("general") == "general"
        assert map_radical_type("tradit") == "tradit"
        assert map_radical_type("nelson") == "nelson"
        assert map_radical_type("jis") == "jis"
        assert map_radical_type(None) == "component"


class TestIsPrimary:
    def test_is_primary(self, basic_setup):
        """is_primary=True only for radical_type=general."""
        parquet_dir, csv_dir, warnings_dir, scope_set, keep_set = basic_setup

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope_set, keep_set)
        comp_df = result["kanji_components"]

        person = comp_df[comp_df["master_symbol"] == "亻"].iloc[0]
        assert person["is_primary"] == True  # noqa: E712

        tree_row = comp_df[comp_df["master_symbol"] == "木"].iloc[0]
        assert tree_row["is_primary"] == False  # noqa: E712


class TestLogicHintDefault:
    def test_logic_hint_default(self, basic_setup):
        """All rows get logic_hint='semantic' as default."""
        parquet_dir, csv_dir, warnings_dir, scope_set, keep_set = basic_setup

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope_set, keep_set)
        comp_df = result["kanji_components"]

        assert (comp_df["logic_hint"] == "semantic").all()


class TestGhostFlattening:
    def test_ghost_flattening(self, tmp_path):
        """Ghost children replaced by their effective children."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # 燐: 火(left) + 粦(right, GHOST) → 米(top) + 舛(bottom)
        kvg_df = _make_kanjivg_df([
            _kvg_row("燐", _tree("燐", stroke_count=17, children=[
                _tree("火", position="left", stroke_count=4),
                _tree("粦", position="right", stroke_count=13, children=[
                    _tree("米", position="top", stroke_count=6),
                    _tree("舛", position="bottom", stroke_count=6),
                ]),
            ])),
            _kvg_row("火", _tree("火", stroke_count=4)),
            _kvg_row("粦", _tree("粦", stroke_count=13, children=[
                _tree("米", position="top", stroke_count=6),
                _tree("舛", position="bottom", stroke_count=6),
            ])),
            _kvg_row("米", _tree("米", stroke_count=6)),
            _kvg_row("舛", _tree("舛", stroke_count=6)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("火", 4), ("米", 6), ("舛", 6)])
        _make_kanji_csv(csv_dir, [("燐", 17, None, None)])

        # 粦 is NOT in keep_set → ghost
        scope = {"燐"}
        keep = {"火", "米", "舛", "燐"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        comp_df = result["kanji_components"]

        assert len(comp_df) == 3
        masters = set(comp_df["master_symbol"])
        assert masters == {"火", "米", "舛"}


class TestLeafKanji:
    def test_leaf_kanji_no_components(self, tmp_path):
        """Leaf kanji (一) produces no component rows."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kvg_df = _make_kanjivg_df([
            _kvg_row("一", _tree("一", stroke_count=1)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("一", 1)])
        _make_kanji_csv(csv_dir, [("一", 1, 1, 5)])

        scope = {"一"}
        keep = {"一"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        comp_df = result["kanji_components"]

        assert len(comp_df) == 0


class TestDeduplication:
    def test_unique_constraint_dedup(self, tmp_path):
        """Duplicate (character, master_symbol, position) deduplicated to first occurrence."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # Kanji with same radical appearing twice at same position (contrived)
        kvg_df = _make_kanjivg_df([
            _kvg_row("X", _tree("X", stroke_count=6, children=[
                _tree("A", position="left", stroke_count=2),
                _tree("A", position="left", stroke_count=2),  # duplicate
                _tree("B", position="right", stroke_count=2),
            ])),
            _kvg_row("A", _tree("A", stroke_count=2)),
            _kvg_row("B", _tree("B", stroke_count=2)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 2), ("B", 2)])
        _make_kanji_csv(csv_dir, [("X", 6, 1, 5)])

        scope = {"X"}
        keep = {"A", "B", "X"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        comp_df = result["kanji_components"]

        # Only 2 rows, not 3
        assert len(comp_df) == 2


# ---------------------------------------------------------------------------
# Step 3: Radical metadata
# ---------------------------------------------------------------------------


class TestImpactScoreBuckets:
    def test_impact_score_buckets(self, tmp_path):
        """Correct bucket mapping for various kanji counts."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # Radical A appears in 3 kanji (bucket 1-5 → score 1, stroke_count=2 → +0)
        children = [_tree("A", position="left", stroke_count=2)]
        kvg_rows = []
        kanji_list = []
        for i in range(3):
            char = chr(0x4E00 + i)  # 一, 丁, 丂
            kvg_rows.append(
                _kvg_row(char, _tree(char, stroke_count=4, children=list(children)))
            )
            kanji_list.append((char, 4, 1, 5))

        kvg_rows.append(_kvg_row("A", _tree("A", stroke_count=2)))
        kvg_df = _make_kanjivg_df(kvg_rows)
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 2)])
        _make_kanji_csv(csv_dir, kanji_list)

        scope = {chr(0x4E00 + i) for i in range(3)}
        keep = scope | {"A"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        rad_df = result["radicals"]

        a_row = rad_df[rad_df["master_symbol"] == "A"].iloc[0]
        assert a_row["impact_score"] == 1  # 3 kanji → bucket 1-5 → base 1 + 0 bonus

    def test_higher_bucket(self, tmp_path):
        """6 kanji → bucket 6-15 → base 2."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        children = [_tree("A", position="left", stroke_count=2)]
        kvg_rows = []
        kanji_list = []
        for i in range(6):
            char = chr(0x4E00 + i)
            kvg_rows.append(
                _kvg_row(char, _tree(char, stroke_count=4, children=list(children)))
            )
            kanji_list.append((char, 4, 1, 5))

        kvg_rows.append(_kvg_row("A", _tree("A", stroke_count=2)))
        kvg_df = _make_kanjivg_df(kvg_rows)
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 2)])
        _make_kanji_csv(csv_dir, kanji_list)

        scope = {chr(0x4E00 + i) for i in range(6)}
        keep = scope | {"A"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        rad_df = result["radicals"]

        a_row = rad_df[rad_df["master_symbol"] == "A"].iloc[0]
        assert a_row["impact_score"] == 2  # 6 kanji → bucket 6-15 → base 2


class TestImpactScoreComplexityBonus:
    def test_impact_score_complexity_bonus(self, tmp_path):
        """Stroke-based bonus applied: 8-11 strokes → +1."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # Radical with 10 strokes, 3 kanji → base 1 + bonus 1 = 2
        children = [_tree("A", position="left", stroke_count=10)]
        kvg_rows = []
        kanji_list = []
        for i in range(3):
            char = chr(0x4E00 + i)
            kvg_rows.append(
                _kvg_row(char, _tree(char, stroke_count=14, children=list(children)))
            )
            kanji_list.append((char, 14, 1, 5))

        kvg_rows.append(_kvg_row("A", _tree("A", stroke_count=10)))
        kvg_df = _make_kanjivg_df(kvg_rows)
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 10)])
        _make_kanji_csv(csv_dir, kanji_list)

        scope = {chr(0x4E00 + i) for i in range(3)}
        keep = scope | {"A"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        rad_df = result["radicals"]

        a_row = rad_df[rad_df["master_symbol"] == "A"].iloc[0]
        assert a_row["impact_score"] == 2  # base 1 + bonus 1

    def test_high_stroke_bonus(self, tmp_path):
        """12+ strokes → +2 bonus."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        children = [_tree("A", position="left", stroke_count=14)]
        kvg_rows = []
        kanji_list = []
        for i in range(3):
            char = chr(0x4E00 + i)
            kvg_rows.append(
                _kvg_row(char, _tree(char, stroke_count=18, children=list(children)))
            )
            kanji_list.append((char, 18, 1, 5))

        kvg_rows.append(_kvg_row("A", _tree("A", stroke_count=14)))
        kvg_df = _make_kanjivg_df(kvg_rows)
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 14)])
        _make_kanji_csv(csv_dir, kanji_list)

        scope = {chr(0x4E00 + i) for i in range(3)}
        keep = scope | {"A"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        rad_df = result["radicals"]

        a_row = rad_df[rad_df["master_symbol"] == "A"].iloc[0]
        assert a_row["impact_score"] == 3  # base 1 + bonus 2


class TestImpactScoreCap:
    def test_impact_score_capped_at_10(self, tmp_path):
        """min(base+bonus, 10) — never exceeds 10."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # 401+ kanji → base 10, 12+ strokes → +2, but capped at 10
        children = [_tree("A", position="left", stroke_count=14)]
        kvg_rows = []
        kanji_list = []
        for i in range(410):
            char = chr(0x4E00 + i)
            kvg_rows.append(
                _kvg_row(char, _tree(char, stroke_count=18, children=list(children)))
            )
            kanji_list.append((char, 18, 1, 5))

        kvg_rows.append(_kvg_row("A", _tree("A", stroke_count=14)))
        kvg_df = _make_kanjivg_df(kvg_rows)
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 14)])
        _make_kanji_csv(csv_dir, kanji_list)

        scope = {chr(0x4E00 + i) for i in range(410)}
        keep = scope | {"A"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        rad_df = result["radicals"]

        a_row = rad_df[rad_df["master_symbol"] == "A"].iloc[0]
        assert a_row["impact_score"] == 10


class TestMinGradeDerivation:
    def test_min_grade_derivation(self, tmp_path):
        """MIN across containing kanji grades."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # Radical A in kanji with grades 3, 1, 6 → min_grade=1
        kvg_rows = []
        kanji_list = []
        grades = [3, 1, 6]
        for i, g in enumerate(grades):
            char = chr(0x4E00 + i)
            kvg_rows.append(
                _kvg_row(char, _tree(char, stroke_count=4, children=[
                    _tree("A", position="left", stroke_count=2),
                ]))
            )
            kanji_list.append((char, 4, g, 5))

        kvg_rows.append(_kvg_row("A", _tree("A", stroke_count=2)))
        kvg_df = _make_kanjivg_df(kvg_rows)
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 2)])
        _make_kanji_csv(csv_dir, kanji_list)

        scope = {chr(0x4E00 + i) for i in range(3)}
        keep = scope | {"A"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        rad_df = result["radicals"]

        a_row = rad_df[rad_df["master_symbol"] == "A"].iloc[0]
        assert a_row["min_grade"] == 1


class TestMinJlptLevelDerivation:
    def test_min_jlpt_level_derivation(self, tmp_path):
        """MAX across containing kanji JLPT levels (inverted scale: N5=5 easiest)."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # Radical A in kanji with jlpt 3, 5, 1 → max=5 (easiest encounter)
        kvg_rows = []
        kanji_list = []
        jlpt_levels = [3, 5, 1]
        for i, j in enumerate(jlpt_levels):
            char = chr(0x4E00 + i)
            kvg_rows.append(
                _kvg_row(char, _tree(char, stroke_count=4, children=[
                    _tree("A", position="left", stroke_count=2),
                ]))
            )
            kanji_list.append((char, 4, 1, j))

        kvg_rows.append(_kvg_row("A", _tree("A", stroke_count=2)))
        kvg_df = _make_kanjivg_df(kvg_rows)
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 2)])
        _make_kanji_csv(csv_dir, kanji_list)

        scope = {chr(0x4E00 + i) for i in range(3)}
        keep = scope | {"A"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        rad_df = result["radicals"]

        a_row = rad_df[rad_df["master_symbol"] == "A"].iloc[0]
        assert a_row["min_jlpt_level"] == 5


class TestMetadataNull:
    def test_metadata_null_when_all_null(self, tmp_path):
        """Null grade/jlpt if all containing kanji have null values."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kvg_df = _make_kanjivg_df([
            _kvg_row("X", _tree("X", stroke_count=4, children=[
                _tree("A", position="left", stroke_count=2),
            ])),
            _kvg_row("A", _tree("A", stroke_count=2)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 2)])
        _make_kanji_csv(csv_dir, [("X", 4, None, None)])

        scope = {"X"}
        keep = {"A", "X"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)
        rad_df = result["radicals"]

        a_row = rad_df[rad_df["master_symbol"] == "A"].iloc[0]
        assert pd.isna(a_row["min_grade"])
        assert pd.isna(a_row["min_jlpt_level"])
        # impact_score still computed (based on count)
        assert a_row["impact_score"] == 1


class TestRadicalsCsvUpdated:
    def test_radicals_csv_updated(self, basic_setup):
        """radicals.csv is rewritten with metadata fields populated."""
        parquet_dir, csv_dir, warnings_dir, scope_set, keep_set = basic_setup

        extract_components(parquet_dir, csv_dir, warnings_dir, scope_set, keep_set)

        # Read back the updated radicals.csv
        rad_df = pd.read_csv(csv_dir / "radicals.csv")

        # Both radicals appear in 1 kanji each → impact_score = 1
        person = rad_df[rad_df["master_symbol"] == "亻"].iloc[0]
        assert person["impact_score"] == 1

        tree_row = rad_df[rad_df["master_symbol"] == "木"].iloc[0]
        assert tree_row["impact_score"] == 1


# ---------------------------------------------------------------------------
# Warnings
# ---------------------------------------------------------------------------


class TestWarningMissingKanji:
    def test_warning_missing_kanji(self, tmp_path):
        """High warning when scope kanji not found in kanji.csv."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kvg_df = _make_kanjivg_df([
            _kvg_row("X", _tree("X", stroke_count=4, children=[
                _tree("A", position="left", stroke_count=2),
            ])),
            _kvg_row("A", _tree("A", stroke_count=2)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [("A", 2)])
        # kanji.csv does NOT contain X
        _make_kanji_csv(csv_dir, [])

        scope = {"X"}
        keep = {"A", "X"}

        extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)

        w_df = pd.read_csv(warnings_dir / "ph2_3_warnings.csv")
        missing = w_df[
            (w_df["entity"] == "X")
            & (w_df["message"].str.contains("not found in kanji.csv"))
        ]
        assert len(missing) == 1
        assert missing.iloc[0]["severity"] == "high"


class TestWarningMissingRadical:
    def test_warning_missing_radical(self, tmp_path):
        """High warning when child element can't be resolved to a radical."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        kvg_df = _make_kanjivg_df([
            _kvg_row("X", _tree("X", stroke_count=4, children=[
                _tree("A", position="left", stroke_count=2),
                _tree("Z", position="right", stroke_count=2),  # Z not in radicals
            ])),
            _kvg_row("A", _tree("A", stroke_count=2)),
            _kvg_row("Z", _tree("Z", stroke_count=2)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        # Only A is a radical, not Z
        _make_radicals_csv(csv_dir, [("A", 2)])
        _make_kanji_csv(csv_dir, [("X", 4, 1, 5)])

        scope = {"X"}
        keep = {"A", "Z", "X"}

        extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)

        w_df = pd.read_csv(warnings_dir / "ph2_3_warnings.csv")
        missing = w_df[
            (w_df["entity"] == "Z")
            & (w_df["message"].str.contains("not resolved to a radical"))
        ]
        assert len(missing) == 1
        assert missing.iloc[0]["severity"] == "high"


# ---------------------------------------------------------------------------
# Integration
# ---------------------------------------------------------------------------


class TestIntegration:
    def test_integration(self, tmp_path):
        """Full pipeline with temp dirs, verify CSV output."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        # 休=亻+木, 語=言+吾, 吾=五+口
        kvg_df = _make_kanjivg_df([
            _kvg_row("休", _tree("休", stroke_count=6, children=[
                _tree("亻", position="left", radical="general", variant=True,
                      original="人", stroke_count=2),
                _tree("木", position="right", stroke_count=4),
            ])),
            _kvg_row("語", _tree("語", stroke_count=14, children=[
                _tree("言", position="left", radical="general", stroke_count=7),
                _tree("吾", position="right", stroke_count=7),
            ])),
            _kvg_row("吾", _tree("吾", stroke_count=7, children=[
                _tree("五", position="top", stroke_count=4),
                _tree("口", position="bottom", stroke_count=3),
            ])),
            _kvg_row("人", _tree("人", stroke_count=2)),
            _kvg_row("木", _tree("木", stroke_count=4)),
            _kvg_row("言", _tree("言", stroke_count=7)),
            _kvg_row("五", _tree("五", stroke_count=4)),
            _kvg_row("口", _tree("口", stroke_count=3)),
        ])
        kvg_df.to_parquet(parquet_dir / "kanjivg.parquet", index=False)

        _make_radicals_csv(csv_dir, [
            ("亻", 2), ("木", 4), ("言", 7),
            ("吾", 7), ("五", 4), ("口", 3),
        ])
        _make_kanji_csv(csv_dir, [
            ("休", 6, 2, 4),
            ("語", 14, 2, 5),
            ("吾", 7, None, None),
        ])

        scope = {"休", "語", "吾"}
        keep = {"亻", "木", "言", "吾", "五", "口", "休", "語"}

        result = extract_components(parquet_dir, csv_dir, warnings_dir, scope, keep)

        # Verify CSV files
        assert (csv_dir / "kanji_components.csv").exists()
        assert (csv_dir / "radicals.csv").exists()

        comp_df = result["kanji_components"]
        # 休→人,木  語→言,吾  吾→五,口 = 6 rows
        assert len(comp_df) == 6

        # Verify round-trip via CSV
        csv_comp = pd.read_csv(csv_dir / "kanji_components.csv")
        assert len(csv_comp) == 6

        # Radicals updated
        rad_df = pd.read_csv(csv_dir / "radicals.csv")
        # All 6 radicals used → impact_score populated
        used = rad_df[rad_df["impact_score"].notna()]
        assert len(used) == 6


class TestDeterministicOutput:
    def test_deterministic_output(self, basic_setup):
        """Running twice produces identical output."""
        parquet_dir, csv_dir, warnings_dir, scope_set, keep_set = basic_setup

        # Run 1
        result1 = extract_components(parquet_dir, csv_dir, warnings_dir, scope_set, keep_set)
        comp1 = result1["kanji_components"].copy()
        rad1 = result1["radicals"].copy()

        # Run 2 (same inputs — rewrite CSVs)
        # Recreate radicals.csv since it was overwritten by run 1
        _make_radicals_csv(csv_dir, [("亻", 2), ("木", 4)])
        result2 = extract_components(parquet_dir, csv_dir, warnings_dir, scope_set, keep_set)
        comp2 = result2["kanji_components"]
        rad2 = result2["radicals"]

        pd.testing.assert_frame_equal(comp1, comp2)
        pd.testing.assert_frame_equal(rad1, rad2)
