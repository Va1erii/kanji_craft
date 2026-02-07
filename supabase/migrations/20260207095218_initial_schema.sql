-- =============================================================
-- Migration: initial_schema
-- Description: Create all enum types, tables, triggers, indexes
-- =============================================================

-- ----- Enum types -----

CREATE TYPE position_type AS ENUM (
  'hen', 'tsukuri', 'kanmuri', 'ashi', 'kamae', 'tare', 'nyo', 'unknown'
);

CREATE TYPE item_type AS ENUM (
  'radical', 'kanji', 'vocabulary'
);

CREATE TYPE reading_priority AS ENUM (
  'primary', 'secondary'
);

CREATE TYPE reading_type AS ENUM (
  'onyomi', 'kunyomi'
);

CREATE TYPE logic_hint AS ENUM (
  'semantic', 'phonetic'
);

CREATE TYPE card_state AS ENUM (
  'new_card', 'learning', 'review', 'relearning'
);

CREATE TYPE rating AS ENUM (
  'again', 'hard', 'good', 'easy'
);

CREATE TYPE auth_provider AS ENUM (
  'email', 'google', 'apple', 'facebook'
);

CREATE TYPE study_path AS ENUM (
  'jlpt', 'grade'
);

-- ----- Shared trigger function -----

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================================
-- Content tables
-- =============================================================

-- ----- radicals -----

CREATE TABLE radicals (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  master_symbol TEXT    NOT NULL,
  stroke_count  INT    NOT NULL,
  impact_score  INT    NOT NULL,
  min_jlpt_level INT   NOT NULL,
  min_grade     INT    NOT NULL,
  svg_file_name TEXT   NOT NULL,
  svg_file_url  TEXT   NOT NULL,
  svg_hash      TEXT   NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_radicals_master_symbol UNIQUE (master_symbol),
  CONSTRAINT chk_radicals_stroke_count CHECK (stroke_count > 0),
  CONSTRAINT chk_radicals_impact_score CHECK (impact_score BETWEEN 1 AND 10),
  CONSTRAINT chk_radicals_min_jlpt_level CHECK (min_jlpt_level BETWEEN 1 AND 5),
  CONSTRAINT chk_radicals_min_grade CHECK (min_grade BETWEEN 1 AND 6),
  CONSTRAINT chk_radicals_master_symbol_ne CHECK (master_symbol <> ''),
  CONSTRAINT chk_radicals_svg_file_name_ne CHECK (svg_file_name <> ''),
  CONSTRAINT chk_radicals_svg_file_url_ne CHECK (svg_file_url <> ''),
  CONSTRAINT chk_radicals_svg_hash_ne CHECK (svg_hash <> '')
);

-- ----- radical_i18n -----

CREATE TABLE radical_i18n (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  radical_id  BIGINT NOT NULL,
  lang_code   TEXT   NOT NULL,
  name        TEXT   NOT NULL,
  system_mnemonic TEXT NOT NULL,
  search_tags TEXT[] NOT NULL DEFAULT '{}',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_radical_i18n_radical_id FOREIGN KEY (radical_id) REFERENCES radicals (id) ON DELETE CASCADE,
  CONSTRAINT uq_radical_i18n_radical_id_lang_code UNIQUE (radical_id, lang_code),
  CONSTRAINT chk_radical_i18n_lang_code_ne CHECK (lang_code <> ''),
  CONSTRAINT chk_radical_i18n_name_ne CHECK (name <> '')
);

-- ----- radical_variants -----

