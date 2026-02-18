"""Tests for shared extraction utilities."""

import json
from pathlib import Path

import pandas as pd
import pytest

from src.extractors.shared import (
    ManualFileError,
    flatten_empty_elements,
    load_manual_list,
    map_position,
    merge_split_parts,
    resolve_effective_children,
    resolve_master_symbol,
    severity_sort_key,
    validate_all_manual_files,
    validate_manual_flatten,
    validate_manual_furigana,
    validate_manual_keep,
    validate_manual_localization,
    validate_manual_strokes,
    validate_visual_rules,
    write_csv_atomic,
)

# --- map_position ---


class TestMapPosition:
    def test_standard_positions(self):
        assert map_position("left") == "hen"
        assert map_position("right") == "tsukuri"
        assert map_position("top") == "kanmuri"
        assert map_position("bottom") == "ashi"
        assert map_position("kamae") == "kamae"
        assert map_position("tare") == "tare"
        assert map_position("nyo") == "nyo"

    def test_none_maps_to_unknown(self):
        assert map_position(None) == "unknown"

    def test_tarec_nyoc_map_to_themselves(self):
        assert map_position("tarec") == "tarec"
        assert map_position("nyoc") == "nyoc"

    def test_unknown_value_maps_to_unknown(self):
        assert map_position("something_weird") == "unknown"


# --- resolve_master_symbol ---


class TestResolveMasterSymbol:
    def test_variant_with_original(self):
        assert resolve_master_symbol("亻", True, "人") == "人"

    def test_non_variant(self):
        assert resolve_master_symbol("木", False, None) == "木"

    def test_variant_without_original(self):
        """variant=True but original=None → use element as fallback."""
        assert resolve_master_symbol("亻", True, None) == "亻"

    def test_non_variant_ignores_original(self):
        assert resolve_master_symbol("木", False, "林") == "木"


# --- load_manual_list ---


class TestLoadManualList:
    def test_nonexistent_file(self):
        assert load_manual_list(Path("/nonexistent/file.txt")) == set()

    def test_empty_file(self, tmp_path):
        f = tmp_path / "empty.txt"
        f.write_text("")
        assert load_manual_list(f) == set()

    def test_comments_and_blanks(self, tmp_path):
        f = tmp_path / "test.txt"
        f.write_text("# comment\n\n木\n# another\n水\n\n")
        assert load_manual_list(f) == {"木", "水"}

    def test_strips_whitespace(self, tmp_path):
        f = tmp_path / "test.txt"
        f.write_text("  木  \n  水  \n")
        assert load_manual_list(f) == {"木", "水"}

    def test_inline_comments(self, tmp_path):
        f = tmp_path / "test.txt"
        f.write_text("袁  # EN: 遠 園 猿\n木  # tree\n")
        assert load_manual_list(f) == {"袁", "木"}


# --- write_csv_atomic ---


class TestWriteCsvAtomic:
    def test_writes_csv(self, tmp_path):
        df = pd.DataFrame({"a": [1, 2], "b": ["x", "y"]})
        path = tmp_path / "out.csv"
        write_csv_atomic(df, path)
        assert path.exists()
        result = pd.read_csv(path)
        assert list(result.columns) == ["a", "b"]
        assert len(result) == 2

    def test_creates_parent_dirs(self, tmp_path):
        df = pd.DataFrame({"a": [1]})
        path = tmp_path / "sub" / "dir" / "out.csv"
        write_csv_atomic(df, path)
        assert path.exists()

    def test_no_temp_file_remains(self, tmp_path):
        df = pd.DataFrame({"a": [1]})
        path = tmp_path / "out.csv"
        write_csv_atomic(df, path)
        tmp_files = list(tmp_path.glob("*.tmp"))
        assert tmp_files == []


# --- flatten_empty_elements ---


