-- =============================================================
-- Migration: revert_radical_fields_not_null
-- Description: Revert 20260210150814 — restore NOT NULL on
--   radical/variant SVG and metadata fields. Content tables
--   represent fully-complete rows; pipeline intermediate state
--   will use separate staging tables.
-- =============================================================

-- ----- radicals: metadata fields -----

ALTER TABLE radicals ALTER COLUMN impact_score SET NOT NULL;
ALTER TABLE radicals DROP CONSTRAINT chk_radicals_impact_score;
ALTER TABLE radicals ADD CONSTRAINT chk_radicals_impact_score
  CHECK (impact_score BETWEEN 1 AND 10);

ALTER TABLE radicals ALTER COLUMN min_jlpt_level SET NOT NULL;
ALTER TABLE radicals DROP CONSTRAINT chk_radicals_min_jlpt_level;
ALTER TABLE radicals ADD CONSTRAINT chk_radicals_min_jlpt_level
  CHECK (min_jlpt_level BETWEEN 1 AND 5);

ALTER TABLE radicals ALTER COLUMN min_grade SET NOT NULL;
ALTER TABLE radicals DROP CONSTRAINT chk_radicals_min_grade;
ALTER TABLE radicals ADD CONSTRAINT chk_radicals_min_grade
  CHECK (min_grade BETWEEN 1 AND 8);

-- ----- radicals: SVG fields -----

ALTER TABLE radicals ALTER COLUMN svg_file_name SET NOT NULL;
ALTER TABLE radicals DROP CONSTRAINT chk_radicals_svg_file_name_ne;
ALTER TABLE radicals ADD CONSTRAINT chk_radicals_svg_file_name_ne
  CHECK (svg_file_name <> '');

ALTER TABLE radicals ALTER COLUMN svg_file_url SET NOT NULL;
ALTER TABLE radicals DROP CONSTRAINT chk_radicals_svg_file_url_ne;
ALTER TABLE radicals ADD CONSTRAINT chk_radicals_svg_file_url_ne
  CHECK (svg_file_url <> '');

ALTER TABLE radicals ALTER COLUMN svg_hash SET NOT NULL;
ALTER TABLE radicals DROP CONSTRAINT chk_radicals_svg_hash_ne;
ALTER TABLE radicals ADD CONSTRAINT chk_radicals_svg_hash_ne
  CHECK (svg_hash <> '');

-- ----- radical_variants: SVG fields -----

ALTER TABLE radical_variants ALTER COLUMN svg_file_name SET NOT NULL;
ALTER TABLE radical_variants DROP CONSTRAINT chk_radical_variants_svg_file_name_ne;
ALTER TABLE radical_variants ADD CONSTRAINT chk_radical_variants_svg_file_name_ne
  CHECK (svg_file_name <> '');

ALTER TABLE radical_variants ALTER COLUMN svg_file_url SET NOT NULL;
ALTER TABLE radical_variants DROP CONSTRAINT chk_radical_variants_svg_file_url_ne;
ALTER TABLE radical_variants ADD CONSTRAINT chk_radical_variants_svg_file_url_ne
  CHECK (svg_file_url <> '');

ALTER TABLE radical_variants ALTER COLUMN svg_hash SET NOT NULL;
ALTER TABLE radical_variants DROP CONSTRAINT chk_radical_variants_svg_hash_ne;
ALTER TABLE radical_variants ADD CONSTRAINT chk_radical_variants_svg_hash_ne
  CHECK (svg_hash <> '');
