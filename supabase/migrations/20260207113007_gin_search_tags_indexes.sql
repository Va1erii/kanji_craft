-- GIN indexes for array containment queries on search_tags
CREATE INDEX idx_radical_i18n_search_tags ON radical_i18n USING GIN (search_tags);
CREATE INDEX idx_kanji_i18n_search_tags ON kanji_i18n USING GIN (search_tags);
CREATE INDEX idx_vocabulary_i18n_search_tags ON vocabulary_i18n USING GIN (search_tags);
