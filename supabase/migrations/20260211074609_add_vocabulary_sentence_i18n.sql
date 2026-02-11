-- New vocabulary_sentence_i18n table for sentence translations

CREATE TABLE vocabulary_sentence_i18n (
  id                     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vocabulary_sentence_id BIGINT NOT NULL,
  lang_code              TEXT   NOT NULL,
  sentence_translated    TEXT   NOT NULL,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT fk_vsi_vocabulary_sentence_id
    FOREIGN KEY (vocabulary_sentence_id) REFERENCES vocabulary_sentences (id) ON DELETE CASCADE,
  CONSTRAINT uq_vsi_sentence_id_lang_code
    UNIQUE (vocabulary_sentence_id, lang_code),
  CONSTRAINT chk_vsi_lang_code_ne CHECK (lang_code <> ''),
  CONSTRAINT chk_vsi_sentence_translated_ne CHECK (sentence_translated <> '')
);

-- Indexes
CREATE INDEX idx_vsi_vocabulary_sentence_id ON vocabulary_sentence_i18n (vocabulary_sentence_id);

-- Updated_at trigger
CREATE TRIGGER trg_vocabulary_sentence_i18n_updated_at
  BEFORE UPDATE ON vocabulary_sentence_i18n
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Propagation trigger: bump vocabulary_sentences.updated_at when i18n changes
CREATE OR REPLACE FUNCTION propagate_updated_at_to_vocabulary_sentences()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  UPDATE vocabulary_sentences SET updated_at = now()
  WHERE id = COALESCE(NEW.vocabulary_sentence_id, OLD.vocabulary_sentence_id);
  RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_vocabulary_sentence_i18n_propagate
  AFTER INSERT OR UPDATE OR DELETE ON vocabulary_sentence_i18n
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_vocabulary_sentences();
