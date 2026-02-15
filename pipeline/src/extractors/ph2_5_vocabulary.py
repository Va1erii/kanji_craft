"""Phase 2.5: Vocabulary Extraction from JMdict.

Reads jmdict.parquet, jlpt_vocab.parquet, jmdict_furigana.parquet,
jmdict_examples.parquet, and kanji.csv to produce:
  vocabulary.csv, vocabulary_readings.csv, vocabulary_i18n.csv,
  vocabulary_kanji.csv, vocabulary_sentences.csv, vocabulary_sentence_i18n.csv.

Fields left empty for later phases:
- system_mnemonic, search_tags in vocabulary_i18n (Phase 3)
- vocabulary_sentences.original_text furigana annotation (Phase 3)
- vocabulary_sentence_i18n non-English translations (Phase 3)
"""

import json
import logging
import re
from pathlib import Path

import pandas as pd

from src.config import JMDICT_LANG_MAP, TARGET_LANGS
from src.extractors.shared import load_manual_furigana, load_manual_localization, write_csv_atomic

log = logging.getLogger(__name__)

DATA_DIR = Path(__file__).resolve().parent.parent.parent / "data"
MANUAL_FURIGANA = DATA_DIR / "manual_furigana.csv"
MANUAL_LOCALIZATION = DATA_DIR / "manual_localization.csv"

# ---------------------------------------------------------------------------
# POS Tag Mapping: JMdict pos codes → PosTag enum values
# ---------------------------------------------------------------------------

POS_TAG_MAP: dict[str, str] = {
    # Ichidan
    "v1": "ichidan_verb",
    "v1-s": "ichidan_verb",
    # Godan (all v5* variants)
    "v5u": "godan_verb",
    "v5k": "godan_verb",
    "v5r": "godan_verb",
    "v5s": "godan_verb",
    "v5t": "godan_verb",
    "v5b": "godan_verb",
    "v5g": "godan_verb",
    "v5m": "godan_verb",
    "v5n": "godan_verb",
    "v5k-s": "godan_verb",
    "v5r-i": "godan_verb",
    "v5u-s": "godan_verb",
    "v5aru": "godan_verb",
    # Suru
    "vs": "suru_verb",
    "vs-i": "suru_verb",
    "vs-s": "suru_verb",
    # Kuru
    "vk": "kuru_verb",
    # Transitivity
    "vt": "transitive",
    "vi": "intransitive",
    # Adjectives
    "adj-i": "i_adjective",
    "adj-ix": "i_adjective",
    "adj-na": "na_adjective",
    "adj-no": "no_adjective",
    # Nouns / other POS
    "n": "noun",
    "adv": "adverb",
    "pn": "pronoun",
    "prt": "particle",
    "ctr": "counter",
    "conj": "conjunction",
    "int": "interjection",
    "exp": "expression",
    "pref": "prefix",
    "suf": "suffix",
}

# ---------------------------------------------------------------------------
# Misc Tag Mapping: JMdict misc/ke_inf codes → MiscTag enum values
# ---------------------------------------------------------------------------

MISC_TAG_MAP: dict[str, str] = {
    "uk": "usually_kana",
    "uK": "usually_kanji",
    "ek": "exclusively_kana",
    "eK": "exclusively_kanji",
    "pol": "polite",
    "hum": "humble",
    "hon": "honorific",
    "col": "colloquial",
    "sl": "slang",
    "arch": "archaism",
    "on-mim": "onomatopoeia",
    "yoji": "yojijukugo",
    "id": "idiomatic",
    "abbr": "abbreviation",
    "proverb": "proverb",
    "iv": "irregular_verb",
    "ateji": "ateji",
    "rare": "rare",
    "sens": "sensitive",
    "vulg": "vulgar",
}

# ---------------------------------------------------------------------------
# Frequency priority tiers
# ---------------------------------------------------------------------------

_HIGH_PRI = {"news1", "ichi1", "spec1"}
_MID_PRI = {"news2", "ichi2", "spec2"}
_LOW_PRI = {"gai1", "gai2"}


