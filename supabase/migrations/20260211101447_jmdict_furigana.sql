-- JmdictFurigana staging table
-- Pre-computed per-character furigana mappings from the JmdictFurigana dataset.
-- Tracked in data_imports (coupled with JMdict, must be updated in lockstep).

-- Add jmdict_furigana to import_source enum
ALTER TYPE import_source ADD VALUE IF NOT EXISTS 'jmdict_furigana';

CREATE TABLE jmdict_furigana (
    import_id  BIGINT NOT NULL,
    text       TEXT   NOT NULL,
    reading    TEXT   NOT NULL,
    furigana   JSONB  NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    PRIMARY KEY (import_id, text, reading),

    CONSTRAINT fk_jmdict_furigana_import_id
        FOREIGN KEY (import_id) REFERENCES data_imports (id) ON DELETE CASCADE,

    CONSTRAINT chk_jmdict_furigana_text_ne CHECK (text <> ''),
    CONSTRAINT chk_jmdict_furigana_reading_ne CHECK (reading <> ''),
    CONSTRAINT chk_jmdict_furigana_furigana_is_array
        CHECK (jsonb_typeof(furigana) = 'array' AND jsonb_array_length(furigana) > 0)
);

CREATE INDEX idx_jmdict_furigana_import_id ON jmdict_furigana(import_id);
CREATE INDEX idx_jmdict_furigana_text ON jmdict_furigana(text);

-- RLS: admin-only (same pattern as staging tables — zero policies, service_role bypasses)
ALTER TABLE jmdict_furigana ENABLE ROW LEVEL SECURITY;
