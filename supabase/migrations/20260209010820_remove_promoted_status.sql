-- Remove 'promoted' from import_status enum and drop promoted_at column.
-- Promotion now happens at the item level (per kanji, vocab, etc.),
-- not at the import level. The terminal success state is 'processed'.

-- Drop the unique partial index that enforced one promoted import per source+version.
DROP INDEX IF EXISTS uq_data_imports_source_version_promoted;

-- Drop the promoted_at column.
ALTER TABLE data_imports DROP COLUMN IF EXISTS promoted_at;

-- Rename the enum value: 'promoted' → remove it.
-- PostgreSQL doesn't support DROP VALUE from enum, so we recreate.
ALTER TYPE import_status RENAME TO import_status_old;

CREATE TYPE import_status AS ENUM (
  'pending', 'ingested', 'processing', 'processed', 'failed'
);

ALTER TABLE data_imports
  ALTER COLUMN status DROP DEFAULT,
  ALTER COLUMN status TYPE import_status USING status::text::import_status,
  ALTER COLUMN status SET DEFAULT 'pending';

DROP TYPE import_status_old;

-- Add a unique partial index for processed imports instead.
CREATE UNIQUE INDEX uq_data_imports_source_version_processed
  ON data_imports (source, source_version)
  WHERE status = 'processed';