def _is_kanji_char(ch: str) -> bool:
    """Check if a character is a CJK Unified Ideograph (kanji)."""
    cp = ord(ch)
    return (
        0x4E00 <= cp <= 0x9FFF  # CJK Unified Ideographs
        or 0x3400 <= cp <= 0x4DBF  # CJK Extension A
        or 0x20000 <= cp <= 0x2A6DF  # CJK Extension B
        or 0xF900 <= cp <= 0xFAFF  # CJK Compatibility Ideographs
    )


def _has_kanji(text: str) -> bool:
    """Check if text contains any kanji characters."""
    return any(_is_kanji_char(ch) for ch in text)


def _collect_priority_flags(k_ele: list[dict] | None, r_ele: list[dict]) -> set[str]:
    """Collect all priority flags from kanji and reading elements."""
    flags: set[str] = set()
    if k_ele:
        for k in k_ele:
            flags.update(k.get("ke_pri") or [])
    for r in r_ele:
        flags.update(r.get("re_pri") or [])
    return flags


def _compute_frequency_rank(pri_flags: set[str], is_jlpt: bool, jlpt_level: int | None) -> int:
    """Compute frequency rank from priority flags.

    High priority (news1/ichi1/spec1) → 1-based rank.
    Mid priority (news2/ichi2/spec2) → offset.
    Low priority (gai1/gai2) → higher offset.
    nfXX → use the nf band number.
    JLPT-only → synthetic rank at 100000+ offset.
    """
    # Extract nf value if present
    nf_val = None
    for f in pri_flags:
        if f.startswith("nf") and f[2:].isdigit():
            nf_val = int(f[2:])

    if pri_flags & _HIGH_PRI:
        # Use nf band if available, otherwise base rank
        return nf_val * 500 if nf_val else 1000
    if pri_flags & _MID_PRI:
        return nf_val * 500 if nf_val else 10000
    if pri_flags & _LOW_PRI:
        return nf_val * 500 if nf_val else 20000
    if nf_val:
        return nf_val * 500
    # JLPT-only words: synthetic rank based on level
    if is_jlpt and jlpt_level is not None:
        # N5=5 (easiest) gets lowest synthetic rank
        return 100000 + (6 - jlpt_level) * 1000
    return 100000


def _build_furigana_lookup(
    furigana_df: pd.DataFrame,
) -> dict[tuple[str, str], list[dict]]:
    """Build (text, reading) → furigana segments lookup."""
    lookup: dict[tuple[str, str], list[dict]] = {}
    for _, row in furigana_df.iterrows():
        text = row["text"]
        reading = row["reading"]
        segments = json.loads(row["furigana"])
        lookup[(text, reading)] = segments
    return lookup


def _construct_furigana(
    word: str,
    reading: str,
    furigana_lookup: dict[tuple[str, str], list[dict]],
    warnings: list[dict],
    is_jlpt: bool = False,
    manual_furigana: dict[tuple[str, str], str] | None = None,
) -> str:
    """Construct {kanji|reading} furigana notation.

    Priority: manual_furigana.csv → jmdict_furigana → whole-word fallback.
    """
    # Check manual overrides first
    if manual_furigana:
        manual = manual_furigana.get((word, reading))
        if manual:
            return manual

    segments = furigana_lookup.get((word, reading))

    if segments is None:
        # Fallback: whole-word furigana or plain text for kana-only
        if not _has_kanji(word):
            return word
        severity = "high" if is_jlpt else "low"
        warnings.append({
            "severity": severity,
            "phase": "2.5",
            "entity": word,
            "message": "Word not found in jmdict_furigana, using whole-word fallback",
        })
        return f"{{{word}|{reading}}}"

    # Build notation from segments, merging consecutive kanji into compound
    parts: list[str] = []
    kanji_buf: str = ""
    reading_buf: list[str] = []

    for seg in segments:
        ruby = seg["ruby"]
        rt = seg.get("rt")
        if rt:
            # Kanji segment — accumulate into buffer
            kanji_buf += ruby
            reading_buf.append(rt)
        else:
            # Kana segment — flush any buffered kanji group first
            if kanji_buf:
                parts.append("{" + "|".join([kanji_buf, *reading_buf]) + "}")
                kanji_buf = ""
                reading_buf = []
            parts.append(ruby)

    # Flush trailing kanji group
    if kanji_buf:
        parts.append("{" + "|".join([kanji_buf, *reading_buf]) + "}")

    result = "".join(parts)

    # Validate: stripping notation should reproduce the word
    plain = re.sub(r"\{([^|]+)\|[^}]+\}", r"\1", result)
    plain = plain.replace("{", "").replace("}", "")
    if plain != word:
        warnings.append({
            "severity": "low",
            "phase": "2.5",
            "entity": word,
            "message": f"Furigana validation failed: stripped='{plain}' != word='{word}'",
        })
        # Fall back to whole-word
        if _has_kanji(word):
            return f"{{{word}|{reading}}}"
        return word

    return result


