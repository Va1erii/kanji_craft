-- Source Vocab Levels
-- Reference table mapping vocabulary words to their JLPT N1–N5 levels.
-- Loaded from sources/jlpt_vocab_mapping/n1-n5.csv via TRUNCATE + INSERT.
-- Local-only — not synced to Remote production.
-- Not tracked in data_imports — standalone reference, rebuilt from CSV on each pipeline setup.

CREATE TABLE source_vocab_levels (
    expression TEXT    NOT NULL,
    reading    TEXT    NOT NULL,
    level      INTEGER NOT NULL CHECK (level BETWEEN 1 AND 5),
    source     TEXT    NOT NULL DEFAULT 'tanos',

    PRIMARY KEY (expression, reading),

    CONSTRAINT chk_source_vocab_levels_expression_ne CHECK (expression <> ''),
    CONSTRAINT chk_source_vocab_levels_reading_ne CHECK (reading <> '')
);

CREATE INDEX idx_source_vocab_levels_level ON source_vocab_levels(level);

-- RLS: admin-only (same pattern as staging tables — zero policies, service_role bypasses)
ALTER TABLE source_vocab_levels ENABLE ROW LEVEL SECURITY;
