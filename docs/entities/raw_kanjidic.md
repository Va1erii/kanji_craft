# Raw KANJIDIC

## Overview

Raw staging table for data imported from [KANJIDIC2](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project) — the comprehensive kanji dictionary maintained by the Electronic Dictionary Research and Development Group. Each row stores the complete KANJIDIC2 representation of a single character as structured JSONB, preserving the original XML data exactly as parsed.

This is an **admin-only table** — not used by the client app. This table lives in the **Supabase Staging Database** (Postgres) as the source of truth. The Admin Tool (Flutter/Drift) fetches this data into a local Drift database for processing/transformation before writing to the production tables. Access is restricted to the `service_role` key (which bypasses RLS).

## Entities

### RawKanjidic (Entity)

One row per character entry in KANJIDIC2. Scalar fields for commonly queried data; JSONB columns for nested/variable structures.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `import_id` | `int` | FK to `data_imports`. Part of composite unique constraint with `literal`. Each re-import creates new rows under a new `import_id`, preserving old rows for diffing and rollback. Source version is derived via join to `data_imports.source_version` |
| `literal` | `String` | The character, e.g. "日" |
| `stroke_count` | `int` | Primary stroke count |
| `stroke_count_misstrokes` | `JsonList?` | Alternative stroke counts from common miscounts, e.g. `[5, 7]`. Null if none |
| `grade` | `int?` | School grade: 1–6 (kyouiku), 8 (remaining jouyou), 9 (jinmeiyou), 10 (variant of jouyou). Null for ungraded characters |
| `jlpt` | `int?` | Old JLPT level 1–4. Null for characters outside the pre-2010 JLPT set |
| `frequency` | `int?` | Newspaper frequency rank (1 = most common). Null for rare characters |
| `codepoints` | `JsonObject` | Character encoding code points (see Codepoints Shape below) |
| `radicals` | `JsonObject` | Radical classification numbers (see Radicals Shape below) |
| `dict_refs` | `JsonObject?` | Dictionary reference indexes (see Dict Refs Shape below). Null if no references |
| `query_codes` | `JsonObject?` | Lookup codes for handwriting/radical queries (see Query Codes Shape below). Null if none |
| `readings` | `JsonObject` | Pronunciation data grouped by reading system (see Readings Shape below) |
| `nanori` | `JsonList?` | Name readings (nanori) as a flat string array, e.g. `["あき", "あさ"]`. Null if none |
| `meanings` | `JsonObject` | Meanings grouped by language (see Meanings Shape below) |
| `variants` | `JsonList?` | Character variants (see Variants Shape below). Null if none |
| `radical_names` | `JsonList?` | Radical names — only present for characters that are themselves radicals, e.g. `["みず"]`. Null for non-radical characters |

**Why `jlpt` is 1–4, not 1–5?**

KANJIDIC2 uses the **pre-2010 JLPT scale** (levels 1–4). The current JLPT (2010+) uses levels 1–5, where old level 4 was split into N4 and N5. This table stores the raw source value as-is. The content pipeline maps old levels to current N1–N5 when populating the `kanji` table.

**Why JSONB for readings, meanings, dict_refs, etc.?**

These fields are variable-width and structurally diverse: a character may have 0–10+ readings per type, meanings in 1–8 languages, and references to 20+ dictionaries. JSONB preserves the complete source structure without N+1 join tables at the staging layer.

**Why a raw staging table instead of importing directly into content tables?**

Same rationale as `raw_kanjivg`: decoupled import and transformation, full source data preserved for debugging and schema evolution, independent testability of each pipeline stage.

### Codepoints Shape

Encoding code points for the character across standards.

```json
{
  "ucs": "65e5",
  "jis208": "38-92",
  "jis212": null,
  "jis213": "1-38-92"
}
```

| Key | Type | Description |
|---|---|---|
| `ucs` | `String` | Unicode code point in hex (always present) |
| `jis208` | `String?` | JIS X 0208 code (ku-ten format) |
| `jis212` | `String?` | JIS X 0212 code (ku-ten format) |
| `jis213` | `String?` | JIS X 0213 code (plane-ku-ten format) |

### Radicals Shape

Radical classification numbers for the character.

```json
{
  "classical": 72,
  "nelson_c": 72
}
```

| Key | Type | Description |
|---|---|---|
| `classical` | `int` | Kangxi radical number (1–214) |
| `nelson_c` | `int?` | Nelson radical number, if different from classical |