def _extract_pos_tags(senses: list[dict]) -> list[str]:
    """Extract and deduplicate POS tags from senses with inheritance."""
    result: list[str] = []
    seen: set[str] = set()
    current_pos: list[str] = []

    for sense in senses:
        sense_pos = sense.get("pos") or []
        if sense_pos:
            current_pos = sense_pos
        # Map current pos codes
        for code in current_pos:
            mapped = POS_TAG_MAP.get(code)
            if mapped and mapped not in seen:
                seen.add(mapped)
                result.append(mapped)

    return result


def _extract_misc_tags(
    senses: list[dict], k_ele: list[dict] | None,
) -> list[str]:
    """Extract and deduplicate misc tags from senses and ke_inf. No inheritance."""
    result: list[str] = []
    seen: set[str] = set()

    # From senses misc
    for sense in senses:
        for code in sense.get("misc") or []:
            mapped = MISC_TAG_MAP.get(code)
            if mapped and mapped not in seen:
                seen.add(mapped)
                result.append(mapped)

    # From ke_inf on kanji elements
    if k_ele:
        for k in k_ele:
            for code in k.get("ke_inf") or []:
                mapped = MISC_TAG_MAP.get(code)
                if mapped and mapped not in seen:
                    seen.add(mapped)
                    result.append(mapped)

    return result


def _extract_field_tags(senses: list[dict]) -> list[str]:
    """Extract and deduplicate field tags from senses as raw strings."""
    result: list[str] = []
    seen: set[str] = set()
    for sense in senses:
        for code in sense.get("field") or []:
            if code not in seen:
                seen.add(code)
                result.append(code)
    return result


def _extract_dialect_tags(senses: list[dict]) -> list[str]:
    """Extract and deduplicate dialect tags from senses as raw strings."""
    result: list[str] = []
    seen: set[str] = set()
    for sense in senses:
        for code in sense.get("dial") or []:
            if code not in seen:
                seen.add(code)
                result.append(code)
    return result


# ---------------------------------------------------------------------------
# Step 1: Create Vocabulary Rows
# ---------------------------------------------------------------------------


