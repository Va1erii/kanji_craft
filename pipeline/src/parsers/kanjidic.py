"""Parse KANJIDIC2 XML into a DataFrame."""

import gzip
import json
import logging
from pathlib import Path

import pandas as pd
from lxml import etree

log = logging.getLogger(__name__)

# Dictionary reference types to skip
_SKIP_DR_TYPES = frozenset({"sakade", "henshall3", "crowley", "maniette"})


def _text(el: etree._Element | None) -> str | None:
    """Get text content of an element, or None if element is None."""
    return el.text if el is not None else None


def _int(el: etree._Element | None) -> int | None:
    """Get integer text content, or None."""
    return int(el.text) if el is not None and el.text else None


def _parse_codepoints(cp_group: etree._Element | None) -> str:
    """Parse <cp_value> elements into JSON: {ucs, jis208?, jis212?, jis213?}."""
    result: dict[str, str] = {}
    if cp_group is not None:
        for cp in cp_group.findall("cp_value"):
            cp_type = cp.get("cp_type", "")
            key = cp_type.replace("-", "").lower()  # jis_208 -> jis208
            if key == "ucs":
                result["ucs"] = cp.text or ""
            elif key in ("jis208", "jis212", "jis213"):
                result[key] = cp.text or ""
    return json.dumps(result, ensure_ascii=False)


def _parse_radicals(rad_group: etree._Element | None) -> str:
    """Parse <rad_value> elements into JSON: {classical, nelson_c?}."""
    result: dict[str, int] = {}
    if rad_group is not None:
        for rad in rad_group.findall("rad_value"):
            rad_type = rad.get("rad_type", "")
            if rad_type == "classical":
                result["classical"] = int(rad.text or "0")
            elif rad_type == "nelson_c":
                result["nelson_c"] = int(rad.text or "0")
    return json.dumps(result)


def _parse_variants(misc: etree._Element) -> str | None:
    """Parse <variant> elements into JSON: [{var_type, value}]."""
    variants = misc.findall("variant")
    if not variants:
        return None
    result = [{"var_type": v.get("var_type", ""), "value": v.text or ""} for v in variants]
    return json.dumps(result, ensure_ascii=False)


def _parse_dict_refs(dic_group: etree._Element | None) -> str | None:
    """Parse <dic_ref> elements into JSON: {dr_type: value, ...}."""
    if dic_group is None:
        return None
    refs: dict[str, object] = {}
    for dic in dic_group.findall("dic_ref"):
        dr_type = dic.get("dr_type", "")
        if dr_type in _SKIP_DR_TYPES:
            continue
        if dr_type == "moro":
            entry: dict[str, str] = {"value": dic.text or ""}
            vol = dic.get("m_vol")
            page = dic.get("m_page")
            if vol:
                entry["volume"] = vol
            if page:
                entry["page"] = page
            refs[dr_type] = entry
        else:
            refs[dr_type] = dic.text or ""
    return json.dumps(refs, ensure_ascii=False) if refs else None


def _parse_query_codes(qc_group: etree._Element | None) -> str:
    """Parse <q_code> elements into JSON."""
    result: dict[str, object] = {}
    if qc_group is not None:
        misclass: list[dict[str, str]] = []
        for qc in qc_group.findall("q_code"):
            qc_type = qc.get("qc_type", "")
            skip_misclass = qc.get("skip_misclass")
            if skip_misclass:
                misclass.append({"type": skip_misclass, "value": qc.text or ""})
            elif qc_type == "skip":
                result["skip"] = qc.text or ""
            elif qc_type == "four_corner":
                result["four_corner"] = qc.text or ""
            elif qc_type == "sh_desc":
                result["sh_desc"] = qc.text or ""
            elif qc_type == "deroo":
                result["deroo"] = qc.text or ""
        if misclass:
            result["misclass"] = misclass
    return json.dumps(result, ensure_ascii=False)


def _parse_readings(rmgroup: etree._Element) -> str:
    """Parse <reading> elements into JSON grouped by type."""
    result: dict[str, list[str]] = {}
    for r in rmgroup.findall("reading"):
        r_type = r.get("r_type", "")
        if r_type == "vietnam":
            continue
        key = r_type.replace("_", "_")  # ja_on, ja_kun, pinyin, korean_r, korean_h
        result.setdefault(key, []).append(r.text or "")
    return json.dumps(result, ensure_ascii=False)


