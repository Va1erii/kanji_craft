"""Shared utilities for Phase 2 extraction."""

import json
import logging
import re
from pathlib import Path

import pandas as pd

from src.config import TARGET_LANGS

log = logging.getLogger(__name__)


class ManualFileError(Exception):
    """Raised when a manual override file fails validation."""

# KanjiVG position → Position enum value
_POSITION_MAP: dict[str, str] = {
    "left": "hen",
    "right": "tsukuri",
    "top": "kanmuri",
    "bottom": "ashi",
    "kamae": "kamae",
    "tare": "tare",
    "nyo": "nyo",
    "tarec": "tarec",
    "nyoc": "nyoc",
}

_SEVERITY_RANK = {"high": 0, "medium": 1, "low": 2}


def severity_sort_key(w: dict) -> tuple:
    """Sort key for warning dicts: high → medium → low, then entity, message."""
    return (_SEVERITY_RANK.get(w["severity"], 9), w.get("entity", ""), w["message"])

_MAX_GHOST_DEPTH = 10
_WARN_GHOST_DEPTH = 5


def write_csv_atomic(df: pd.DataFrame, path: Path) -> None:
    """Write DataFrame to CSV using temp file + rename for atomicity."""
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(".csv.tmp")
    df.to_csv(tmp, index=False)
    tmp.rename(path)
    log.info("Wrote %s (%d rows)", path.name, len(df))


def load_manual_list(path: Path) -> set[str]:
    """Load one-char-per-line file, skip blanks and # comments.

    Supports inline comments: ``袁  # EN: 遠 園 猿`` → ``袁``.
    """
    if not path.exists():
        return set()
    result: set[str] = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.split("#", 1)[0].strip()
        if line:
            result.add(line)
    return result


def load_manual_strokes(path: Path) -> dict[str, int]:
    """Load char→stroke_count mapping file, skip blanks and # comments.

    Format: ``电  5  # comment`` → ``{"电": 5}``.
    """
    if not path.exists():
        return {}
    result: dict[str, int] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.split("#", 1)[0].strip()
        if not line:
            continue
        parts = line.split()
        if len(parts) >= 2:
            result[parts[0]] = int(parts[1])
    return result


def load_manual_furigana(path: Path) -> dict[tuple[str, str], str]:
    """Load manual furigana overrides from CSV.

    Format: ``word,reading,furigana`` (header row required).
    Empty furigana values are skipped. Returns ``{(word, reading): furigana}``.
    """
    if not path.exists():
        return {}
    df = pd.read_csv(path, dtype=str, keep_default_na=False)
    result: dict[tuple[str, str], str] = {}
    for _, row in df.iterrows():
        word = row.get("word", "").strip()
        reading = row.get("reading", "").strip()
        furigana = row.get("furigana", "").strip()
        if word and reading and furigana:
            result[(word, reading)] = furigana
    log.info("Loaded %d manual furigana entries from %s", len(result), path.name)
    return result


def load_manual_localization(path: Path) -> dict[tuple[str, str], str]:
    """Load manual localization overrides from CSV.

    Format: ``word,lang_code,meanings`` (header row required).
    Rows with empty meanings are skipped (placeholder pattern).
    Returns ``{(word, lang_code): meanings_json_string}``.
    """
    if not path.exists():
        return {}
    df = pd.read_csv(path, dtype=str, keep_default_na=False)
    result: dict[tuple[str, str], str] = {}
    for _, row in df.iterrows():
        word = row.get("word", "").strip()
        lang_code = row.get("lang_code", "").strip()
        meanings = row.get("meanings", "").strip()
        if word and lang_code and meanings:
            result[(word, lang_code)] = meanings
    log.info("Loaded %d manual localization entries from %s", len(result), path.name)
    return result


def load_visual_rules(path: Path) -> dict[str, dict]:
    """Load visual disambiguation rules from JSON.

    Format: ``{"master_symbol": {"visual_group": "...", "disambiguation_note": {...}}}``
    Returns parsed dict, or empty dict if file doesn't exist or is empty.
    """
    if not path.exists():
        return {}
    content = path.read_text(encoding="utf-8").strip()
    if not content:
        return {}
    return json.loads(content)


