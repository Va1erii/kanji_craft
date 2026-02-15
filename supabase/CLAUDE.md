# Supabase — Context

## CLI

Installed globally via brew. No `npx` needed.

```bash
supabase start / stop             # Local Supabase instance
```

## Schema Overview

### Enums

```sql
position_type:       hen, tsukuri, kanmuri, ashi, kamae, tare, nyo, unknown
item_type:           radical, kanji, vocabulary
reading_priority:    primary, secondary
reading_type:        onyomi, kunyomi
logic_hint:          semantic, phonetic
radical_type:        general, tradit, nelson, jis, component
card_state:          new_card, learning, review, relearning
rating:              again, hard, good, easy
auth_provider:       email, google, apple, facebook
study_path:          jlpt, grade
pos_tag:             ichidan_verb, godan_verb, suru_verb, kuru_verb, transitive,
                     intransitive, i_adjective, na_adjective, no_adjective, noun,
                     adverb, pronoun, particle, counter, conjunction, interjection,
                     expression, prefix, suffix
misc_tag:            usually_kana, usually_kanji, exclusively_kana, exclusively_kanji,
                     polite, humble, honorific, colloquial, slang, archaism,
                     onomatopoeia, yojijukugo, idiomatic, abbreviation, proverb,
                     irregular_verb, ateji, rare, sensitive, vulgar
```

### Table Dependencies (FK order for sync)

```
radicals
  ├── radical_i18n          (radical_id)
  ├── radical_variants      (radical_id)
  └──┐
kanji │
  ├── kanji_readings        (kanji_id)
  ├── kanji_i18n            (kanji_id)
  └──┐
     └── kanji_components   (kanji_id, radical_id)

vocabulary
  ├── vocabulary_readings   (vocabulary_id)
  ├── vocabulary_i18n       (vocabulary_id)
  ├── vocabulary_kanji      (vocabulary_id, kanji_id)
  └── vocabulary_sentences  (vocabulary_id)
      └── vocabulary_sentence_i18n (vocabulary_sentence_id)

users (UUID, references auth.users)
  ├── user_settings         (user_id, 1:1)
  ├── srs_cards             (user_id, polymorphic item_type+item_id)
  │   └── review_logs       (card_id, append-only)
  └── user_mnemonics        (user_id, polymorphic item_type+item_id)
```

### Key Schema Facts

- `users.id` is UUID referencing `auth.users(id)`, not BIGINT
- `srs_cards`, `user_mnemonics`: polymorphic FKs via `item_type` + `item_id`, no DB FK on `item_id`
- `review_logs`: append-only, no `updated_at`, no UPDATE/DELETE RLS
- `srs_cards.difficulty`: 0-10 range (0 = new card sentinel)
- `kanji_components.is_primary`: `GENERATED ALWAYS AS (radical_type = 'general') STORED`
- `vocabulary.pos_tags`: JSONB array of pos_tag enum values for grammar badges
- `vocabulary.misc_tags`: JSONB array of misc_tag enum values for register/orthography/style
- `vocabulary.field_tags`: JSONB array of strings (raw JMdict field codes)
- `vocabulary.dialect_tags`: JSONB array of strings (raw JMdict dialect codes)
- `vocabulary_sentences.original_text`: Japanese sentence with `{kanji|reading}` inline furigana

### Propagation Triggers

Child table changes bump parent `updated_at` so sync detects updates:
- `kanji_readings`, `kanji_i18n`, `kanji_components` → bump `kanji.updated_at`
- `radical_i18n`, `radical_variants` → bump `radicals.updated_at`
- `vocabulary_readings`, `vocabulary_i18n`, `vocabulary_kanji`, `vocabulary_sentences` → bump `vocabulary.updated_at`
- `vocabulary_sentence_i18n` → bump `vocabulary_sentences.updated_at`

### RLS Strategy

- **Public content tables** (radicals, kanji, vocabulary + children): `SELECT` for `authenticated`
- **User tables** (srs_cards, user_mnemonics, review_logs): row-level `user_id = auth.uid()`
- **Storage** (`svg` bucket): public read, no authenticated write (pipeline uploads via service_role)

## Notes

- Migrations were deleted (Feb 2026) — schema will be recreated from entity specs when needed
- `config.toml` declares the `svg` storage bucket
- Pipeline uses service_role key (bypasses RLS for content table operations)
