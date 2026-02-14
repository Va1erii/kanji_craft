# Vocabulary Extraction

## Overview

Vocabulary extraction transforms JMdict data (from `jmdict.parquet`) into learnable vocabulary output CSVs: `vocabulary.csv`, `vocabulary_readings.csv`, `vocabulary_i18n.csv`, `vocabulary_kanji.csv`, `vocabulary_sentences.csv`, and `vocabulary_sentence_i18n.csv`. The result is a structured educational dataset where every word carries its readings, localized meanings, kanji composition links, example sentences, and furigana notation for Ghost Kanji rendering — everything the SRS engine needs to schedule lessons and the client needs to render cards.

This phase sits after Kanji Composition (Phase 2.2) and Component Linking (Phase 2.3) because vocabulary items are "gated" by the kanji they contain. The `kanji.csv` must be fully populated so that Step 6 can resolve `vocabulary_kanji.kanji_id` links and Step 2 can construct furigana with valid kanji references.

**Key goal:** Create a "Lego-style" progression where words are unlocked only after their constituent kanji are stabilized. To solve pedagogical gaps (like the "Eki Problem"), this phase also integrates external JLPT level data that may disagree with kanji-derived levels.

**What this phase does NOT do:** AI translation of missing sentence pairs or bracket-notation furigana annotation of raw Japanese sentences. Those occur in Phase 3 (AI Enrichment).

## Source Data

| Source | Used in | Purpose |
|---|---|---|
| `jmdict.parquet` | Steps 1, 3, 4 | Core dictionary entries (words, readings, meanings, POS codes) |
| `jmdict_examples.parquet` | Step 5 | Tanaka Corpus example sentences (verified English) |
| `kanji.csv` | Steps 2, 6 | Resolving `vocabulary_kanji` links and furigana kanji references |
| `jlpt_vocab.parquet` | Step 1 | Tanos JLPT vocabulary list (N5–N1) for `min_jlpt_level` |
| `jmdict_furigana.parquet` | Step 2 | Per-character furigana mappings for notation construction |

## Prerequisites

Both conditions must hold before this phase runs:

1. **Kanji Composition (Phase 2.2) complete** — `kanji.csv`, `kanji_readings.csv`, and `kanji_i18n.csv` are written. Vocabulary extraction relies on kanji rows to create links and resolve furigana references.
2. **JLPT Vocab Mapping (Phase 1) loaded** — `jlpt_vocab.parquet` must be produced from the Tanos vocabulary CSVs (see [ph1_ingestion.md](ph1_ingestion.md)).

## Algorithm

The extraction runs in six steps over the JMdict Parquet data. Each step is idempotent — re-running with the same data produces the same output files.

### Step 1: Create Vocabulary Rows

For each `jmdict.parquet` entry, determine if it qualifies for the app, then write a `vocabulary.csv` row.

**Selection logic:**

Import the word if **either** condition is met:
- It has a priority flag (`news1`, `ichi1`, `spec1`, `gai1`, etc.) on any kanji element or reading element, **OR**
- It appears in `jlpt_vocab.parquet` (it is a required JLPT word).

This ensures both common words (frequency-based) and pedagogically important words (JLPT-based) are included, even if they lack priority flags.

**Field mapping:**

| `jmdict.parquet` | `vocabulary.csv` | Transformation |
|---|---|---|
| `ent_seq` | `id` | Use JMdict sequence ID directly (stable identifier; see §ID Strategy) |
| `kanji_elements[0].keb` | `word` | Use the first (most common) kanji headword. If null, use `reading_elements[0].reb` (kana-only word) |
| (Derived) | `furigana` | Construct `{kanji\|reading}` notation using `jmdict_furigana.parquet` (see §Furigana Construction) |
| (Derived) | `min_jlpt_level` | Primary: lookup in `jlpt_vocab.parquet`. Fallback: `MAX(kanji.min_jlpt_level)` across constituent kanji (see §JLPT Level Strategy) |
| (Derived) | `pos_tags` | Collect `pos` and `misc` from all senses, map to `PosTag` enum (see §POS Tag Extraction) |
| Priority flags | `frequency_rank` | Map priority flags to an integer rank (see below) |

