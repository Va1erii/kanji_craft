-- =============================================================
-- Migration: initial_rls_policies
-- Description: Enable RLS and create policies for all tables
-- =============================================================

-- ----- Enable RLS on all tables -----

ALTER TABLE radicals             ENABLE ROW LEVEL SECURITY;
ALTER TABLE radical_i18n         ENABLE ROW LEVEL SECURITY;
ALTER TABLE radical_variants     ENABLE ROW LEVEL SECURITY;
ALTER TABLE kanji                ENABLE ROW LEVEL SECURITY;
ALTER TABLE kanji_readings       ENABLE ROW LEVEL SECURITY;
ALTER TABLE kanji_i18n           ENABLE ROW LEVEL SECURITY;
ALTER TABLE kanji_components     ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary           ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary_readings  ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary_i18n      ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary_kanji     ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary_sentences ENABLE ROW LEVEL SECURITY;
ALTER TABLE users                ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_settings        ENABLE ROW LEVEL SECURITY;
ALTER TABLE srs_cards            ENABLE ROW LEVEL SECURITY;
ALTER TABLE review_logs          ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_mnemonics       ENABLE ROW LEVEL SECURITY;

-- =============================================================
-- Content tables: SELECT only for authenticated users
-- =============================================================

CREATE POLICY "Authenticated users can read radicals"
  ON radicals FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read radical_i18n"
  ON radical_i18n FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read radical_variants"
  ON radical_variants FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read kanji"
  ON kanji FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read kanji_readings"
  ON kanji_readings FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read kanji_i18n"
  ON kanji_i18n FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read kanji_components"
  ON kanji_components FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read vocabulary"
  ON vocabulary FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read vocabulary_readings"
  ON vocabulary_readings FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read vocabulary_i18n"
  ON vocabulary_i18n FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read vocabulary_kanji"
  ON vocabulary_kanji FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read vocabulary_sentences"
  ON vocabulary_sentences FOR SELECT TO authenticated USING (true);

-- =============================================================
-- users: full CRUD on own row (id = auth.uid())
-- =============================================================

CREATE POLICY "Users can read own row"
  ON users FOR SELECT TO authenticated
  USING (id = auth.uid());

CREATE POLICY "Users can insert own row"
  ON users FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid());

CREATE POLICY "Users can update own row"
  ON users FOR UPDATE TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

CREATE POLICY "Users can delete own row"
  ON users FOR DELETE TO authenticated
  USING (id = auth.uid());

-- =============================================================
-- user_settings: full CRUD where user_id = auth.uid()
-- =============================================================

CREATE POLICY "Users can read own settings"
  ON user_settings FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own settings"
  ON user_settings FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own settings"
  ON user_settings FOR UPDATE TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own settings"
  ON user_settings FOR DELETE TO authenticated
  USING (user_id = auth.uid());

-- =============================================================
-- srs_cards: SELECT + INSERT + UPDATE where user_id = auth.uid()
-- No DELETE — cards are never deleted by users (review_logs
-- depend on card_id via CASCADE; allowing DELETE would silently
-- destroy append-only review history). Account deletion cascades
-- through users → srs_cards → review_logs at the FK level.
-- =============================================================

CREATE POLICY "Users can read own cards"
  ON srs_cards FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own cards"
  ON srs_cards FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own cards"
  ON srs_cards FOR UPDATE TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- =============================================================
-- review_logs: SELECT + INSERT only (append-only)
-- Ownership via EXISTS subquery through srs_cards
-- =============================================================

CREATE POLICY "Users can read own review logs"
  ON review_logs FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM srs_cards
      WHERE srs_cards.id = review_logs.card_id
        AND srs_cards.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own review logs"
  ON review_logs FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM srs_cards
      WHERE srs_cards.id = review_logs.card_id
        AND srs_cards.user_id = auth.uid()
    )
  );

-- =============================================================
-- user_mnemonics: full CRUD where user_id = auth.uid()
-- =============================================================

CREATE POLICY "Users can read own mnemonics"
  ON user_mnemonics FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own mnemonics"
  ON user_mnemonics FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own mnemonics"
  ON user_mnemonics FOR UPDATE TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own mnemonics"
  ON user_mnemonics FOR DELETE TO authenticated
  USING (user_id = auth.uid());
