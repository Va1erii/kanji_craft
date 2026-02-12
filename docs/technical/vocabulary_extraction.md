# Vocabulary Extraction

## Overview

Vocabulary extraction transforms `raw_jmdict` staging data into learnable vocabulary rows and their child tables: `vocabulary`, `vocabulary_readings`, `vocabulary_i18n`, `vocabulary_kanji`, `vocabulary_sentences`, and `vocabulary_sentence_i18n`. The result is a structured educational dataset where every word carries its readings, localized meanings, kanji composition links, example sentences, and a segment breakdown for Ghost Kanji rendering — everything the SRS engine needs to schedule lessons and the client needs to render cards.

This phase sits after Kanji Composition (Phase 2.3) and Component Linking because vocabulary items are "gated" by the kanji they contain. The `kanji` table must be fully populated so that Step 4 can resolve `vocabulary_kanji.kanji_id` links and Step 1 can construct segments with valid `kanji_id` references.

**Key goal:** Create a "Lego-style" progression where words are unlocked only after their constituent kanji are stabilized. To solve pedagogical gaps (like the "Eki Problem"), this phase also integrates external JLPT level data that may disagree with kanji-derived levels.

**What this phase does NOT do:** AI translation of missing sentence pairs. That occurs in the subsequent AI Enrichment step (Phase 2.7). Bracket-notation furigana annotation of raw Japanese sentences also happens there.

## Source Data

| Source | Used in | Purpose |
|---|---|---|
| `raw_jmdict` | Steps 1, 2, 3 | Core dictionary entries (words, readings, meanings, POS codes) |
| `raw_jmdict.examples` | Step 5 | Tanaka Corpus example sentences (verified English) |
| `kanji` table | Steps 1, 4 | Resolving `vocabulary_kanji` links and segment `kanji_id` |
| `source_vocab_levels` | Step 1 | Tanos JLPT vocabulary list (N5–N1) for `min_jlpt_level` |
| `jmdict_furigana` | Step 1 | Per-character furigana mappings for segment construction |

**Note on new sources:** `source_vocab_levels`, and `jmdict_furigana` are new ingestion sources not yet implemented in the codebase. `source_vocab_levels` follows the same pattern as `source_jlpt_levels` (curated CSV → local reference table, not tracked in `data_imports`). `jmdict_furigana` is tracked in `data_imports` because it is tightly coupled with JMdict and must be updated in lockstep. The schema changes and ingestion logic will be implemented separately; this doc describes the extraction algorithm that consumes them.

## Prerequisites

Both conditions must hold before this phase runs:

1. **Kanji Composition (Phase 2.3) complete** — `kanji`, `kanji_readings`, and `kanji_i18n` tables are populated. Vocabulary extraction relies on `kanji.id` to create links and resolve segment references.
2. **JLPT Vocab Mapping (Phase 1) loaded** — The `source_vocab_levels` table must be populated from the Tanos vocabulary CSV (see [ingestion.md](ingestion.md)).

## Algorithm

The extraction runs in five steps over the active `raw_jmdict` import. Each step is idempotent — re-running with the same data produces the same result.

### Step 1: Create Vocabulary Rows

For each `raw_jmdict` entry in the active import, determine if it qualifies for the app, then upsert a `vocabulary` row.

**Selection logic:**

Import the word if **either** condition is met:
- It has a priority flag (`news1`, `ichi1`, `spec1`, `gai1`, etc.) on any kanji element or reading element, **OR**
- It appears in `source_vocab_levels` (it is a required JLPT word).

This ensures both common words (frequency-based) and pedagogically important words (JLPT-based) are included, even if they lack priority flags.

**Field mapping:**

