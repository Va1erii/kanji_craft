/// Curated part-of-speech and usage tags derived from JMdict.
///
/// Drives UI badges, color-coding, and display logic (e.g., prepending
/// "to" for verbs, showing transitivity indicators).
enum PosTag {
  ichidanVerb,
  godanVerb,
  suruVerb,
  kuruVerb,
  transitive,
  intransitive,
  iAdjective,
  naAdjective,
  noun,
  adverb,
  usuallyKana,
  polite,
  humble,
  honorific,
}
