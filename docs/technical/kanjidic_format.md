# KANJIDIC Format Reference

## Overview

The [KANJIDIC Project](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project) is maintained by the Electronic Dictionary Research and Development Group (EDRDG). It provides comprehensive information about kanji characters in three distribution files:

| File | Encoding | Characters | Description |
|---|---|---|---|
| **KANJIDIC2** | XML (UTF-8) | 13,108 | All characters from all three JIS standards. This is the file our parser consumes |
| KANJIDIC | EUC-JP flat-text | 6,355 | Characters in JIS X 0208 only |
| KANJD212 | EUC-JP flat-text | 5,801 | Characters in JIS X 0212 only |

Character coverage by JIS standard:

| Standard | Count | Description |
|---|---|---|
| JIS X 0208 | 6,355 | Core set — covers jouyou, jinmeiyou, and common kanji |
| JIS X 0212 | 5,801 | Supplementary set — rare kanji, variant forms |
| JIS X 0213 | 952 (additional) | Extended set — adds characters not in 0208 or 0212 |

This document is a reference for the KANJIDIC format as consumed by our ingestion parser ([kanjidic_parser.dart](../../apps/admin/lib/data/services/kanjidic_parser.dart)) and stored in the [raw_kanjidic](../entities/raw_kanjidic.md) staging table.

**Source file:** `kanjidic2.xml.gz` (gzip-compressed XML, ~3.5 MB compressed, ~12 MB uncompressed).

## KANJIDIC2 XML Structure

The XML has a flat structure — one `<character>` element per kanji inside a `<kanjidic2>` root:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE kanjidic2 [...]>
<kanjidic2>
  <header>
    <file_version>4</file_version>
    <database_version>2024-060</database_version>
    <date_of_creation>2024-02-29</date_of_creation>
  </header>
  <character>...</character>
  <character>...</character>
  <!-- ~13,108 character entries -->
</kanjidic2>
```

Our parser ignores the `<header>` and processes all `<character>` elements.

### Character Entry

```xml
<character>
  <literal>日</literal>
  <codepoint>
    <cp_value cp_type="ucs">65e5</cp_value>
    <cp_value cp_type="jis208">38-92</cp_value>
  </codepoint>
  <radical>
    <rad_value rad_type="classical">72</rad_value>
    <rad_value rad_type="nelson_c">72</rad_value>
  </radical>
  <misc>
    <grade>1</grade>
    <stroke_count>4</stroke_count>
    <variant var_type="jis208">...</variant>
    <freq>1</freq>
    <jlpt>4</jlpt>
  </misc>
  <dic_number>
    <dic_ref dr_type="nelson_c">2097</dic_ref>
    <dic_ref dr_type="heisig">12</dic_ref>
    <dic_ref dr_type="moro" m_vol="7" m_page="0001">14311</dic_ref>
    ...
  </dic_number>
  <query_code>
    <q_code qc_type="skip">4-4-1</q_code>
    <q_code qc_type="four_corner">6010.0</q_code>
    ...
  </query_code>
  <reading_meaning>
    <rmgroup>
      <reading r_type="ja_on">ニチ</reading>
      <reading r_type="ja_on">ジツ</reading>
      <reading r_type="ja_kun">ひ</reading>
      <reading r_type="ja_kun">-び</reading>
      <reading r_type="pinyin">ri4</reading>
      <meaning>day</meaning>
      <meaning>sun</meaning>
      <meaning m_lang="es">día</meaning>
    </rmgroup>
    <nanori>あき</nanori>
    <nanori>あさ</nanori>
  </reading_meaning>