CREATE TABLE radical_variants (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  radical_id  BIGINT        NOT NULL,
  shape       TEXT          NOT NULL,
  position    position_type NOT NULL,
  is_locked   BOOLEAN       NOT NULL DEFAULT false,
  svg_file_name TEXT        NOT NULL,
  svg_file_url  TEXT        NOT NULL,
  svg_hash      TEXT        NOT NULL,
  created_at  TIMESTAMPTZ   NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ   NOT NULL DEFAULT now(),

  CONSTRAINT fk_radical_variants_radical_id FOREIGN KEY (radical_id) REFERENCES radicals (id) ON DELETE CASCADE,
  CONSTRAINT uq_radical_variants_radical_id_position UNIQUE (radical_id, position),
  CONSTRAINT chk_radical_variants_shape_ne CHECK (shape <> ''),
  CONSTRAINT chk_radical_variants_svg_file_name_ne CHECK (svg_file_name <> ''),
  CONSTRAINT chk_radical_variants_svg_file_url_ne CHECK (svg_file_url <> ''),
  CONSTRAINT chk_radical_variants_svg_hash_ne CHECK (svg_hash <> '')
);

-- ----- kanji -----

CREATE TABLE kanji (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  character      TEXT   NOT NULL,
  stroke_count   INT    NOT NULL,
  min_jlpt_level INT,
  min_grade      INT,
  frequency_rank INT    NOT NULL,
  svg_file_name  TEXT   NOT NULL,
  svg_file_url   TEXT   NOT NULL,
  svg_hash       TEXT   NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_kanji_character UNIQUE (character),
  CONSTRAINT chk_kanji_stroke_count CHECK (stroke_count > 0),
  CONSTRAINT chk_kanji_min_jlpt_level CHECK (min_jlpt_level BETWEEN 1 AND 5),
  CONSTRAINT chk_kanji_min_grade CHECK (min_grade BETWEEN 1 AND 6),
  CONSTRAINT chk_kanji_frequency_rank CHECK (frequency_rank > 0),
  CONSTRAINT chk_kanji_character_ne CHECK (character <> ''),
  CONSTRAINT chk_kanji_svg_file_name_ne CHECK (svg_file_name <> ''),
  CONSTRAINT chk_kanji_svg_file_url_ne CHECK (svg_file_url <> ''),
  CONSTRAINT chk_kanji_svg_hash_ne CHECK (svg_hash <> '')
);

-- ----- kanji_readings -----

CREATE TABLE kanji_readings (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kanji_id     BIGINT           NOT NULL,
  reading      TEXT             NOT NULL,
  reading_type reading_type     NOT NULL,
  priority     reading_priority NOT NULL,
  created_at   TIMESTAMPTZ      NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ      NOT NULL DEFAULT now(),

  CONSTRAINT fk_kanji_readings_kanji_id FOREIGN KEY (kanji_id) REFERENCES kanji (id) ON DELETE CASCADE,
  CONSTRAINT uq_kanji_readings_kanji_id_reading_reading_type UNIQUE (kanji_id, reading, reading_type),
  CONSTRAINT chk_kanji_readings_reading_ne CHECK (reading <> '')
);

-- ----- kanji_i18n -----

CREATE TABLE kanji_i18n (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kanji_id        BIGINT NOT NULL,
  lang_code       TEXT   NOT NULL,
  meanings        TEXT[] NOT NULL,
  system_mnemonic TEXT   NOT NULL,
  search_tags     TEXT[] NOT NULL DEFAULT '{}',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_kanji_i18n_kanji_id FOREIGN KEY (kanji_id) REFERENCES kanji (id) ON DELETE CASCADE,
  CONSTRAINT uq_kanji_i18n_kanji_id_lang_code UNIQUE (kanji_id, lang_code),
  CONSTRAINT chk_kanji_i18n_lang_code_ne CHECK (lang_code <> ''),
  CONSTRAINT chk_kanji_i18n_meanings_len CHECK (array_length(meanings, 1) > 0)
);

-- ----- kanji_components -----

CREATE TABLE kanji_components (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kanji_id   BIGINT     NOT NULL,
  radical_id BIGINT     NOT NULL,
  logic_hint logic_hint NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_kanji_components_kanji_id FOREIGN KEY (kanji_id) REFERENCES kanji (id) ON DELETE CASCADE,
  CONSTRAINT fk_kanji_components_radical_id FOREIGN KEY (radical_id) REFERENCES radicals (id) ON DELETE CASCADE,
  CONSTRAINT uq_kanji_components_kanji_id_radical_id UNIQUE (kanji_id, radical_id)
);

