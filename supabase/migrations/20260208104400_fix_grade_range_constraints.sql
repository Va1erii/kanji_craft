-- Fix min_grade range: 1-6 → 1-8 (includes secondary school grades)
ALTER TABLE radicals
  DROP CONSTRAINT chk_radicals_min_grade,
  ADD CONSTRAINT chk_radicals_min_grade CHECK (min_grade BETWEEN 1 AND 8);

ALTER TABLE kanji
  DROP CONSTRAINT chk_kanji_min_grade,
  ADD CONSTRAINT chk_kanji_min_grade CHECK (min_grade BETWEEN 1 AND 8);

-- Add cross-column constraint for current_level upper bound
ALTER TABLE user_settings
  DROP CONSTRAINT chk_user_settings_current_level,
  ADD CONSTRAINT chk_user_settings_current_level CHECK (
    (study_path = 'jlpt' AND current_level BETWEEN 1 AND 5) OR
    (study_path = 'grade' AND current_level BETWEEN 1 AND 8)
  );