def _step1_vocabulary_rows(
    jmdict_df: pd.DataFrame,
    jlpt_vocab_df: pd.DataFrame,
    kanji_df: pd.DataFrame,
    furigana_df: pd.DataFrame,
    warnings: list[dict],
    manual_furigana: dict[tuple[str, str], str] | None = None,
) -> pd.DataFrame:
    """Step 1+2: Create vocabulary rows with furigana.

    Selection: word is imported if it has a priority flag OR appears in jlpt_vocab.
    """
    log.info("Step 1: Creating vocabulary rows")

    # Build lookups
    furigana_lookup = _build_furigana_lookup(furigana_df)

    # JLPT vocab lookup: (expression, reading) → level
    jlpt_vocab_lookup: dict[tuple[str, str], int] = {}
    for _, row in jlpt_vocab_df.iterrows():
        key = (row["expression"], row["reading"])
        existing = jlpt_vocab_lookup.get(key)
        # Keep easiest level (highest number): N5=5 easiest, N1=1 hardest
        if existing is None or row["level"] > existing:
            jlpt_vocab_lookup[key] = int(row["level"])

    # Also build expression-only lookup for broader matching
    jlpt_expr_lookup: dict[str, int] = {}
    for _, row in jlpt_vocab_df.iterrows():
        expr = row["expression"]
        existing = jlpt_expr_lookup.get(expr)
        if existing is None or row["level"] > existing:
            jlpt_expr_lookup[expr] = int(row["level"])

    # Kanji character → jlpt level lookup
    kanji_jlpt: dict[str, int | None] = {}
    kanji_chars: set[str] = set()
    if not kanji_df.empty:
        for _, krow in kanji_df.iterrows():
            ch = krow["character"]
            kanji_chars.add(ch)
            lvl = krow.get("min_jlpt_level")
            kanji_jlpt[ch] = None if pd.isna(lvl) else int(lvl)

    vocab_rows: list[dict] = []

    for _, row in jmdict_df.iterrows():
        ent_seq = int(row["ent_seq"])
        k_ele = json.loads(row["k_ele"]) if pd.notna(row["k_ele"]) else None
        r_ele = json.loads(row["r_ele"])
        senses = json.loads(row["senses"])

        # Determine word and reading
        if k_ele and k_ele[0].get("keb"):
            word = k_ele[0]["keb"]
            reading = r_ele[0]["reb"]
        else:
            word = r_ele[0]["reb"]
            reading = word

        # Selection: priority flags or JLPT membership
        pri_flags = _collect_priority_flags(k_ele, r_ele)
        in_jlpt_exact = (word, reading) in jlpt_vocab_lookup
        in_jlpt_expr = word in jlpt_expr_lookup

        has_priority = bool(pri_flags - {"nf01", "nf02", "nf03", "nf04", "nf05",
                                          "nf06", "nf07", "nf08", "nf09", "nf10",
                                          "nf11", "nf12", "nf13", "nf14", "nf15",
                                          "nf16", "nf17", "nf18", "nf19", "nf20",
                                          "nf21", "nf22", "nf23", "nf24", "nf25",
                                          "nf26", "nf27", "nf28", "nf29", "nf30",
                                          "nf31", "nf32", "nf33", "nf34", "nf35",
                                          "nf36", "nf37", "nf38", "nf39", "nf40",
                                          "nf41", "nf42", "nf43", "nf44", "nf45",
                                          "nf46", "nf47", "nf48"})
        # Actually, nfXX IS a priority flag per spec. Simplify:
        has_priority = bool(pri_flags)
        in_jlpt = in_jlpt_exact or in_jlpt_expr

        if not has_priority and not in_jlpt:
            continue

        # JLPT level resolution
        # Source 1: jlpt_vocab (authoritative) — match on (expression, reading) first
        jlpt_level: int | None = None
        if in_jlpt_exact:
            jlpt_level = jlpt_vocab_lookup[(word, reading)]
        elif in_jlpt_expr:
            jlpt_level = jlpt_expr_lookup[word]

        # Source 2: kanji-derived fallback
        # N5=5 easiest, N1=1 hardest; MIN returns the hardest kanji's level,
        # which is the level at which the word becomes available (gated by
        # the hardest constituent kanji).
        if jlpt_level is None:
            kanji_levels = []
            for ch in word:
                if _is_kanji_char(ch) and ch in kanji_jlpt:
                    kl = kanji_jlpt[ch]
                    if kl is not None:
                        kanji_levels.append(kl)
            if kanji_levels:
                jlpt_level = min(kanji_levels)

        # Furigana
        has_jlpt = jlpt_level is not None
        furigana = _construct_furigana(
            word, reading, furigana_lookup, warnings,
            is_jlpt=has_jlpt, manual_furigana=manual_furigana,
        )

        # POS tags
        pos_tags = _extract_pos_tags(senses)

        # Misc tags
        misc_tags = _extract_misc_tags(senses, k_ele)

        # Field tags
        field_tags = _extract_field_tags(senses)

        # Dialect tags
        dialect_tags = _extract_dialect_tags(senses)

        # Frequency rank
        freq_rank = _compute_frequency_rank(pri_flags, in_jlpt, jlpt_level)

        vocab_rows.append({
            "id": ent_seq,
            "word": word,
            "furigana": furigana,
            "min_jlpt_level": jlpt_level,
            "pos_tags": json.dumps(pos_tags, ensure_ascii=False),
            "misc_tags": json.dumps(misc_tags, ensure_ascii=False),
            "field_tags": json.dumps(field_tags, ensure_ascii=False),
            "dialect_tags": json.dumps(dialect_tags, ensure_ascii=False),
            "frequency_rank": freq_rank,
        })

    df = pd.DataFrame(vocab_rows)
    if not df.empty:
        df["id"] = df["id"].astype("int64")
        df["frequency_rank"] = df["frequency_rank"].astype("int64")
        # Sort by id for deterministic output
        df = df.sort_values("id").reset_index(drop=True)

    log.info("Step 1: %d vocabulary rows", len(df))
    return df


