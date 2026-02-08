#!/usr/bin/env python3
"""
Generate seed JSON for N5 kanji data from KANJIDIC and KanjiVG sources.

Pipeline: External XML → Parser → seed.json → AI pass → Admin review → Push to Supabase

This script fills data-derivable fields and leaves AI/manual fields as null.
Stdlib only — no third-party dependencies.
"""

import argparse
import gzip
import json
import sys
import unicodedata
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

# ── Paths ───────────────────────────────────────────────────────────────────

BASE_DIR = Path(__file__).parent
DATA_DIR = BASE_DIR / "data"
OUTPUT_DIR = BASE_DIR / "output"

JLPT_MAP_PATH = DATA_DIR / "jlpt_kanji_map.json"
KANJIDIC_PATH = DATA_DIR / "jmdict20260207" / "KANJIDIC_english.zip"
KANJIVG_PATH = DATA_DIR / "kanjivg20250816" / "kanjivg-20250816.xml.gz"

# ── Constants ───────────────────────────────────────────────────────────────

KVG_NS = "http://kanjivg.tagaini.net"

# CJK Extension B characters to exclude (no data available)
EXCLUDED_MASTERS = {"\U00020087", "\U00020089"}  # 𠂇, 𠂉

POSITION_MAP = {
    "left": "hen",
    "right": "tsukuri",
    "top": "kanmuri",
    "bottom": "ashi",
    "kamae": "kamae",
    "kamaec": "kamae",
    "tare": "tare",
    "tarec": "tare",
    "nyo": "nyo",
    "nyoc": "nyo",
    "middle": "unknown",
}


def _kvg(attr):
    """Build namespaced KanjiVG attribute name."""
    return f"{{{KVG_NS}}}{attr}"


# ── Kangxi ──────────────────────────────────────────────────────────────────


def build_kangxi_set():
    """Build set of 214 Kangxi radical CJK equivalents from Unicode NFKD."""
    kangxi = set()
    for cp in range(0x2F00, 0x2FD6):
        normalized = unicodedata.normalize("NFKD", chr(cp))
        kangxi.add(normalized)
    return kangxi


# ── Loaders ─────────────────────────────────────────────────────────────────


def load_jlpt_map():
    """Load jlpt_kanji_map.json → full dict."""
    with open(JLPT_MAP_PATH, encoding="utf-8") as f:
        return json.load(f)


def load_kanjidic():
    """Load KANJIDIC from Yomitan-format zip → {char: entry_array}."""
    kanjidic = {}
    with zipfile.ZipFile(KANJIDIC_PATH) as z:
        for name in z.namelist():
            if name.startswith("kanji_bank"):
                with z.open(name) as f:
                    for entry in json.load(f):
                        kanjidic[entry[0]] = entry
    return kanjidic


def load_kanjivg():
    """Load KanjiVG gzipped XML → ElementTree root."""
    with gzip.open(KANJIVG_PATH, "rt", encoding="utf-8") as f:
        tree = ET.parse(f)
    return tree.getroot()


# ── Component extraction ────────────────────────────────────────────────────


