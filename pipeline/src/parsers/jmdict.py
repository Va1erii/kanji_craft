"""Parse JMdict XML files into DataFrames."""

import gzip
import json
import logging
from pathlib import Path

import pandas as pd
from lxml import etree

log = logging.getLogger(__name__)


def _texts(parent: etree._Element, tag: str) -> list[str]:
    """Collect text from all child elements with given tag."""
    return [el.text or "" for el in parent.findall(tag)]


def _parse_k_ele(entry: etree._Element) -> list[dict] | None:
    """Parse <k_ele> elements into list of dicts."""
    k_eles = entry.findall("k_ele")
    if not k_eles:
        return None
    result = []
    for k in k_eles:
        result.append({
            "keb": k.findtext("keb", default=""),
            "ke_inf": _texts(k, "ke_inf"),
            "ke_pri": _texts(k, "ke_pri"),
        })
    return result


def _parse_r_ele(entry: etree._Element) -> list[dict]:
    """Parse <r_ele> elements into list of dicts."""
    result = []
    for r in entry.findall("r_ele"):
        result.append({
            "reb": r.findtext("reb", default=""),
            "re_nokanji": r.find("re_nokanji") is not None,
            "re_restr": _texts(r, "re_restr"),
            "re_inf": _texts(r, "re_inf"),
            "re_pri": _texts(r, "re_pri"),
        })
    return result


def _parse_senses(entry: etree._Element) -> list[dict]:
    """Parse <sense> elements into list of dicts."""
    result = []
    for sense in entry.findall("sense"):
        glosses = []
        for g in sense.findall("gloss"):
            gloss_entry: dict[str, str] = {
                "lang": g.get("{http://www.w3.org/XML/1998/namespace}lang", "eng"),
                "text": g.text or "",
            }
            g_type = g.get("g_type")
            if g_type:
                gloss_entry["g_type"] = g_type
            glosses.append(gloss_entry)

        lsources = []
        for ls in sense.findall("lsource"):
            ls_entry: dict[str, str | bool] = {
                "lang": ls.get("{http://www.w3.org/XML/1998/namespace}lang", "eng"),
            }
            if ls.text:
                ls_entry["text"] = ls.text
            ls_type = ls.get("ls_type")
            if ls_type:
                ls_entry["ls_type"] = ls_type
            ls_wasei = ls.get("ls_wasei")
            if ls_wasei:
                ls_entry["ls_wasei"] = ls_wasei == "y"
            lsources.append(ls_entry)

        sense_dict: dict[str, object] = {
            "pos": _texts(sense, "pos"),
            "stagk": _texts(sense, "stagk"),
            "stagr": _texts(sense, "stagr"),
            "xref": _texts(sense, "xref"),
            "ant": _texts(sense, "ant"),
            "field": _texts(sense, "field"),
            "misc": _texts(sense, "misc"),
            "dial": _texts(sense, "dial"),
            "gloss": glosses,
            "lsource": lsources,
        }

        s_inf = sense.findtext("s_inf")
        if s_inf:
            sense_dict["s_inf"] = s_inf

        result.append(sense_dict)
    return result


def parse_jmdict(xml_gz_path: Path) -> pd.DataFrame:
    """Parse JMdict.gz → DataFrame with one row per entry.

    Uses streaming iterparse. DTD entity references are resolved by lxml automatically.

    Args:
        xml_gz_path: Path to JMdict.gz.

    Returns:
        DataFrame with columns: ent_seq, k_ele, r_ele, senses.
    """
    log.info("Parsing JMdict: %s", xml_gz_path)

    rows: list[dict] = []
    with gzip.open(xml_gz_path, "rb") as f:
        context = etree.iterparse(f, events=("end",), tag="entry", load_dtd=True)
        for _, entry in context:
            ent_seq = int(entry.findtext("ent_seq", default="0"))
            k_ele = _parse_k_ele(entry)
            r_ele = _parse_r_ele(entry)
            senses = _parse_senses(entry)

            rows.append({
                "ent_seq": ent_seq,
                "k_ele": json.dumps(k_ele, ensure_ascii=False) if k_ele else None,
                "r_ele": json.dumps(r_ele, ensure_ascii=False),
                "senses": json.dumps(senses, ensure_ascii=False),
            })

            entry.clear()
            while entry.getprevious() is not None:
                del entry.getparent()[0]

    df = pd.DataFrame(rows)
    df["ent_seq"] = df["ent_seq"].astype("int64")
    log.info("Parsed %d JMdict entries", len(df))
    return df


def parse_jmdict_examples(xml_gz_path: Path) -> pd.DataFrame:
    """Parse JMdict_e_examp.gz → DataFrame with one row per example sentence.

    Args:
        xml_gz_path: Path to JMdict_e_examp.gz.

    Returns:
        DataFrame with columns: ent_seq, source_id, word_form, sentence_ja, sentence_en.
    """
    log.info("Parsing JMdict examples: %s", xml_gz_path)

    rows: list[dict] = []
    with gzip.open(xml_gz_path, "rb") as f:
        context = etree.iterparse(f, events=("end",), tag="entry", load_dtd=True)
        for _, entry in context:
            ent_seq = int(entry.findtext("ent_seq", default="0"))

            for sense in entry.findall("sense"):
                for example in sense.findall("example"):
                    source_el = example.find("ex_srce")
                    source_id = source_el.text if source_el is not None else ""
                    word_form = example.findtext("ex_text", default="")

                    sentence_ja = ""
                    sentence_en = ""
                    for sent in example.findall("ex_sent"):
                        lang = sent.get("{http://www.w3.org/XML/1998/namespace}lang", "")
                        if lang == "jpn":
                            sentence_ja = sent.text or ""
                        elif lang == "eng":
                            sentence_en = sent.text or ""

                    rows.append({
                        "ent_seq": ent_seq,
                        "source_id": source_id,
                        "word_form": word_form,
                        "sentence_ja": sentence_ja,
                        "sentence_en": sentence_en,
                    })

            entry.clear()
            while entry.getprevious() is not None:
                del entry.getparent()[0]

    cols = ["ent_seq", "source_id", "word_form", "sentence_ja", "sentence_en"]
    df = pd.DataFrame(rows, columns=cols)
    df["ent_seq"] = df["ent_seq"].astype("int64")
    log.info("Parsed %d JMdict example sentences", len(df))
    return df
