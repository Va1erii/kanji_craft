-- Source JLPT Levels
-- Reference table mapping individual kanji to current JLPT N1–N5 levels.
-- Loaded from sources/jlpt_mapping/jlpt_mapping.csv via TRUNCATE + INSERT.
-- Local-only — not synced to Remote production.
-- Not tracked in data_imports — standalone reference, rebuilt from CSV on each pipeline setup.

CREATE TABLE source_jlpt_levels (
    character TEXT PRIMARY KEY,
    level     INTEGER NOT NULL CHECK (level BETWEEN 1 AND 5),
    source    TEXT NOT NULL DEFAULT 'tanos'
);

CREATE INDEX idx_source_jlpt_level ON source_jlpt_levels(level);

-- RLS: admin-only (same pattern as staging tables — zero policies, service_role bypasses)
ALTER TABLE source_jlpt_levels ENABLE ROW LEVEL SECURITY;