def extract_components(kanjivg_root, chars):
    """Extract first-level components for each kanji from KanjiVG.

    Returns: {char: [(master_symbol, shape, position_str)]}
    """
    # Build lookup: hex_id → <kanji> element
    kanji_elements = {}
    for elem in kanjivg_root:
        kid = elem.attrib.get("id", "")
        # id format: "kvg:kanji_XXXXX"
        if "kanji_" in kid:
            hex_part = kid.split("kanji_")[-1]
            kanji_elements[hex_part] = elem

    result = {}
    for char in chars:
        hex_id = format(ord(char), "05x")
        kanji_elem = kanji_elements.get(hex_id)
        if kanji_elem is None:
            result[char] = []
            continue

        root_g = kanji_elem[0]  # root <g> element
        components = []
        seen_masters = {}  # master → first occurrence index (for dedup by part)

        for child in root_g:
            # Only process <g> children (skip <path> strokes)
            tag = child.tag
            if not (tag.endswith("}g") or tag == "g"):
                continue

            elem_name = child.attrib.get(_kvg("element"), "?")
            position = child.attrib.get(_kvg("position"), "")
            variant = child.attrib.get(_kvg("variant"), "")
            original = child.attrib.get(_kvg("original"), "")
            part = child.attrib.get(_kvg("part"), "")

            # Skip unnamed structural groupings
            if elem_name == "?":
                continue

            # Resolve variant → original as master_symbol
            master = original if (variant == "true" and original) else elem_name

            # Skip excluded CJK Extension B characters
            if master in EXCLUDED_MASTERS:
                continue

            # Deduplicate multi-part kanji (e.g., 五 has 二 part=1 and part=2)
            if master in seen_masters:
                continue
            seen_masters[master] = len(components)

            mapped_pos = POSITION_MAP.get(position, "unknown")
            components.append((master, elem_name, mapped_pos))

        result[char] = components

    return result


# ── Variant scanning ────────────────────────────────────────────────────────


def scan_variants(kanjivg_root, master_symbols):
    """Scan full KanjiVG for all occurrences of each master_symbol.

    Returns: {master: [(shape, position)]}
    """
    variants = {m: set() for m in master_symbols}

    for kanji_elem in kanjivg_root:
        root_g = kanji_elem[0] if len(kanji_elem) > 0 else None
        if root_g is None:
            continue
        _scan_group(root_g, variants)

    return {m: sorted(v) for m, v in variants.items()}


def _scan_group(group, variants):
    """Recursively scan a <g> element for master_symbol occurrences."""
    for child in group:
        tag = child.tag
        if not (tag.endswith("}g") or tag == "g"):
            continue

        elem_name = child.attrib.get(_kvg("element"), "?")
        if elem_name == "?":
            _scan_group(child, variants)
            continue

        variant_flag = child.attrib.get(_kvg("variant"), "")
        original = child.attrib.get(_kvg("original"), "")
        position = child.attrib.get(_kvg("position"), "")

        master = original if (variant_flag == "true" and original) else elem_name
        shape = elem_name

        if master in variants:
            mapped_pos = POSITION_MAP.get(position, "unknown")
            variants[master].add((shape, mapped_pos))

        # Recurse into nested groups
        _scan_group(child, variants)


# ── Stroke count helpers ────────────────────────────────────────────────────


def count_paths(kanjivg_root, char):
    """Count <path> elements for a character in KanjiVG (fallback stroke count)."""
    hex_id = format(ord(char), "05x")
    for elem in kanjivg_root:
        if hex_id in elem.attrib.get("id", ""):
            return sum(
                1
                for p in elem.iter()
                if p.tag == "path" or p.tag.endswith("}path")
            )
    return 0


def get_stroke_count(char, kanjidic, jlpt_map, kanjivg_root):
    """Get stroke count with cascading fallback: KANJIDIC → jlpt_map → KanjiVG paths."""
    if char in kanjidic:
        strokes = kanjidic[char][5].get("strokes")
        if strokes:
            return int(strokes)

    if char in jlpt_map.get("kanji", {}):
        strokes = jlpt_map["kanji"][char].get("strokes")
        if strokes:
            return int(strokes)

    return count_paths(kanjivg_root, char)


# ── Reading parsing ─────────────────────────────────────────────────────────


def parse_onyomi(raw):
    """Parse onyomi string → list of {reading, reading_type, priority} dicts."""
    if not raw or not raw.strip():
        return []

    tokens = raw.strip().split()
    readings = []
    for i, token in enumerate(tokens):
        readings.append(
            {
                "reading": token,
                "reading_type": "onyomi",
                "priority": "primary" if i == 0 else "secondary",
            }
        )
    return readings


