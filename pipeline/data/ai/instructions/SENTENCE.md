# AI Instructions: Sentence Generation (Batch)

Fill the template CSV `sentence_ai.csv` with level-appropriate example sentences and their translations.

## CSV Format

| Column | Type | Description |
|---|---|---|
| `vocabulary_id` | read-only | Vocabulary ID |
| `word` | read-only | The vocabulary word (e.g. 食べる, 学校) |
| `lang_code` | read-only | `en`, `es`, or `ru` |
| `original_text` | **fill** | Japanese sentence with `{kanji\|reading}` furigana notation (same for all langs — fill only on `en` row, others will copy) |
| `sentence_translated` | **fill** | Translation in the target language |

Only fill `original_text` and `sentence_translated`. Do not modify read-only columns.

## Field 1: `original_text` — Japanese Sentence

Write a natural Japanese sentence that uses the target vocabulary word. The sentence should be appropriate for the JLPT level of this batch.

### JLPT Grammar Constraints

| Level | Grammar | Notes |
|---|---|---|
| N5 | `です/ます` form, simple structure, basic particles (は, が, を, に, で, へ) | Use only N5 vocabulary where possible |
| N4 | `て-form`, `ない-form`, basic conjunctions (から, けど), potential form | Can use N5+N4 vocabulary |
| N3 | Passive/causative, conditionals (ば, たら, なら), volitional | Can use N5-N3 vocabulary |
| N2+ | Complex sentences, formal/informal register mixing, embedded clauses | Full grammar range |

### Furigana Notation

Every kanji in `original_text` MUST have furigana notation:

- Single kanji: `{食|た}べる`
- Compound per-character: `{学生|がく|せい}` (reading count == kanji count)
- Jukujikun: `{大人|おとな}` (1 reading, multiple kanji → single ruby span)
- Kana-only words: no braces needed

### Rules

1. **One sentence per vocabulary word.** The sentence must naturally use the target word.
2. **Level-appropriate grammar and vocabulary.** N5 sentences must be simple enough for beginners.
3. **Natural Japanese.** Write sentences that a native speaker would actually say.
4. **8-20 characters** (excluding furigana notation). Not too short, not too long.
5. **The `original_text` is the same for all 3 languages** (it's Japanese). Fill it on the `en` row; the merge process will copy it to `es` and `ru` rows.

### Examples (N5)

| word | original_text |
|---|---|
| 食べる | {毎日|まい|にち}、ごはんを{食|た}べます。 |
| 学校 | {私|わたし}は{学校|がっ|こう}に{行|い}きます。 |

## Field 2: `sentence_translated` — Translation

Translate the Japanese sentence into the target language (`lang_code`).

### Rules

1. **Natural phrasing** in the target language — not word-for-word translation.
2. **Same register** as the Japanese sentence (polite → polite, casual → casual).
3. **Spanish:** Standard neutral (Latin American generic). No regional slang.
4. **Russian:** Standard literary. No regional colloquialisms.
5. **English:** Standard American English.

### Examples

| word | lang | sentence_translated |
|---|---|---|
| 食べる | en | I eat rice every day. |
| 食べる | es | Como arroz todos los días. |
| 食べる | ru | Я каждый день ем рис. |

## CSV Formatting Rules

1. **Wrap fields containing commas in double quotes.**
2. **Double quotes inside quoted fields must be escaped** as `""`.
3. **No newlines inside fields.** Each row must be a single line.
4. **Every row must have exactly 5 columns.**