**Frequency rank mapping:**

JMdict priority flags indicate frequency tier. Map them to a numeric rank:

1. Words with `news1` or `ichi1` (high frequency) get the lowest ranks.
2. Words with `news2`, `ichi2`, `spec1`, `spec2` get mid-range ranks.
3. Words with only `gai1`/`gai2` (loanword frequency) or `nfxx` (Netflix frequency) get higher ranks.
4. Words with no priority flags but included via `jlpt_vocab.parquet` get a synthetic rank (offset to distinguish from corpus-ranked words).

The exact rank assignment uses the same deterministic ordering principle as kanji `frequency_rank` — relative order is stable across re-runs.

**ID strategy (`ent_seq` as `id`):**

Using JMdict's `ent_seq` as the vocabulary `id` ensures stable identity across database rebuilds. Since the admin architecture is stateless (local DB rebuilt from source files), auto-increment IDs would produce different values on each rebuild, breaking comparison-based sync. JMdict `ent_seq` values are stable, unique integers (~1,000,000 to ~2,900,000).

For custom words not in JMdict (e.g., textbook-specific terms added manually), use IDs starting at **900,000,000** — safely above the JMdict range.

**Note:** The current schema uses `BIGINT GENERATED ALWAYS AS IDENTITY`. Switching to explicit `ent_seq` IDs requires a schema migration (not yet implemented).

**Unique key:** `word` (unique constraint on `vocabulary.csv`).

### Step 2: Construct Furigana