class TestFlattenEmptyElements:
    def test_no_empty_elements(self):
        children = [
            {"element": "木", "position": "left", "children": []},
            {"element": "水", "position": "right", "children": []},
        ]
        result = flatten_empty_elements(children)
        assert len(result) == 2
        assert result[0]["element"] == "木"

    def test_empty_element_promotes_children(self):
        children = [
            {
                "element": None,
                "children": [
                    {"element": "木", "position": "left", "children": []},
                    {"element": "水", "position": "right", "children": []},
                ],
            },
        ]
        result = flatten_empty_elements(children)
        assert len(result) == 2
        assert result[0]["element"] == "木"
        assert result[1]["element"] == "水"

    def test_mixed_empty_and_non_empty(self):
        children = [
            {"element": "火", "position": "left", "children": []},
            {
                "element": None,
                "children": [
                    {"element": "木", "children": []},
                ],
            },
            {"element": "水", "position": "right", "children": []},
        ]
        result = flatten_empty_elements(children)
        assert len(result) == 3
        assert [c["element"] for c in result] == ["火", "木", "水"]

    def test_empty_string_element(self):
        """Empty string should also trigger promotion."""
        children = [
            {
                "element": "",
                "children": [
                    {"element": "口", "children": []},
                ],
            },
        ]
        result = flatten_empty_elements(children)
        assert len(result) == 1
        assert result[0]["element"] == "口"


# --- merge_split_parts ---


class TestMergeSplitParts:
    def test_no_parts(self):
        children = [
            {"element": "木", "children": []},
            {"element": "水", "children": []},
        ]
        result = merge_split_parts(children)
        assert len(result) == 2

    def test_merges_same_element_with_parts(self):
        children = [
            {"element": "辶", "part": 1, "position": "nyo", "stroke_count": 2, "children": []},
            {"element": "首", "stroke_count": 9, "children": []},
            {"element": "辶", "part": 2, "stroke_count": 1, "children": []},
        ]
        result = merge_split_parts(children)
        assert len(result) == 2
        # Merged 辶 should have combined stroke count
        assert result[0]["element"] == "辶"
        assert result[0]["stroke_count"] == 3
        assert result[0]["position"] == "nyo"  # kept from first part
        assert result[1]["element"] == "首"

    def test_different_elements_with_parts_not_merged(self):
        children = [
            {"element": "A", "part": 1, "stroke_count": 2, "children": []},
            {"element": "B", "part": 1, "stroke_count": 3, "children": []},
        ]
        result = merge_split_parts(children)
        assert len(result) == 2

    def test_no_part_attribute_not_merged(self):
        """Same element without part values should not be merged."""
        children = [
            {"element": "木", "stroke_count": 4, "children": []},
            {"element": "木", "stroke_count": 4, "children": []},
        ]
        result = merge_split_parts(children)
        assert len(result) == 2


# --- resolve_effective_children ---