def parse_kunyomi(raw):
    """Parse kunyomi string → list of {reading, reading_type, priority} dicts.

    Filters prefix/suffix forms (starting with -), strips okurigana (text after .),
    deduplicates stems.
    """
    if not raw or not raw.strip():
        return []

    tokens = raw.strip().split()
    stems = []
    seen = set()

    for token in tokens:
        # Skip prefix/suffix forms (leading - = suffix, trailing - = prefix)
        if token.startswith("-") or token.endswith("-"):
            continue

        # Strip okurigana: take text before '.'
        stem = token.split(".")[0]

        if stem not in seen:
            seen.add(stem)
            stems.append(stem)

    readings = []
    for i, stem in enumerate(stems):
        readings.append(
            {
                "reading": stem,
                "reading_type": "kunyomi",
                "priority": "primary" if i == 0 else "secondary",
            }
        )
    return readings


# ── Builders ────────────────────────────────────────────────────────────────


def build_radicals(
    master_symbols,
    components_by_kanji,
    kanjidic,
    jlpt_map,
    kanjivg_root,
    kangxi_set,
    variant_map,
):
    """Build radical entries with variants and i18n stubs.

    Returns: (list of radical dicts, {master_symbol: ref_string})
    """
    radicals = []
    ref_map = {}  # master_symbol → "radical_N"

    for idx, master in enumerate(sorted(master_symbols), start=1):
        ref = f"radical_{idx}"
        ref_map[master] = ref

        stroke_count = get_stroke_count(master, kanjidic, jlpt_map, kanjivg_root)
        is_official = master in kangxi_set

        # min_grade = minimum grade of any N5 kanji using this radical
        min_grade = None
        for char, comps in components_by_kanji.items():
            for m, _shape, _pos in comps:
                if m == master:
                    kanji_data = jlpt_map.get("kanji", {}).get(char, {})
                    grade = kanji_data.get("grade")
                    if grade is not None:
                        if min_grade is None or grade < min_grade:
                            min_grade = grade

        svg_hex = format(ord(master), "05x")

        # Build variants from full KanjiVG scan
        variants_data = variant_map.get(master, [])
        variants = []
        if variants_data:
            for shape, position in variants_data:
                shape_hex = format(ord(shape), "05x")
                variants.append(
                    {
                        "shape": shape,
                        "position": position,
                        "is_locked": None,
                        "svg_file_name": f"{shape_hex}.svg",
                        "svg_file_url": None,
                        "svg_hash": None,
                    }
                )
        else:
            # No variants found: emit one entry with master_symbol
            variants.append(
                {
                    "shape": master,
                    "position": "unknown",
                    "is_locked": None,
                    "svg_file_name": f"{svg_hex}.svg",
                    "svg_file_url": None,
                    "svg_hash": None,
                }
            )

        # i18n stub
        i18n = [
            {
                "lang_code": "en",
                "name": None,
                "system_mnemonic": None,
                "search_tags": None,
            }
        ]

        radicals.append(
            {
                "_ref": ref,
                "master_symbol": master,
                "stroke_count": stroke_count,
                "impact_score": None,
                "min_jlpt_level": 5,
                "min_grade": min_grade,
                "svg_file_name": f"{svg_hex}.svg",
                "svg_file_url": None,
                "svg_hash": None,
                "is_official": is_official,
                "variants": variants,
                "i18n": i18n,
            }
        )

    return radicals, ref_map