-- ----- vocabulary -----

CREATE TABLE vocabulary (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  word           TEXT   NOT NULL,
  min_jlpt_level INT,
  frequency_rank INT    NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_vocabulary_word UNIQUE (word),
  CONSTRAINT chk_vocabulary_min_jlpt_level CHECK (min_jlpt_level BETWEEN 1 AND 5),
  CONSTRAINT chk_vocabulary_frequency_rank CHECK (frequency_rank > 0),
  CONSTRAINT chk_vocabulary_word_ne CHECK (word <> '')
);

-- ----- vocabulary_readings -----

CREATE TABLE vocabulary_readings (
  id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vocabulary_id BIGINT           NOT NULL,
  reading       TEXT             NOT NULL,
  priority      reading_priority NOT NULL,
  created_at    TIMESTAMPTZ      NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ      NOT NULL DEFAULT now(),

  CONSTRAINT fk_vocabulary_readings_vocabulary_id FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (id) ON DELETE CASCADE,
  CONSTRAINT uq_vocabulary_readings_vocabulary_id_reading UNIQUE (vocabulary_id, reading),
  CONSTRAINT chk_vocabulary_readings_reading_ne CHECK (reading <> '')
);

-- ----- vocabulary_i18n -----

CREATE TABLE vocabulary_i18n (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vocabulary_id   BIGINT NOT NULL,
  lang_code       TEXT   NOT NULL,
  meanings        TEXT[] NOT NULL,
  system_mnemonic TEXT,
  search_tags     TEXT[] NOT NULL DEFAULT '{}',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_vocabulary_i18n_vocabulary_id FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (id) ON DELETE CASCADE,
  CONSTRAINT uq_vocabulary_i18n_vocabulary_id_lang_code UNIQUE (vocabulary_id, lang_code),
  CONSTRAINT chk_vocabulary_i18n_lang_code_ne CHECK (lang_code <> ''),
  CONSTRAINT chk_vocabulary_i18n_meanings_len CHECK (array_length(meanings, 1) > 0)
);

-- ----- vocabulary_kanji -----

CREATE TABLE vocabulary_kanji (
  id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vocabulary_id BIGINT NOT NULL,
  kanji_id      BIGINT NOT NULL,
  position      INT    NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_vocabulary_kanji_vocabulary_id FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (id) ON DELETE CASCADE,
  CONSTRAINT fk_vocabulary_kanji_kanji_id FOREIGN KEY (kanji_id) REFERENCES kanji (id) ON DELETE CASCADE,
  CONSTRAINT uq_vocabulary_kanji_vocabulary_id_kanji_id UNIQUE (vocabulary_id, kanji_id),
  CONSTRAINT chk_vocabulary_kanji_position CHECK (position >= 0)
);

-- ----- vocabulary_sentences -----

CREATE TABLE vocabulary_sentences (
  id                   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vocabulary_id        BIGINT NOT NULL,
  lang_code            TEXT   NOT NULL,
  sentence_ja          TEXT   NOT NULL,
  sentence_furigana    TEXT   NOT NULL,
  sentence_translated  TEXT   NOT NULL,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_vocabulary_sentences_vocabulary_id FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (id) ON DELETE CASCADE,
  CONSTRAINT uq_vocabulary_sentences_vocabulary_id_lang_code UNIQUE (vocabulary_id, lang_code),
  CONSTRAINT chk_vocabulary_sentences_lang_code_ne CHECK (lang_code <> ''),
  CONSTRAINT chk_vocabulary_sentences_sentence_ja_ne CHECK (sentence_ja <> ''),
  CONSTRAINT chk_vocabulary_sentences_sentence_furigana_ne CHECK (sentence_furigana <> ''),
  CONSTRAINT chk_vocabulary_sentences_sentence_translated_ne CHECK (sentence_translated <> '')
);

-- =============================================================
-- User tables
-- =============================================================

-- ----- users -----

