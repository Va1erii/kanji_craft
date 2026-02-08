-- =============================================================
-- Migration: staging_enums_and_tables
-- Description: Add staging tables (data_imports, raw_kanjivg,
--   raw_kanjidic), admin review table (kanji_component_reviews),
--   position column on kanji_components, and supporting enums
-- =============================================================

-- ----- New enum types -----

CREATE TYPE import_source AS ENUM ('kanjivg', 'kanjidic');

CREATE TYPE import_status AS ENUM (
  'pending', 'ingested', 'processing', 'processed', 'promoted', 'failed'
);

CREATE TYPE verification_status AS ENUM ('draft', 'verified', 'flagged');

-- =============================================================
-- Staging tables
-- =============================================================

-- ----- data_imports -----

CREATE TABLE data_imports (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  source         import_source NOT NULL,
  source_version TEXT          NOT NULL,
  status         import_status NOT NULL DEFAULT 'pending',
  record_count   INT,
  started_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),
  ingested_at    TIMESTAMPTZ,
  processed_at   TIMESTAMPTZ,
  promoted_at    TIMESTAMPTZ,
  error_message  TEXT,
  metadata       JSONB,
  created_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

  CONSTRAINT chk_data_imports_source_version_ne CHECK (source_version <> '')
);

-- Only one promoted import per source+version
CREATE UNIQUE INDEX uq_data_imports_source_version_promoted
  ON data_imports (source, source_version)
  WHERE status = 'promoted';

CREATE TRIGGER trg_data_imports_updated_at
  BEFORE UPDATE ON data_imports
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ----- raw_kanjivg -----

CREATE TABLE raw_kanjivg (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  import_id    BIGINT NOT NULL,
  character    TEXT   NOT NULL,
  unicode_hex  TEXT   NOT NULL,
  view_box     TEXT   NOT NULL,
  stroke_count INT    NOT NULL,
  strokes      JSONB  NOT NULL,
  components   JSONB  NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_raw_kanjivg_import_id FOREIGN KEY (import_id) REFERENCES data_imports (id) ON DELETE CASCADE,
  CONSTRAINT uq_raw_kanjivg_import_id_character UNIQUE (import_id, character),
  CONSTRAINT chk_raw_kanjivg_stroke_count CHECK (stroke_count > 0),
  CONSTRAINT chk_raw_kanjivg_character_ne CHECK (character <> ''),
  CONSTRAINT chk_raw_kanjivg_unicode_hex CHECK (unicode_hex ~ '^[0-9a-f]{5}$'),
  CONSTRAINT chk_raw_kanjivg_view_box_ne CHECK (view_box <> '')
);

CREATE INDEX idx_raw_kanjivg_import_id ON raw_kanjivg (import_id);
CREATE INDEX idx_raw_kanjivg_character ON raw_kanjivg (character);

-- No updated_at trigger — raw rows are immutable after insert

-- ----- raw_kanjidic -----

CREATE TABLE raw_kanjidic (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  import_id               BIGINT NOT NULL,
  literal                 TEXT   NOT NULL,
  stroke_count            INT    NOT NULL,
  stroke_count_misstrokes JSONB,
  grade                   INT,
  jlpt                    INT,
  frequency               INT,
  codepoints              JSONB  NOT NULL,
  radicals                JSONB  NOT NULL,
  dict_refs               JSONB,
  query_codes             JSONB,
  readings                JSONB  NOT NULL,
  nanori                  JSONB,
  meanings                JSONB  NOT NULL,
  variants                JSONB,
  radical_names           JSONB,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_raw_kanjidic_import_id FOREIGN KEY (import_id) REFERENCES data_imports (id) ON DELETE CASCADE,
  CONSTRAINT uq_raw_kanjidic_import_id_literal UNIQUE (import_id, literal),
  CONSTRAINT chk_raw_kanjidic_stroke_count CHECK (stroke_count > 0),
  CONSTRAINT chk_raw_kanjidic_literal_ne CHECK (literal <> ''),
  CONSTRAINT chk_raw_kanjidic_grade CHECK (grade IN (1, 2, 3, 4, 5, 6, 8, 9, 10)),
  CONSTRAINT chk_raw_kanjidic_jlpt CHECK (jlpt BETWEEN 1 AND 4),
  CONSTRAINT chk_raw_kanjidic_frequency CHECK (frequency > 0)
);

CREATE INDEX idx_raw_kanjidic_import_id ON raw_kanjidic (import_id);
CREATE INDEX idx_raw_kanjidic_literal ON raw_kanjidic (literal);

-- No updated_at trigger — raw rows are immutable after insert

-- =============================================================
-- Alter kanji_components — add position column
-- =============================================================

ALTER TABLE kanji_components
  ADD COLUMN position position_type NOT NULL DEFAULT 'unknown';

ALTER TABLE kanji_components
  DROP CONSTRAINT uq_kanji_components_kanji_id_radical_id;

ALTER TABLE kanji_components
  ADD CONSTRAINT uq_kanji_components_kanji_id_radical_id_position
  UNIQUE (kanji_id, radical_id, position);

-- =============================================================
-- Admin review table
-- =============================================================

-- ----- kanji_component_reviews -----

CREATE TABLE kanji_component_reviews (
  id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kanji_component_id    BIGINT              NOT NULL,
  verification_status   verification_status NOT NULL DEFAULT 'draft',
  ai_confidence         DOUBLE PRECISION,
  created_at            TIMESTAMPTZ         NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ         NOT NULL DEFAULT now(),

  CONSTRAINT fk_kanji_component_reviews_kanji_component_id
    FOREIGN KEY (kanji_component_id) REFERENCES kanji_components (id) ON DELETE CASCADE,
  CONSTRAINT uq_kanji_component_reviews_kanji_component_id
    UNIQUE (kanji_component_id),
  CONSTRAINT chk_kanji_component_reviews_ai_confidence
    CHECK (ai_confidence BETWEEN 0 AND 1)
);

CREATE TRIGGER trg_kanji_component_reviews_updated_at
  BEFORE UPDATE ON kanji_component_reviews
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX idx_kanji_component_reviews_verification_status
  ON kanji_component_reviews (verification_status);
