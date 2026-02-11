-- Restructure vocabulary_sentences: replace split fields with original_text

-- Drop old check constraints
ALTER TABLE vocabulary_sentences DROP CONSTRAINT chk_vocabulary_sentences_lang_code_ne;
ALTER TABLE vocabulary_sentences DROP CONSTRAINT chk_vocabulary_sentences_sentence_ja_ne;
ALTER TABLE vocabulary_sentences DROP CONSTRAINT chk_vocabulary_sentences_sentence_furigana_ne;
ALTER TABLE vocabulary_sentences DROP CONSTRAINT chk_vocabulary_sentences_sentence_translated_ne;

-- Drop old unique constraint
ALTER TABLE vocabulary_sentences DROP CONSTRAINT uq_vocabulary_sentences_vocabulary_id_lang_code;

-- Remove old columns
ALTER TABLE vocabulary_sentences DROP COLUMN lang_code;
ALTER TABLE vocabulary_sentences DROP COLUMN sentence_ja;
ALTER TABLE vocabulary_sentences DROP COLUMN sentence_furigana;
ALTER TABLE vocabulary_sentences DROP COLUMN sentence_translated;

-- Add new column
ALTER TABLE vocabulary_sentences ADD COLUMN original_text TEXT NOT NULL DEFAULT '';

-- Add check constraint for non-empty
ALTER TABLE vocabulary_sentences ADD CONSTRAINT chk_vocabulary_sentences_original_text_ne
  CHECK (original_text <> '');

-- One sentence per vocabulary word
ALTER TABLE vocabulary_sentences ADD CONSTRAINT uq_vocabulary_sentences_vocabulary_id
  UNIQUE (vocabulary_id);