For each vocabulary word, construct the `furigana` field using `{kanji|reading}` pipe-delimited notation (see [vocabulary.md §Furigana Notation](../domain/vocabulary.md#furigana-notation)).

**Source:** `jmdict_furigana.parquet` — per-character reading breakdowns ingested from the [JmdictFurigana](https://github.com/Doublevil/JmdictFurigana) dataset.

**Construction logic:**

1. Look up the word in `jmdict_furigana.parquet` to get per-character reading mappings.
2. For each character/group in the mapping:
   - If the character is a kanji → wrap as `{kanji|reading}`.
   - If the mapping indicates a jukujikun group (multiple kanji sharing one reading) → wrap as `{kanjigroup|reading}` (one reading for multiple characters → single ruby span).
   - If the mapping indicates a compound with per-character readings → wrap as `{kanjigroup|reading1|reading2|...}` (reading count == kanji count).
   - If the character is kana → leave as plain text (no braces).
3. **Validation:** Stripping all `{` `|` `}` and reading portions must reproduce the original `word` text.

**Fallback:** If a word is not found in `jmdict_furigana.parquet`, use **whole-word furigana** rather than attempting to guess the kanji/okurigana split:

```
{食べる|たべる}   ← safe whole-word fallback
{食|た}べる       ← correct split (only from jmdict_furigana)
{食べ|た}る       ← wrong split — NEVER guess
```

A wrong split (e.g. attaching okurigana to the kanji span) looks unprofessional and confuses learners. Whole-word furigana is always safe — the client renders a single ruby span over the entire word. Ghost Kanji rendering still works: the client scans all characters inside `{...}` for known kanji.

**Fallback construction:** Wrap the entire word with its reading: `{word|reading}`. If the word is kana-only (no kanji characters), leave as plain text (no braces needed). Log a `medium` warning for each fallback so missing entries can be added to `jmdict_furigana.parquet` over time.

### Worked Examples (Furigana)

#### 冷蔵庫 (Refrigerator) — Per-Character Readings

Word: `冷蔵庫`, reading: `れいぞうこ`

Furigana source: `冷=れい, 蔵=ぞう, 庫=こ`

```
{冷|れい}{蔵|ぞう}{庫|こ}
```

Or equivalently as a compound: `{冷蔵庫|れい|ぞう|こ}`

Each kanji gets its own ruby annotation. The client checks the user's SRS state for each kanji — learned kanji render solid, unlearned kanji render as gray "ghosts" with furigana above.

#### 食べる (To Eat) — Mixed Kanji/Kana

Word: `食べる`, reading: `たべる`

Furigana source: `食=た`

```
{食|た}べる
```

The kana part `べる` is plain text — always rendered in solid black.

#### 大人 (Adult) — Jukujikun

Word: `大人`, reading: `おとな`

This is a jukujikun compound — the reading `おとな` cannot be split across individual kanji.

```
{大人|おとな}
```

One reading for multiple kanji characters → single ruby span over the entire group. The client checks both kanji for ghost status.

#### すごい (Amazing) — Kana Only

Word: `すごい`, reading: `すごい`

```
すごい
```

Plain text, no braces. No kanji references. No ghost rendering logic needed.

### Step 3: Create Reading Rows

For each vocabulary word, extract readings from `jmdict.parquet` reading elements and write to `vocabulary_readings.csv`.

**Priority assignment:**

- If `re_pri` on the reading element contains any of the same priority flags as the selected headword's `ke_pri`, mark as `primary`.
- Otherwise, mark as `secondary`.

**Reading restrictions (`re_restr`):**

If a reading element has `re_restr` values, it applies only to those specific headwords. Skip the reading if its `re_restr` list does not include the selected headword (`kanji_elements[0].keb`).

**Kana-only entries:**

If the entry has `re_nokanji = true`, the reading is the word itself (no kanji headword). The reading is still stored as a `vocabulary_readings.csv` row with `priority = primary`.

**Unique key:** `(vocabulary_id, reading)` — no duplicate readings for the same word.

**Validation:** After processing, every vocabulary word must have at least one reading row and at least one `primary` reading.

### Step 4: Create I18n Rows

For each vocabulary word, write localized meaning rows to `vocabulary_i18n.csv` for each target language in the pipeline configuration (default: `['en', 'es']`).

For each target language:

1. Collect all `sense` elements from the JMdict entry.
2. For each sense, look up `glosses[lang_code]`.
3. If the language key is present and the glosses array is non-empty:
   - Aggregate glosses across all senses into a single `meanings` array (preserving sense ordering).
   - `system_mnemonic` ← empty string. Populated later during AI enrichment (Phase 3) or manually by admin.
   - `search_tags` ← empty array. Populated later during content enrichment.
4. If no senses have glosses for the target language, **skip** — do not write an i18n row. Fallback to English happens at query time (see [vocabulary.md](../domain/vocabulary.md) edge cases).

**Sense filtering:**

- Skip senses marked with `misc` codes for archaic (`arch`) or obscure (`obs`) usage **unless** they are the only senses available for the target language.
- Respect `stagk`/`stagr` restrictions: if a sense is restricted to specific headwords or readings, only include it if the restrictions match the selected headword.
- **Part-of-speech inheritance:** JMdict applies `pos` to subsequent senses until a new `pos` appears. The parser must carry forward the current `pos` when processing senses.

**Unique key:** `(vocabulary_id, lang_code)`.

**Validation:** After processing, every vocabulary word must have at least an English (`en`) i18n row. JMdict always includes English glosses, so a missing `en` row indicates a parser bug.

### Step 5: Create Verified Sentences

Extract example sentences from `jmdict_examples.parquet` (Tanaka Corpus).

**Source:** Each entry contains `sentence_ja` (Japanese) and `sentence_en` (English).

**Action:**

1. Write a `vocabulary_sentences.csv` row:
   - `vocabulary_id`: The word's ID.
   - `original_text`: Set to `sentence_ja`. If furigana notation can be generated from available data, apply it; otherwise store as plain text (AI Enrichment in Phase 3 will add `{漢|かん}{字|じ}` annotation later).

2. Write a `vocabulary_sentence_i18n.csv` row:
   - `vocabulary_sentence_id`: The sentence's ID.
   - `lang_code`: `en`.
   - `sentence_translated`: Set to `sentence_en`.

**Note:** Only one sentence per vocabulary word (unique constraint on `vocabulary_id`). If multiple examples exist for the same word, select the shortest sentence that still provides meaningful context.

**Unique key:** `vocabulary_id` (unique on `vocabulary_sentences.csv`).

### Step 6: Link Kanji

Parse the `word` string to find constituent kanji and write `vocabulary_kanji.csv` rows.

1. **Scan:** Iterate through every character in the `word` string.
2. **Lookup:** For each character, check if it exists in `kanji.csv` (by `character`).
3. **Link:** If found, write a `vocabulary_kanji` row:
   - `vocabulary_id`: The word's ID.
   - `kanji_id`: The found kanji's ID.
   - `position`: The character's 0-based index in the `word` string.

**Orphan kanji handling (permissive approach):**

If a word contains a kanji character that is **not** in `kanji.csv` (e.g., a rare character excluded from the KANJIDIC import), the word is still imported. The unlinked kanji will always render as a "Ghost" in the UI (gray, with furigana) because it can never be "learned" — but the word remains available for study. This is the recommended approach for N1 coverage completeness.

Log a warning for each unlinked kanji so admin can review coverage gaps.

**Unique key:** `(vocabulary_id, position)` — each position in a word holds exactly one kanji reference.

**Client query pattern:** When rendering a vocabulary card, the client queries: "For vocabulary ID X, give me all kanji IDs" → then checks SRS status for each kanji to decide solid vs. ghost rendering. Ensure `vocabulary_kanji` has an index on `vocabulary_id` (standard FK index — verify in the migration).

**Kana-only words:** Words like すごい contain no kanji characters. Step 6 produces zero `vocabulary_kanji` rows. This is correct — these words have no unlock gate and can enter the lesson queue immediately.

## JLPT Level Strategy

Users can choose between JLPT Path and Grade Path. Vocabulary `min_jlpt_level` must be accurate for JLPT-path users, while Grade-path unlocking works differently.

### Source 1: `jlpt_vocab.parquet` (Authoritative)

The Tanos JLPT vocabulary list maps words directly to N5–N1 levels. If the word appears in this dataset, use this level — it takes precedence over any derivation.

**Example:** 駅 (Station) is in the Tanos N5 list. `min_jlpt_level = 5`, even though the kanji 駅 itself is classified as N4 in the kanji table.

### Source 2: Kanji-Derived (Fallback)

For words not in `jlpt_vocab.parquet`, derive the level from constituent kanji:

```
min_jlpt_level = MAX(kanji.min_jlpt_level) across all kanji in the word
```

**Why MAX, not MIN:** JLPT levels are inverted — N5 = 5 (easiest), N1 = 1 (hardest). `MAX` returns the **easiest** level among the word's kanji, matching the level at which the hardest kanji first appears. Always comment the intent in implementation code (`// N5=5 easiest, N1=1 hardest; MAX returns earliest encounter`).

**Example:** 大変 (Tough). 大 is N5, 変 is N3. Fallback `min_jlpt_level = 3` (N3) — the word is gated by the N3 kanji.

### The "Eki Problem"

This is the key pedagogical gap that `jlpt_vocab.parquet` solves:

- `jlpt_vocab.parquet` says 駅 (station) is an **N5 vocabulary word** — beginners need it immediately.
- The `kanji` table says the character 駅 is **N4** — it's taught one level later.

Without `jlpt_vocab.parquet`, the pipeline would derive `min_jlpt_level = 4` (from the kanji), and N5 students would never see this essential word. With the authoritative JLPT list, `min_jlpt_level = 5`, and the Ghost Kanji feature allows N5 users to study the word even though the kanji 駅 appears gray (unlearned).

### Words Without JLPT Level

If a word is not in `jlpt_vocab.parquet` and all its kanji have `null` JLPT levels, `min_jlpt_level` is set to `null`. These words are excluded from JLPT-based study paths but remain accessible via search.

## POS Tag Extraction

The `pos_tags` field on `vocabulary` is derived from JMdict `pos` and `misc` codes across all senses of the entry, mapped to the curated `PosTag` enum (see [shared_types.md §PosTag](../domain/shared_types.md#postag-enum)).

**Collection logic:**

1. Iterate over all `senses` in the JMdict entry.
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
6. Store as a JSON array on `vocabulary.csv` `pos_tags`.

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
Words like すごい or ありがとう contain no kanji. They have zero `vocabulary_kanji` rows, plain-text furigana (no braces), and no unlock gate — they can enter the lesson queue immediately.

### Jukujikun
Compounds like 大人(おとな) and 今日(きょう) have irregular readings that don't decompose per-character. The furigana step creates a single `{kanjigroup|reading}` notation. The `jmdict_furigana.parquet` source must flag these compounds.

### Orphan kanji
If a word contains a kanji not in `kanji.csv` (e.g., rare N1+ character excluded from the KANJIDIC import), the word is still imported (permissive approach). The missing kanji gets no `vocabulary_kanji` row and always renders as a Ghost in the UI. Logged as a warning for admin review.

### Missing JLPT level
Words not in `jlpt_vocab.parquet` whose kanji all have `null` JLPT levels get `min_jlpt_level = null`. They surface only via search, not JLPT study paths.

### Duplicate `ent_seq`
JMdict `ent_seq` values are unique within a single JMdict release. If a re-import introduces updated entries, the write on `word` handles deduplication. The `ent_seq`-as-`id` strategy means the same word keeps its identity across imports.

### Multiple kanji headwords
JMdict entries may have multiple `kanji_elements` (e.g., 御飯 and ご飯). The pipeline uses the **first** `kanji_elements[0].keb` as the canonical `word`. Alternate writings are not stored as separate vocabulary rows.

### Entries with no glosses in target language
If an entry has no glosses for a target language (e.g., Spanish), no `vocabulary_i18n.csv` row is created for that language. The client falls back to English at query time.

### Entries with `re_nokanji`
Reading elements marked `re_nokanji = true` indicate the entry has no kanji headword. The `word` field uses the reading (`reb`) directly. These entries produce plain-text furigana and no `vocabulary_kanji` rows.

### Entries that are pure cross-references
Some JMdict entries exist only to point to other entries via `xref` and have no useful glosses. These are excluded during selection (they lack both priority flags and JLPT listing).

### Missing example sentences
Not every vocabulary word has Tanaka Corpus examples. Words without sentences simply have no `vocabulary_sentences.csv` row. The UI gracefully hides the sentence section.

## Warnings

Warnings are written to `data/csv/warnings/ph2_5_warnings.csv` with columns: `severity, phase, entity, message`.

| Condition | Severity | Rationale |
|---|---|---|
| Orphan kanji in word (character not in `kanji.csv`), JLPT-mapped word | high | Learner-facing gap — word in a JLPT study path will have a permanent Ghost Kanji |
| Orphan kanji in word, non-JLPT word | low | Informational — word still imported with Ghost rendering for the missing character |
| Word with no readings after Step 3 | high | Data integrity — every word must have at least one reading; indicates a parser bug |
| Word with no English (`en`) glosses after Step 4 | high | Data integrity — JMdict always has English glosses; indicates a parser or filter bug |
| Word not found in `jmdict_furigana.parquet` | low | Informational — heuristic furigana used as fallback; may produce less accurate notation |
| Orphan kanji during furigana construction (kanji not in `kanji.csv`) | low | Informational — furigana still generated; kanji renders as Ghost in the UI |

**JLPT-aware severity:** The "orphan kanji" condition uses a two-tier pattern — `high` if the word is JLPT-mapped (via `jlpt_vocab.parquet` or kanji-derived level), `low` otherwise.

## Business Rules

1. Every `jmdict.parquet` entry that meets selection criteria produces exactly one `vocabulary.csv` row (unique on `word`).
2. `word` must be non-empty and unique.
3. `furigana` must use valid `{kanji|reading}` notation. Stripping braces and readings must reproduce the `word` field.
4. Every vocabulary word must have at least one reading row after Step 3.
5. Every vocabulary word must have at least one `primary` reading.
6. `vocabulary_i18n.csv` required for `en` at minimum (JMdict always has English glosses).
7. `vocabulary_i18n.csv` `meanings` must have at least one entry per row.
8. `vocabulary_kanji` rows must reference existing kanji IDs from `kanji.csv`.
9. `vocabulary_kanji.position` is 0-based and unique per vocabulary word.
10. `vocabulary_sentences.csv` `vocabulary_id` is unique — one sentence per word.
11. `frequency_rank` must be a positive integer.
12. `min_jlpt_level`, when present, must be in range 1–5.
13. Re-processing the same data produces the same output files (idempotent file writes).
14. `pos_tags` must be a JSON array of valid `PosTag` enum values with no duplicates.
15. POS inheritance must be tracked across senses — a sense with `pos: null` inherits from the most recent non-null `pos`.

## Output Summary

| File | Source | Description |
|---|---|---|
| `vocabulary.csv` | `jmdict.parquet` | Core entity with JLPT levels, furigana, POS tags, and frequency rank |
| `vocabulary_readings.csv` | `jmdict.parquet` reading elements | Pronunciations with priority |
| `vocabulary_i18n.csv` | `jmdict.parquet` senses | Localized meanings (en, es) |
| `vocabulary_kanji.csv` | Computed from `word` + `kanji.csv` | Kanji composition links with positions |
| `vocabulary_sentences.csv` | `jmdict_examples.parquet` | Example sentences |
| `vocabulary_sentence_i18n.csv` | `jmdict_examples.parquet` | English translations of sentences |

Files updated by **later phases** (not this algorithm):
- `vocabulary_i18n.csv` `system_mnemonic`, `search_tags` — AI Enrichment (Phase 3)
- `vocabulary_sentences.csv` (AI-translated sentences) — AI Enrichment (Phase 3)
- `vocabulary_sentence_i18n.csv` (non-English translations) — AI Enrichment (Phase 3)
- `vocabulary_sentences.csv` `original_text` furigana annotation — AI Enrichment (Phase 3)

## Ordering Constraints

The full Phase 2 execution order, showing where vocabulary extraction fits:

```
Phase 2.1 Passes 1-2: Radical extraction (outputs radicals.csv, radical_variants.csv)
    |
Phase 2.2 Steps 1-3: Kanji composition (outputs kanji.csv, kanji_readings.csv, kanji_i18n.csv)
    |
Phase 2.3: Component linking + metadata derivation (outputs kanji_components.csv, updates radicals.csv)
    |
Phase 2.4: SVG Processing (updates svg fields on radicals.csv, radical_variants.csv, kanji.csv)
    |
Phase 2.5: Vocabulary extraction (outputs vocabulary CSVs)  <-- THIS DOC
    |
Phase 3: AI Enrichment (sentence translation, furigana annotation, system mnemonics)
```

Steps 1–4 depend on `jmdict.parquet`, `jlpt_vocab.parquet`, `jmdict_furigana.parquet`, and `kanji.csv`. Step 5 depends on `jmdict_examples.parquet`. Step 6 depends on `kanji.csv` for character lookups.

## Related Docs

- [vocabulary.md](../domain/vocabulary.md) — Vocabulary entity spec (target schema, furigana format, business rules)
- [jmdict_format.md](../sources/jmdict_format.md) — JMdict XML format reference (priority codes, sense inheritance)
- [jmdict_furigana_format.md](../sources/jmdict_furigana_format.md) — JmdictFurigana JSON format (per-character furigana mappings)
- [jlpt_vocab_mapping_format.md](../sources/jlpt_vocab_mapping_format.md) — JLPT vocabulary mapping CSV format (Tanos word lists)
- [ph2_2_kanji_composition.md](ph2_2_kanji_composition.md) — Prerequisite phase (kanji row creation)
- [ph2_3_component_linking.md](ph2_3_component_linking.md) — Component linking (kanji-radical bridge)
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
- [ph1_ingestion.md](ph1_ingestion.md) — Phase 1 ingestion (Parquet production)
