# AI Enrichment

## Overview

AI Enrichment adds human-quality learning content to the structured CSVs produced by Phase 2. Phase 2 extracts facts (readings, meanings, component links) from dictionaries — Phase 3 transforms those facts into **memorable teaching material** (mnemonics, sentence translations, annotated sentences) that make the SRS experience effective.

**Note:** Vocabulary i18n localization (es/ru meanings) is fully handled in Phase 2 via `manual_localization.csv` — an AI-translated override file with 14,254 entries covering all JLPT words missing JMdict glosses. Phase 3 does **not** generate vocabulary translations; it only generates **sentence** translations (Step 6).

The phase has two distinct modes:

- **Deterministic** (Step 1): Logic hint refinement — pure onyomi comparison, no AI. Runs as a script, no review needed.
- **AI-generated** (Steps 2–6): Mnemonics, translations, furigana annotation, search tags. Generated via AI (chat, batch API, or scripts), then reviewed by the admin before proceeding to Phase 4.

**Key properties:**

- **Human-in-the-loop:** Every AI-generated field is reviewed by the admin before upload. The pipeline does not auto-promote AI output to Phase 4.
- **Layer ordering:** Radical names (Step 2) must be finalized before kanji mnemonics (Step 3), because kanji stories reference radical names.
- **Batch by JLPT level:** N5 first (beginner content = highest priority), then N4, N3, N2, N1.

## Source Data

| Source | Used in | Purpose |
|---|---|---|
| `kanji_components.csv` | Step 1 | Rows to refine `logic_hint` |
| `kanjidic.parquet` | Steps 1, 2 | Onyomi lookup for kanji and radical master symbols; KANJIDIC meanings for radical names |
| `radicals.csv` | Steps 1, 2 | `master_symbol` → onyomi lookup; radical identity for i18n creation |
| `kanji.csv` | Steps 1, 3 | `character` → onyomi lookup; kanji identity for mnemonic context |
| `kanji_readings.csv` | Step 1 | Onyomi readings for kanji (alternative to `kanjidic.parquet` lookup) |
| `kanji_i18n.csv` | Step 3 | Rows to enrich with `system_mnemonic` and `search_tags` |
| `vocabulary_i18n.csv` | Step 4 | Rows to enrich with `system_mnemonic` and `search_tags` |
| `vocabulary_sentences.csv` | Step 5 | Rows to annotate `original_text` with furigana notation |
| `vocabulary_sentence_i18n.csv` | Step 6 | Existing English rows; target for new ES/RU translations |
| `jmdict_furigana.parquet` | Step 5 | Pre-computed per-character furigana mappings for sentence annotation |
| `kanji.csv` | Step 5 | Known kanji set for identifying kanji characters in sentences |

## Prerequisites

All conditions must hold before this phase runs:

1. **Phase 2 complete** — All Phase 2 sub-phases (2.1 through 2.5) have finished. All CSV files in `data/csv/` are populated with their Phase 2 content.
2. **Parquet files available** — `kanjidic.parquet` and `jmdict_furigana.parquet` from Phase 1 are present in `data/parquet/`.

## Batching Strategy

Content is processed in JLPT-level batches, ordered from easiest to hardest:

```
N5 → N4 → N3 → N2 → N1 → ungraded
```

**Why this order:**

- N5 is beginner content — highest priority for initial release.
- Each batch is a manageable review unit for the admin.
- Incremental release is possible: upload N5 content while N4 is still in review.

**Within each JLPT level:**

- Radicals are processed before kanji (Layer 1 names must exist before Layer 2 stories).
- Kanji are ordered by frequency rank (most common first).
- Vocabulary follows after kanji mnemonics are stable.

**Batch size considerations:**

| JLPT Level | Approx. kanji | Approx. radicals | Approx. vocabulary |
|---|---|---|---|
| N5 | ~80 | ~100–150 | ~700 |
| N4 | ~170 | ~50–80 (incremental) | ~600 |
| N3 | ~370 | ~80–120 (incremental) | ~1,800 |
| N2 | ~380 | ~60–90 (incremental) | ~2,500 |
| N1 | ~1,200 | ~100–150 (incremental) | ~2,500 |