# ---------------------------------------------------------------------------
# Step 3: Create Reading Rows
# ---------------------------------------------------------------------------


def _step3_reading_rows(
    vocab_df: pd.DataFrame,
    jmdict_df: pd.DataFrame,
) -> pd.DataFrame:
    """Step 3: Create reading rows from JMdict reading elements."""
    log.info("Step 3: Creating reading rows")

    if vocab_df.empty:
        return pd.DataFrame(columns=["id", "vocabulary_id", "reading", "reading_type", "priority"])

    # Build ent_seq → jmdict row lookup
    jmdict_lookup: dict[int, pd.Series] = {}
    for _, row in jmdict_df.iterrows():
        jmdict_lookup[int(row["ent_seq"])] = row

    rows: list[dict] = []

    for _, vrow in vocab_df.iterrows():
        vid = int(vrow["id"])
        jm_row = jmdict_lookup.get(vid)
        if jm_row is None:
            continue

        k_ele = json.loads(jm_row["k_ele"]) if pd.notna(jm_row["k_ele"]) else None
        r_ele = json.loads(jm_row["r_ele"])

        # Get headword priority flags for primary/secondary determination
        headword_pri: set[str] = set()
        if k_ele:
            headword_pri = set(k_ele[0].get("ke_pri") or [])

        headword_keb = k_ele[0]["keb"] if k_ele else None

        seen_readings: set[str] = set()

        for r in r_ele:
            reb = r["reb"]

            # Skip if re_restr doesn't include our headword
            re_restr = r.get("re_restr") or []
            if re_restr and headword_keb and headword_keb not in re_restr:
                continue

            if reb in seen_readings:
                continue
            seen_readings.add(reb)

            # Vocabulary readings don't distinguish on/kun
            reading_type = "kana"

            # Determine priority
            re_pri = set(r.get("re_pri") or [])
            if re_pri & headword_pri:
                priority = "primary"
            elif not headword_pri:
                # No headword priorities — first reading is primary
                is_first = not rows or rows[-1]["vocabulary_id"] != vid
                priority = "primary" if is_first else "secondary"
            else:
                priority = "secondary"

            rows.append({
                "vocabulary_id": vid,
                "reading": reb,
                "reading_type": reading_type,
                "priority": priority,
            })

    # Ensure every vocab word has at least one primary reading
    vocab_with_primary: set[int] = set()
    for r in rows:
        if r["priority"] == "primary":
            vocab_with_primary.add(r["vocabulary_id"])

    for r in rows:
        if r["vocabulary_id"] not in vocab_with_primary:
            r["priority"] = "primary"
            vocab_with_primary.add(r["vocabulary_id"])

    # Assign sequential IDs
    for i, r in enumerate(rows, start=1):
        r["id"] = i

    df = pd.DataFrame(rows)
    if not df.empty:
        df["id"] = df["id"].astype("int64")
        df["vocabulary_id"] = df["vocabulary_id"].astype("int64")
        df = df[["id", "vocabulary_id", "reading", "reading_type", "priority"]]

    log.info("Step 3: %d reading rows", len(df))
    return df


# ---------------------------------------------------------------------------
# Step 4: Create I18n Rows
# ---------------------------------------------------------------------------


