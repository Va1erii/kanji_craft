"""Shared utilities for Phase 2 extraction."""

import json
import logging
from pathlib import Path

import pandas as pd

log = logging.getLogger(__name__)

# KanjiVG position → Position enum value
_POSITION_MAP: dict[str, str] = {
    "left": "hen",
    "right": "tsukuri",
    "top": "kanmuri",
    "bottom": "ashi",
    "kamae": "kamae",
    "tare": "tare",
    "nyo": "nyo",
}

_UNKNOWN_POSITIONS = frozenset({"tarec", "nyoc"})

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
    kamae→kamae, tare→tare, nyo→nyo, tarec/nyoc/None→unknown.
    """
    if kvg_position is None:
        return "unknown"
    mapped = _POSITION_MAP.get(kvg_position)
    if mapped:
        return mapped
    if kvg_position in _UNKNOWN_POSITIONS:
        return "unknown"
    log.warning("Unknown KanjiVG position '%s', mapping to 'unknown'", kvg_position)
    return "unknown"


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


def parse_component_tree(json_str: str) -> dict:
    """Parse a component_tree JSON string into a dict."""
    return json.loads(json_str)