class TestResolveEffectiveChildren:
    def test_simple_tree_no_ghosts(self):
        """All children in keep set — no flattening needed."""
        tree = {
            "element": "休",
            "children": [
                {"element": "亻", "position": "left", "variant": True, "original": "人",
                 "radical": "general", "children": []},
                {"element": "木", "position": "right", "children": []},
            ],
        }
        keep = {"人", "木"}
        tree_map = {}
        result = resolve_effective_children(tree, keep, tree_map)
        assert len(result) == 2
        assert result[0]["element"] == "亻"
        assert result[1]["element"] == "木"

    def test_ghost_with_keep_children_promoted(self):
        """Ghost radical → its keep-set children are promoted."""
        root = {
            "element": "燐",
            "children": [
                {"element": "火", "position": "left", "children": []},
                {
                    "element": "粦",
                    "position": "right",
                    "children": [],
                },
            ],
        }
        ghost_tree = {
            "element": "粦",
            "children": [
                {"element": "米", "position": "top", "children": []},
                {"element": "舛", "position": "bottom", "children": []},
            ],
        }
        keep = {"火", "米", "舛"}
        tree_map = {"粦": ghost_tree}

        result = resolve_effective_children(root, keep, tree_map)
        assert len(result) == 3
        elements = [c["element"] for c in result]
        assert elements == ["火", "米", "舛"]

    def test_recursive_ghost(self):
        """Ghost of ghost — flattening recurses through multiple levels."""
        root = {
            "element": "Y",
            "children": [
                {"element": "G1", "children": []},
            ],
        }
        g1_tree = {
            "element": "G1",
            "children": [
                {"element": "A", "position": "left", "children": []},
                {"element": "G2", "children": []},
            ],
        }
        g2_tree = {
            "element": "G2",
            "children": [
                {"element": "B", "position": "top", "children": []},
                {"element": "C", "position": "bottom", "children": []},
            ],
        }
        keep = {"A", "B", "C"}
        tree_map = {"G1": g1_tree, "G2": g2_tree}

        result = resolve_effective_children(root, keep, tree_map)
        assert [c["element"] for c in result] == ["A", "B", "C"]

    def test_position_inheritance(self):
        """Child without position inherits ghost's position."""
        root = {
            "element": "X",
            "children": [
                {"element": "火", "position": "left", "children": []},
                {
                    "element": "G",
                    "position": "right",
                    "children": [],
                },
            ],
        }
        ghost_tree = {
            "element": "G",
            "children": [
                {"element": "米", "position": "top", "children": []},
                {"element": "丶", "position": None, "children": []},
            ],
        }
        keep = {"火", "米", "丶"}
        tree_map = {"G": ghost_tree}

        result = resolve_effective_children(root, keep, tree_map)
        assert len(result) == 3
        # 米 keeps its own position "top"
        assert result[1]["element"] == "米"
        assert result[1]["position"] == "top"
        # 丶 inherits ghost's position "right"
        assert result[2]["element"] == "丶"
        assert result[2]["position"] == "right"

    def test_unflattenable_ghost_no_entry(self):
        """Ghost with no KanjiVG entry → kept as leaf."""
        root = {
            "element": "X",
            "children": [
                {"element": "G_no_entry", "position": "left", "children": []},
            ],
        }
        keep: set[str] = set()  # G_no_entry not in keep set
        tree_map: dict[str, dict] = {}  # No entry for G_no_entry

        warnings: list[dict] = []
        result = resolve_effective_children(root, keep, tree_map, warnings=warnings)
        assert len(result) == 1
        assert result[0]["element"] == "G_no_entry"
        assert any("no KanjiVG entry" in w["message"] for w in warnings)

    def test_unflattenable_ghost_no_children(self):
        """Ghost with KanjiVG entry but empty children → kept as leaf."""
        root = {
            "element": "X",
            "children": [
                {"element": "G_leaf", "position": "left", "children": []},
            ],
        }
        ghost_tree = {"element": "G_leaf", "children": []}
        keep: set[str] = set()
        tree_map = {"G_leaf": ghost_tree}

        warnings: list[dict] = []
        result = resolve_effective_children(root, keep, tree_map, warnings=warnings)
        assert len(result) == 1
        assert result[0]["element"] == "G_leaf"
        assert any("no children" in w["message"] for w in warnings)

    def test_depth_limit(self):
        """Recursion exceeding depth 10 → hard stop."""
        # Build a chain of 12 ghosts
        keep: set[str] = {"Z"}
        tree_map: dict[str, dict] = {}
        for i in range(12):
            name = f"G{i}"
            next_name = f"G{i + 1}" if i < 11 else "Z"
            tree_map[name] = {
                "element": name,
                "children": [{"element": next_name, "children": []}],
            }

        root = {"element": "root", "children": [{"element": "G0", "children": []}]}
        warnings: list[dict] = []
        resolve_effective_children(root, keep, tree_map, warnings=warnings)
        # Should have a high-severity depth warning
        assert any("depth exceeded" in w["message"].lower() or "Recursion depth" in w["message"]
                    for w in warnings)

    def test_empty_element_flattening_inside_ghost_resolution(self):
        """Empty element nodes should be flattened before ghost resolution."""
        root = {
            "element": "X",
            "children": [
                {
                    "element": None,
                    "children": [
                        {"element": "A", "position": "left", "children": []},
                    ],
                },
                {"element": "B", "position": "right", "children": []},
            ],
        }
        keep = {"A", "B"}
        tree_map: dict[str, dict] = {}

        result = resolve_effective_children(root, keep, tree_map)
        assert [c["element"] for c in result] == ["A", "B"]

    def test_split_part_merging_inside_ghost_resolution(self):
        """Split parts should be merged during ghost resolution."""
        root = {
            "element": "道",
            "children": [
                {"element": "辶", "part": 1, "position": "nyo", "stroke_count": 2,
                 "children": []},
                {"element": "首", "stroke_count": 9, "children": []},
                {"element": "辶", "part": 2, "stroke_count": 1, "children": []},
            ],
        }
        keep = {"辶", "首"}
        tree_map: dict[str, dict] = {}

        result = resolve_effective_children(root, keep, tree_map)
        assert len(result) == 2
        elements = [c["element"] for c in result]
        assert "辶" in elements
        assert "首" in elements