Radical counts are incremental — many radicals are shared across levels. A radical is assigned to the batch of its `min_jlpt_level`.

## Step 1: Logic Hint Refinement (Deterministic)

**Target:** `kanji_components.csv` → `logic_hint` field

**This is the only fully deterministic step.** No AI is needed — it compares onyomi readings using data already available in the pipeline. It can run as a standalone script before any AI generation begins.

### Permissive Heuristic

The algorithm uses a **permissive** matching strategy: if *any* kanji onyomi matches *any* radical onyomi, the hint is set to `phonetic`. This is deliberately broad.

- **Benefit:** Catches obscure phonetic connections, including historical sound shifts where the etymological link is real but non-obvious to modern learners.
- **Risk:** False positives. A radical with 4 readings and a kanji with 3 readings have a statistical chance of coincidental overlap that isn't etymologically motivated.
- **V1 verdict:** Permissive is better for learning. It is more helpful to tell the user "this sound matches!" (a useful hint even if coincidental) than to miss a valid phonetic clue. False positives still aid memorization — the sound *does* match, giving the learner a hook regardless of etymology.

### Algorithm

For each row in `kanji_components.csv`:

1. **Get kanji onyomi:** Look up all onyomi readings for `kanji_id` (from `kanji_readings.csv` where `reading_type = onyomi`, or from `kanjidic.parquet`).
2. **Get radical onyomi:** Look up the radical's `master_symbol` from `radicals.csv`, then find all onyomi readings for that character in `kanjidic.parquet` (treating the master symbol as a kanji character for lookup purposes).
3. **Compare:**
   - If **any** kanji onyomi matches **any** radical onyomi → set `logic_hint = phonetic`.
   - If no onyomi match → keep `logic_hint = semantic` (the Phase 2 default).
4. **Radicals without KANJIDIC entries:** If the radical's `master_symbol` has no entry in `kanjidic.parquet` (e.g., a rare component or custom radical), it cannot contribute a phonetic reading. Keep `logic_hint = semantic`.

### Position-Based Heuristic (Secondary)

When onyomi comparison is inconclusive or as a validation cross-check, position predicts the likely role:

| Structure | Semantic (meaning) position | Phonetic (sound) position | Example |
|---|---|---|---|
| Left-Right (⿰) | Left (`hen`) | Right (`tsukuri`) | 江: 氵 Water + 工 KOU → reading KOU |
| Top-Bottom (⿱) | Top (`kanmuri`) | Bottom (`ashi`) | 花: 艹 Grass + 化 KA → reading KA |
| Enclosure (⿴) | Outside (`kamae`) | Inside | 聞: 門 Gate + 耳 ear → reading MON |

**Usage:** The position heuristic is informational — it can flag rows where onyomi comparison and position disagree (e.g., onyomi says `phonetic` but position is `hen`). These conflicts are logged as warnings for admin review but the onyomi comparison result takes precedence.

### Worked Example

Kanji 清 (SEI) with components:
- 水 (radical, position: `hen`) — onyomi: スイ. Does not match SEI → `semantic`.
- 青 (radical, position: `tsukuri`) — onyomi: セイ, ショウ. セイ matches SEI → `phonetic`.

Result: 水 stays `semantic`, 青 becomes `phonetic`. Position heuristic agrees (left=semantic, right=phonetic).

### Edge Cases

- **Radical has multiple onyomi:** Any match is sufficient. 生 has onyomi セイ and ショウ — if the kanji reads セイ, it's a match.
- **Kanji has multiple onyomi:** Check each kanji onyomi against each radical onyomi. Any pair match → `phonetic`.
- **Kanji with no onyomi:** Rare native-Japanese kanji (e.g., 畑) may lack onyomi entirely. All components stay `semantic`.
- **Same radical is phonetic in one kanji and semantic in another:** This is expected and correct. 亡 is phonetic in 忙 (BOU matches) but semantic in 死 (no onyomi match).

## Step 2: Radical I18n Creation (AI + KANJIDIC)

**Target:** `radical_i18n.csv` — **created entirely in Phase 3**

