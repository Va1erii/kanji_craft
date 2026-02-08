ALTER TABLE vocabulary_sentences
  ADD COLUMN verification_status verification_status NOT NULL DEFAULT 'verified';

CREATE INDEX idx_vocabulary_sentences_verification_status
  ON vocabulary_sentences (verification_status);
