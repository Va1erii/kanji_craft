/// Register, orthography, and style tags derived from JMdict misc/ke_inf codes.
///
/// Complements [PosTag] (grammar) with non-grammatical metadata that affects
/// display, tone, and search.
enum MiscTag {
  usuallyKana,
  usuallyKanji,
  exclusivelyKana,
  exclusivelyKanji,
  polite,
  humble,
  honorific,
  colloquial,
  slang,
  archaism,
  onomatopoeia,
  yojijukugo,
  idiomatic,
  abbreviation,
  proverb,
  irregularVerb,
  ateji,
  rare,
  sensitive,
  vulgar,
}
