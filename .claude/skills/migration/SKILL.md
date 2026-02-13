---
name: migration
description: Generates Supabase migration SQL files from entity docs. Use when the user runs /migration.
---

# Migration Skill

Generate Supabase PostgreSQL migration files by translating entity specs from `docs/domain/` into SQL.

## Arguments

- `/migration <scope>` — Describe what to migrate (e.g. `/migration initial schema`, `/migration add vocabulary tables`).

## Workflow

1. **Gather scope.** Use the argument and conversation context to determine which entity groups are in scope.
2. **Read entity docs.** Read all referenced `docs/domain/*.md` files. Extract every field, type, relationship, constraint, enum, and business rule.
3. **Check completeness — stop if insufficient.** Before generating any SQL, verify the entity docs provide enough information to produce a correct migration. If any of the following are missing or ambiguous, **do not proceed** — instead, list exactly what is missing and ask the user to update the entity docs first:
   - A referenced entity doc file does not exist in `docs/domain/`
   - An entity is missing its field table (no fields defined)
   - Field types are missing or unclear (cannot determine Postgres type)
   - Relationships reference entities with no corresponding doc
   - Business rules mention constraints (unique, range, etc.) but the fields they apply to are not defined
   - An enum is referenced but its values are not listed in any entity doc or `shared_types.md`
4. **Read existing migrations.** Scan `supabase/migrations/` for existing tables to avoid conflicts and stay consistent with naming/style. If the directory is empty, this is the initial migration.
5. **Read technical docs.** Check `docs/adr/supabase.md` for conventions and `docs/adr/offline.md` for local-only fields to exclude.
6. **Generate SQL.** Produce migration SQL following the rules below.
7. **Write files.** Use `supabase migration new <name>` to create the file with the correct timestamp prefix, then write the SQL content into the generated file. Separate concerns into multiple files when warranted (see "Separation of Concerns" below).
8. **Validate.** Walk through every field in every entity doc in scope and confirm it is either present in the migration or explicitly excluded as local-only. Print a checklist summary.

## SQL Generation Rules

### Table Naming

- `snake_case`, plural form: `Radical` → `radicals`, `KanjiReading` → `kanji_readings`, `UserSettings` → `user_settings`.

### Primary Keys

```sql
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
```

### Foreign Keys

- Named `fk_<table>_<column>`.
- All use `ON DELETE CASCADE`.

```sql
CONSTRAINT fk_radical_variants_radical_id FOREIGN KEY (radical_id) REFERENCES radicals(id) ON DELETE CASCADE
```

### Unique Constraints

- Named `uq_<table>_<columns>`.

```sql
CONSTRAINT uq_radical_i18n_radical_id_lang_code UNIQUE (radical_id, lang_code)
```

### Check Constraints

- Named `chk_<table>_<description>`.

```sql
CONSTRAINT chk_radicals_impact_score CHECK (impact_score BETWEEN 1 AND 10)
```

### Enums

- Use Postgres `CREATE TYPE` for each enum.
- Enum values must exactly match the entity doc values.

```sql
CREATE TYPE position_type AS ENUM ('hen', 'tsukuri', 'kanmuri', 'ashi', 'kamae', 'tare', 'nyo', 'unknown');
CREATE TYPE item_type AS ENUM ('radical', 'kanji', 'vocabulary');
CREATE TYPE reading_priority AS ENUM ('primary', 'secondary');
```

### Timestamps

- `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`
- `updated_at TIMESTAMPTZ NOT NULL DEFAULT now()`

Content tables must have `updated_at` for incremental sync. Add a trigger to auto-update it:

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_<table>_updated_at
    BEFORE UPDATE ON <table>
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### Exclude Local-Only Fields

These fields exist only in Drift (SQLite) and must **never** appear in Supabase migrations:

- `sync_status`
- `remote_updated_at`
- `local_updated_at`

See `docs/adr/offline.md` → "Local-Only Fields" for reference.

### User Tables

User-scoped tables include a `user_id` column referencing Supabase Auth:

```sql
user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE
```

### Field Type Mapping

| Dart Type | Postgres Type |
|---|---|
| `int` | `INTEGER` |
| `String` | `TEXT` |
| `double` | `DOUBLE PRECISION` |
| `bool` | `BOOLEAN` |
| `DateTime` | `TIMESTAMPTZ` |
| `List<String>` | `TEXT[]` |
| Enum types (e.g. `Position`) | Corresponding `CREATE TYPE` enum |

### Nullability

- Fields marked `?` in entity docs → nullable (no `NOT NULL`).
- All other fields → `NOT NULL`.

### Ordering

Within a `CREATE TABLE` block, order columns as:
1. `id` (PK)
2. Foreign key columns
3. Core data fields (in the order listed in the entity doc)
4. Metadata fields (`created_at`, `updated_at`)

Tables must be ordered by dependency — a table must be created after any table it references. Enum types must be created before any table that uses them.

## Separation of Concerns

If the scope warrants multiple files, split by concern. Use `supabase migration new` for each to get correct timestamps:

| Suffix | Contents |
|---|---|
| `_schema` | `CREATE TYPE` + `CREATE TABLE` + indexes + triggers |
| `_rls_policies` | `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` + `CREATE POLICY` statements |
| `_storage` | Storage bucket setup (only if SVG/file storage is in scope) |

### RLS Policy Patterns

Follow the access patterns from `docs/adr/supabase.md`:

**Content tables** (read-only for users):
```sql
ALTER TABLE radicals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read radicals"
    ON radicals FOR SELECT
    TO authenticated
    USING (true);
```

**User tables** (per-user read-write):
```sql
ALTER TABLE srs_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read own srs_cards"
    ON srs_cards FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());
CREATE POLICY "Users can insert own srs_cards"
    ON srs_cards FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can update own srs_cards"
    ON srs_cards FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can delete own srs_cards"
    ON srs_cards FOR DELETE
    TO authenticated
    USING (user_id = auth.uid());
```

### Storage Bucket Setup

Only include if SVG/file storage is in scope:
```sql
INSERT INTO storage.buckets (id, name, public)
VALUES ('svg', 'svg', true);

CREATE POLICY "Public read access for SVG bucket"
    ON storage.objects FOR SELECT
    TO public
    USING (bucket_id = 'svg');
```

## Validation Checklist

Before finishing, verify each item and print a summary:

- [ ] Every field from every in-scope entity doc is present in the migration or documented as excluded (local-only)
- [ ] All foreign keys match the Relationships section in entity docs
- [ ] All unique constraints match Business Rules (e.g. radical_id + lang_code unique)
- [ ] Check constraints cover range validations (e.g. `impact_score` 1–10, `min_jlpt_level` 1–5)
- [ ] Enum types match the entity doc enum values exactly
- [ ] No local-only Drift fields leaked into the migration (`sync_status`, `remote_updated_at`, `local_updated_at`)
- [ ] `updated_at` trigger exists on every content table
- [ ] User tables have `user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE`
- [ ] RLS is enabled on all tables (content = authenticated read; user = per-user CRUD)
- [ ] Tables are created in dependency order (enums first, then parent tables, then child tables)
- [ ] Naming conventions: `snake_case` plural tables, `fk_` FKs, `uq_` uniques, `chk_` checks