# --- validate_manual_keep ---


class TestValidateManualKeep:
    def test_nonexistent_passes(self):
        validate_manual_keep(Path("/nonexistent/file.txt"))

    def test_valid_passes(self, tmp_path):
        f = tmp_path / "manual_keep.txt"
        f.write_text("# comment\n木\n水\n")
        validate_manual_keep(f)

    def test_multi_char_fails(self, tmp_path):
        f = tmp_path / "manual_keep.txt"
        f.write_text("木水\n")
        with pytest.raises(ManualFileError, match="single character"):
            validate_manual_keep(f)


# --- validate_manual_flatten ---


class TestValidateManualFlatten:
    def test_valid_with_cdp_codes(self, tmp_path):
        f = tmp_path / "manual_flatten.txt"
        f.write_text("CDP-8BC4\n⻞\n㐫\n")
        validate_manual_flatten(f)

    def test_invalid_multi_char_fails(self, tmp_path):
        f = tmp_path / "manual_flatten.txt"
        f.write_text("abc\n")
        with pytest.raises(ManualFileError, match="single char or CDP"):
            validate_manual_flatten(f)


# --- validate_manual_strokes ---


class TestValidateManualStrokes:
    def test_valid(self, tmp_path):
        f = tmp_path / "manual_strokes.txt"
        f.write_text("电  5  # Lightning\nCDP-8BC4 8\n")
        validate_manual_strokes(f)

    def test_non_integer_fails(self, tmp_path):
        f = tmp_path / "manual_strokes.txt"
        f.write_text("电  abc\n")
        with pytest.raises(ManualFileError, match="non-integer"):
            validate_manual_strokes(f)

    def test_missing_count_fails(self, tmp_path):
        f = tmp_path / "manual_strokes.txt"
        f.write_text("电\n")
        with pytest.raises(ManualFileError, match="token count"):
            validate_manual_strokes(f)


# --- validate_manual_furigana ---


class TestValidateManualFurigana:
    def test_valid(self, tmp_path):
        f = tmp_path / "manual_furigana.csv"
        f.write_text("word,reading,furigana\n食べる,たべる,{食|た}べる\n")
        validate_manual_furigana(f)

    def test_bad_header_fails(self, tmp_path):
        f = tmp_path / "manual_furigana.csv"
        f.write_text("a,b,c\nfoo,bar,baz\n")
        with pytest.raises(ManualFileError, match="header columns"):
            validate_manual_furigana(f)

    def test_strip_mismatch_fails(self, tmp_path):
        f = tmp_path / "manual_furigana.csv"
        f.write_text("word,reading,furigana\n食べる,たべる,{飲|の}む\n")
        with pytest.raises(ManualFileError, match="stripped furigana"):
            validate_manual_furigana(f)

    def test_empty_field_fails(self, tmp_path):
        f = tmp_path / "manual_furigana.csv"
        f.write_text("word,reading,furigana\n食べる,,{食|た}べる\n")
        with pytest.raises(ManualFileError, match="empty field"):
            validate_manual_furigana(f)


# --- validate_manual_localization ---


