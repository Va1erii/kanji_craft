-- Add segments JSONB column to vocabulary table

ALTER TABLE vocabulary ADD COLUMN segments JSONB NOT NULL DEFAULT '[]';

ALTER TABLE vocabulary ADD CONSTRAINT chk_vocabulary_segments_is_array
  CHECK (jsonb_typeof(segments) = 'array');
