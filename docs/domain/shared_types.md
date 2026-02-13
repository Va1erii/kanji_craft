# Shared Types

## Overview

Small enums and types that are referenced across multiple entity groups. These don't belong to any single entity doc — they are shared building blocks used by kanji, vocabulary, SRS, mnemonics, and others.

## Types

### ItemType (Enum)

The three core learning item categories in the SRS system. Items are unlocked and reviewed in order: radical → kanji → vocabulary.

| Value | Description |
|---|---|
| `radical` | A radical — the smallest meaningful building block of a kanji (see radical.md) |
| `kanji` | A kanji character composed of one or more radicals (see kanji.md) |
| `vocabulary` | A word or compound built from kanji (see vocabulary.md) |

Used by: `SrsCard.item_type` (see srs.md), `UserMnemonic.item_type` (see mnemonic.md).

### ReadingType (Enum)

The Japanese reading systems for kanji characters.

| Value | Script | Description |
|---|---|---|
| `onyomi` | Katakana | Sino-Japanese reading derived from Chinese pronunciation (e.g. ニチ, ジツ for 日) |
| `kunyomi` | Hiragana | Native Japanese reading (e.g. ひ, か for 日) |
| `nanori` | Hiragana | Name reading used in personal and place names (e.g. あきら for 明). Not all kanji have nanori |

Used by: `KanjiReading.reading_type` (see kanji.md).

### ReadingPriority (Enum)

Indicates whether a reading is a primary or secondary pronunciation. Used for both kanji readings and vocabulary readings.

| Value | Description |
|---|---|
| `primary` | A core reading actively taught and tested. An item can have multiple primary readings (e.g. ニチ and ジツ are both primary onyomi for 日) |
| `secondary` | A less common reading shown for reference only — not tested separately; learned naturally through vocabulary that uses it |

Used by: `KanjiReading.priority` (see kanji.md), `VocabularyReading.priority` (see vocabulary.md).

### PosTag (Enum)

A curated subset of JMdict part-of-speech and miscellaneous codes that drive pedagogical UI: badges, color-coding, display logic (e.g., prepending "to" for verbs), and transitivity indicators. Stored as a JSONB array on `vocabulary.pos_tags`.

The full JMdict DTD defines 200+ POS codes; this enum captures only the ~14 that affect learner-facing grammar rules and visual cues. Everything else is ignored during extraction.

| Value | JMdict Source | Category | UI Purpose |
|---|---|---|---|
| `ichidan_verb` | `v1` (pos) | Verb type | "Verb" badge; conjugation hint (drop -ru) |
| `godan_verb` | `v5*` (pos) | Verb type | "Verb" badge; conjugation hint (u-row shift) |
| `suru_verb` | `vs`, `vs-i`, `vs-s` (pos) | Verb type | "Suru-Verb" badge; noun+する pattern |
| `kuru_verb` | `vk` (pos) | Verb type | "Verb" badge; irregular conjugation |
| `transitive` | `vt` (pos) | Transitivity | "Transitive" badge; "to [do something]" |
| `intransitive` | `vi` (pos) | Transitivity | "Intransitive" badge; "[something] happens" |
| `i_adjective` | `adj-i` (pos) | Adjective | "i-Adj" badge; direct conjugation |
| `na_adjective` | `adj-na` (pos) | Adjective | "na-Adj" badge; copula conjugation |
| `noun` | `n` (pos) | Word class | "Noun" badge |
| `adverb` | `adv` (pos) | Word class | "Adverb" badge |
| `usually_kana` | `uk` (misc) | Display hint | Prioritize kana view over kanji view |
| `polite` | `pol` (misc) | Tone | "Polite" usage indicator |
| `humble` | `hum` (misc) | Tone | "Humble" usage indicator |
| `honorific` | `hon` (misc) | Tone | "Honorific" usage indicator |

**Mapping rules:**
- All `v5*` variants (`v5u`, `v5k`, `v5r`, `v5s`, etc.) map to a single `godan_verb` value.
- All suru variants (`vs`, `vs-i`, `vs-s`) map to a single `suru_verb` value.
- `uk`, `pol`, `hum`, `hon` come from the `misc` field in JMdict senses, not `pos`.
- A word typically has 2–4 tags (e.g., `[godan_verb, transitive]` or `[noun, suru_verb]`).

Used by: `Vocabulary.pos_tags` (see vocabulary.md). Extraction logic in [vocabulary_extraction.md](../pipeline/vocabulary_extraction.md).

### Supported Languages

The app supports two content languages for the client UI and production tables. Ingestion (Phase 1) stores **all** languages from source files in raw tables — filtering to supported languages happens during transformation (Phase 2) when creating `*_i18n` rows. This means adding a new language requires no re-ingestion.

| Code | Language | Notes |
|---|---|---|
| `en` | English | Default/primary. KANJIDIC: `m_lang` absent = English. JMDict: `xml:lang` absent = English |
| `es` | Spanish | KANJIDIC: `m_lang="es"`. JMDict: `xml:lang="spa"` |
| `ru` | Russian | KANJIDIC: `m_lang="ru"`. JMDict: `xml:lang="rus"` |

Used by: `RadicalI18n.lang_code`, `KanjiI18n.lang_code`, `VocabularyI18n.lang_code`, `VocabularySentence.lang_code`, transformation layer (language filtering).
