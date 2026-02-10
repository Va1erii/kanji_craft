# Vocabulary

## Overview

A vocabulary word is a Japanese word or compound that uses one or more kanji characters. For example, 日本 ("Japan") is composed of the kanji 日 ("day/sun") and 本 ("origin/book"). Vocabulary is the final stage of the SRS progression: radical → kanji → vocabulary. A word only enters the lesson queue after the user has stabilized all kanji it contains. Vocabulary is reviewed on both meaning and reading, with example sentences providing real-world context.

## Entities

### Vocabulary (Entity)

The core identity of a single vocabulary word. Holds language-independent data: the written form, reading metadata, and level classifications.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `word` | `String` | The vocabulary word as written, e.g. "日本", "食べる", "大きい". Unique across all vocabulary |
| `min_jlpt_level` | `int?` | The easiest JLPT level this word appears in (5 = N5, 1 = N1). Null for words outside the JLPT set |
| `frequency_rank` | `int` | Frequency rank (1 = most common). Used for ordering within a level |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp. Auto-bumped on direct changes and when child tables change (propagation trigger) |

**Why no `min_grade` on Vocabulary?**

School grades classify individual kanji, not vocabulary words. The JLPT test set defines vocabulary lists directly, so `min_jlpt_level` is the natural classifier. Grade-path users see vocabulary unlocked by their kanji progress, not by a separate grade assignment.

**Why no SVG fields?**

Vocabulary words are rendered as styled text, not as stroke-order diagrams. The individual kanji within the word already have SVGs (see kanji.md).

### VocabularyReading (Entity)

A single pronunciation of a vocabulary word. Most words have one standard reading, but some have multiple (e.g. 明日 can be あした or あす).

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `vocabulary_id` | `int` | FK to the parent Vocabulary |
| `reading` | `String` | The pronunciation in kana, e.g. "にほん", "たべる" |
| `priority` | `ReadingPriority` | `primary` or `secondary` (see shared_types.md) |

**Why reuse `ReadingPriority`?**

The concept is identical to kanji readings — some pronunciations are core (taught first, tested early) and others are secondary (shown for reference). Using the shared enum (see shared_types.md) keeps the SRS review logic consistent across kanji and vocabulary.

### VocabularyKanji (Entity)

Links a vocabulary word to each kanji it contains, in order. This is the bridge table that enables unlock gating and composition display.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `vocabulary_id` | `int` | FK to the parent Vocabulary |
| `kanji_id` | `int` | FK to the Kanji (see kanji.md) |
| `position` | `int` | 0-based index of this kanji within the word. e.g. in 日本, 日 = 0, 本 = 1 |

**Why an explicit junction table instead of parsing kanji from the word string?**

Parsing Unicode to extract kanji is fragile (mixed kana/kanji words like 食べる) and doesn't establish a queryable relationship. An explicit table makes "which vocabulary uses this kanji?" a simple query, enables unlock gating, and lets the UI highlight individual kanji within a word.

### VocabularyI18n (Value Object)

Localized meanings, system mnemonic, and search data for a vocabulary word. One row per word per language.

| Field | Type | Description |
|---|---|---|
| `vocabulary_id` | `int` | FK to the parent Vocabulary |
| `lang_code` | `String` | ISO 639-1 language code, e.g. "en", "es" |
| `meanings` | `List<String>` | Localized meanings in priority order, e.g. ["Japan"] or ["to eat", "to consume"] |
| `system_mnemonic` | `String?` | Optional app-provided learning story (see mnemonic.md). Vocabulary meanings are often self-explanatory |
| `search_tags` | `List<String>` | Synonyms and related terms for search, e.g. ["Japanese", "Nihon", "Nippon"] |

### VocabularySentence (Entity)

An example sentence that uses the vocabulary word in context. Helps the user see how the word is used naturally. One sentence per vocabulary word; translations live in `VocabularySentenceI18n`.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `vocabulary_id` | `int` | FK to the parent Vocabulary. Unique — one sentence per word |
| `sentence_ja` | `String` | The Japanese sentence in plain text, e.g. "日本に行きたい。" |
| `sentence_furigana` | `String` | The same sentence with inline furigana using `[kanji|reading]` notation, e.g. "[日本|にほん]に[行|い]きたい。" |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp. Auto-bumped on direct changes and when child tables change (propagation trigger) |

**Why separate `sentence_ja` and `sentence_furigana`?**

`sentence_ja` is clean text — useful for display without furigana, search indexing, and text-to-speech. `sentence_furigana` carries `[kanji|reading]` annotations that the app parses for rendering small kana above kanji. Keeping them separate avoids parsing when furigana isn't needed.

### VocabularySentenceI18n (Value Object)

Localized translation of an example sentence. One row per sentence per language. Follows the same pattern as `VocabularyI18n`.

| Field | Type | Description |
|---|---|---|
| `vocabulary_sentence_id` | `int` | FK to VocabularySentence |
| `lang_code` | `String` | ISO 639-1 language code, e.g. "en", "es" |
| `sentence_translated` | `String` | Translated sentence, e.g. "I want to go to Japan." |