def _parse_meanings(rmgroup: etree._Element) -> str:
    """Parse <meaning> elements into JSON grouped by language."""
    result: dict[str, list[str]] = {}
    for m in rmgroup.findall("meaning"):
        lang = m.get("m_lang", "en")
        if lang not in ("en", "fr", "es", "pt"):
            continue
        result.setdefault(lang, []).append(m.text or "")
    return json.dumps(result, ensure_ascii=False)


def parse_kanjidic(xml_gz_path: Path) -> pd.DataFrame:
    """Parse kanjidic2.xml.gz → DataFrame with one row per character.

    Uses streaming iterparse for memory efficiency.

    Args:
        xml_gz_path: Path to kanjidic2.xml.gz.

    Returns:
        DataFrame with columns as specified in the plan.
    """
    log.info("Parsing KANJIDIC: %s", xml_gz_path)

    rows: list[dict] = []
    with gzip.open(xml_gz_path, "rb") as f:
        context = etree.iterparse(f, events=("end",), tag="character")
        for _, char_el in context:
            row = _parse_character(char_el)
            rows.append(row)
            char_el.clear()
            while char_el.getprevious() is not None:
                del char_el.getparent()[0]

    df = pd.DataFrame(rows)
    # Set proper types
    df["stroke_count"] = df["stroke_count"].astype("int32")
    df["grade"] = df["grade"].astype("Int32")  # nullable
    df["jlpt"] = df["jlpt"].astype("Int32")  # nullable
    df["frequency"] = df["frequency"].astype("Int32")  # nullable

    log.info("Parsed %d KANJIDIC entries", len(df))
    return df


def _parse_character(char_el: etree._Element) -> dict:
    """Parse a single <character> element into a dict."""
    literal = char_el.findtext("literal", default="")

    # Codepoints
    cp_group = char_el.find("codepoint")
    codepoints = _parse_codepoints(cp_group)

    # Radicals
    rad_group = char_el.find("radical")
    radicals = _parse_radicals(rad_group)

    # Misc
    misc = char_el.find("misc")
    assert misc is not None

    stroke_counts = misc.findall("stroke_count")
    stroke_count = int(stroke_counts[0].text or "0")
    misstrokes = (
        [int(sc.text or "0") for sc in stroke_counts[1:]] if len(stroke_counts) > 1 else None
    )

    grade = _int(misc.find("grade"))
    jlpt = _int(misc.find("jlpt"))
    frequency = _int(misc.find("freq"))
    variants = _parse_variants(misc)
    radical_names = [rn.text or "" for rn in misc.findall("rad_name")] or None

    # Dictionary references
    dic_group = char_el.find("dic_number")
    dict_refs = _parse_dict_refs(dic_group)

    # Query codes
    qc_group = char_el.find("query_code")
    query_codes = _parse_query_codes(qc_group)

    # Readings and meanings
    rmgroup_el = char_el.find("reading_meaning")
    readings_json = "{}"
    meanings_json = "{}"
    nanori = None

    if rmgroup_el is not None:
        rmgroup = rmgroup_el.find("rmgroup")
        if rmgroup is not None:
            readings_json = _parse_readings(rmgroup)
            meanings_json = _parse_meanings(rmgroup)
        nanori_els = rmgroup_el.findall("nanori")
        if nanori_els:
            nanori = [n.text or "" for n in nanori_els]

    return {
        "literal": literal,
        "stroke_count": stroke_count,
        "stroke_count_misstrokes": json.dumps(misstrokes) if misstrokes else None,
        "grade": grade,
        "jlpt": jlpt,
        "frequency": frequency,
        "codepoints": codepoints,
        "radicals": radicals,
        "variants": variants,
        "dict_refs": dict_refs,
        "query_codes": query_codes,
        "readings": readings_json,
        "meanings": meanings_json,
        "nanori": json.dumps(nanori, ensure_ascii=False) if nanori else None,
        "radical_names": json.dumps(radical_names, ensure_ascii=False) if radical_names else None,
    }