| `raw_jmdict` | `vocabulary` | Transformation |
|---|---|---|
| `ent_seq` | `id` | Use JMdict sequence ID directly (stable identifier; see §ID Strategy) |
| `kanji_elements[0].keb` | `word` | Use the first (most common) kanji headword. If null, use `reading_elements[0].reb` (kana-only word) |
| (Derived) | `segments` | Construct JSONB using `jmdict_furigana` logic (see §Segmentation) |
| (Derived) | `min_jlpt_level` | Primary: lookup in `source_vocab_levels`. Fallback: `MAX(kanji.min_jlpt_level)` across constituent kanji (see §JLPT Level Strategy) |
| (Derived) | `pos_tags` | Collect `pos` and `misc` from all senses, map to `PosTag` enum (see §POS Tag Extraction) |
| Priority flags | `frequency_rank` | Map priority flags to an integer rank (see below) |

**Frequency rank mapping:**

JMdict priority flags indicate frequency tier. Map them to a numeric rank:

1. Words with `news1` or `ichi1` (high frequency) get the lowest ranks.
2. Words with `news2`, `ichi2`, `spec1`, `spec2` get mid-range ranks.
3. Words with only `gai1`/`gai2` (loanword frequency) or `nfxx` (Netflix frequency) get higher ranks.
4. Words with no priority flags but included via `source_vocab_levels` get a synthetic rank (offset to distinguish from corpus-ranked words).

The exact rank assignment uses the same deterministic ordering principle as kanji `frequency_rank` — relative order is stable across re-runs.

**ID strategy (`ent_seq` as `id`):**

Using JMdict's `ent_seq` as the vocabulary `id` ensures stable identity across database rebuilds. Since the admin architecture is stateless (local DB rebuilt from source files), auto-increment IDs would produce different values on each rebuild, breaking comparison-based sync. JMdict `ent_seq` values are stable, unique integers (~1,000,000 to ~2,900,000).

For custom words not in JMdict (e.g., textbook-specific terms added manually), use IDs starting at **900,000,000** — safely above the JMdict range.

**Note:** The current schema uses `BIGINT GENERATED ALWAYS AS IDENTITY`. Switching to explicit `ent_seq` IDs requires a schema migration (not yet implemented).

**Upsert key:** `word` (unique constraint on `vocabulary`).

### Step 2: Create Reading Rows

For each vocabulary word, extract readings from `raw_jmdict.reading_elements` and upsert into `vocabulary_readings`.

**Priority assignment:**

- If `re_pri` on the reading element contains any of the same priority flags as the selected headword's `ke_pri`, mark as `primary`.
- Otherwise, mark as `secondary`.

**Reading restrictions (`re_restr`):**

If a reading element has `re_restr` values, it applies only to those specific headwords. Skip the reading if its `re_restr` list does not include the selected headword (`kanji_elements[0].keb`).

**Kana-only entries:**

If the entry has `re_nokanji = true`, the reading is the word itself (no kanji headword). The reading is still stored as a `vocabulary_readings` row with `priority = primary`.

**Upsert key:** `(vocabulary_id, reading)` — no duplicate readings for the same word.

**Validation:** After processing, every vocabulary word must have at least one reading row and at least one `primary` reading.

### Step 3: Create I18n Rows

For each vocabulary word, create localized meaning rows in `vocabulary_i18n` for each target language in the pipeline configuration (default: `['en', 'es']`).

For each target language:

1. Collect all `sense` elements from `raw_jmdict.senses`.
2. For each sense, look up `glosses[lang_code]`.
3. If the language key is present and the glosses array is non-empty:
   - Aggregate glosses across all senses into a single `meanings` array (preserving sense ordering).
   - `system_mnemonic` ← `null`. Populated later during content enrichment or manually by admin.
   - `search_tags` ← empty array. Populated later during content enrichment.
4. If no senses have glosses for the target language, **skip** — do not create an i18n row. Fallback to English happens at query time (see [vocabulary.md](../entities/vocabulary.md) edge cases).

**Sense filtering:**

