-- Wrap auth.uid() in (select ...) so Postgres evaluates it once per query
-- instead of per row. Drops and recreates each affected policy.

-- =============================================================
-- users
-- =============================================================

DROP POLICY "Users can read own row" ON users;
CREATE POLICY "Users can read own row"
  ON users FOR SELECT TO authenticated
  USING (id = (select auth.uid()));

DROP POLICY "Users can insert own row" ON users;
CREATE POLICY "Users can insert own row"
  ON users FOR INSERT TO authenticated
  WITH CHECK (id = (select auth.uid()));

DROP POLICY "Users can update own row" ON users;
CREATE POLICY "Users can update own row"
  ON users FOR UPDATE TO authenticated
  USING (id = (select auth.uid()))
  WITH CHECK (id = (select auth.uid()));

DROP POLICY "Users can delete own row" ON users;
CREATE POLICY "Users can delete own row"
  ON users FOR DELETE TO authenticated
  USING (id = (select auth.uid()));

-- =============================================================
-- user_settings
-- =============================================================

DROP POLICY "Users can read own settings" ON user_settings;
CREATE POLICY "Users can read own settings"
  ON user_settings FOR SELECT TO authenticated
  USING (user_id = (select auth.uid()));

DROP POLICY "Users can insert own settings" ON user_settings;
CREATE POLICY "Users can insert own settings"
  ON user_settings FOR INSERT TO authenticated
  WITH CHECK (user_id = (select auth.uid()));

DROP POLICY "Users can update own settings" ON user_settings;
CREATE POLICY "Users can update own settings"
  ON user_settings FOR UPDATE TO authenticated
  USING (user_id = (select auth.uid()))
  WITH CHECK (user_id = (select auth.uid()));

DROP POLICY "Users can delete own settings" ON user_settings;
CREATE POLICY "Users can delete own settings"
  ON user_settings FOR DELETE TO authenticated
  USING (user_id = (select auth.uid()));

-- =============================================================
-- srs_cards
-- =============================================================

DROP POLICY "Users can read own cards" ON srs_cards;
CREATE POLICY "Users can read own cards"
  ON srs_cards FOR SELECT TO authenticated
  USING (user_id = (select auth.uid()));

DROP POLICY "Users can insert own cards" ON srs_cards;
CREATE POLICY "Users can insert own cards"
  ON srs_cards FOR INSERT TO authenticated
  WITH CHECK (user_id = (select auth.uid()));

DROP POLICY "Users can update own cards" ON srs_cards;
CREATE POLICY "Users can update own cards"
  ON srs_cards FOR UPDATE TO authenticated
  USING (user_id = (select auth.uid()))
  WITH CHECK (user_id = (select auth.uid()));

-- =============================================================
-- review_logs
-- =============================================================

DROP POLICY "Users can read own review logs" ON review_logs;
CREATE POLICY "Users can read own review logs"
  ON review_logs FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM srs_cards
      WHERE srs_cards.id = review_logs.card_id
        AND srs_cards.user_id = (select auth.uid())
    )
  );

DROP POLICY "Users can insert own review logs" ON review_logs;
CREATE POLICY "Users can insert own review logs"
  ON review_logs FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM srs_cards
      WHERE srs_cards.id = review_logs.card_id
        AND srs_cards.user_id = (select auth.uid())
    )
  );

-- =============================================================
-- user_mnemonics
-- =============================================================

DROP POLICY "Users can read own mnemonics" ON user_mnemonics;
CREATE POLICY "Users can read own mnemonics"
  ON user_mnemonics FOR SELECT TO authenticated
  USING (user_id = (select auth.uid()));

DROP POLICY "Users can insert own mnemonics" ON user_mnemonics;
CREATE POLICY "Users can insert own mnemonics"
  ON user_mnemonics FOR INSERT TO authenticated
  WITH CHECK (user_id = (select auth.uid()));

DROP POLICY "Users can update own mnemonics" ON user_mnemonics;
CREATE POLICY "Users can update own mnemonics"
  ON user_mnemonics FOR UPDATE TO authenticated
  USING (user_id = (select auth.uid()))
  WITH CHECK (user_id = (select auth.uid()));

DROP POLICY "Users can delete own mnemonics" ON user_mnemonics;
CREATE POLICY "Users can delete own mnemonics"
  ON user_mnemonics FOR DELETE TO authenticated
  USING (user_id = (select auth.uid()));
