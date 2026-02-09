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

The two Japanese reading systems for kanji characters.

| Value | Script | Description |
|---|---|---|
| `onyomi` | Katakana | Sino-Japanese reading derived from Chinese pronunciation (e.g. ニチ, ジツ for 日) |
| `kunyomi` | Hiragana | Native Japanese reading (e.g. ひ, か for 日) |

Used by: `KanjiReading.reading_type` (see kanji.md).

### ReadingPriority (Enum)

Indicates whether a reading is a primary or secondary pronunciation. Used for both kanji readings and vocabulary readings.

| Value | Description |
|---|---|
| `primary` | A core reading taught during initial lessons. An item can have multiple primary readings (e.g. ニチ and ジツ are both primary onyomi for 日) |
| `secondary` | A less common reading shown for reference but not tested during early SRS stages |

Used by: `KanjiReading.priority` (see kanji.md), `VocabularyReading.priority` (see vocabulary.md).

### Supported Languages

The app supports two content languages. All localized data (meanings, glosses, example sentences) is stored and displayed only for these languages. During ingestion, parsers discard data for unsupported languages.

| Code | Language | Notes |
|---|---|---|
| `en` | English | Default/primary. KANJIDIC: `m_lang` absent = English. JMDict: `xml:lang` absent = English |
| `es` | Spanish | KANJIDIC: `m_lang="es"`. JMDict: `xml:lang="spa"` |

Used by: `KanjiI18n.lang_code`, `VocabularyI18n.lang_code`, `VocabularySentence.lang_code`, ingestion parsers (language filtering).