- Skip senses marked with `misc` codes for archaic (`arch`) or obscure (`obs`) usage **unless** they are the only senses available for the target language.
- Respect `stagk`/`stagr` restrictions: if a sense is restricted to specific headwords or readings, only include it if the restrictions match the selected headword.
- **Part-of-speech inheritance:** JMdict applies `pos` to subsequent senses until a new `pos` appears. The parser must carry forward the current `pos` when processing senses.

**Upsert key:** `(vocabulary_id, lang_code)`.

**Validation:** After processing, every vocabulary word must have at least an English (`en`) i18n row. JMdict always includes English glosses, so a missing `en` row indicates a parser bug.

### Step 4: Link Kanji

Parse the `word` string to find constituent kanji and create `vocabulary_kanji` rows.

1. **Scan:** Iterate through every character in the `word` string.
2. **Lookup:** For each character, check if it exists in the `kanji` table (by `character`).
3. **Link:** If found, upsert a `vocabulary_kanji` row:
   - `vocabulary_id`: The word's ID.
   - `kanji_id`: The found kanji's ID.
   - `position`: The character's 0-based index in the `word` string.

**Orphan kanji handling (permissive approach):**

If a word contains a kanji character that is **not** in the `kanji` table (e.g., a rare character excluded from the KANJIDIC import), the word is still imported. The unlinked kanji will always render as a "Ghost" in the UI (gray, with furigana) because it can never be "learned" — but the word remains available for study. This is the recommended approach for N1 coverage completeness.

Log a warning for each unlinked kanji so admin can review coverage gaps.

**Upsert key:** `(vocabulary_id, position)` — each position in a word holds exactly one kanji reference.

**Kana-only words:** Words like すごい contain no kanji characters. Step 4 produces zero `vocabulary_kanji` rows. This is correct — these words have no unlock gate and can enter the lesson queue immediately.

### Step 5: Create Verified Sentences

Extract example sentences from `raw_jmdict.examples` (Tanaka Corpus).

**Source:** Each `raw_jmdict.examples` entry contains `sentence_ja` (Japanese) and `sentence_en` (English).

**Action:**

1. Create a `vocabulary_sentences` row:
   - `vocabulary_id`: The word's ID.
   - `original_text`: Set to `sentence_ja`. If bracket-notation furigana can be generated from available data, apply it; otherwise store as plain text (AI Enrichment in Phase 2.7 will add `[漢](かん)[字](じ)` annotation later).
   - `verification_status`: Set to `verified` — Tanaka Corpus sentences are considered trusted source data.

2. Create a `vocabulary_sentence_i18n` row:
   - `vocabulary_sentence_id`: The sentence's ID.
   - `lang_code`: `en`.
   - `sentence_translated`: Set to `sentence_en`.

**Note:** Only one sentence per vocabulary word (unique constraint on `vocabulary_id`). If multiple examples exist for the same word, select the shortest sentence that still provides meaningful context.

**Upsert key:** `vocabulary_id` (unique on `vocabulary_sentences`).

## Segmentation (Ghost Kanji Support)

