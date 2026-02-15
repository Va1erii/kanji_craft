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

Grammar classification tags derived from JMdict `pos` codes. Drives pedagogical UI: badges, color-coding, display logic (e.g., prepending "to" for verbs), and transitivity indicators. Stored as a JSONB array on `vocabulary.pos_tags`.

All PosTag values come exclusively from the JMdict `pos` field. Register, orthography, and style metadata (previously mixed into PosTag) are now in the separate `MiscTag` enum.

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
| `no_adjective` | `adj-no` (pos) | Adjective | "no-Adj" badge |
| `noun` | `n` (pos) | Word class | "Noun" badge |
| `adverb` | `adv` (pos) | Word class | "Adverb" badge |
| `pronoun` | `pn` (pos) | Word class | "Pronoun" badge |
| `particle` | `prt` (pos) | Word class | "Particle" badge |
| `counter` | `ctr` (pos) | Word class | "Counter" badge |
| `conjunction` | `conj` (pos) | Word class | "Conjunction" badge |
| `interjection` | `int` (pos) | Word class | "Interjection" badge |
| `expression` | `exp` (pos) | Word class | "Expression" badge |
| `prefix` | `pref` (pos) | Word class | "Prefix" badge |
| `suffix` | `suf` (pos) | Word class | "Suffix" badge |

**Mapping rules:**
- All `v5*` variants (`v5u`, `v5k`, `v5r`, `v5s`, etc.) map to a single `godan_verb` value.
- All suru variants (`vs`, `vs-i`, `vs-s`) map to a single `suru_verb` value.
- All values come from the `pos` field in JMdict senses only — never from `misc`.
- A word typically has 2–4 tags (e.g., `[godan_verb, transitive]` or `[noun, suru_verb]`).

Used by: `Vocabulary.pos_tags` (see vocabulary.md). Extraction logic in [ph2_5_vocabulary_extraction.md](../pipeline/ph2_5_vocabulary_extraction.md).

### MiscTag (Enum)

Register, orthography, and style tags derived from JMdict `misc` and `ke_inf` codes. Stored as a JSONB array on `vocabulary.misc_tags`. Complements `PosTag` (grammar) with non-grammatical metadata that affects display, tone, and search.

| Value | JMdict Source | Category | UI Purpose |
|---|---|---|---|
| `usually_kana` | `uk` (misc) | Orthography | Prioritize kana view over kanji view |
| `usually_kanji` | `uK` (misc) | Orthography | Prioritize kanji view (default behavior) |
| `exclusively_kana` | `ek` (ke_inf) | Orthography | Always show kana form |
| `exclusively_kanji` | `eK` (ke_inf) | Orthography | Always show kanji form |
| `polite` | `pol` (misc) | Register | "Polite" usage indicator |
| `humble` | `hum` (misc) | Register | "Humble" usage indicator |
| `honorific` | `hon` (misc) | Register | "Honorific" usage indicator |
| `colloquial` | `col` (misc) | Register | "Colloquial" usage indicator |
| `slang` | `sl` (misc) | Register | "Slang" usage indicator |
| `archaism` | `arch` (misc) | Register | "Archaic" usage indicator |
| `onomatopoeia` | `on-mim` (misc) | Style | "Onomatopoeia" badge |
| `yojijukugo` | `yoji` (misc) | Style | "4-character idiom" badge |
| `idiomatic` | `id` (misc) | Style | "Idiomatic" indicator |
| `abbreviation` | `abbr` (misc) | Style | "Abbreviation" indicator |
| `proverb` | `proverb` (misc) | Style | "Proverb" badge |
| `irregular_verb` | `iv` (misc) | Grammar note | "Irregular" conjugation warning |
| `ateji` | `ateji` (ke_inf) | Orthography | Kanji used for sound, not meaning |
| `rare` | `rare` (misc) | Frequency | "Rare" indicator |
| `sensitive` | `sens` (misc) | Usage | Sensitive content flag |
| `vulgar` | `vulg` (misc) | Usage | Vulgar content flag |

**Collection rules:**
- Collect from both `misc` codes on senses and `ke_inf` codes on kanji elements.
- Deduplicate — each tag appears at most once per word.
- A word may have zero misc tags (most words do).

Used by: `Vocabulary.misc_tags` (see vocabulary.md). Extraction logic in [ph2_5_vocabulary_extraction.md](../pipeline/ph2_5_vocabulary_extraction.md).

### Field Tags

Domain/subject codes from JMdict `field` elements, stored as raw strings on `vocabulary.field_tags` (JSONB array). No enum — JMdict defines ~30 field codes that may change between releases.

Examples: `"food"`, `"comp"`, `"med"`, `"law"`, `"mus"`, `"math"`, `"sports"`, `"MA"` (martial arts).

Used by: `Vocabulary.field_tags` (see vocabulary.md). Full code list in [jmdict_format.md](../sources/jmdict_format.md). Extraction logic in [ph2_5_vocabulary_extraction.md](../pipeline/ph2_5_vocabulary_extraction.md).

### Dialect Tags

Dialect codes from JMdict `dial` elements, stored as raw strings on `vocabulary.dialect_tags` (JSONB array). No enum — JMdict defines ~11 dialect codes.

Examples: `"ksb"` (Kansai-ben), `"ktb"` (Kantō-ben), `"tsug"` (Tsugaru-ben), `"kyb"` (Kyōto-ben).

Used by: `Vocabulary.dialect_tags` (see vocabulary.md). Full code list in [jmdict_format.md](../sources/jmdict_format.md). Extraction logic in [ph2_5_vocabulary_extraction.md](../pipeline/ph2_5_vocabulary_extraction.md).

### Supported Languages

The app supports three content languages for the client UI and production tables, configured via `TARGET_LANGS` in `pipeline/src/config.py`. Ingestion (Phase 1) stores **all** languages from source files in raw tables — filtering to supported languages happens during transformation (Phase 2) when creating `*_i18n` rows. This means adding a new language requires no re-ingestion.

| Code | Language | Notes |
|---|---|---|
| `en` | English | Default/primary. KANJIDIC: `m_lang` absent = English. JMDict: `xml:lang` absent = English |
| `es` | Spanish | KANJIDIC: `m_lang="es"`. JMDict: `xml:lang="spa"` |
| `ru` | Russian | KANJIDIC: `m_lang="ru"`. JMDict: `xml:lang="rus"` |

Used by: `RadicalI18n.lang_code`, `KanjiI18n.lang_code`, `VocabularyI18n.lang_code`, `VocabularySentence.lang_code`, transformation layer (language filtering).
