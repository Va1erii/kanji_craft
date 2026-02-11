# Supabase — Context

## CLI

Installed globally via brew. No `npx` needed.

```bash
supabase migration new <name>     # Create timestamped migration in supabase/migrations/
supabase db reset                 # Drop and recreate local DB with all migrations
supabase start / stop             # Local Supabase instance
```

## Migration Conventions

- One concern per migration file
- Descriptive snake_case name: `add_position_to_kanji_components`, `make_radical_deferred_fields_nullable`
- Constraint naming: `chk_` (check), `uq_` (unique), `fk_` (foreign key)
- Trigger naming: `trg_{table}_updated_at`
- Index naming: `idx_{table}_{column(s)}`
- Use `ON CONFLICT DO NOTHING` for idempotent storage operations
- `config.toml` declares the `svg` storage bucket

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
import_source:       kanjivg, kanjidic, jmdict
import_status:       pending, ingested, processing, processed, failed
verification_status: draft, verified, flagged
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
         └── kanji_component_reviews (kanji_component_id)

vocabulary
  ├── vocabulary_readings   (vocabulary_id)
  ├── vocabulary_i18n       (vocabulary_id)
  ├── vocabulary_kanji      (vocabulary_id, kanji_id)
  └── vocabulary_sentences  (vocabulary_id)

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
- `kanji.svg_*`: NOT NULL (content tables hold complete rows; pipeline staging is separate)
- `vocabulary_sentences.verification_status`: column directly on the row (no separate review table for sentences)

### Propagation Triggers

Child table changes bump parent `updated_at` so Release Builder detects updates:
- `kanji_readings`, `kanji_i18n`, `kanji_components` → bump `kanji.updated_at`
- `radical_i18n`, `radical_variants` → bump `radicals.updated_at`
- `vocabulary_readings`, `vocabulary_i18n`, `vocabulary_kanji`, `vocabulary_sentences` → bump `vocabulary.updated_at`

### RLS Strategy

- **Public content tables** (radicals, kanji, vocabulary + children): `SELECT` for `authenticated`
- **User tables** (srs_cards, user_mnemonics, review_logs): row-level `user_id = auth.uid()`
- **Admin tables** (data_imports, raw_*, kanji_component_reviews): RLS enabled with **zero policies** — only `service_role` key can access
- **Storage** (`svg` bucket): public read, no authenticated write (admin uploads via service_role)

## Migration History

| Migration | What it does |
|---|---|
| `20260207095218` | Initial schema (all 21 tables, enums, triggers, indexes) |
| `20260207095228` | RLS policies |
| `20260207095238` | Storage bucket (`svg`) |
| `20260207113007` | GIN indexes for search_tags |
| `20260207113853` | Fix set_updated_at search_path |
| `20260208071813` | Staging enums/tables + position on kanji_components |
| `20260208071859` | Staging RLS policies |
| `20260208104400` | Fix grade range constraints (1-8 instead of 1-6) |
| `20260208111953` | Add jmdict to import_source enum |
| `20260208112001` | Add verification_status to vocabulary_sentences |
| `20260209010820` | Remove promoted status from import_status |
| `20260209044442` | Propagation triggers (child→parent updated_at) |
| `20260209233509` | Fix search_path on propagation triggers |
| `20260209235740` | Optimize RLS with auth.uid() caching |
| `20260210123515` | Add radical_type enum + column + is_primary generated column |
| `20260210150814` | Make radical deferred fields nullable (SVG + metadata) |
| `20260211015427` | source_jlpt_levels table |
| `20260211060339` | Revert radical/variant nullable fields to NOT NULL |