Phase 2 does not produce `radical_i18n.csv` content (radical extraction registers the radical identity but not its localized name or mnemonic). This step creates all rows.

### Fields

| Field | Source | Description |
|---|---|---|
| `radical_id` | `radicals.csv` | FK to the radical |
| `lang_code` | Pipeline config | `en`, `es`, `ru` |
| `name` | KANJIDIC + AI | Localized name — a single concrete noun (see §Naming Rules) |
| `system_mnemonic` | AI | Layer 1 mnemonic — visual keyword + physical shape description |
| `search_tags` | AI | Synonyms and alternative terms per language |

### Naming Rules

1. **English seed:** Look up the radical's `master_symbol` in `kanjidic.parquet`. Use the first English meaning as the seed name (e.g., 水 → "Water", 木 → "Tree").
2. **No KANJIDIC entry:** If the radical's `master_symbol` has no KANJIDIC entry (custom radical), the name must be AI-generated based on visual shape resemblance.
3. **Single concrete noun:** Names must be a single concrete noun — "Water", not "water radical" or "liquid element".
4. **ES/RU names:** AI-translated or AI-generated from the English name. Must follow the same single-noun rule. ES: "Agua". RU: "Вода".
5. **Radical-kanji name consistency:** When a radical's `master_symbol` is also a kanji character (dual identity — see [radical.md rule #10](../domain/radical.md)), the radical name **must** match the kanji's primary meaning. If radical 州 = "River" but kanji 州 = "Province", the user's brain breaks when they see 州 in a compound. Verify against `kanji_i18n.csv` meanings.

### Layer 1 Mnemonic Rules

From [mnemonic.md §Layer 1](../domain/mnemonic.md):

- **Goal:** Teach the radical's visual shape and meaning keyword.
- **Formula:** Visual keyword (prefer official meaning > visual shape resemblance).
- **Story must describe the shape physically** — e.g., "Two legs walking forward" for 人. Do NOT use "See X as Y" phrasing.
- **A2 level language** — simple, common words. No technical or abstract vocabulary.
- **Each language independent** — stories may differ across EN/ES/RU to fit natural phrasing.

### Search Tags

AI generates 3–8 synonyms per language. Examples:
- 水 (Water) EN: `["liquid", "splash", "ocean", "rain", "flow"]`
- 水 (Water) ES: `["líquido", "río", "lluvia", "fluir"]`
- 水 (Water) RU: `["жидкость", "река", "дождь", "поток"]`

Tags should include alternative meanings, related concepts, and common associations that a learner might search for.

### Output

Creates `radical_i18n.csv` with one row per radical per language (3 rows per radical for EN/ES/RU).

**Expected count:** ~600–700 radicals × 3 languages = ~1,800–2,100 rows.

## Step 3: Kanji I18n Enrichment (AI)

**Target:** `kanji_i18n.csv` → `system_mnemonic` and `search_tags` fields (exist but empty from Phase 2)

Phase 2 creates `kanji_i18n.csv` rows with `meanings` populated from KANJIDIC, but `system_mnemonic` and `search_tags` are left empty. This step fills them.

### Layer 2 Mnemonic Rules

From [mnemonic.md §Layer 2](../domain/mnemonic.md):

- **Goal:** Link radical keywords to kanji meaning via an onyomi sound anchor.
- **Formula:** `[Radical 1] + [Radical 2] = [Meaning]. [Sound anchor story.]`
- **Must use radical names from Step 2** (Layer 1 names) — never invent new names for components.
- **Prioritize onyomi** (90% rule: most compound words use onyomi — learning it here unlocks thousands of words).
- **Include a sound-alike word** for the onyomi from the language's sound anchor table.
- **Do NOT mention kunyomi** — that belongs in Layer 3 (vocabulary).
- **Each language independent** — different sound anchors per language.

### Sound Anchor Tables

Once a sound anchor is chosen for an onyomi in a given language, it must be reused consistently across all kanji with that reading. The tables below are the canonical anchors. Use the "Best Anchor" first; only use the "Alternative" if it fits the story context significantly better.

**English:**