To support Ghost Kanji rendering (showing unlearned kanji in gray with furigana), the `segments` JSONB field must be constructed during extraction. Segments follow the `VocabularySegment` format defined in [vocabulary.md §Segments Format](../entities/vocabulary.md#segments-format).

**Source:** `jmdict_furigana` — a reference table mapping vocabulary words to per-character reading breakdowns, ingested from the [JmdictFurigana](https://github.com/Doublevil/JmdictFurigana) dataset.

**Segment types:**

| Type | Fields present | Description |
|---|---|---|
| Kanji segment | `text`, `reading`, `kanji_id` | A single kanji character with its reading and FK to `kanji` |
| Jukujikun segment | `text`, `reading`, `kanji_ids` | An irregular compound where the reading spans multiple kanji |
| Kana segment | `text` | Plain kana — no `reading`, no kanji reference |

**Key rules:**
- `kanji_id` (single int) and `kanji_ids` (list of ints) are mutually exclusive. Exactly one is present for kanji-containing segments; neither for kana segments.
- Kana segments have **no `reading` field** — the text is already kana.
- There is no `is_kanji` field. Segment type is determined by the presence of `kanji_id` or `kanji_ids`.

**Construction logic:**

1. Look up the word in `jmdict_furigana` to get per-character reading mappings.
2. For each character/group in the mapping:
   - If the character is a kanji found in the `kanji` table → create a **kanji segment** with `text`, `reading`, and `kanji_id`.
   - If the character is a kanji **not** in the `kanji` table → still create a kanji segment, but `kanji_id` references will need to be resolved against available data (log warning if missing).
   - If the mapping indicates a jukujikun group (multiple kanji sharing one reading) → create a **jukujikun segment** with `text`, `reading`, and `kanji_ids` (list of all constituent kanji IDs).
   - If the character is kana → create a **kana segment** with `text` only.
3. **Validation:** Concatenating all segment `text` values must exactly reproduce the `word` field.

**Fallback:** If a word is not found in `jmdict_furigana`, construct segments heuristically by scanning characters in the word against the kanji table and using the word's reading to infer per-character readings where possible.

### Worked Examples

#### 冷蔵庫 (Refrigerator) — All Kanji

Word: `冷蔵庫`, reading: `れいぞうこ`

Furigana source: `冷=れい, 蔵=ぞう, 庫=こ`

```json
[
  {"text": "冷", "reading": "れい", "kanji_id": 501},
  {"text": "蔵", "reading": "ぞう", "kanji_id": 892},
  {"text": "庫", "reading": "こ", "kanji_id": 505}
]
```

Each kanji is a separate segment with its own `kanji_id`. The client checks the user's SRS state for each `kanji_id` — learned kanji render solid, unlearned kanji render as gray "ghosts" with furigana above.

#### 食べる (To Eat) — Mixed Kanji/Kana

Word: `食べる`, reading: `たべる`

Furigana source: `食=た`

```json
[
  {"text": "食", "reading": "た", "kanji_id": 201},
  {"text": "べる"}
]
```

The kana part `べる` has no `reading` and no `kanji_id` — it always renders in solid black text.

#### 大人 (Adult) — Jukujikun

Word: `大人`, reading: `おとな`

This is a jukujikun compound — the reading `おとな` cannot be split across individual kanji.

```json
[
  {"text": "大人", "reading": "おとな", "kanji_ids": [102, 45]}
]
```

One segment spans both kanji. `kanji_ids` lists both constituent kanji IDs. The client renders a single ruby annotation over the entire group and checks both kanji for ghost status.

#### すごい (Amazing) — Kana Only

Word: `すごい`, reading: `すごい`

```json
[
  {"text": "すごい"}
]
```

A single kana segment. No kanji references. No ghost rendering logic needed.

## JLPT Level Strategy

Users can choose between JLPT Path and Grade Path. Vocabulary `min_jlpt_level` must be accurate for JLPT-path users, while Grade-path unlocking works differently.

### Source 1: `source_vocab_levels` (Authoritative)

The Tanos JLPT vocabulary list maps words directly to N5–N1 levels. If the word appears in this table, use this level — it takes precedence over any derivation.

**Example:** 駅 (Station) is in the Tanos N5 list. `min_jlpt_level = 5`, even though the kanji 駅 itself is classified as N4 in the kanji table.

### Source 2: Kanji-Derived (Fallback)

For words not in `source_vocab_levels`, derive the level from constituent kanji:

```
min_jlpt_level = MAX(kanji.min_jlpt_level) across all kanji in the word
```

`MAX` returns the **easiest** level (5 = N5 easiest, 1 = N1 hardest) among the word's kanji, matching the level at which the hardest kanji first appears.

**Example:** 大変 (Tough). 大 is N5, 変 is N3. Fallback `min_jlpt_level = 3` (N3) — the word is gated by the N3 kanji.

### The "Eki Problem"

This is the key pedagogical gap that `source_vocab_levels` solves:

- `source_vocab_levels` says 駅 (station) is an **N5 vocabulary word** — beginners need it immediately.
- The `kanji` table says the character 駅 is **N4** — it's taught one level later.

Without `source_vocab_levels`, the pipeline would derive `min_jlpt_level = 4` (from the kanji), and N5 students would never see this essential word. With the authoritative JLPT list, `min_jlpt_level = 5`, and the Ghost Kanji feature allows N5 users to study the word even though the kanji 駅 appears gray (unlearned).

### Words Without JLPT Level

If a word is not in `source_vocab_levels` and all its kanji have `null` JLPT levels, `min_jlpt_level` is set to `null`. These words are excluded from JLPT-based study paths but remain accessible via search.

## POS Tag Extraction

The `pos_tags` field on `vocabulary` is derived from JMdict `pos` and `misc` codes across all senses of the entry, mapped to the curated `PosTag` enum (see [shared_types.md §PosTag](../entities/shared_types.md#postag-enum)).

**Collection logic:**

1. Iterate over all `senses` in the `raw_jmdict` entry.
2. For each sense, collect `pos` codes (with inheritance — carry forward from previous sense if `pos` is null).
3. For each sense, collect `misc` codes.
4. Map each collected code to a `PosTag` value using these rules:

| JMdict Code | Maps To | Source Field |
|---|---|---|
| `v1` | `ichidan_verb` | `pos` |
| `v5u`, `v5k`, `v5r`, `v5s`, `v5t`, `v5b`, `v5g`, `v5m`, `v5n`, `v5k-s`, `v5r-i`, `v5u-s`, `v5aru` | `godan_verb` | `pos` |
| `vs`, `vs-i`, `vs-s` | `suru_verb` | `pos` |
| `vk` | `kuru_verb` | `pos` |
| `vt` | `transitive` | `pos` |
| `vi` | `intransitive` | `pos` |
| `adj-i` | `i_adjective` | `pos` |
| `adj-na` | `na_adjective` | `pos` |
| `n` | `noun` | `pos` |
| `adv` | `adverb` | `pos` |
| `uk` | `usually_kana` | `misc` |
| `pol` | `polite` | `misc` |
| `hum` | `humble` | `misc` |
| `hon` | `honorific` | `misc` |

5. Deduplicate the result — a word gets each tag at most once, regardless of how many senses carry it.
6. Store as a JSONB array on `vocabulary.pos_tags`.

**POS inheritance:** JMdict applies `pos` to subsequent senses until a new `pos` appears. The extractor must track the "current POS" state while iterating senses. When a sense has `pos: null`, it inherits the most recent non-null `pos`. All inherited codes are included in the collection.

**Example — 勉強 (Study):**

Sense 1: `pos: ["n", "vs"]`, `misc: null` → `[noun, suru_verb]`
Sense 2: `pos: null` (inherits `["n", "vs"]`), `misc: null` → no new tags

Result: `pos_tags = ["noun", "suru_verb"]`

**Example — 消す (To Erase):**

Sense 1: `pos: ["v5s", "vt"]`, `misc: null` → `[godan_verb, transitive]`

Result: `pos_tags = ["godan_verb", "transitive"]`

**Example — 有難う (Thank You):**

Sense 1: `pos: ["int"]`, `misc: ["uk"]` → `[usually_kana]` (int is not in our curated set)

Result: `pos_tags = ["usually_kana"]`

## Grade Path Note

Vocabulary does **not** store a `min_grade` field. School grades classify individual kanji, not vocabulary words — there is no official "Grade 1 Vocabulary List."

Grade-path unlocking is a **runtime derivation**: a word becomes unlockable as soon as the user has stabilized all its constituent kanji (checked via `vocabulary_kanji` links). For example, 学校 (School) — composed of 学 (Grade 1) and 校 (Grade 1) — becomes available as soon as the user completes Grade 1 kanji.

This avoids a second source of truth (a stored `min_grade` column would duplicate what `vocabulary_kanji` + `kanji.min_grade` already express) and respects the "Lego Philosophy" where vocabulary is unlocked by its parts, not by a separate classification.

## Edge Cases

### Kana-only words
Words like すごい or ありがとう contain no kanji. They have zero `vocabulary_kanji` rows, all-kana segments, and no unlock gate — they can enter the lesson queue immediately.

### Jukujikun
Compounds like 大人(おとな) and 今日(きょう) have irregular readings that don't decompose per-character. The segmentation step creates a single jukujikun segment with `kanji_ids` listing all constituent kanji. The `jmdict_furigana` source must flag these compounds.

### Orphan kanji
If a word contains a kanji not in the `kanji` table (e.g., rare N1+ character excluded from the KANJIDIC import), the word is still imported (permissive approach). The missing kanji gets no `vocabulary_kanji` row and always renders as a Ghost in the UI. Logged as a warning for admin review.

### Missing JLPT level
Words not in `source_vocab_levels` whose kanji all have `null` JLPT levels get `min_jlpt_level = null`. They surface only via search, not JLPT study paths.

### Duplicate `ent_seq`
JMdict `ent_seq` values are unique within a single JMdict release. If a re-import introduces updated entries, the upsert on `word` handles deduplication. The `ent_seq`-as-`id` strategy means the same word keeps its identity across imports.

### Multiple kanji headwords
JMdict entries may have multiple `kanji_elements` (e.g., 御飯 and ご飯). The pipeline uses the **first** `kanji_elements[0].keb` as the canonical `word`. Alternate writings are not stored as separate vocabulary rows.

### Entries with no glosses in target language
If an entry has no glosses for a target language (e.g., Spanish), no `vocabulary_i18n` row is created for that language. The client falls back to English at query time.

### Entries with `re_nokanji`
Reading elements marked `re_nokanji = true` indicate the entry has no kanji headword. The `word` field uses the reading (`reb`) directly. These entries produce kana-only segments and no `vocabulary_kanji` rows.

### Entries that are pure cross-references
Some JMdict entries exist only to point to other entries via `xref` and have no useful glosses. These are excluded during selection (they lack both priority flags and JLPT listing).

### Missing example sentences
Not every vocabulary word has Tanaka Corpus examples. Words without sentences simply have no `vocabulary_sentences` row. The UI gracefully hides the sentence section.

## Warnings

The phase uses the `Warning` class with `WarningSeverity` (see [pipeline.md §Warning Pattern](pipeline.md#warning-pattern)).

| Condition | Severity | Rationale |
|---|---|---|
| Orphan kanji in word (character not in `kanji` table), JLPT-mapped word | high | Learner-facing gap — word in a JLPT study path will have a permanent Ghost Kanji |
| Orphan kanji in word, non-JLPT word | low | Informational — word still imported with Ghost rendering for the missing character |
| Word with no readings after Step 2 | high | Data integrity — every word must have at least one reading; indicates a parser bug |
| Word with no English (`en`) glosses after Step 3 | high | Data integrity — JMdict always has English glosses; indicates a parser or filter bug |
| Word not found in `jmdict_furigana` | low | Informational — heuristic segmentation used as fallback; may produce less accurate segments |
| Kanji segment with unresolved `kanji_id` during segmentation | low | Informational — kanji segment created without FK reference; renders as Ghost in the UI |

**JLPT-aware severity:** The "orphan kanji" condition uses a two-tier pattern — `high` if the word is JLPT-mapped (via `source_vocab_levels` or kanji-derived level), `low` otherwise.

## Business Rules

1. Every `raw_jmdict` entry that meets selection criteria produces exactly one `vocabulary` row (upsert on `word`).
2. `word` must be non-empty and unique in the `vocabulary` table.
3. `segments` must be a valid JSON array. Concatenating all `text` values must exactly reproduce `word`.
4. Segments use `kanji_id` (single int) for regular kanji segments and `kanji_ids` (list of ints) for jukujikun — mutually exclusive, never both.
5. Every vocabulary word must have at least one reading row after Step 2.
6. Every vocabulary word must have at least one `primary` reading.
7. `vocabulary_i18n` required for `en` at minimum (JMdict always has English glosses).
8. `vocabulary_i18n.meanings` must have at least one entry per row.
9. `vocabulary_kanji` rows must reference existing `kanji.id` values.
10. `vocabulary_kanji.position` is 0-based and unique per vocabulary word.
11. `vocabulary_sentences.vocabulary_id` is unique — one sentence per word.
12. Sentences from Tanaka Corpus get `verification_status = verified`.
13. `frequency_rank` must be a positive integer.
14. `min_jlpt_level`, when present, must be in range 1–5.
15. Re-processing the same `raw_jmdict` data produces the same result (idempotent upserts).
16. `pos_tags` must be a JSON array of valid `PosTag` enum values with no duplicates.
17. POS inheritance must be tracked across senses — a sense with `pos: null` inherits from the most recent non-null `pos`.

## Output Summary

| Table | Source | Description |
|---|---|---|
| `vocabulary` | `raw_jmdict` | Core entity with JLPT levels, segments, POS tags, and frequency rank |
| `vocabulary_readings` | `raw_jmdict.reading_elements` | Pronunciations with priority |
| `vocabulary_i18n` | `raw_jmdict.senses` | Localized meanings (en, es) |
| `vocabulary_kanji` | Computed from `word` + `kanji` table | Kanji composition links with positions |
| `vocabulary_sentences` | `raw_jmdict.examples` | Verified example sentences |
| `vocabulary_sentence_i18n` | `raw_jmdict.examples` | English translations of sentences |

Tables populated by **later phases** (not this algorithm):
- `vocabulary_i18n.system_mnemonic` — Content enrichment
- `vocabulary_i18n.search_tags` — Content enrichment
- `vocabulary_sentences` (AI-translated, non-Tanaka) — AI Enrichment (Phase 2.7)
- `vocabulary_sentence_i18n` (non-English) — AI Enrichment (Phase 2.7)
- `vocabulary_sentences.original_text` bracket notation — AI Enrichment (Phase 2.7)

## Ordering Constraints

The full Phase 2 execution order, showing where vocabulary extraction fits:

```
Phase 2.2 Passes 1-2: Radical extraction (populates radicals, radical_variants)
    |
Phase 2.3 Steps 1-3: Kanji composition (populates kanji, kanji_readings, kanji_i18n)
    |
Phase 2.3 Steps 4-5: Component linking + metadata derivation (populates kanji_components, updates radicals)
    |
Phase 2.4: SVG Processing (populates svg fields on radicals, radical_variants, kanji)
    |
Phase 2.5: Vocabulary extraction  <-- THIS DOC
    |
Phase 2.6: AI Heuristics (refines logic_hint, creates kanji_component_reviews)
    |
Phase 2.7: AI Enrichment (sentence translation, furigana annotation)
```

Steps 1–3 depend on `raw_jmdict`, `source_vocab_levels`, `jmdict_furigana`, and the `kanji` table. Step 4 additionally depends on the `kanji` table for character lookups. Step 5 depends on `raw_jmdict.examples`.

## Related Docs

- [vocabulary.md](../entities/vocabulary.md) — Vocabulary entity spec (target schema, segments format, business rules)
- [raw_jmdict.md](../entities/raw_jmdict.md) — Source staging table schema (JSONB structure, edge cases)
- [jmdict_format.md](../sources/jmdict_format.md) — JMdict XML format reference (priority codes, sense inheritance)
- [kanji_composition.md](kanji_composition.md) — Prerequisite phase (kanji table creation)
- [component_linking.md](component_linking.md) — Component linking (kanji-radical bridge)
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
- [ingestion.md](ingestion.md) — Phase 1 ingestion (source_vocab_levels staging)