</character>
```

## Information Fields

This section mirrors the official KANJIDIC project field reference. For each field, the flat-text KANJIDIC code (where applicable) and the KANJIDIC2 XML path are listed, along with our parser's handling.

### Character Literal

The kanji character itself.

| Format | Location |
|---|---|
| Flat-text | First field of the entry |
| XML | `<literal>` |

Our parser → `raw_kanjidic.literal`

### Character Code Points

Encoding code points for the character across standards.

| `cp_type` | Flat-text Code | Description | Example |
|---|---|---|---|
| `ucs` | `U` | Unicode code point in hex (always present) | `65e5` |
| `jis208` | (hex after kanji) | JIS X 0208 kuten code | `38-92` |
| `jis212` | — | JIS X 0212 kuten code | `73-12` |
| `jis213` | — | JIS X 0213 plane-kuten code | `1-38-92` |

XML: `<codepoint>/<cp_value cp_type="...">`. Our parser → `raw_kanjidic.codepoints` as `{ucs, jis208?, jis212?, jis213?}`.

### Radical Classification

The radical (bushu) under which the character is traditionally classified.

| `rad_type` | Flat-text Code | Description | Range |
|---|---|---|---|
| `classical` | `B` | Kangxi radical number, as used in the JIS Kanji Jiten (日本規格協会). Always present | 1–214 |
| `nelson_c` | `C` | The radical used in the Classic Nelson dictionary, when it differs from classical | 1–214 |

XML: `<radical>/<rad_value rad_type="...">`. Our parser → `raw_kanjidic.radicals` as `{classical, nelson_c?}`.

Where Nelson uses a different radical from the JIS Kanji Jiten, both are provided. The classical radical is the standard reference.

### Grade Level

The grade level at which the kanji is taught in Japanese schools.

| Value | Flat-text Code | Meaning | Count |
|---|---|---|---|
| 1–6 | `G1`–`G6` | Kyouiku (education) kanji — taught in elementary school at the specified grade | 1,026 total |
| 8 | `G8` | Remaining jouyou kanji — taught in secondary school (junior high). Note: 1,106 are in KANJIDIC, 2 in KANJD212, 2 only in KANJIDIC2 | 1,110 |
| 9 | `G9` | Jinmeiyou ("for use in names") kanji — approved for family name registers and official documents | 649 |
| 10 | `G10` | Jinmeiyou kanji that are variants of jouyou kanji | 212 |

XML: `<misc>/<grade>` — stores the plain integer (no "G" prefix). Null for ungraded characters. Grade 7 is not used.

Our parser → `raw_kanjidic.grade`. Our pipeline imports grades 1–6 and 8 into `kanji.min_grade`. Grades 9–10 (name kanji) are stored in `raw_kanjidic` but may be excluded from the learnable kanji set depending on content scope.

### Stroke Count

The stroke count of the kanji.

| Position | Flat-text Code | Description |
|---|---|---|
| First `<stroke_count>` | `S` | The accepted stroke count |
| Additional `<stroke_count>` | — | Common miscounts, listed when references disagree |

XML: `<misc>/<stroke_count>` (multiple elements allowed). The first value is the accepted count; additional values represent common miscounts from reference disagreements.

Our parser → `raw_kanjidic.stroke_count` (first value) + `raw_kanjidic.stroke_count_misstrokes` (remaining values, null if none).

See [Radical and Stroke Counting Rules](#radical-and-stroke-counting-rules) for specific counting disputes.

### Frequency

A ranking of the 2,501 most-used kanji based on a survey of newspapers by the National Language Research Institute, using data from the Mainichi Shimbun. A ranking of 1 indicates the most frequently used kanji.

| Flat-text Code | XML Path | Range |
|---|---|---|
| `F` | `<misc>/<freq>` | 1–2501 |

Null for characters outside the top 2,501.

Our parser → `raw_kanjidic.frequency`.

### JLPT Level

The pre-2010 Japanese Language Proficiency Test level for the kanji.

| Flat-text Code | XML Path | Range |
|---|---|---|
| `J` | `<misc>/<jlpt>` | 1–4 |

KANJIDIC2 uses the **pre-2010 JLPT scale** (4 levels). The current JLPT (2010+) uses 5 levels:

| Old Level | New Level(s) | Notes |
|---|---|---|
| 4 | N5, N4 | Old level 4 was split into N4 and N5 |
| 3 | N4, N3 | Old level 3 maps roughly to N4 |
| 2 | N3, N2 | Old level 2 was split between N2 and N3 |
| 1 | N1 | Old level 1 maps to N1 |

**No official kanji lists exist for the new N1–N5 levels.** Our pipeline stores the raw 1–4 value in `raw_kanjidic.jlpt` and uses a separate JLPT N1–N5 mapping table when populating `kanji.min_jlpt_level`. In our schema, N5 is stored as `5` and N1 as `1`.

### Variant Cross-References

Code points of related or variant kanji.

| `var_type` | Flat-text Code | Description |
|---|---|---|
| `jis208` | — | JIS X 0208 variant |
| `jis212` | — | JIS X 0212 variant |
| `jis213` | — | JIS X 0213 variant |
| `ucs` | — | Unicode variant |
| `deroo` | `DR` | De Roo index variant |
| `njecd` | `X` (partial) | NJECD (Halpern) cross-reference |
| `s_h` | — | Spahn & Hadamitzky index variant |
| `nelson_c` | — | Nelson index variant |
| `oneill` | — | O'Neill index variant |

XML: `<misc>/<variant var_type="...">`. Our parser → `raw_kanjidic.variants` as `[{var_type, value}]`, null if none.

In the flat-text KANJIDIC, the `X` field provides cross-references as JIS hex codes. KANJIDIC2 provides them in a richer typed format.

### Dictionary References

Indexes in published kanji dictionaries and reference books. All stored in XML under `<dic_number>/<dic_ref dr_type="...">`.

| `dr_type` | Flat-text Code | Dictionary | We Parse? |
|---|---|---|---|
| `nelson_c` | `N` | "Modern Reader's Japanese-English Character Dictionary" (Classic Nelson, 1962) — Andrew Nelson. 5,446 main entries, cross-refs to ~3,000 more | Yes |
| `nelson_n` | `V` | "The New Nelson Japanese-English Character Dictionary" (New Nelson, 1997) — John Haig, based on Andrew Nelson | Yes |
| `halpern_njecd` | `H` | "New Japanese-English Character Dictionary" (1990) — Jack Halpern | Yes |
| `halpern_kkd` | `DK` | "Kodansha Kanji Dictionary" (2013) — Jack Halpern | Yes |
| `halpern_kkld` | `DL` | "Kanji Learners Dictionary" (1999, 1st ed.) — Jack Halpern | Yes |
| `halpern_kkld_2ed` | — | "Kanji Learners Dictionary" (2013, 2nd ed.) — Jack Halpern | Yes |
| `heisig` | `L` | "Remembering The Kanji" — James Heisig | Yes |
| `heisig6` | — | "Remembering The Kanji" (6th ed.) — James Heisig | Yes |
| `gakken` | `K` | "A New Dictionary of Kanji Usage" — Gakken | Yes |
| `oneill_names` | `O` | "Japanese Names" — P.G. O'Neill | Yes |
| `oneill_kk` | `DO` | "Essential Kanji" — P.G. O'Neill | Yes |
| `moro` | `M` | "Daikanwajiten" — Morohashi. Uses `m_vol` + `m_page` attributes (see below) | Yes |
| `henshall` | `E` | "A Guide To Remembering Japanese Characters" — Kenneth Henshall | Yes |
| `sh_kk` | `IN` | "Kanji & Kana" (2011 ed.) — Spahn & Hadamitzky | Yes |
| `sh_kk2` | — | "Kanji & Kana" (2nd ed.) — Spahn & Hadamitzky | Yes |
| `jf_cards` | `DF` | "Japanese Kanji Flashcards" — White Rabbit Press | Yes |
| `tutt_cards` | `DT` | "Tuttle Kanji Cards" — Alexander Kask | Yes |
| `kanji_in_context` | `DC` | "Kanji in Context" — Nishiguchi & Kono | Yes |
| `kodansha_compact` | `DJ` | "Kodansha Compact Kanji Guide" | Yes |
| `busy_people` | `DB` | "Japanese for Busy People" — AJALT. Volume.chapter format (e.g. `1.A`) | Yes |
| `sakade` | `DS` | "A Guide to Reading & Writing Japanese" (Florence Sakade) | No — skipped |
| `henshall3` | `DH` | "A Guide to Reading & Writing Japanese" (3rd ed., Henshall et al.) | No — skipped |
| `crowley` | `DG` | "The Kanji Way to Japanese Language Power" (Dale Crowley) | No — skipped |
| `maniette` | `DM` | "Les Kanjis dans la tête" (Yves Maniette, French Heisig) | No — skipped |

Our parser → `raw_kanjidic.dict_refs` as a JSONB object keyed by `dr_type`.

**Morohashi special case:** Unlike other dictionary references (flat string values), Morohashi uses separate attributes for volume and page number:

```xml
<dic_ref dr_type="moro" m_vol="7" m_page="0001">14311</dic_ref>
```

The element text is the index number (e.g. `14311`). A terminal `P` in the index number indicates a reference to the separate Morohashi supplement volume, while `X` indicates an index number that is an approximation or estimate. Our parser stores this as `{volume, page}` — only `m_vol` and `m_page` attributes are kept; the index number text is dropped.

### Readings

Pronunciation data for the character. XML: `<reading_meaning>/<rmgroup>/<reading r_type="...">`.

| `r_type` | Script | Description | We Parse? |
|---|---|---|---|
| `ja_on` | Katakana | On'yomi — Sino-Japanese readings (e.g. ニチ, ジツ) | Yes |
| `ja_kun` | Hiragana | Kun'yomi — native Japanese readings (e.g. ひ, -び) | Yes |
| `pinyin` | Latin | Chinese PinYin readings (e.g. ri4) | Yes |
| `korean_r` | Latin | Korean romanized readings (e.g. il) | Yes |
| `korean_h` | Hangul | Korean readings in hangul (e.g. 일) | Yes |
| `vietnam` | Latin | Vietnamese readings in modern quốc ngữ romanization | No — skipped |

**Kun'yomi notation:** A dot `.` separates the kanji reading from okurigana (e.g. `おこ.る` for 怒る — the kanji reads おこ and る is hiragana appended in writing). A leading `-` indicates a suffix/prefix (e.g. `-び`). Our raw table preserves these markers as-is; the pipeline strips them when populating `kanji_readings`.

**On'yomi notation:** Always in katakana. A leading `-` marks a bound form that does not occur independently.

Our parser → `raw_kanjidic.readings` as `{ja_on, ja_kun, pinyin?, korean_r?, korean_h?}`.

### Meanings

The English (and other language) meanings for the kanji. XML: `<reading_meaning>/<rmgroup>/<meaning>`.

Meanings without `m_lang` attribute default to English. Other languages use ISO 639-1 codes:

```xml
<meaning>day</meaning>           <!-- English (default) -->
<meaning m_lang="fr">jour</meaning>
<meaning m_lang="es">día</meaning>
<meaning m_lang="pt">dia</meaning>
```

Available languages in KANJIDIC2: `en` (always present), `fr`, `es`, `pt`. Coverage varies — English has meanings for all characters; other languages are partial.

Our parser → `raw_kanjidic.meanings` as `{en: [...], fr?: [...], es?: [...], pt?: [...]}`. **Our supported languages:** `en` and `es` (see [shared_types.md](../entities/shared_types.md)). All languages are preserved in raw; filtering to supported languages happens during transformation.

### Nanori

Japanese readings associated with names. XML: `<reading_meaning>/<nanori>`. These appear outside the `<rmgroup>` element, always in hiragana.

Our parser → `raw_kanjidic.nanori` as a flat string array. Null if none.

### Radical Names

For characters that are themselves radicals, the Japanese name(s) of the radical in hiragana. XML: `<reading_meaning>/<rad_name>`. These also appear outside `<rmgroup>`.

Our parser → `raw_kanjidic.radical_names` as a flat string array. Null for non-radical characters.

## Kanji Dictionary Search Codes

Query codes for character lookup by structural features. XML: `<query_code>/<q_code qc_type="...">`.

Our parser → `raw_kanjidic.query_codes` as `{skip?, four_corner?, sh_desc?, deroo?, misclass?}`.

### SKIP — System of Kanji Indexing by Patterns

| `qc_type` | Flat-text Code | Format |
|---|---|---|
| `skip` | `P` | `l-m-n` |

Developed by Jack Halpern. Each kanji is classified by a pattern type and stroke counts:

| Pattern (l) | Name | Description | Example |
|---|---|---|---|
| 1 | Left–Right | Character splits vertically into left and right parts. `m` = left strokes, `n` = right strokes | `1-2-4` (休) |
| 2 | Up–Down | Character splits horizontally into top and bottom. `m` = top strokes, `n` = bottom strokes | `2-4-4` (花) |
| 3 | Enclosure | One part encloses the other. `m` = outer strokes, `n` = inner strokes | `3-3-4` (国) |
| 4 | Solid | Character cannot be split. `m` = total strokes, `n` = sub-pattern | `4-4-1` (日) |

**SKIP Misclassifications:** When a `skip_misclass` attribute is present on a `<q_code>` element, it indicates a common misclassification rather than the primary SKIP code:

```xml
<q_code qc_type="skip">1-2-4</q_code>                          <!-- primary -->
<q_code qc_type="skip" skip_misclass="posn">2-2-4</q_code>     <!-- misclassification -->
```

| `skip_misclass` | Flat-text Code | Description |
|---|---|---|
| `posn` | `ZPP` | Misclassification by position of the dividing line |
| `stroke_count` | `ZSP` | Misclassification by stroke count |
| `stroke_and_posn` | `ZBP` | Misclassification by both position and stroke count |
| `stroke_diff` | `ZRP` | Ambiguity due to differing stroke counts |

Our parser stores misclassifications as `[{type, value}]` in `query_codes.misclass`.

### De Roo Codes

| `qc_type` | Flat-text Code | Format |
|---|---|---|
| `deroo` | `DR` | 4-digit numeric code |

Developed by Joseph De Roo for his book "2001 Kanji". The code is based on a two-level classification of shapes at the top and bottom of the kanji:

- **First two digits** — classification of the top part of the kanji
- **Last two digits** — classification of the bottom part of the kanji

Each two-digit pair encodes a shape category. For example, horizontal lines, vertical lines, enclosures, and various combinations each have assigned numeric codes.

### Four Corner Codes

| `qc_type` | Flat-text Code | Format |
|---|---|---|
| `four_corner` | `Q` | `nnnn.n` |

A system based on the shapes at the four corners of the kanji character:

- **Digit 1** — top-left corner shape
- **Digit 2** — top-right corner shape
- **Digit 3** — bottom-left corner shape
- **Digit 4** — bottom-right corner shape
- **Digit after `.`** — an additional "extra" stroke classification for disambiguation

Each corner shape is assigned a number (0–9) according to a set of rules about the stroke types present.

### Spahn & Hadamitzky Descriptor

| `qc_type` | Flat-text Code | Format |
|---|---|---|
| `sh_desc` | `I` | `nxnn.n` |

From "The Kanji Dictionary" by Spahn & Hadamitzky. The descriptor encodes the radical's stroke count, radical identifier letter, remaining stroke count, and sequence number. E.g. `3k11.2` = 3-stroke radical "k", 11 other strokes, 2nd in sequence.

## Radical and Stroke Counting Rules

Where there is disagreement between references on radical classification or stroke counts, KANJIDIC applies specific rules. Below are the principal cases.

### Radical B54 (廴 — ennyou)

The radical 廴 is historically counted as 3 strokes (traditional form had a small hook at the top). KANJIDIC counts it as **3 strokes** following the JIS standard, though some modern references count 2. This affects characters like 廷 and 建.

### Radical B58 (彐 — keigashira)

May appear as 彐 or ヨ. KANJIDIC counts it as **3 strokes** regardless of form. Nelson counts 3 for ヨ form but 4 for 彐 form.

### Radical B113 (示 — shimesu hen)

The simplified form (礻) has 4 strokes; the traditional form (示) has 5. KANJIDIC provides stroke counts according to the glyph form shown in the JIS standard:
- Characters using 礻 (e.g. 礼, 社) — 4 strokes for the radical
- Characters using 示 (e.g. 祀) — 5 strokes for the radical

### Radical B140 (艹 — kusakanmuri)

This radical appears in different forms: 3-stroke (modern, two vertical strokes + connecting horizontal), 4-stroke (older, four strokes). KANJIDIC always counts it as **3 strokes** following the JIS standard, regardless of historical form.

### Radical B162 (辶 — shinnyuu)

Appears with 1 or 2 waves. Stroke count varies by reference:
- 2 strokes (Nelson)
- 3 strokes (JIS standard, Halpern)
- 4 strokes (traditional references)

KANJIDIC follows the JIS standard form. Characters using the "1 wave" form get **3 strokes**; "2 wave" form gets **4 strokes** for the radical.

### Radicals B163 (邑/邦) and B170 (阜/阡)

The right-side radical 阝(おおざと, from 邑) and left-side radical 阝(こざと, from 阜) are both commonly written as 阝. Nelson counts them as **2 strokes**; Halpern counts **3 strokes**. KANJIDIC follows the JIS standard and counts **3 strokes** for both.

### Stroke Count Disputes — General

When the accepted stroke count differs between references, KANJIDIC lists the primary (JIS standard) count first, followed by alternative counts from other references. Our parser stores the first as `stroke_count` and the rest as `stroke_count_misstrokes`.

## Mapping to `raw_kanjidic`

| KANJIDIC2 XML Path | `raw_kanjidic` Column | Type |
|---|---|---|
| `literal` | `literal` | `String` |
| `misc/stroke_count` (first) | `stroke_count` | `int` |
| `misc/stroke_count` (rest) | `stroke_count_misstrokes` | `JsonList?` |
| `misc/grade` | `grade` | `int?` |
| `misc/jlpt` | `jlpt` | `int?` |
| `misc/freq` | `frequency` | `int?` |
| `codepoint/cp_value[cp_type]` | `codepoints` | `JsonObject` |
| `radical/rad_value[rad_type]` | `radicals` | `JsonObject` |
| `misc/variant[var_type]` | `variants` | `JsonList?` |
| `dic_number/dic_ref[dr_type]` | `dict_refs` | `JsonObject?` |
| `query_code/q_code[qc_type]` | `query_codes` | `JsonObject?` |
| `reading_meaning/rmgroup/reading[r_type]` | `readings` | `JsonObject` |
| `reading_meaning/nanori` | `nanori` | `JsonList?` |
| `reading_meaning/rmgroup/meaning[m_lang]` | `meanings` | `JsonObject` |
| `reading_meaning/rad_name` | `radical_names` | `JsonList?` |

## Fields We Skip

These KANJIDIC2 fields exist in the source but are not extracted by our parser:

| Field | Reason |
|---|---|
| `dic_ref dr_type="sakade"` | Niche dictionary, not useful for our learner audience |
| `dic_ref dr_type="henshall3"` | We already store `henshall` (original edition) |
| `dic_ref dr_type="crowley"` | Niche dictionary |
| `dic_ref dr_type="maniette"` | French adaptation of Heisig — we store `heisig` directly |
| `reading r_type="vietnam"` | Vietnamese not in our supported language set |
| `moro` index number (element text) | Only `m_vol`/`m_page` attributes are stored; the raw index is dropped |
| `<header>` | Database version metadata — not per-character data |

## Data Quality Notes

| Issue | Impact | Handling |
|---|---|---|
| JLPT levels are pre-2010 (1–4 scale) | Cannot directly use for current N1–N5 filtering | Pipeline maps to N1–N5 via external mapping table |
| `frequency` only covers top 2,501 characters | Rare kanji have no ranking | Pipeline assigns synthetic rank or excludes from lesson ordering |
| `grade` is null for non-jouyou/jinmeiyou kanji | Many characters are ungraded | Pipeline handles null — ungraded kanji excluded from grade-based study path |
| English meanings always present; other languages partial | Some kanji have no Spanish meanings | Pipeline falls back to English for `kanji_i18n` in unsupported languages |
| Morohashi index has `P`/`X` suffixes | Variant/approximate entries | Our parser drops the index text entirely, keeping only volume/page |
| Multiple `<stroke_count>` values | First is accepted; rest are miscounts | First → `stroke_count`, rest → `stroke_count_misstrokes` |
| Kun'yomi with `.` okurigana markers | Raw reading includes the marker | Pipeline strips `.` when populating `kanji_readings` |
| Kun'yomi/On'yomi with `-` prefixes | Indicates bound form/prefix/suffix | Pipeline strips `-` when populating `kanji_readings` |

## Related Docs

- [raw_kanjidic.md](../entities/raw_kanjidic.md) — Staging table schema (how parsed KANJIDIC2 data is stored)
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
- [ingestion.md](ingestion.md) — Phase 1 correctness invariants
- [radical_extraction.md](radical_extraction.md) — How KANJIDIC data feeds into radical metadata derivation (Pass 4)
- [KANJIDIC2 DTD](http://www.edrdg.org/kanjidic/kanjidic2_dtdh.html) — Upstream DTD with field annotations
- [KANJIDIC Project](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project) — Official project page