def build_kanji(n5_chars, components_by_kanji, ref_map, kanjidic, jlpt_map):
    """Build kanji entries with readings, i18n, and components."""
    kanji_list = []

    for idx, char in enumerate(n5_chars, start=1):
        ref = f"kanji_{idx}"

        kanji_data = jlpt_map.get("kanji", {}).get(char, {})
        grade = kanji_data.get("grade")
        jlpt = kanji_data.get("jlpt")
        strokes = kanji_data.get("strokes", 0)
        freq_rank = kanji_data.get("frequency_rank", 0)

        svg_hex = format(ord(char), "05x")

        # Readings from KANJIDIC
        readings = []
        kd_entry = kanjidic.get(char)
        if kd_entry:
            readings.extend(parse_onyomi(kd_entry[1]))
            readings.extend(parse_kunyomi(kd_entry[2]))

        # i18n from KANJIDIC meanings
        meanings = []
        if kd_entry and kd_entry[4]:
            meanings = list(kd_entry[4])

        i18n = [
            {
                "lang_code": "en",
                "meanings": meanings if meanings else None,
                "system_mnemonic": None,
                "search_tags": None,
            }
        ]

        # Components
        components = []
        comps = components_by_kanji.get(char, [])
        for master, _shape, position in comps:
            radical_ref = ref_map.get(master)
            if radical_ref:
                components.append(
                    {
                        "radical_ref": radical_ref,
                        "logic_hint": "semantic",
                    }
                )

        kanji_list.append(
            {
                "_ref": ref,
                "character": char,
                "stroke_count": strokes,
                "min_jlpt_level": jlpt,
                "min_grade": grade,
                "frequency_rank": freq_rank,
                "svg_file_name": f"{svg_hex}.svg",
                "svg_file_url": None,
                "svg_hash": None,
                "readings": readings,
                "i18n": i18n,
                "components": components,
            }
        )

    return kanji_list


# ── Validation ──────────────────────────────────────────────────────────────


def validate(seed, n5_chars):
    """Run validation checks. Returns (errors, warnings)."""
    errors = []
    warnings = []

    radicals = seed["radicals"]
    kanji_list = seed["kanji"]

    # 1. All 80 N5 kanji present
    kanji_chars = {k["character"] for k in kanji_list}
    missing = set(n5_chars) - kanji_chars
    if missing:
        errors.append(f"Missing N5 kanji: {''.join(missing)}")
    if len(kanji_list) != 80:
        errors.append(f"Expected 80 kanji, got {len(kanji_list)}")

    # 2. Every radical_ref resolves
    radical_refs = {r["_ref"] for r in radicals}
    for k in kanji_list:
        for comp in k["components"]:
            if comp["radical_ref"] not in radical_refs:
                errors.append(
                    f"Kanji {k['character']}: radical_ref '{comp['radical_ref']}' not found"
                )

    # 3. Every kanji has ≥1 reading with ≥1 primary
    for k in kanji_list:
        if not k["readings"]:
            errors.append(f"Kanji {k['character']}: no readings")
        else:
            has_primary = any(r["priority"] == "primary" for r in k["readings"])
            if not has_primary:
                errors.append(f"Kanji {k['character']}: no primary reading")

    # 4. Every kanji has ≥1 English meaning
    for k in kanji_list:
        en_i18n = next((i for i in k["i18n"] if i["lang_code"] == "en"), None)
        if not en_i18n or not en_i18n["meanings"]:
            errors.append(f"Kanji {k['character']}: no English meanings")

    # 5. stroke_count > 0, frequency_rank > 0
    for k in kanji_list:
        if k["stroke_count"] <= 0:
            errors.append(f"Kanji {k['character']}: stroke_count={k['stroke_count']}")
        if k["frequency_rank"] <= 0:
            errors.append(
                f"Kanji {k['character']}: frequency_rank={k['frequency_rank']}"
            )

    for r in radicals:
        if r["stroke_count"] <= 0:
            errors.append(
                f"Radical {r['master_symbol']}: stroke_count={r['stroke_count']}"
            )

    # 6. No duplicate _ref values
    all_refs = [r["_ref"] for r in radicals] + [k["_ref"] for k in kanji_list]
    seen_refs = set()
    for ref in all_refs:
        if ref in seen_refs:
            errors.append(f"Duplicate _ref: {ref}")
        seen_refs.add(ref)

    # 7. Warnings
    for k in kanji_list:
        if not k["components"]:
            warnings.append(f"Kanji {k['character']}: 0 components")

    for r in radicals:
        if r["master_symbol"] not in {
            entry[0]
            for entry in []  # placeholder — checked via stroke_count fallback
        }:
            pass  # handled by stroke_count check above

    return errors, warnings