CREATE TABLE users (
  id               UUID        PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  auth_provider    auth_provider NOT NULL,
  auth_provider_id TEXT          NOT NULL,
  email            TEXT,
  display_name     TEXT,
  lang_code        TEXT          NOT NULL DEFAULT 'en',
  created_at       TIMESTAMPTZ   NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ   NOT NULL DEFAULT now(),

  CONSTRAINT uq_users_auth_provider_auth_provider_id UNIQUE (auth_provider, auth_provider_id),
  CONSTRAINT chk_users_lang_code_ne CHECK (lang_code <> '')
);

-- ----- user_settings -----

CREATE TABLE user_settings (
  id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id            UUID       NOT NULL,
  study_path         study_path NOT NULL DEFAULT 'jlpt',
  current_level      INT        NOT NULL DEFAULT 5,
  daily_lesson_limit INT        NOT NULL DEFAULT 10,
  daily_review_limit INT        NOT NULL DEFAULT 100,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_user_settings_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT uq_user_settings_user_id UNIQUE (user_id),
  CONSTRAINT chk_user_settings_current_level CHECK (current_level >= 1),
  CONSTRAINT chk_user_settings_daily_lesson_limit CHECK (daily_lesson_limit >= 1),
  CONSTRAINT chk_user_settings_daily_review_limit CHECK (daily_review_limit >= 1)
);

-- ----- srs_cards -----

CREATE TABLE srs_cards (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id        UUID       NOT NULL,
  item_type      item_type  NOT NULL,
  item_id        BIGINT     NOT NULL,
  state          card_state NOT NULL DEFAULT 'new_card',
  due            TIMESTAMPTZ NOT NULL DEFAULT now(),
  stability      DOUBLE PRECISION NOT NULL DEFAULT 0,
  difficulty     DOUBLE PRECISION NOT NULL DEFAULT 0,
  elapsed_days   INT        NOT NULL DEFAULT 0,
  scheduled_days INT        NOT NULL DEFAULT 0,
  reps           INT        NOT NULL DEFAULT 0,
  lapses         INT        NOT NULL DEFAULT 0,
  last_review    TIMESTAMPTZ,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_srs_cards_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT uq_srs_cards_user_id_item_type_item_id UNIQUE (user_id, item_type, item_id),
  CONSTRAINT chk_srs_cards_stability CHECK (stability >= 0),
  CONSTRAINT chk_srs_cards_difficulty CHECK (difficulty BETWEEN 0 AND 10),
  CONSTRAINT chk_srs_cards_elapsed_days CHECK (elapsed_days >= 0),
  CONSTRAINT chk_srs_cards_scheduled_days CHECK (scheduled_days >= 0),
  CONSTRAINT chk_srs_cards_reps CHECK (reps >= 0),
  CONSTRAINT chk_srs_cards_lapses CHECK (lapses >= 0)
);

-- ----- review_logs -----

CREATE TABLE review_logs (
  id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  card_id           BIGINT           NOT NULL,
  rating            rating           NOT NULL,
  state_before      card_state       NOT NULL,
  stability_before  DOUBLE PRECISION NOT NULL,
  difficulty_before DOUBLE PRECISION NOT NULL,
  reviewed_at       TIMESTAMPTZ      NOT NULL DEFAULT now(),
  created_at        TIMESTAMPTZ      NOT NULL DEFAULT now(),

  CONSTRAINT fk_review_logs_card_id FOREIGN KEY (card_id) REFERENCES srs_cards (id) ON DELETE CASCADE
);

-- ----- user_mnemonics -----

CREATE TABLE user_mnemonics (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id    UUID      NOT NULL,
  item_type  item_type NOT NULL,
  item_id    BIGINT    NOT NULL,
  text       TEXT      NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_user_mnemonics_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT uq_user_mnemonics_user_id_item_type_item_id UNIQUE (user_id, item_type, item_id),
  CONSTRAINT chk_user_mnemonics_text_ne CHECK (text <> '')
);

