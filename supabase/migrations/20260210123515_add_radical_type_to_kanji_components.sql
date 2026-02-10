-- =============================================================
-- Migration: add_radical_type_to_kanji_components
-- Description: Add radical_type enum and column to kanji_components.
--   Captures the KanjiVG kvg:radical classification per component.
--   Also adds a generated is_primary column for dictionary lookups.
-- =============================================================

CREATE TYPE radical_type AS ENUM (
  'general', 'tradit', 'nelson', 'jis', 'component'
);

ALTER TABLE kanji_components
  ADD COLUMN radical_type radical_type NOT NULL DEFAULT 'component';

ALTER TABLE kanji_components
  ADD COLUMN is_primary BOOLEAN GENERATED ALWAYS AS (radical_type = 'general') STORED;
