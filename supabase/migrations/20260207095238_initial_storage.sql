-- =============================================================
-- Migration: initial_storage
-- Description: Create SVG storage bucket and public read policy
-- =============================================================

-- Create the svg bucket (ON CONFLICT for config.toml local declaration)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'svg',
  'svg',
  true,
  1048576,  -- 1 MiB
  ARRAY['image/svg+xml']
)
ON CONFLICT (id) DO NOTHING;

-- Public read access for SVG files (no auth required)
CREATE POLICY "Public read access for SVG files"
  ON storage.objects FOR SELECT TO public
  USING (bucket_id = 'svg');