def _step4_i18n_rows(
    vocab_df: pd.DataFrame,
    jmdict_df: pd.DataFrame,
    warnings: list[dict],
    manual_localization: dict[tuple[str, str], str] | None = None,
) -> pd.DataFrame:
    """Step 4: Create i18n rows for target languages."""
    log.info("Step 4: Creating i18n rows")

    if vocab_df.empty:
        return pd.DataFrame(columns=["vocabulary_id", "lang_code", "meanings",
                                      "system_mnemonic", "search_tags"])

    # Build ent_seq → jmdict row lookup
    jmdict_lookup: dict[int, pd.Series] = {}
    for _, row in jmdict_df.iterrows():
        jmdict_lookup[int(row["ent_seq"])] = row

    rows: list[dict] = []

    for _, vrow in vocab_df.iterrows():
        vid = int(vrow["id"])
        word = vrow["word"]
        jm_row = jmdict_lookup.get(vid)
        if jm_row is None:
            continue

        k_ele = json.loads(jm_row["k_ele"]) if pd.notna(jm_row["k_ele"]) else None
        senses = json.loads(jm_row["senses"])
        headword_keb = k_ele[0]["keb"] if k_ele else None

        for lang_code in sorted(TARGET_LANGS):
            jmdict_lang = JMDICT_LANG_MAP.get(lang_code)
            if not jmdict_lang:
                continue

            meanings: list[str] = []
            for sense in senses:
                # Respect stagk restrictions
                stagk = sense.get("stagk") or []
                if stagk and headword_keb and headword_keb not in stagk:
                    continue

                glosses = sense.get("gloss") or []
                for g in glosses:
                    if g.get("lang") == jmdict_lang and g.get("text"):
                        meanings.append(g["text"])

            if not meanings and manual_localization:
                manual_entry = manual_localization.get((word, lang_code))
                if manual_entry:
                    meanings = json.loads(manual_entry)

            if not meanings:
                continue

            rows.append({
                "vocabulary_id": vid,
                "lang_code": lang_code,
                "meanings": json.dumps(meanings, ensure_ascii=False),
                "system_mnemonic": "",
                "search_tags": "[]",
            })

        # Validate: must have English
        vid_rows = [r for r in rows if r["vocabulary_id"] == vid]
        vid_langs = {r["lang_code"] for r in vid_rows}
        jlpt_level = vrow.get("min_jlpt_level")
        is_jlpt = pd.notna(jlpt_level)

        if "en" not in vid_langs:
            warnings.append({
                "severity": "high",
                "phase": "2.5",
                "entity": word,
                "message": "Missing English (en) glosses",
            })

        # Warn about missing non-English translations for JLPT words
        if is_jlpt:
            for lc in sorted(TARGET_LANGS):
                if lc != "en" and lc not in vid_langs:
                    warnings.append({
                        "severity": "high",
                        "phase": "2.5",
                        "entity": word,
                        "message": f"JLPT word missing {lc} translation",
                    })

    df = pd.DataFrame(rows)
    if not df.empty:
        df["vocabulary_id"] = df["vocabulary_id"].astype("int64")

    log.info("Step 4: %d i18n rows", len(df))
    return df


# ---------------------------------------------------------------------------
# Step 5: Create Verified Sentences
# ---------------------------------------------------------------------------