def map_position(kvg_position: str | None) -> str:
    """Map KanjiVG position string to Position enum value.

    left→hen, right→tsukuri, top→kanmuri, bottom→ashi,
    kamae→kamae, tare→tare, nyo→nyo, tarec→tarec, nyoc→nyoc, None→unknown.
    """
    if kvg_position is None:
        return "unknown"
    mapped = _POSITION_MAP.get(kvg_position)
    if mapped:
        return mapped
    log.warning("Unknown KanjiVG position '%s', mapping to 'unknown'", kvg_position)
    return "unknown"


def map_radical_type(kvg_radical: str | None) -> str:
    """Map KanjiVG radical attribute to RadicalType enum value.

    general→general, tradit→tradit, nelson→nelson, jis→jis, None→component.
    """
    if kvg_radical is None:
        return "component"
    if kvg_radical in {"general", "tradit", "nelson", "jis"}:
        return kvg_radical
    log.warning("Unknown KanjiVG radical type '%s', mapping to 'component'", kvg_radical)
    return "component"


def resolve_master_symbol(element: str, variant: bool, original: str | None) -> str:
    """Resolve master symbol: variant=True + original → original; else → element."""
    if variant and original:
        return original
    return element


def flatten_empty_elements(children: list[dict]) -> list[dict]:
    """Remove <g> nodes with empty element, promote their children.

    Structural groups in KanjiVG sometimes have no element attribute.
    Their children are promoted to become siblings.
    """
    result: list[dict] = []
    for child in children:
        if not child.get("element"):
            # Promote grandchildren
            result.extend(child.get("children", []))
        else:
            result.append(child)
    return result


def merge_split_parts(children: list[dict]) -> list[dict]:
    """Merge children with same element but different part values.

    E.g. 辶 part=1 and 辶 part=2 become a single 辶 entry.
    Stroke counts are summed. The first occurrence's attributes are kept,
    except children are merged.
    """
    seen: dict[str, int] = {}  # element → index in result
    result: list[dict] = []

    for child in children:
        element = child.get("element")
        part = child.get("part")

        if element and part is not None and element in seen:
            # Merge into existing entry
            idx = seen[element]
            existing = result[idx]
            existing["stroke_count"] = existing.get("stroke_count", 0) + child.get(
                "stroke_count", 0
            )
            existing["children"] = existing.get("children", []) + child.get("children", [])
        elif element and part is not None:
            # First occurrence of a split part
            seen[element] = len(result)
            result.append(dict(child))  # shallow copy
        else:
            result.append(child)

    return result


def resolve_effective_children(
    component: dict,
    keep_set: set[str],
    tree_map: dict[str, dict],
    depth: int = 0,
    inherit_position: str | None = None,
    warnings: list[dict] | None = None,
    force_drop: set[str] | None = None,
) -> list[dict]:
    """Ghost flattening algorithm. Recursive, depth-limited.

    For each direct child of `component`:
    - If master_symbol is in force_drop → silently discard
    - If master_symbol is in keep_set → keep (apply inherited position if needed)
    - Else (ghost) → look up ghost's tree entry and recursively flatten
    - If ghost has no entry or no children → keep as unflattenable leaf

    Returns list of effective child dicts with resolved positions.
    """
    if warnings is None:
        warnings = []

    if depth > _MAX_GHOST_DEPTH:
        if warnings is not None:
            warnings.append({
                "severity": "high",
                "phase": "2.1",
                "entity": component.get("element", "?"),
                "message": f"Recursion depth exceeded ({depth}) during ghost flattening",
            })
        return component.get("children", [])

    if depth > _WARN_GHOST_DEPTH:
        warnings.append({
            "severity": "medium",
            "phase": "2.1",
            "entity": component.get("element", "?"),
            "message": f"Deep recursion at depth {depth} during ghost flattening",
        })

    raw_children = component.get("children", [])
    direct_children = merge_split_parts(flatten_empty_elements(raw_children))

    result: list[dict] = []
    for child in direct_children:
        element = child.get("element")
        if not element:
            continue

        master = resolve_master_symbol(
            element, child.get("variant", False), child.get("original")
        )

        if force_drop and master in force_drop and master not in keep_set:
            continue

        if master in keep_set:
            # Meaningful component — keep. Apply inherited position if child has none.
            if child.get("position") is None and inherit_position is not None:
                child = dict(child)
                child["position"] = inherit_position
            result.append(child)
        else:
            # Ghost radical — try to flatten
            ghost_tree = tree_map.get(master)
            if ghost_tree and ghost_tree.get("children"):
                ghost_position = child.get("position") or inherit_position
                result.extend(
                    resolve_effective_children(
                        ghost_tree,
                        keep_set,
                        tree_map,
                        depth + 1,
                        ghost_position,
                        warnings,
                        force_drop,
                    )
                )
                # Log ghost flattening (severity depends on frequency, set by caller)
            else:
                # No tree or leaf — keep as unflattenable radical
                reason = "no KanjiVG entry" if ghost_tree is None else "no children"
                warnings.append({
                    "severity": "medium",
                    "phase": "2.1",
                    "entity": master,
                    "message": f"Ghost radical unflattenable ({reason})",
                })
                if child.get("position") is None and inherit_position is not None:
                    child = dict(child)
                    child["position"] = inherit_position
                result.append(child)

    return result