### VocabularySentenceReview (Entity)

Admin-only review state for each `VocabularySentence`. This table lives in the **Remote `admin` schema** as the authoritative source of truth, surviving device loss. It is **not present in the client Drift schema** — clients never see review data; they only receive sentences that have been verified and synced to production. Access is restricted to the `service_role` key (which bypasses RLS). Follows the same pattern as `KanjiComponentReview` (see kanji_component.md).

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `vocabulary_sentence_id` | `int` | FK to `vocabulary_sentences(id)`. One review row per sentence (unique constraint) |
| `verification_status` | `VerificationStatus` | Review state for this sentence. Defaults to `draft`. Only `verified` rows are eligible for remote sync. See `VerificationStatus` enum in kanji_component.md |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp (auto-set) |

## Relationships

```
Vocabulary  ──1:N──→ VocabularyReading    (one word, many pronunciations)
Vocabulary  ──1:N──→ VocabularyI18n       (one word, one row per language)
Vocabulary  ──1:N──→ VocabularyKanji      (one word, many kanji in order)
Vocabulary  ──1:1──→ VocabularySentence   (one word, one example sentence)
VocabularySentence ──1:N──→ VocabularySentenceI18n   (one sentence, translations per language)
VocabularySentence ──1:1──→ VocabularySentenceReview (one review row per sentence; admin-only)
Vocabulary  ──N:M──→ Kanji               (via VocabularyKanji; see kanji.md)
```

## Business Rules

1. Every vocabulary must have a non-empty `word`.
2. Every vocabulary must have at least one `VocabularyReading`.
3. Every vocabulary must have at least one `primary` reading.
4. `VocabularyI18n` must exist for the default language ("en") at minimum.
5. `meanings` in `VocabularyI18n` must have at least one entry.
6. A vocabulary cannot enter the lesson queue until all its kanji (via `VocabularyKanji`) have `stability >= 7.0` days on their SrsCard (see srs.md rule #7).
7. Vocabulary is reviewed on both meaning and reading.
8. `vocabulary_id` + `reading` must be unique in `VocabularyReading` — no duplicate readings.
9. `vocabulary_id` + `position` must be unique in `VocabularyKanji` — each position in a word holds exactly one kanji. The same kanji may appear at multiple positions (e.g. 人々).
10. `vocabulary_id` + `lang_code` must be unique in `VocabularyI18n` — one translation per language.
11. `frequency_rank` must be a positive integer (1 = most common).
12. `min_jlpt_level`, when present, must be in the range 1–5.
13. `vocabulary_id` must be unique in `VocabularySentence` — one sentence per word.
14. `vocabulary_sentence_id` + `lang_code` must be unique in `VocabularySentenceI18n` — one translation per language per sentence.
15. New sentences created by the pipeline must have a corresponding `VocabularySentenceReview` row with `verification_status = draft`.
16. Only sentences whose review row has `verification_status = verified` are eligible for remote sync (see [pipeline.md](../technical/pipeline.md)).
17. There is exactly one `VocabularySentenceReview` per `VocabularySentence` (enforced by unique constraint on `vocabulary_sentence_id`).
18. Deleting a `VocabularySentence` must cascade-delete its `VocabularySentenceReview` row and all `VocabularySentenceI18n` rows.

## Edge Cases

- **Vocabulary with no JLPT level:** Some common words aren't in the JLPT set. They unlock based on kanji progress alone and surface via search, not the JLPT lesson path.
- **Kana-only vocabulary:** Words like すごい or ありがとう contain no kanji. They have zero `VocabularyKanji` rows and no unlock gate — they can enter the lesson queue immediately. Rule #6 is trivially satisfied (all zero kanji are stable).
- **Repeated kanji in a word:** Words like 人々 or 日々 use the same kanji twice. `VocabularyKanji` stores one row per occurrence, each with a distinct `position`. The unlock gate deduplicates by `kanji_id` — it only checks whether each distinct kanji is known, not how many times it appears.
- **Multiple primary readings:** Some words genuinely have two primary readings (e.g. 明日: あした and あす are both common). SRS should test all primary readings.
- **Mixed kana/kanji words:** Words like 食べる contain both kanji (食) and kana (べる). `VocabularyKanji` only links the kanji portion. The reading covers the full word including kana.
- **Missing translations:** If a user's language has no `VocabularyI18n` row, fall back to "en". Never show blank meanings or system mnemonic.
- **Missing sentences:** Not every vocabulary word will have an example sentence. The UI should gracefully hide the sentence section when none exist.
- **Missing sentence translations:** A sentence may exist but lack a translation in the user's language. Fall back to "en". If no translations exist at all, hide the sentence section.
- **Unverified sentences:** A sentence whose `VocabularySentenceReview` is `draft` or `flagged` will not sync to remote. Clients never see it.
- **Word deleted:** Deleting a Vocabulary must cascade-delete VocabularyReading, VocabularyKanji, VocabularyI18n, VocabularySentence (which cascades to VocabularySentenceI18n and VocabularySentenceReview), and associated SrsCard/ReviewLog rows.