def _step5_sentences(
    vocab_df: pd.DataFrame,
    examples_df: pd.DataFrame,
) -> tuple[pd.DataFrame, pd.DataFrame]:
    """Step 5: Create sentence rows from Tanaka Corpus examples.

    One sentence per vocabulary word (shortest meaningful sentence).
    """
    log.info("Step 5: Creating sentence rows")

    sent_cols = ["id", "vocabulary_id", "original_text"]
    sent_i18n_cols = ["vocabulary_sentence_id", "lang_code", "sentence_translated"]

    if vocab_df.empty or examples_df.empty:
        return (
            pd.DataFrame(columns=sent_cols),
            pd.DataFrame(columns=sent_i18n_cols),
        )

    vocab_ids = set(vocab_df["id"])

    # Group examples by ent_seq, pick shortest
    best: dict[int, tuple[str, str]] = {}
    for _, erow in examples_df.iterrows():
        ent_seq = int(erow["ent_seq"])
        if ent_seq not in vocab_ids:
            continue
        ja = erow["sentence_ja"]
        en = erow["sentence_en"]
        if not ja or not en:
            continue
        existing = best.get(ent_seq)
        if existing is None or len(ja) < len(existing[0]):
            best[ent_seq] = (ja, en)

    sent_rows: list[dict] = []
    sent_i18n_rows: list[dict] = []

    for ent_seq in sorted(best.keys()):
        ja, en = best[ent_seq]
        sent_id = len(sent_rows) + 1
        sent_rows.append({
            "id": sent_id,
            "vocabulary_id": ent_seq,
            "original_text": ja,
        })
        sent_i18n_rows.append({
            "vocabulary_sentence_id": sent_id,
            "lang_code": "en",
            "sentence_translated": en,
        })

    sent_df = pd.DataFrame(sent_rows)
    sent_i18n_df = pd.DataFrame(sent_i18n_rows)

    if not sent_df.empty:
        sent_df["id"] = sent_df["id"].astype("int64")
        sent_df["vocabulary_id"] = sent_df["vocabulary_id"].astype("int64")
        sent_df = sent_df[sent_cols]

    if not sent_i18n_df.empty:
        col = "vocabulary_sentence_id"
        sent_i18n_df[col] = sent_i18n_df[col].astype("int64")
        sent_i18n_df = sent_i18n_df[sent_i18n_cols]

    log.info("Step 5: %d sentences", len(sent_df))
    return sent_df, sent_i18n_df


# ---------------------------------------------------------------------------
# Step 6: Link Kanji
# ---------------------------------------------------------------------------


def _step6_kanji_links(
    vocab_df: pd.DataFrame,
    kanji_df: pd.DataFrame,
    warnings: list[dict],
) -> pd.DataFrame:
    """Step 6: Create vocabulary_kanji links."""
    log.info("Step 6: Creating kanji links")

    if vocab_df.empty:
        return pd.DataFrame(columns=["vocabulary_id", "kanji_id", "position"])

    # Build character → kanji_id lookup
    char_to_id: dict[str, int] = {}
    for _, krow in kanji_df.iterrows():
        char_to_id[krow["character"]] = int(krow["id"])

    rows: list[dict] = []

    for _, vrow in vocab_df.iterrows():
        vid = int(vrow["id"])
        word = vrow["word"]
        jlpt_level = vrow.get("min_jlpt_level")
        is_jlpt = pd.notna(jlpt_level)

        for pos, ch in enumerate(word):
            if not _is_kanji_char(ch):
                continue
            kanji_id = char_to_id.get(ch)
            if kanji_id is not None:
                rows.append({
                    "vocabulary_id": vid,
                    "kanji_id": kanji_id,
                    "position": pos,
                })
            else:
                severity = "high" if is_jlpt else "low"
                warnings.append({
                    "severity": severity,
                    "phase": "2.5",
                    "entity": f"{word}:{ch}",
                    "message": f"Orphan kanji '{ch}' in word '{word}' not found in kanji.csv",
                })

    df = pd.DataFrame(rows)
    if not df.empty:
        df["vocabulary_id"] = df["vocabulary_id"].astype("int64")
        df["kanji_id"] = df["kanji_id"].astype("int64")
        df["position"] = df["position"].astype("int64")
        df = df[["vocabulary_id", "kanji_id", "position"]]

    log.info("Step 6: %d kanji links", len(df))
    return df


# ---------------------------------------------------------------------------
# Public entry point
# ---------------------------------------------------------------------------


