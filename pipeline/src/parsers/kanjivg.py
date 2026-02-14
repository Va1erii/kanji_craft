"""Parse KanjiVG XML into a DataFrame with component trees."""

import gzip
import json
import logging
import re
from pathlib import Path

import pandas as pd
from lxml import etree

log = logging.getLogger(__name__)

_KVG_NS = "http://kanjivg.tagaini.net"

# Regex to extract hex code from group/kanji id like "kvg:kanji_04eee" or "kvg:04eee"
_HEX_RE = re.compile(r"[0-9a-f]{4,5}$")


def _get_kvg(el: etree._Element, attr: str) -> str | None:
    """Get a kvg: namespaced attribute value."""
    return el.get(f"{{{_KVG_NS}}}{attr}")


def _count_all_paths(group: etree._Element) -> int:
    """Count all <path> descendants of this group (no namespace)."""
    return len(group.findall(".//path"))


def _build_component_tree(group: etree._Element) -> dict:
    """Recursively build component tree from a <g> group element."""
    element = _get_kvg(group, "element")
    position = _get_kvg(group, "position")
    radical = _get_kvg(group, "radical")
    original = _get_kvg(group, "original")
    variant = _get_kvg(group, "variant") == "true"
    phon = _get_kvg(group, "phon")
    part = _get_kvg(group, "part")
    partial = _get_kvg(group, "partial") == "true"

    children: list[dict] = []
    for child in group:
        tag = etree.QName(child.tag).localname if isinstance(child.tag, str) else child.tag
        if tag == "g":
            children.append(_build_component_tree(child))

    stroke_count = _count_all_paths(group)
    part_val: int | None = int(part) if part else None

    return {
        "element": element,
        "position": position,
        "radical": radical,
        "original": original,
        "variant": variant,
        "phon": phon,
        "part": part_val,
        "partial": partial,
        "stroke_count": stroke_count,
        "children": children,
    }


def _extract_char_from_id(el_id: str) -> str | None:
    """Extract kanji character from ID like 'kvg:kanji_04eee' or 'kvg:04eee'."""
    match = _HEX_RE.search(el_id)
    if match:
        try:
            return chr(int(match.group(), 16))
        except (ValueError, OverflowError):
            return None
    return None


def parse_kanjivg(xml_gz_path: Path) -> pd.DataFrame:
    """Parse kanjivg-*.xml.gz → DataFrame with one row per kanji.

    The real KanjiVG master XML uses <kanji> elements (no SVG namespace):
        <kanjivg xmlns:kvg='http://kanjivg.tagaini.net'>
          <kanji id="kvg:kanji_04eee">
            <g id="kvg:04eee" kvg:element="仮">
              ...
            </g>
          </kanji>
        </kanjivg>

    Args:
        xml_gz_path: Path to kanjivg-*.xml.gz.

    Returns:
        DataFrame with columns: character, component_tree.
    """
    log.info("Parsing KanjiVG: %s", xml_gz_path)

    rows: list[dict] = []

    with gzip.open(xml_gz_path, "rb") as f:
        context = etree.iterparse(f, events=("end",), tag="kanji")
        for _, kanji_el in context:
            row = _parse_kanji_element(kanji_el)
            if row:
                rows.append(row)
            kanji_el.clear()
            while kanji_el.getprevious() is not None:
                del kanji_el.getparent()[0]

    df = pd.DataFrame(rows, columns=["character", "component_tree"])
    log.info("Parsed %d KanjiVG entries", len(df))
    return df


def _parse_kanji_element(kanji_el: etree._Element) -> dict | None:
    """Parse a single <kanji> element into a row dict."""
    kanji_id = kanji_el.get("id", "")
    char = _extract_char_from_id(kanji_id)
    if not char:
        return None

    # The root component group is the first <g> child of <kanji>
    root_groups = [child for child in kanji_el if child.tag == "g"]
    if not root_groups:
        return None

    root_group = root_groups[0]
    tree = _build_component_tree(root_group)

    return {
        "character": char,
        "component_tree": json.dumps(tree, ensure_ascii=False),
    }