# ── Main ────────────────────────────────────────────────────────────────────


def main():
    parser = argparse.ArgumentParser(description="Generate kanji seed JSON")
    parser.add_argument(
        "--scope",
        choices=["n5"],
        default="n5",
        help="JLPT scope to generate (default: n5)",
    )
    args = parser.parse_args()

    scope_key = args.scope.upper()  # "N5"
    print(f"Generating seed for {scope_key}...")

    # Load sources
    print("  Loading jlpt_kanji_map.json...")
    jlpt_map = load_jlpt_map()
    n5_chars = jlpt_map["by_jlpt"][scope_key]
    print(f"  → {len(n5_chars)} characters")

    print("  Loading KANJIDIC...")
    kanjidic = load_kanjidic()
    print(f"  → {len(kanjidic)} entries")

    print("  Loading KanjiVG...")
    kanjivg_root = load_kanjivg()
    print(f"  → {sum(1 for _ in kanjivg_root)} kanji elements")

    # Build Kangxi set
    kangxi_set = build_kangxi_set()
    print(f"  → {len(kangxi_set)} Kangxi radicals")

    # Extract components
    print("  Extracting components...")
    components_by_kanji = extract_components(kanjivg_root, n5_chars)

    # Collect unique master symbols
    master_symbols = set()
    for comps in components_by_kanji.values():
        for master, _shape, _pos in comps:
            master_symbols.add(master)
    print(f"  → {len(master_symbols)} unique radical masters")

    # Scan variants across full KanjiVG
    print("  Scanning variants (full KanjiVG)...")
    variant_map = scan_variants(kanjivg_root, master_symbols)

    # Build radicals
    print("  Building radicals...")
    radicals, ref_map = build_radicals(
        master_symbols,
        components_by_kanji,
        kanjidic,
        jlpt_map,
        kanjivg_root,
        kangxi_set,
        variant_map,
    )
    print(f"  → {len(radicals)} radicals")

    # Build kanji
    print("  Building kanji...")
    kanji_list = build_kanji(n5_chars, components_by_kanji, ref_map, kanjidic, jlpt_map)
    print(f"  → {len(kanji_list)} kanji")

    # Assemble seed
    seed = {
        "_meta": {
            "scope": scope_key,
            "sources": {
                "jlpt_map": str(JLPT_MAP_PATH.name),
                "kanjidic": str(KANJIDIC_PATH.name),
                "kanjivg": str(KANJIVG_PATH.name),
            },
            "counts": {
                "radicals": len(radicals),
                "kanji": len(kanji_list),
                "vocabulary": 0,
            },
        },
        "radicals": radicals,
        "kanji": kanji_list,
        "vocabulary": [],
    }

    # Validate
    print("  Validating...")
    errors, warnings = validate(seed, n5_chars)

    for w in warnings:
        print(f"  ⚠ {w}")
    for e in errors:
        print(f"  ✗ {e}")

    if errors:
        print(f"\n✗ {len(errors)} error(s), {len(warnings)} warning(s). Aborting.")
        sys.exit(1)

    # Write output
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    output_path = OUTPUT_DIR / f"seed_{args.scope}.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(seed, f, ensure_ascii=False, indent=2)

    print(f"\n✓ Written {output_path}")
    print(
        f"  Radicals: {len(radicals)}, Kanji: {len(kanji_list)}, Vocabulary: 0"
    )
    print(f"  Warnings: {len(warnings)}, Errors: 0")


if __name__ == "__main__":
    main()