def extract_vocabulary(
    parquet_dir: Path,
    csv_dir: Path,
    warnings_dir: Path,
    manual_furigana_path: Path = MANUAL_FURIGANA,
    manual_localization_path: Path = MANUAL_LOCALIZATION,
) -> dict[str, pd.DataFrame]:
    """Main entry point: run Steps 1-6, write CSVs.

    Returns dict of output DataFrames for inspection/testing.
    """
    log.info("Phase 2.5: Vocabulary extraction starting")

    # Load manual overrides
    manual_furigana = load_manual_furigana(manual_furigana_path)
    manual_localization = load_manual_localization(manual_localization_path)

    # Load Parquet files
    jmdict_df = pd.read_parquet(parquet_dir / "jmdict.parquet")
    jlpt_vocab_df = pd.read_parquet(parquet_dir / "jlpt_vocab.parquet")
    furigana_df = pd.read_parquet(parquet_dir / "jmdict_furigana.parquet")

    examples_path = parquet_dir / "jmdict_examples.parquet"
    if examples_path.exists():
        examples_df = pd.read_parquet(examples_path)
    else:
        examples_df = pd.DataFrame(columns=["ent_seq", "source_id", "word_form",
                                              "sentence_ja", "sentence_en"])
        log.warning("jmdict_examples.parquet not found, skipping sentences")

    # Load kanji.csv (output from Phase 2.2)
    kanji_csv_path = csv_dir / "kanji.csv"
    if kanji_csv_path.exists() and kanji_csv_path.stat().st_size > 0:
        kanji_df = pd.read_csv(kanji_csv_path)
    else:
        kanji_df = pd.DataFrame(columns=["id", "character", "min_jlpt_level"])
        log.warning("kanji.csv not found, kanji links will be empty")

    log.info(
        "Loaded: %d JMdict, %d JLPT vocab, %d furigana, %d examples, %d kanji",
        len(jmdict_df), len(jlpt_vocab_df), len(furigana_df),
        len(examples_df), len(kanji_df),
    )

    warnings: list[dict] = []

    # Step 1+2: Vocabulary rows with furigana
    vocab_df = _step1_vocabulary_rows(
        jmdict_df, jlpt_vocab_df, kanji_df, furigana_df, warnings,
        manual_furigana=manual_furigana,
    )

    # Step 3: Reading rows
    readings_df = _step3_reading_rows(vocab_df, jmdict_df)

    # Validate: every word must have at least one reading
    if not vocab_df.empty and not readings_df.empty:
        vocab_with_readings = set(readings_df["vocabulary_id"])
        for _, vrow in vocab_df.iterrows():
            vid = int(vrow["id"])
            if vid not in vocab_with_readings:
                warnings.append({
                    "severity": "high",
                    "phase": "2.5",
                    "entity": vrow["word"],
                    "message": "Word with no readings after Step 3",
                })

    # Step 4: I18n rows
    i18n_df = _step4_i18n_rows(vocab_df, jmdict_df, warnings, manual_localization)

    # Step 5: Sentences
    sentences_df, sentence_i18n_df = _step5_sentences(vocab_df, examples_df)

    # Step 6: Kanji links
    kanji_links_df = _step6_kanji_links(vocab_df, kanji_df, warnings)

    # Write outputs
    csv_dir.mkdir(parents=True, exist_ok=True)
    write_csv_atomic(vocab_df, csv_dir / "vocabulary.csv")
    write_csv_atomic(readings_df, csv_dir / "vocabulary_readings.csv")
    write_csv_atomic(i18n_df, csv_dir / "vocabulary_i18n.csv")
    write_csv_atomic(kanji_links_df, csv_dir / "vocabulary_kanji.csv")
    write_csv_atomic(sentences_df, csv_dir / "vocabulary_sentences.csv")
    write_csv_atomic(sentence_i18n_df, csv_dir / "vocabulary_sentence_i18n.csv")

    # Write warnings
    if warnings:
        warnings_dir.mkdir(parents=True, exist_ok=True)
        warnings.sort(key=lambda w: (w["severity"], w.get("entity", ""), w["message"]))
        warnings_df = pd.DataFrame(warnings)
        write_csv_atomic(warnings_df, warnings_dir / "ph2_5_warnings.csv")
        log.info("Phase 2.5: %d warnings written", len(warnings))
    else:
        log.info("Phase 2.5: no warnings")

    log.info(
        "Phase 2.5 complete: %d vocabulary, %d readings, %d i18n, "
        "%d kanji links, %d sentences",
        len(vocab_df), len(readings_df), len(i18n_df),
        len(kanji_links_df), len(sentences_df),
    )

    return {
        "vocabulary": vocab_df,
        "vocabulary_readings": readings_df,
        "vocabulary_i18n": i18n_df,
        "vocabulary_kanji": kanji_links_df,
        "vocabulary_sentences": sentences_df,
        "vocabulary_sentence_i18n": sentence_i18n_df,
    }