### Dict Refs Shape

Dictionary and reference book indexes. All values are strings except `moro` which is an object.

```json
{
  "nelson_c": "2097",
  "nelson_n": "2410",
  "halpern_njecd": "3027",
  "halpern_kkd": "2185",
  "halpern_kkld": "1516",
  "halpern_kkld_2ed": "2050",
  "heisig": "12",
  "heisig6": "12",
  "gakken": "1",
  "oneill_names": "365",
  "oneill_kk": "28",
  "moro": { "volume": "7", "page": "0001" },
  "henshall": "62",
  "sh_kk": "554",
  "sh_kk2": "568",
  "jf_cards": "36",
  "tutt_cards": "32",
  "kanji_in_context": "15",
  "kodansha_compact": "843",
  "skip": "4-4-1",
  "busy_people": "1.A"
}
```

| Key | Type | Description |
|---|---|---|
| `nelson_c` | `String?` | Classic Nelson index |
| `nelson_n` | `String?` | New Nelson index |
| `halpern_njecd` | `String?` | New Japanese-English Character Dictionary |
| `halpern_kkd` | `String?` | Kanji & Kana Dictionary (Halpern) |
| `halpern_kkld` | `String?` | Kanji Learners Dictionary (1st ed.) |
| `halpern_kkld_2ed` | `String?` | Kanji Learners Dictionary (2nd ed.) |
| `heisig` | `String?` | Remembering the Kanji (original) |
| `heisig6` | `String?` | Remembering the Kanji (6th ed.) |
| `gakken` | `String?` | Gakken Kanji Dictionary |
| `oneill_names` | `String?` | Japanese Names (O'Neill) |
| `oneill_kk` | `String?` | Essential Kanji (O'Neill) |
| `moro` | `JsonObject?` | Morohashi Daikanwajiten — object `{volume, page}`, not a flat string |
| `henshall` | `String?` | A Guide to Remembering Japanese Characters |
| `sh_kk` | `String?` | Kanji & Kana (Spahn & Hadamitzky, 2011) |
| `sh_kk2` | `String?` | Kanji & Kana (2nd ed.) |
| `jf_cards` | `String?` | Japanese Kanji Flashcards (White Rabbit) |
| `tutt_cards` | `String?` | Tuttle Kanji Cards |
| `kanji_in_context` | `String?` | Kanji in Context |
| `kodansha_compact` | `String?` | Kodansha Compact Kanji Guide |
| `skip` | `String?` | SKIP code (also in query_codes) |
| `busy_people` | `String?` | Japanese for Busy People |

**Why is `moro` an object?**

Morohashi references include both volume and page, unlike other dictionaries which use a single index string. The source XML encodes these as separate attributes, so the JSONB preserves that structure.

### Query Codes Shape

Codes used for character lookup by structural features.

```json
{
  "skip": "4-4-1",
  "four_corner": "6010.0",
  "sh_desc": "2a2.4",
  "deroo": "1463",
  "misclass": [
    { "type": "skip_position", "value": "2-2-2" },
    { "type": "skip_stroke_count", "value": "2-1-3" }
  ]
}
```

| Key | Type | Description |
|---|---|---|
| `skip` | `String?` | SKIP code (System of Kanji Indexing by Patterns) |
| `four_corner` | `String?` | Four Corner code |
| `sh_desc` | `String?` | Spahn & Hadamitzky descriptor |
| `deroo` | `String?` | De Roo code |
| `misclass` | `JsonList?` | Common misclassifications: `[{type, value}]` |

### Readings Shape

Pronunciations grouped by reading system.

```json
{
  "ja_on": ["ニチ", "ジツ"],
  "ja_kun": ["ひ", "-び", "-か"],
  "pinyin": ["ri4"],
  "korean_r": ["il"],
  "korean_h": ["일"]
}
```

| Key | Type | Description |
|---|---|---|
| `ja_on` | `JsonList` | On'yomi (Sino-Japanese) readings in katakana |
| `ja_kun` | `JsonList` | Kun'yomi (native) readings in hiragana. Prefix `-` indicates okurigana boundary |
| `pinyin` | `JsonList?` | Chinese pinyin reading(s) |
| `korean_r` | `JsonList?` | Korean romanized reading(s) |
| `korean_h` | `JsonList?` | Korean hangul reading(s) |

### Meanings Shape

Meanings grouped by ISO 639-1 language code.

```json
{
  "en": ["day", "sun", "Japan", "counter for days"],
  "fr": ["jour", "soleil", "Japon"],
  "es": ["día", "sol", "Japón"],
  "pt": ["dia", "sol"]
}
```

| Key | Type | Description |
|---|---|---|
| `en` | `JsonList` | English meanings (always present in KANJIDIC2) |
| `fr` | `JsonList?` | French meanings |
| `es` | `JsonList?` | Spanish meanings |
| `pt` | `JsonList?` | Portuguese meanings |

Additional language keys may appear as KANJIDIC2 adds languages. The schema does not restrict which keys are present.

### Variants Shape

Character variants from different classification systems.

```json
[
  { "var_type": "jis208", "value": "38-92" },
  { "var_type": "ucs", "value": "FA6A" }
]
```

| Key | Type | Description |
|---|---|---|
| `var_type` | `String` | Variant classification system (e.g. "jis208", "jis212", "jis213", "ucs", "deroo", "njecd", "s_h", "nelson_c", "oneill") |
| `value` | `String` | The variant reference value in that system |

## Relationships

```
RawKanjidic ··pipeline··→ kanji              (character, stroke_count, grade, frequency)
RawKanjidic ··pipeline··→ kanji_readings     (ja_on, ja_kun → onyomi/kunyomi rows)
RawKanjidic ··pipeline··→ kanji_i18n         (meanings by language → localized meaning rows)
```

These are **pipeline-level data flows**, not foreign keys. The content pipeline reads from `raw_kanjidic` and writes to the downstream tables. There are no FK constraints between them.

## Business Rules

1. `literal` must be a single Unicode code point.
2. **Composite unique constraint:** `import_id` + `literal` must be unique. Re-imports create new rows with a new `import_id`, leaving old rows for diffing and rollback.
3. `stroke_count` must be a positive integer.
4. `readings` must contain at least `ja_on` or `ja_kun` (a character always has at least one Japanese reading).
5. `meanings.en` must be a non-empty array (KANJIDIC2 always includes English meanings).
6. `codepoints.ucs` must be present and non-null.
7. `radicals.classical` must be present and in the range 1–214.
8. **RLS:** RLS is enabled with zero policies for `authenticated` or `anon` roles. Only `service_role` (which bypasses RLS) can read or write this table.
9. `grade`, when present, must be one of: 1, 2, 3, 4, 5, 6, 8, 9, 10.
10. `jlpt`, when present, must be in the range 1–4 (pre-2010 scale).

## Edge Cases

- **Character with no grade:** Many characters in KANJIDIC2 are outside the jouyou/jinmeiyou sets. `grade` is null — the pipeline must handle this when deciding whether to import into the `kanji` table.
- **Character with no JLPT level:** KANJIDIC2's JLPT field covers the old 4-level system only. Characters added to JLPT N5 after the 2010 restructuring may have `jlpt: null`. The pipeline uses a separate JLPT N1–N5 mapping table for current level assignment.
- **Character with no frequency:** Rare characters have no newspaper frequency rank. `frequency` is null — the pipeline assigns a synthetic rank or excludes them from lesson ordering.
- **Readings with okurigana markers:** Kun'yomi readings use `-` to mark okurigana boundaries (e.g. "やす-む" for 休む). The raw value preserves this marker; the pipeline strips it when populating `kanji_readings`.
- **Moro dict_ref as object:** Unlike all other dictionary references (flat strings), `moro` is `{volume, page}`. The pipeline must handle this structural difference when extracting dict_refs.
- **Multiple misclass entries:** A single character can have several common misclassifications in `query_codes.misclass`. All are preserved as an array.
- **Empty optional JSONB fields:** `dict_refs`, `query_codes`, `variants`, `nanori`, `radical_names`, and `stroke_count_misstrokes` can all be null. The pipeline must not assume their presence.
- **Re-import with fewer characters:** If a new KANJIDIC2 release drops a character, the old row remains under the previous `import_id`. The new import simply won't have a row for that character. Orphan detection (comparing import versions) is a separate pipeline step.
- **Language coverage varies:** Not all characters have meanings in all languages. English is always present; French, Spanish, and Portuguese coverage is partial. The pipeline falls back to English for `kanji_i18n` rows in unsupported languages.
