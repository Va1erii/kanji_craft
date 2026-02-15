# Vocabulary

## Overview

A vocabulary word is a Japanese word or compound that uses one or more kanji characters. For example, 日本 ("Japan") is composed of the kanji 日 ("day/sun") and 本 ("origin/book"). Vocabulary is the final stage of the SRS progression: radical → kanji → vocabulary. A word only enters the lesson queue after the user has stabilized all kanji it contains. Vocabulary is reviewed on both meaning and reading, with example sentences providing real-world context.

## Entities

### Vocabulary (Entity)

The core identity of a single vocabulary word. Holds language-independent data: the written form, furigana, reading metadata, level classifications, and grammar tags.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `word` | `String` | The vocabulary word as written, e.g. "日本", "食べる", "大きい". Unique across all vocabulary |
| `furigana` | `String` | Word with inline furigana notation, e.g. `{食|た}べる`. See Furigana Notation below |
| `min_jlpt_level` | `int?` | The easiest JLPT level this word appears in (5 = N5, 1 = N1). Null for words outside the JLPT set |
| `pos_tags` | `List<PosTag>` | Grammar classification tags from JMdict `pos`. See [shared_types.md §PosTag](shared_types.md#postag-enum) |
| `misc_tags` | `List<MiscTag>` | Register, orthography, and style tags from JMdict `misc`/`ke_inf`. See [shared_types.md §MiscTag](shared_types.md#misctag-enum) |
| `field_tags` | `List<String>` | Domain codes from JMdict `field` (e.g. `["food", "comp"]`). See [shared_types.md §Field Tags](shared_types.md#field-tags) |
| `dialect_tags` | `List<String>` | Dialect codes from JMdict `dial` (e.g. `["ksb"]`). See [shared_types.md §Dialect Tags](shared_types.md#dialect-tags) |
| `frequency_rank` | `int` | Frequency rank (1 = most common). Used for ordering within a level |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp. Auto-bumped on direct changes and when child tables change (propagation trigger) |

**Why no `min_grade` on Vocabulary?**

School grades classify individual kanji, not vocabulary words. The JLPT test set defines vocabulary lists directly, so `min_jlpt_level` is the natural classifier. Grade-path users see vocabulary unlocked by their kanji progress, not by a separate grade assignment.

**Why no SVG fields?**

Vocabulary words are rendered as styled text, not as stroke-order diagrams. The individual kanji within the word already have SVGs (see kanji.md).

#### Furigana Notation

Pipe-delimited notation encodes kanji readings inline within text. Used on both `Vocabulary.furigana` and `VocabularySentence.original_text`.

**Format:** `{kanji|reading}` — curly braces wrap kanji and reading(s), separated by pipes. Plain text outside braces is kana rendered as-is.

**Single kanji:**

```
{食|た}べる              → 食(た)べる
{冷|れい}{蔵|ぞう}{庫|こ} → 冷(れい) 蔵(ぞう) 庫(こ)
```

**Compound — one reading per kanji:**

```
{学生|がく|せい}   → 学(がく) 生(せい)
{勉強|べん|きょう} → 勉(べん) 強(きょう)
```

**Jukujikun — one reading for multiple kanji:**

```
{大人|おとな}  → 大人(おとな) — single ruby span over the group
{今日|きょう}  → 今日(きょう)
{昨日|きのう}  → 昨日(きのう)
```

**Parser logic:**
- Split by `|` — first element is kanji text, rest are readings
- Reading count == kanji character count → per-character ruby
- Reading count == 1, kanji character count > 1 → jukujikun (one ruby span)

**Full sentence example:**

```
{日|に}{本|ほん}に{行|い}きたい。

Renders as:  に ほん     い
             日 本   に 行 きたい。
```

**Tap-to-navigate:** The client parses `{X|...}` blocks, extracts the kanji characters, and looks up `kanji.character` in the local DB. Matching kanji become tappable, linking to the kanji detail page.

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
| `original_text` | `String` | Japanese sentence with inline furigana notation, e.g. `{日|に}{本|ほん}に{行|い}きたい。` See Furigana Notation above |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp. Auto-bumped on direct changes and when child tables change (propagation trigger) |

### VocabularySentenceI18n (Value Object)

Localized translation of an example sentence. One row per sentence per language. Follows the same pattern as `VocabularyI18n`.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `vocabulary_sentence_id` | `int` | FK to VocabularySentence |
| `lang_code` | `String` | ISO 639-1 language code, e.g. "en", "es" |
| `sentence_translated` | `String` | Translated sentence, e.g. "I want to go to Japan." |
| `created_at` | `DateTime` | Row creation timestamp (auto-set) |
| `updated_at` | `DateTime` | Last modification timestamp (auto-set) |

## Relationships

```
Vocabulary  ──1:N──→ VocabularyReading          (one word, many pronunciations)
Vocabulary  ──1:N──→ VocabularyI18n             (one word, one row per language)
Vocabulary  ──1:N──→ VocabularyKanji            (one word, many kanji in order)
Vocabulary  ──1:1──→ VocabularySentence         (one word, one example sentence)
VocabularySentence ──1:N──→ VocabularySentenceI18n  (one sentence, translations per language)
Vocabulary  ──N:M──→ Kanji                      (via VocabularyKanji; see kanji.md)
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
15. Deleting a `VocabularySentence` must cascade-delete all `VocabularySentenceI18n` rows.
17. `furigana` and `original_text` must use valid `{kanji|reading}` notation. Stripping notation from `furigana` must reproduce `word` exactly.
18. Each `{...}` group must have at least one reading. Reading count must equal kanji character count (per-character) or be exactly 1 (jukujikun).
20. `pos_tags` must be a JSON array of valid `PosTag` enum values. May be empty for words that don't match any curated tag.
21. `pos_tags` values must not contain duplicates.
22. `misc_tags` must be a JSON array of valid `MiscTag` enum values. May be empty (most words have no misc tags).
23. `field_tags` must be a JSON array of strings (raw JMdict field codes). May be empty.
24. `dialect_tags` must be a JSON array of strings (raw JMdict dialect codes). May be empty.
25. `misc_tags`, `field_tags`, and `dialect_tags` values must not contain duplicates within each array.

## Edge Cases

- **Vocabulary with no JLPT level:** Some common words aren't in the JLPT set. They unlock based on kanji progress alone and surface via search, not the JLPT lesson path.
- **Kana-only vocabulary:** Words like すごい or ありがとう contain no kanji. They have zero `VocabularyKanji` rows and no unlock gate — they can enter the lesson queue immediately. Rule #6 is trivially satisfied (all zero kanji are stable). Their `furigana` field contains plain text with no `{...}` groups.
- **Repeated kanji in a word:** Words like 人々 or 日々 use the same kanji twice. `VocabularyKanji` stores one row per occurrence, each with a distinct `position`. The unlock gate deduplicates by `kanji_id` — it only checks whether each distinct kanji is known, not how many times it appears.
- **Multiple primary readings:** Some words genuinely have two primary readings (e.g. 明日: あした and あす are both common). SRS should test all primary readings.
- **Mixed kana/kanji words:** Words like 食べる contain both kanji (食) and kana (べる). `VocabularyKanji` only links the kanji portion. The reading covers the full word including kana. In furigana notation: `{食|た}べる`.
- **Missing translations:** If a user's language has no `VocabularyI18n` row, fall back to "en". Never show blank meanings or system mnemonic.
- **Missing sentences:** Not every vocabulary word will have an example sentence. The UI should gracefully hide the sentence section when none exist.
- **Missing sentence translations:** A sentence may exist but lack a `VocabularySentenceI18n` row in the user's language. Fall back to "en". If no translations exist at all, hide the translation.
- **Jukujikun in furigana:** Irregular compound readings like 大人(おとな) use single-reading notation: `{大人|おとな}`. The client detects jukujikun (1 reading, multiple kanji) and renders one ruby span over the entire group.
- **Words with multiple POS tags:** A word like 勉強 is both a noun and a suru-verb (`[noun, suru_verb]`). A verb like 消す is godan and transitive (`[godan_verb, transitive]`). The UI determines the dominant badge/color from the tag list — this is a presentation concern, not an entity concern.
- **Words with `usually_kana` tag:** Words like 有難う (ありがとう) have `usually_kana` in their `misc_tags`. The client should default to showing the kana form even if the kanji form exists.
- **Words with no matching POS tags:** Rare words that don't match any curated JMdict code get an empty `pos_tags` array. The UI shows no badge.
- **Words with domain tags:** Specialized vocabulary like 味噌 (miso) may have `field_tags: ["food"]`. The UI can optionally show a domain badge or use it for filtered study paths.
- **Words with dialect tags:** Regional vocabulary may have `dialect_tags: ["ksb"]` (Kansai-ben). The UI can optionally indicate the dialect.
- **Words with multiple misc tags:** A word can carry several misc tags (e.g. `[colloquial, abbreviation]`). All tags are stored; UI determines which to display.
- **Word deleted:** Deleting a Vocabulary must cascade-delete VocabularyReading, VocabularyKanji, VocabularyI18n, VocabularySentence (which cascades to VocabularySentenceI18n), and associated SrsCard/ReviewLog rows.