| Onyomi | Best Anchor | Alternative |
|---|---|---|
| CHUU | Chew (gum) | Choo-choo (train) |
| SHUU | Shoes | Shoot (gun/camera) |
| KOU | Coat | Comb, Cone |
| KAN | Can (soda) | Khan (Genghis) |
| SEI | Saber (sword) | Saint (halo) |
| KAI | Kite | Coyote |
| SHIN | Shin (leg) | Chin |
| TOU | Toe | Toast (burnt bread) |
| KYUU | Cucumber | Cube (ice/Rubik's) |
| JYUU | Jewel | Juice (spill it) |
| GYOU | Gyoza (dumpling) | Ghoul (monster) |
| GYUU | Guitar | Glue (sticky) |
| GAN | Gun | Gong (loud sound) |
| JIN | Genie (lamp) | Jeans (clothing) |
| DOU | Donut | Door, Dough |
| GOU | Goat | Ghost, Goal |

**Spanish:**

| Onyomi | Best Anchor | Alternative |
|---|---|---|
| CHUU | Chupete (pacifier) | Chuleta (chop/steak) |
| SHUU | Sumo (wrestler) | Sudor (sweat) |
| KOU | Cola (glue/tail) | Coco (coconut) |
| KAN | Candado (lock) | Canguro (kangaroo) |
| SEI | Seis (6) | Sello (stamp) |
| KAI | Caimán (gator) | Caída (falling) |
| SHIN | Chinchilla | Chinche (thumbtack) |
| TOU | Toro (bull) | Torre (tower) |
| KYUU | Cubo (bucket) | Cuna (crib) |
| JYUU | Lluvia (rain) | Yudo (judo) |
| GYOU | Guillotina | Guiñol (puppet) |
| GYUU | Guitarra | Guinda (cherry) |
| GAN | Gancho (hook) | Ganso (goose) |
| JIN | Jinete (rider) | Ginebra (gin bottle) |
| DOU | Dominó | Dorado (gold object) |
| GOU | Goma (eraser) | Gorra (cap) |

**Russian:**

| Onyomi | Best Anchor | Alternative |
|---|---|---|
| CHUU | Чучело (scarecrow) | Чупа-чупс (lollipop) |
| SHUU | Шуба (fur coat) | Шут (jester) |
| KOU | Кот (cat) | Кол (stake) |
| KAN | Канат (rope) | Кан (jerrycan) |
| SEI | Сейф (safe) | Сейлор (Sailor Moon) |
| KAI | Кай (Snow Queen) | Гайка (nut/bolt) |
| SHIN | Шина (tire) | Шило (awl) |
| TOU | Торт (cake) | Топор (axe) |
| KYUU | Кювет (ditch) | Клюв (beak) |
| JYUU | Жук (beetle) | Журавль (crane) |
| GYOU | Гёза (gyoza) | Герб (coat of arms) |
| GYUU | Гюйс (naval jack) | Гюрза (viper) |
| GAN | Гантель (dumbbell) | Гангстер (gangster) |
| JIN | Джин (genie) | Джинсы (jeans) |
| DOU | Дом (house) | Доска (board) |
| GOU | Гора (mountain) | Гонг (gong) |

These tables grow as new onyomi patterns are encountered. Rules:
- Never use abstract words as anchors.
- Once an anchor is chosen for a sound in a given language, reuse it consistently. Exceptions are allowed when the alternative makes a significantly better story, but prefer consistency.

### Worked Example

Kanji 休 (Rest) = 人 (Person) + 木 (Tree). Primary onyomi: KYUU.

**English:** "A Person leans on a Tree to Rest. He uses a Cucumber (KYUU) as a pillow."
- Uses radical names from Step 2: "Person" (人), "Tree" (木)
- Sound anchor: Cucumber for KYUU
- Does not mention kunyomi やす(む)

**Spanish:** "Una Persona se apoya en un Árbol para Descansar. Usa un Cubo (KYUU) como almohada."
- Radical names: "Persona" (人), "Árbol" (木)
- Sound anchor: Cubo for KYUU

**Russian:** "Человек прислонился к Дереву, чтобы Отдохнуть. Он упал в Кювет (KYUU) и заснул."
- Radical names: "Человек" (人), "Дерево" (木)
- Sound anchor: Кювет for KYUU

### Critical Rule: Radical-Kanji Name Consistency

When a radical is also a kanji (like 木, 力, 山), the radical keyword **must** match the kanji meaning. The kanji mnemonic must use the same name that was assigned in Step 2. If the radical name for 木 is "Tree", then every kanji mnemonic referencing 木 must say "Tree" — never "Wood" or "Timber".

### Search Tags

AI generates 3–8 synonyms per language. Examples:
- 休 (Rest) EN: `["break", "holiday", "pause", "vacation", "relax"]`
- 休 (Rest) ES: `["descanso", "pausa", "vacaciones", "relajar"]`

Tags should include alternative meanings, related concepts, and study-relevant associations.

### Output

Updates `kanji_i18n.csv` — fills `system_mnemonic` and `search_tags` on existing rows.

## Step 4: Vocabulary I18n Enrichment (AI)

**Target:** `vocabulary_i18n.csv` → `system_mnemonic` and `search_tags` fields (exist but empty from Phase 2)

### Layer 3 Mnemonic Rules

From [mnemonic.md §Layer 3](../domain/mnemonic.md):

- **Goal:** Teach the actual word reading (often kunyomi) in context.
- **Formula:** Kanji meaning + context sentence + native reading.
- **Focus on the word itself** — do NOT mention radicals.
- **Write a short sentence** where the mnemonic explains the reading.
- **`system_mnemonic` is nullable** — skip self-explanatory words. Not every vocabulary word benefits from a mnemonic. Words whose meaning is obvious from their kanji composition (e.g., 学校 = "study" + "school" = School) can be left null.
- **Kunyomi is context-heavy** — it pairs with hiragana (like 食べる). The vocabulary card provides that context naturally.

### Worked Example

休む (yasumu) = to rest.
- **EN:** "I will Rest. YEA, SUMO wrestlers (Ya-sumu) need rest too."
- **ES:** "Descansar. YA, los SUMO (Ya-sumu) necesitan descansar también."
- **RU:** "Отдыхать. Я видел, как СУМО (Я-суму) борцы отдыхали."

### When to Skip

Set `system_mnemonic = null` (or empty string, matching the Phase 2 default) when:
- The word's meaning is self-explanatory from its kanji (e.g., 学生 = student).
- The reading is the standard kunyomi with no irregular pattern.
- Adding a mnemonic would be forced or confusing rather than helpful.

The admin reviews and may add mnemonics to words initially skipped if learner feedback indicates they're needed.

### Search Tags

AI generates 3–8 synonyms per language. Examples:
- 食べる (to eat) EN: `["consume", "dine", "meal", "eating"]`
- 食べる (to eat) ES: `["consumir", "cenar", "comida", "alimentar"]`

### Output

Updates `vocabulary_i18n.csv` — fills `system_mnemonic` and `search_tags` on existing rows.

## Step 5: Sentence Furigana Annotation (AI + JmdictFurigana)

**Target:** `vocabulary_sentences.csv` → `original_text` field

Phase 2 stores `original_text` as plain Japanese text (from the Tanaka Corpus). This step adds `{kanji|reading}` pipe-delimited notation so the client can render furigana and Ghost Kanji in sentences.

### Algorithm

For each `vocabulary_sentences.csv` row:

1. **Tokenize** the Japanese sentence into morphemes using a morphological analyzer. Japanese has no word-boundary whitespace, so regex splitting is insufficient — a proper tokenizer is required. **Recommended: SudachiPy** (`sudachi_dict_small`) — handles compound verb conjugations more accurately than MeCab and integrates well with the Python pipeline.
2. **For each token containing kanji:**
   - Look up the token's dictionary form in `jmdict_furigana.parquet` for pre-computed per-character readings.
   - If found: construct `{kanji|reading}` notation using the same rules as vocabulary furigana (see [vocabulary.md §Furigana Notation](../domain/vocabulary.md#furigana-notation)). For conjugated forms, the tokenizer provides the surface reading — use that instead of the dictionary-form reading.
   - If not found: use AI to determine the reading and construct the notation.
3. **Kana-only tokens** remain as plain text (no braces).
4. **Validation:** Stripping all `{`, `|`, `}` and reading portions must reproduce the original plain-text sentence.

### Furigana Rules

Same notation as vocabulary furigana (see [ph2_5 §Step 2](ph2_5_vocabulary_extraction.md)):

- Single kanji: `{食|た}べる`
- Compound per-character: `{学生|がく|せい}`
- Jukujikun: `{大人|おとな}` (1 reading, multiple kanji → single ruby span)
- Each `{...}` group must have at least one reading
- Reading count must equal kanji character count (per-character) or be exactly 1 (jukujikun)

### Why AI is Needed

Sentence furigana is harder than word furigana because:
- **Context-dependent readings:** 今日 reads きょう in most contexts but こんにち in こんにちは. The correct reading depends on the sentence.
- **Verb conjugations:** 食べました has the root 食 reading た, but the conjugated form changes the surrounding kana.
- **Proper nouns:** Names in sentences may have unusual readings not in JmdictFurigana.

`jmdict_furigana.parquet` provides readings for dictionary forms. AI fills the gaps for conjugated forms, context-dependent readings, and words not in the dataset.

### Output

Updates `vocabulary_sentences.csv` — replaces plain-text `original_text` with furigana-annotated text.

## Step 6: Sentence Translation (AI)

**Target:** `vocabulary_sentence_i18n.csv` → new ES and RU rows

Phase 2 creates English sentence translations from the Tanaka Corpus. This step adds Spanish and Russian translations via AI.

### Algorithm

For each `vocabulary_sentences.csv` row that has an English translation in `vocabulary_sentence_i18n.csv`:

1. **Input:** The English `sentence_translated` text.
2. **Generate:** AI translates English → Spanish and English → Russian.
3. **Write:** Two new `vocabulary_sentence_i18n.csv` rows:
   - `(vocabulary_sentence_id, 'es', spanish_translation)`
   - `(vocabulary_sentence_id, 'ru', russian_translation)`

### Translation Rules

- Translate from English (not from Japanese) — the English translation is already verified from the Tanaka Corpus.
- Maintain the same register and tone as the English sentence.
- Use standard neutral Spanish (Latin American generic) and standard literary Russian — no regional slang or colloquialisms.
- Preserve sentence structure where natural in the target language; restructure for fluency when needed.

### Output

Appends new rows to `vocabulary_sentence_i18n.csv` — one ES and one RU row per sentence.

**Unique key:** `(vocabulary_sentence_id, lang_code)` — prevents duplicate translations.

## Mnemonic Rules Summary

Consolidated rules from [mnemonic.md](../domain/mnemonic.md) that apply across all steps:

### Language Rules

| Language | Register | Notes |
|---|---|---|
| English | CEFR A2/B1 | Simple, common words. Prefer physical actions (hit, run, eat) over abstract language |
| Spanish | Standard neutral (Latin American generic) | No regional slang |
| Russian | Standard literary | No regional colloquialisms |

### Independence Rule

Each language has its own sound anchors and mnemonics. "KYUU-cumber" works in English but not in Russian — each language must find native words that sound like the target reading. Stories will differ across languages.

### Consistency Rules

1. **Sound anchor consistency:** Once chosen for an onyomi in a language, reuse across all kanji. See §Sound Anchor Tables above.
2. **Radical-kanji name consistency:** When a radical is also a kanji, the keyword must match across Layer 1 (radical name) and Layer 2 (kanji mnemonic component reference).
3. **Layer ordering:** Radical names (Layer 1) → kanji mnemonics (Layer 2) → vocabulary mnemonics (Layer 3). Each layer builds on the previous.
4. **No abstract anchors:** Sound anchors must be concrete, physical, visual objects or actions — never abstract concepts.

### Layer Summary

| Layer | Step | What it teaches | Formula | Target |
|---|---|---|---|---|
| 1 (Radical) | Step 2 | Shape + meaning | Visual keyword (concrete noun) | `radical_i18n.system_mnemonic` |
| 2 (Kanji) | Step 3 | Components + onyomi | Radical keywords + sound anchor = meaning | `kanji_i18n.system_mnemonic` |
| 3 (Vocabulary) | Step 4 | Usage + actual reading | Kanji meaning + context + reading | `vocabulary_i18n.system_mnemonic` (nullable) |

## Admin Review Workflow

Phase 3 is the human-in-the-loop checkpoint. The admin reviews AI output before it proceeds to Phase 4 (Verification & Upload).

### Review process

1. **Step 1 output (logic hints):** Deterministic — run the script, spot-check a sample of `phonetic` assignments against known phono-semantic compounds. No full review needed.
2. **Step 2 output (radical i18n):** Review all radical names for accuracy and consistency. This is the foundation — errors here cascade into kanji mnemonics.
3. **Step 3 output (kanji i18n):** Review mnemonics for correct radical name usage, sound anchor consistency, and story quality.
4. **Step 4 output (vocabulary i18n):** Review mnemonics where present. Verify that skipped words (null mnemonic) are genuinely self-explanatory.
5. **Step 5 output (sentence furigana):** Validate a sample of annotated sentences. Check that context-dependent readings are correct.
6. **Step 6 output (sentence translations):** Review ES/RU translations for accuracy and natural phrasing.

### Review tools

The review can happen in any tool the admin prefers:
- Direct CSV editing (spreadsheet or text editor)
- Script-based validator that flags common issues
- Local Supabase UI for browsing and editing
- Custom review dashboard

### Iteration

If the admin rejects content, the AI regeneration step is re-run for the affected rows only. The pipeline supports partial re-enrichment — unchanged rows are not reprocessed.

## Warnings

Warnings are written to `data/csv/warnings/ph3_warnings.csv` with columns: `severity, phase, entity, message`.

| Condition | Severity | Rationale |
|---|---|---|
| Onyomi comparison and position heuristic disagree on `logic_hint` | medium | May indicate an unusual phono-semantic pattern — admin should verify |
| Radical `master_symbol` not found in `kanjidic.parquet` (Step 1) | low | Custom radical with no KANJIDIC entry — `logic_hint` stays `semantic` |
| Radical name differs from kanji meaning for dual-identity character | high | Radical-kanji name consistency violation — must be resolved before Step 3 |
| Sound anchor inconsistency (same onyomi, different anchor in same language) | high | Breaks memorability — all kanji with the same onyomi should use the same anchor word |
| Sentence furigana validation failure (stripped text doesn't match original) | high | Notation error — the annotated sentence doesn't reconstruct to the original text |
| Missing radical i18n row for a language | high | Every radical must have i18n for all 3 languages (EN/ES/RU) |
| Kanji mnemonic references a radical name not matching Step 2 output | high | Layer consistency violation — mnemonic uses a different word than the radical's assigned name |
| Vocabulary mnemonic mentions radical names | medium | Layer 3 should focus on the word itself, not radicals |

## Validation Invariants

Before proceeding to Phase 4, the following completeness checks must pass for each JLPT level being uploaded:

### Radical completeness

- Every radical with `min_jlpt_level` in the batch has `radical_i18n` rows for all 3 languages (EN, ES, RU).
- Every `radical_i18n` row has a non-empty `name`.
- Every `radical_i18n` row has a non-empty `system_mnemonic`.
- Every `radical_i18n` row has a non-empty `search_tags` array.

### Kanji completeness

- Every kanji in the batch has `kanji_i18n` rows for all 3 languages.
- Every `kanji_i18n` row has a non-empty `system_mnemonic`.
- Every `kanji_i18n` row has a non-empty `search_tags` array.
- Every `kanji_components` row has a non-default `logic_hint` (i.e., Step 1 has been applied — though the value may still be `semantic` if onyomi don't match).

### Vocabulary completeness

- Every vocabulary in the batch has `vocabulary_i18n` rows for all 3 languages. (EN from JMdict, ES/RU from JMdict + `manual_localization.csv` in Phase 2.)
- Every `vocabulary_i18n` row has a non-empty `search_tags` array.
- `system_mnemonic` may be null (intentionally skipped) — no completeness check on this field.

### Sentence completeness

- Every `vocabulary_sentences` row in the batch has furigana-annotated `original_text` (contains at least one `{...}` group, unless the sentence is pure kana).
- Every `vocabulary_sentences` row has `vocabulary_sentence_i18n` rows for all 3 languages (EN, ES, RU).

### Cross-layer consistency

- Every radical name referenced in a kanji `system_mnemonic` matches the `radical_i18n.name` for that language.
- Every sound anchor used in kanji mnemonics is consistent within the batch (same onyomi → same anchor word per language).

## Output Summary

| File | Action | Step | Description |
|---|---|---|---|
| `kanji_components.csv` | Updated | Step 1 | `logic_hint` refined from default `semantic` to `phonetic` where onyomi match |
| `radical_i18n.csv` | **Created** | Step 2 | New file — radical names, Layer 1 mnemonics, search tags for EN/ES/RU |
| `kanji_i18n.csv` | Updated | Step 3 | `system_mnemonic` and `search_tags` populated on existing rows |
| `vocabulary_i18n.csv` | Updated | Step 4 | `system_mnemonic` (nullable) and `search_tags` populated on existing rows |
| `vocabulary_sentences.csv` | Updated | Step 5 | `original_text` annotated with `{kanji\|reading}` furigana notation |
| `vocabulary_sentence_i18n.csv` | Updated | Step 6 | New ES and RU rows appended for each sentence |

**Warning file:** `data/csv/warnings/ph3_warnings.csv`

## Ordering Constraints

Phase 3 sits between Phase 2 (extraction) and Phase 4 (verification & upload). Within Phase 3, steps have internal dependencies:

```
Phase 2 (all sub-phases complete)
    |
    v
Step 1: Logic Hint Refinement (deterministic — can run immediately)
    |
    v
Step 2: Radical I18n Creation (Layer 1 names — foundation for Steps 3-4)
    |
    v
Step 3: Kanji I18n Enrichment (Layer 2 — depends on radical names from Step 2)
    |
    v
Step 4: Vocabulary I18n Enrichment (Layer 3 — independent of Steps 2-3 but ordered for review flow)
    |
Step 5: Sentence Furigana Annotation (independent of Steps 2-4 — can run in parallel)
    |
Step 6: Sentence Translation (independent of Steps 2-4 — can run in parallel)
    |
    v
Admin Review (all steps)
    |
    v
Phase 4: Verification & Upload
```

**Parallelizable:** Steps 5 and 6 have no dependency on Steps 2–4 and can run in parallel with them. Step 1 has no dependency on any other step and can run first.

**Sequential:** Step 2 → Step 3 is strictly ordered (kanji mnemonics reference radical names). Step 3 → Step 4 is recommended for review flow but not technically required (vocabulary mnemonics don't reference kanji mnemonics).

## Related Docs

### Domain specs

- [mnemonic.md](../domain/mnemonic.md) — Mnemonic Lego Stack theory, sound anchor tables, consistency rules
- [radical.md](../domain/radical.md) — Radical and RadicalI18n entity spec
- [kanji.md](../domain/kanji.md) — Kanji and KanjiI18n entity spec
- [kanji_component.md](../domain/kanji_component.md) — KanjiComponent entity spec, LogicHint enum
- [vocabulary.md](../domain/vocabulary.md) — Vocabulary, VocabularyI18n, VocabularySentence entity specs, furigana notation

### Pipeline docs

- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phases 1–4)
- [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md) — Radical registration (produces `radicals.csv`)
- [ph2_2_kanji_composition.md](ph2_2_kanji_composition.md) — Kanji creation (produces `kanji_i18n.csv` with empty mnemonic fields)
- [ph2_3_component_linking.md](ph2_3_component_linking.md) — Component linking (produces `kanji_components.csv` with default `logic_hint`)
- [ph2_5_vocabulary_extraction.md](ph2_5_vocabulary_extraction.md) — Vocabulary extraction (produces `vocabulary_i18n.csv`, `vocabulary_sentences.csv`, `vocabulary_sentence_i18n.csv`)

### Source format docs

- [kanjidic_format.md](../sources/kanjidic_format.md) — KANJIDIC2 XML structure (onyomi readings, meanings)
- [jmdict_furigana_format.md](../sources/jmdict_furigana_format.md) — JmdictFurigana JSON format (sentence furigana lookups)
