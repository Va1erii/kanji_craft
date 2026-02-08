-- =============================================================
-- Migration: staging_rls_policies
-- Description: Enable RLS on staging and admin tables.
--   Zero policies — access is service_role only (bypasses RLS).
-- =============================================================

ALTER TABLE data_imports              ENABLE ROW LEVEL SECURITY;
ALTER TABLE raw_kanjivg               ENABLE ROW LEVEL SECURITY;
ALTER TABLE raw_kanjidic              ENABLE ROW LEVEL SECURITY;
ALTER TABLE kanji_component_reviews   ENABLE ROW LEVEL SECURITY;
