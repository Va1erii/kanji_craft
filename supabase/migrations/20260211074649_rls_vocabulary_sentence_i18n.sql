-- RLS for vocabulary_sentence_i18n (same pattern as other content children)

ALTER TABLE vocabulary_sentence_i18n ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read vocabulary_sentence_i18n"
  ON vocabulary_sentence_i18n
  FOR SELECT
  TO authenticated
  USING (true);
