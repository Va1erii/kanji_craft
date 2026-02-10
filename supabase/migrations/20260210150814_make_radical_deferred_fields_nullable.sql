-- =============================================================
-- Migration: make_radical_deferred_fields_nullable
-- Description: Make pipeline-deferred fields nullable on radicals
--   and radical_variants. These are populated in later pipeline
--   passes (Pass 4 metadata, Phase 2.4 SVG). The Release Builder
--   rejects rows with nulls before remote sync.
-- =============================================================

-- ----- radicals: metadata fields (Pass 4) -----

ALTER TABLE radicals
  ALTER COLUMN impact_score DROP NOT NULL;

ALTER TABLE radicals
  DROP CONSTRAINT chk_radicals_impact_score;
ALTER TABLE radicals
  ADD CONSTRAINT chk_radicals_impact_score CHECK (impact_score IS NULL OR impact_score BETWEEN 1 AND 10);

ALTER TABLE radicals
  ALTER COLUMN min_jlpt_level DROP NOT NULL;

ALTER TABLE radicals
  DROP CONSTRAINT chk_radicals_min_jlpt_level;
ALTER TABLE radicals
  ADD CONSTRAINT chk_radicals_min_jlpt_level CHECK (min_jlpt_level IS NULL OR min_jlpt_level BETWEEN 1 AND 5);

ALTER TABLE radicals
  ALTER COLUMN min_grade DROP NOT NULL;

-- min_grade constraint already allows 1-8 from fix_grade_range_constraints
ALTER TABLE radicals
  DROP CONSTRAINT chk_radicals_min_grade;
ALTER TABLE radicals
  ADD CONSTRAINT chk_radicals_min_grade CHECK (min_grade IS NULL OR min_grade BETWEEN 1 AND 8);

-- ----- radicals: SVG fields (Phase 2.4) -----

ALTER TABLE radicals
  ALTER COLUMN svg_file_name DROP NOT NULL;
ALTER TABLE radicals
  DROP CONSTRAINT chk_radicals_svg_file_name_ne;
ALTER TABLE radicals
  ADD CONSTRAINT chk_radicals_svg_file_name_ne CHECK (svg_file_name IS NULL OR svg_file_name <> '');

ALTER TABLE radicals
  ALTER COLUMN svg_file_url DROP NOT NULL;
ALTER TABLE radicals
  DROP CONSTRAINT chk_radicals_svg_file_url_ne;
ALTER TABLE radicals
  ADD CONSTRAINT chk_radicals_svg_file_url_ne CHECK (svg_file_url IS NULL OR svg_file_url <> '');

ALTER TABLE radicals
  ALTER COLUMN svg_hash DROP NOT NULL;
ALTER TABLE radicals
  DROP CONSTRAINT chk_radicals_svg_hash_ne;
ALTER TABLE radicals
  ADD CONSTRAINT chk_radicals_svg_hash_ne CHECK (svg_hash IS NULL OR svg_hash <> '');

-- ----- radical_variants: SVG fields (Phase 2.4) -----

ALTER TABLE radical_variants
  ALTER COLUMN svg_file_name DROP NOT NULL;
ALTER TABLE radical_variants
  DROP CONSTRAINT chk_radical_variants_svg_file_name_ne;
ALTER TABLE radical_variants
  ADD CONSTRAINT chk_radical_variants_svg_file_name_ne CHECK (svg_file_name IS NULL OR svg_file_name <> '');

ALTER TABLE radical_variants
  ALTER COLUMN svg_file_url DROP NOT NULL;
ALTER TABLE radical_variants
  DROP CONSTRAINT chk_radical_variants_svg_file_url_ne;
ALTER TABLE radical_variants
  ADD CONSTRAINT chk_radical_variants_svg_file_url_ne CHECK (svg_file_url IS NULL OR svg_file_url <> '');

ALTER TABLE radical_variants
  ALTER COLUMN svg_hash DROP NOT NULL;
ALTER TABLE radical_variants
  DROP CONSTRAINT chk_radical_variants_svg_hash_ne;
ALTER TABLE radical_variants
  ADD CONSTRAINT chk_radical_variants_svg_hash_ne CHECK (svg_hash IS NULL OR svg_hash <> '');