def char_to_svg_filename(char: str) -> str:
    """Character → unpadded hex filename for storage: 一 → '4e00.svg'."""
    return f"{ord(char):x}.svg"


def char_to_kvg_filename(char: str) -> str:
    """Character → KanjiVG ZIP filename (5-digit padded): 一 → '04e00.svg'."""
    return f"{ord(char):05x}.svg"


def parse_component_tree(json_str: str) -> dict:
    """Parse a component_tree JSON string into a dict."""
    return json.loads(json_str)


# ---------------------------------------------------------------------------
# Manual file validation
# ---------------------------------------------------------------------------


def validate_manual_keep(path: Path) -> None:
    """Validate manual_keep.txt: each non-comment line must be a single character."""
    if not path.exists():
        return
    errors: list[str] = []
    for i, raw_line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw_line.split("#", 1)[0].strip()
        if not line:
            continue
        if len(line) != 1:
            errors.append(f"{path.name}:{i}: expected single character, got '{line}'")
    if errors:
        raise ManualFileError("\n".join(errors))


def validate_manual_flatten(path: Path) -> None:
    """Validate manual_flatten.txt: each line is a single char or CDP-* code."""
    if not path.exists():
        return
    errors: list[str] = []
    cdp_pattern = re.compile(r"^CDP-[A-Z0-9]+$")
    for i, raw_line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw_line.split("#", 1)[0].strip()
        if not line:
            continue
        if len(line) == 1:
            continue
        if cdp_pattern.match(line):
            continue
        errors.append(f"{path.name}:{i}: expected single char or CDP-* code, got '{line}'")
    if errors:
        raise ManualFileError("\n".join(errors))


def validate_manual_strokes(path: Path) -> None:
    """Validate manual_strokes.txt: each line is token + positive integer."""
    if not path.exists():
        return
    errors: list[str] = []
    for i, raw_line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw_line.split("#", 1)[0].strip()
        if not line:
            continue
        parts = line.split()
        if len(parts) < 2:
            errors.append(f"{path.name}:{i}: expected 'token count', got '{line}'")
            continue
        try:
            count = int(parts[1])
            if count <= 0:
                errors.append(f"{path.name}:{i}: stroke count must be positive, got {count}")
        except ValueError:
            errors.append(f"{path.name}:{i}: non-integer stroke count '{parts[1]}'")
    if errors:
        raise ManualFileError("\n".join(errors))