-- =============================================================
-- updated_at triggers (all tables except review_logs)
-- =============================================================

CREATE TRIGGER trg_radicals_updated_at
  BEFORE UPDATE ON radicals
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_radical_i18n_updated_at
  BEFORE UPDATE ON radical_i18n
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_radical_variants_updated_at
  BEFORE UPDATE ON radical_variants
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_kanji_updated_at
  BEFORE UPDATE ON kanji
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_kanji_readings_updated_at
  BEFORE UPDATE ON kanji_readings
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_kanji_i18n_updated_at
  BEFORE UPDATE ON kanji_i18n
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_kanji_components_updated_at
  BEFORE UPDATE ON kanji_components
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_vocabulary_updated_at
  BEFORE UPDATE ON vocabulary
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_vocabulary_readings_updated_at
  BEFORE UPDATE ON vocabulary_readings
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_vocabulary_i18n_updated_at
  BEFORE UPDATE ON vocabulary_i18n
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_vocabulary_kanji_updated_at
  BEFORE UPDATE ON vocabulary_kanji
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_vocabulary_sentences_updated_at
  BEFORE UPDATE ON vocabulary_sentences
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_user_settings_updated_at
  BEFORE UPDATE ON user_settings
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_srs_cards_updated_at
  BEFORE UPDATE ON srs_cards
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_user_mnemonics_updated_at
  BEFORE UPDATE ON user_mnemonics
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- =============================================================
-- Indexes
-- =============================================================

-- FK indexes (PostgreSQL does not auto-index FKs)
CREATE INDEX idx_radical_i18n_radical_id ON radical_i18n (radical_id);
CREATE INDEX idx_radical_variants_radical_id ON radical_variants (radical_id);
CREATE INDEX idx_kanji_readings_kanji_id ON kanji_readings (kanji_id);
CREATE INDEX idx_kanji_i18n_kanji_id ON kanji_i18n (kanji_id);
CREATE INDEX idx_kanji_components_kanji_id ON kanji_components (kanji_id);
CREATE INDEX idx_kanji_components_radical_id ON kanji_components (radical_id);
CREATE INDEX idx_vocabulary_readings_vocabulary_id ON vocabulary_readings (vocabulary_id);
CREATE INDEX idx_vocabulary_i18n_vocabulary_id ON vocabulary_i18n (vocabulary_id);
CREATE INDEX idx_vocabulary_kanji_vocabulary_id ON vocabulary_kanji (vocabulary_id);
CREATE INDEX idx_vocabulary_kanji_kanji_id ON vocabulary_kanji (kanji_id);
CREATE INDEX idx_vocabulary_sentences_vocabulary_id ON vocabulary_sentences (vocabulary_id);
CREATE INDEX idx_user_settings_user_id ON user_settings (user_id);
CREATE INDEX idx_srs_cards_user_id ON srs_cards (user_id);
CREATE INDEX idx_review_logs_card_id ON review_logs (card_id);
CREATE INDEX idx_user_mnemonics_user_id ON user_mnemonics (user_id);

-- Lookup indexes
CREATE INDEX idx_srs_cards_user_id_item_type ON srs_cards (user_id, item_type);
CREATE INDEX idx_srs_cards_user_id_due ON srs_cards (user_id, due);
CREATE INDEX idx_review_logs_card_id_reviewed_at ON review_logs (card_id, reviewed_at);

-- Partial indexes for nullable JLPT/grade
CREATE INDEX idx_radicals_min_jlpt_level ON radicals (min_jlpt_level);
CREATE INDEX idx_radicals_min_grade ON radicals (min_grade);
CREATE INDEX idx_kanji_min_jlpt_level ON kanji (min_jlpt_level) WHERE min_jlpt_level IS NOT NULL;
CREATE INDEX idx_kanji_min_grade ON kanji (min_grade) WHERE min_grade IS NOT NULL;
CREATE INDEX idx_vocabulary_min_jlpt_level ON vocabulary (min_jlpt_level) WHERE min_jlpt_level IS NOT NULL;