class TestValidateManualLocalization:
    def test_valid(self, tmp_path):
        f = tmp_path / "manual_localization.csv"
        f.write_text('word,lang_code,meanings\n食べる,es,"[""comer""]"\n')
        validate_manual_localization(f)

    def test_empty_meanings_allowed(self, tmp_path):
        f = tmp_path / "manual_localization.csv"
        f.write_text("word,lang_code,meanings\n食べる,es,\n")
        validate_manual_localization(f)

    def test_invalid_lang_code_fails(self, tmp_path):
        f = tmp_path / "manual_localization.csv"
        f.write_text("word,lang_code,meanings\n食べる,xx,\n")
        with pytest.raises(ManualFileError, match="invalid lang_code"):
            validate_manual_localization(f)

    def test_duplicate_pair_fails(self, tmp_path):
        f = tmp_path / "manual_localization.csv"
        f.write_text("word,lang_code,meanings\n食べる,es,\n食べる,es,\n")
        with pytest.raises(ManualFileError, match="duplicate pair"):
            validate_manual_localization(f)

    def test_bad_header_fails(self, tmp_path):
        f = tmp_path / "manual_localization.csv"
        f.write_text("a,b,c\nfoo,bar,baz\n")
        with pytest.raises(ManualFileError, match="header columns"):
            validate_manual_localization(f)


# --- validate_visual_rules ---


class TestValidateVisualRules:
    def test_valid(self, tmp_path):
        f = tmp_path / "visual_rules.json"
        data = {
            "木": {
                "visual_group": "木",
                "disambiguation_note": {"en": "Tree"},
            },
        }
        f.write_text(json.dumps(data))
        validate_visual_rules(f)

    def test_missing_visual_group_fails(self, tmp_path):
        f = tmp_path / "visual_rules.json"
        data = {"木": {"disambiguation_note": {"en": "Tree"}}}
        f.write_text(json.dumps(data))
        with pytest.raises(ManualFileError, match="visual_group"):
            validate_visual_rules(f)

    def test_invalid_json_fails(self, tmp_path):
        f = tmp_path / "visual_rules.json"
        f.write_text("{bad json")
        with pytest.raises(ManualFileError, match="invalid JSON"):
            validate_visual_rules(f)


# --- validate_all_manual_files ---


class TestValidateAllManualFiles:
    def test_all_valid_passes(self, tmp_path):
        """No files exist → all validators skip → passes."""
        validate_all_manual_files(tmp_path)

    def test_collects_all_errors(self, tmp_path):
        """Multiple invalid files → combined error report."""
        (tmp_path / "manual_keep.txt").write_text("abc\n")
        (tmp_path / "manual_strokes.txt").write_text("电\n")
        with pytest.raises(ManualFileError) as exc_info:
            validate_all_manual_files(tmp_path)
        msg = str(exc_info.value)
        assert "single character" in msg
        assert "token count" in msg


# --- severity_sort_key ---


class TestSeveritySortKey:
    def test_high_before_medium_before_low(self):
        warnings = [
            {"severity": "low", "entity": "A", "message": "msg"},
            {"severity": "high", "entity": "B", "message": "msg"},
            {"severity": "medium", "entity": "C", "message": "msg"},
        ]
        result = sorted(warnings, key=severity_sort_key)
        assert [w["severity"] for w in result] == ["high", "medium", "low"]

    def test_same_severity_sorted_by_entity_then_message(self):
        warnings = [
            {"severity": "high", "entity": "B", "message": "z"},
            {"severity": "high", "entity": "A", "message": "y"},
            {"severity": "high", "entity": "A", "message": "x"},
        ]
        result = sorted(warnings, key=severity_sort_key)
        assert [(w["entity"], w["message"]) for w in result] == [
            ("A", "x"), ("A", "y"), ("B", "z"),
        ]

    def test_missing_entity_defaults_to_empty(self):
        warnings = [
            {"severity": "low", "message": "no entity"},
            {"severity": "low", "entity": "A", "message": "has entity"},
        ]
        result = sorted(warnings, key=severity_sort_key)
        assert result[0]["message"] == "no entity"
        assert result[1]["message"] == "has entity"

    def test_unknown_severity_sorts_last(self):
        warnings = [
            {"severity": "unknown", "entity": "A", "message": "msg"},
            {"severity": "low", "entity": "B", "message": "msg"},
        ]
        result = sorted(warnings, key=severity_sort_key)
        assert result[0]["severity"] == "low"
        assert result[1]["severity"] == "unknown"