def validate_manual_furigana(path: Path) -> None:
    """Validate manual_furigana.csv: header word,reading,furigana; all fields non-empty;
    stripping {X|...} notation reproduces word."""
    if not path.exists():
        return
    errors: list[str] = []
    df = pd.read_csv(path, dtype=str, keep_default_na=False)
    expected_cols = {"word", "reading", "furigana"}
    if not expected_cols.issubset(set(df.columns)):
        raise ManualFileError(
            f"{path.name}: expected header columns {expected_cols}, got {set(df.columns)}"
        )
    for i, row in df.iterrows():
        line_num = i + 2  # 1-indexed + header
        word = row["word"].strip()
        reading = row["reading"].strip()
        furigana = row["furigana"].strip()
        if not word or not reading or not furigana:
            errors.append(f"{path.name}:{line_num}: empty field (word/reading/furigana)")
            continue
        # Strip {X|...} notation → should reproduce word
        plain = re.sub(r"\{([^|]+)\|[^}]+\}", r"\1", furigana)
        plain = plain.replace("{", "").replace("}", "")
        if plain != word:
            errors.append(
                f"{path.name}:{line_num}: stripped furigana '{plain}' != word '{word}'"
            )
    if errors:
        raise ManualFileError("\n".join(errors))


def validate_manual_localization(path: Path) -> None:
    """Validate manual_localization.csv: header word,lang_code,meanings;
    word+lang_code non-empty; lang_code in TARGET_LANGS; no duplicate pairs;
    meanings may be empty."""
    if not path.exists():
        return
    errors: list[str] = []
    df = pd.read_csv(path, dtype=str, keep_default_na=False)
    expected_cols = {"word", "lang_code", "meanings"}
    if not expected_cols.issubset(set(df.columns)):
        raise ManualFileError(
            f"{path.name}: expected header columns {expected_cols}, got {set(df.columns)}"
        )
    seen: set[tuple[str, str]] = set()
    for i, row in df.iterrows():
        line_num = i + 2
        word = row["word"].strip()
        lang_code = row["lang_code"].strip()
        if not word:
            errors.append(f"{path.name}:{line_num}: empty word")
            continue
        if not lang_code:
            errors.append(f"{path.name}:{line_num}: empty lang_code")
            continue
        if lang_code not in TARGET_LANGS:
            errors.append(
                f"{path.name}:{line_num}: invalid lang_code '{lang_code}', "
                f"expected one of {TARGET_LANGS}"
            )
        pair = (word, lang_code)
        if pair in seen:
            errors.append(f"{path.name}:{line_num}: duplicate pair ({word}, {lang_code})")
        seen.add(pair)
    if errors:
        raise ManualFileError("\n".join(errors))


def validate_visual_rules(path: Path) -> None:
    """Validate visual_rules.json: valid JSON; each entry has visual_group (str)
    and disambiguation_note (dict)."""
    if not path.exists():
        return
    content = path.read_text(encoding="utf-8").strip()
    if not content:
        return
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        raise ManualFileError(f"{path.name}: invalid JSON: {e}") from e

    errors: list[str] = []
    if not isinstance(data, dict):
        raise ManualFileError(f"{path.name}: expected top-level dict, got {type(data).__name__}")
    for key, entry in data.items():
        if not isinstance(entry, dict):
            errors.append(f"{path.name}: entry '{key}' is not a dict")
            continue
        if "visual_group" not in entry or not isinstance(entry["visual_group"], str):
            errors.append(f"{path.name}: entry '{key}' missing or invalid 'visual_group'")
        if "disambiguation_note" not in entry or not isinstance(entry["disambiguation_note"], dict):
            errors.append(f"{path.name}: entry '{key}' missing or invalid 'disambiguation_note'")
    if errors:
        raise ManualFileError("\n".join(errors))


def validate_all_manual_files(data_dir: Path) -> None:
    """Run all manual file validators. Collects all errors and raises once."""
    validators = [
        ("manual_keep.txt", validate_manual_keep),
        ("manual_flatten.txt", validate_manual_flatten),
        ("manual_strokes.txt", validate_manual_strokes),
        ("manual_furigana.csv", validate_manual_furigana),
        ("manual_localization.csv", validate_manual_localization),
        ("visual_rules.json", validate_visual_rules),
    ]
    all_errors: list[str] = []
    for filename, validator in validators:
        try:
            validator(data_dir / filename)
        except ManualFileError as e:
            all_errors.append(str(e))
    if all_errors:
        raise ManualFileError(
            "Manual file validation failed:\n" + "\n".join(all_errors)
        )
