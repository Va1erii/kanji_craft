-- Pin search_path on propagation trigger functions to prevent
-- mutable search_path security issue.
-- Recreate with schema-qualified table references since search_path is empty.

CREATE OR REPLACE FUNCTION public.propagate_updated_at_to_radical()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
  UPDATE public.radicals SET updated_at = now()
  WHERE id = COALESCE(NEW.radical_id, OLD.radical_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.propagate_updated_at_to_kanji()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
  UPDATE public.kanji SET updated_at = now()
  WHERE id = COALESCE(NEW.kanji_id, OLD.kanji_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.propagate_updated_at_to_vocabulary()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
  UPDATE public.vocabulary SET updated_at = now()
  WHERE id = COALESCE(NEW.vocabulary_id, OLD.vocabulary_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;
