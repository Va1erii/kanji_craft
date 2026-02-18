# AI Instructions: Vocabulary I18n (Batch)

Fill the template CSV `vocab_i18n_ai.csv` with mnemonics and search tags for vocabulary in this batch.

## CSV Format

| Column | Type | Description |
|---|---|---|
| `vocabulary_id` | read-only | Vocabulary ID |
| `word` | read-only | The word (e.g. 食べる, 学校) |
| `furigana` | read-only | Furigana notation (e.g. `{食|た}べる`) |
| `meanings_en` | read-only | English meanings JSON array |
| `lang_code` | read-only | `en`, `es`, or `ru` |
| `system_mnemonic` | **fill** | Layer 3 mnemonic story (nullable — leave empty if self-explanatory) |
| `search_tags` | **fill** | JSON array of synonyms |

Only fill `system_mnemonic` and `search_tags`. Do not modify read-only columns.

## Field 1: `system_mnemonic` — Layer 3 Mnemonic

A short story (1-2 sentences) that teaches the word's reading in context.

### Rules

1. **Focus on the word itself** — do NOT reference radicals or kanji components.
2. **Kunyomi focus:** Most vocabulary uses kunyomi (native Japanese reading). The mnemonic should help the learner connect the reading to the meaning.
3. **Write a short sentence** where a sound-alike word for the reading creates a memorable connection.
4. **A2/B1 level language.** Simple words, concrete images.
5. **Each language is independent** — different stories for EN/ES/RU.
6. **1-2 sentences max.**

### When to Skip (Leave Empty)

Set `system_mnemonic` to empty when:
- The word's meaning is self-explanatory from its kanji (e.g. 学生 = "study" + "life" = student).
- The reading is the standard kunyomi with no irregular pattern.
- Adding a mnemonic would be forced or confusing rather than helpful.

Not every word needs a mnemonic. It is better to leave it empty than to write a bad one.

### Worked Example

休む (yasumu) = to rest.

| lang | system_mnemonic |
|---|---|
| en | I will Rest. YEA, SUMO wrestlers (Ya-sumu) need rest too. |
| es | Descansar. YA, los SUMO (Ya-sumu) necesitan descansar también. |
| ru | Отдыхать. Я видел, как СУМО (Я-суму) борцы отдыхали. |

## Field 2: `search_tags` — Synonyms

A JSON array of 3-8 alternative terms a learner might search for.

### Rules

1. **JSON array format:** `["tag1", "tag2", "tag3"]`
2. **3-8 tags** per entry.
3. **Include:** alternative meanings, related concepts, usage contexts.
4. **Do NOT include** the primary meaning itself.
5. **Lowercase** all tags.
6. **Language-appropriate** — tags must be in the same language as `lang_code`.

### Examples

| word | lang | search_tags |
|---|---|---|
| 食べる | en | `["consume", "dine", "meal", "eating"]` |
| 食べる | es | `["consumir", "cenar", "comida", "alimentar"]` |

## CSV Formatting Rules

1. **Wrap fields containing commas in double quotes.**
2. **Double quotes inside quoted fields must be escaped** as `""`.
3. **`search_tags` always needs quoting** because the JSON array contains commas.
4. **No newlines inside fields.** Each row must be a single line.
5. **Every row must have exactly 7 columns.**
