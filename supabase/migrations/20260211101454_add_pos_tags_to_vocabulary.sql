-- Add pos_tag enum and pos_tags JSONB column to vocabulary table

CREATE TYPE pos_tag AS ENUM (
    'ichidan_verb',
    'godan_verb',
    'suru_verb',
    'kuru_verb',
    'transitive',
    'intransitive',
    'i_adjective',
    'na_adjective',
    'noun',
    'adverb',
    'usually_kana',
    'polite',
    'humble',
    'honorific'
);

ALTER TABLE vocabulary ADD COLUMN pos_tags JSONB NOT NULL DEFAULT '[]';

ALTER TABLE vocabulary ADD CONSTRAINT chk_vocabulary_pos_tags_is_array
    CHECK (jsonb_typeof(pos_tags) = 'array');
