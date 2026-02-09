-- =============================================================
-- Dependency propagation triggers
-- When a child row is inserted, updated, or deleted, bump the parent's updated_at
-- so the parent appears "dirty" for sync.
-- =============================================================

CREATE OR REPLACE FUNCTION propagate_updated_at_to_radical()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE radicals SET updated_at = now()
  WHERE id = COALESCE(NEW.radical_id, OLD.radical_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION propagate_updated_at_to_kanji()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE kanji SET updated_at = now()
  WHERE id = COALESCE(NEW.kanji_id, OLD.kanji_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION propagate_updated_at_to_vocabulary()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE vocabulary SET updated_at = now()
  WHERE id = COALESCE(NEW.vocabulary_id, OLD.vocabulary_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Radical children
CREATE TRIGGER trg_radical_i18n_propagate
  AFTER INSERT OR UPDATE OR DELETE ON radical_i18n
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_radical();

CREATE TRIGGER trg_radical_variants_propagate
  AFTER INSERT OR UPDATE OR DELETE ON radical_variants
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_radical();

-- Kanji children
CREATE TRIGGER trg_kanji_readings_propagate
  AFTER INSERT OR UPDATE OR DELETE ON kanji_readings
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_kanji();

CREATE TRIGGER trg_kanji_i18n_propagate
  AFTER INSERT OR UPDATE OR DELETE ON kanji_i18n
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_kanji();

CREATE TRIGGER trg_kanji_components_propagate
  AFTER INSERT OR UPDATE OR DELETE ON kanji_components
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_kanji();

-- Vocabulary children
CREATE TRIGGER trg_vocabulary_readings_propagate
  AFTER INSERT OR UPDATE OR DELETE ON vocabulary_readings
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_vocabulary();

CREATE TRIGGER trg_vocabulary_i18n_propagate
  AFTER INSERT OR UPDATE OR DELETE ON vocabulary_i18n
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_vocabulary();

CREATE TRIGGER trg_vocabulary_kanji_propagate
  AFTER INSERT OR UPDATE OR DELETE ON vocabulary_kanji
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_vocabulary();

CREATE TRIGGER trg_vocabulary_sentences_propagate
  AFTER INSERT OR UPDATE OR DELETE ON vocabulary_sentences
  FOR EACH ROW EXECUTE FUNCTION propagate_updated_at_to_vocabulary();
