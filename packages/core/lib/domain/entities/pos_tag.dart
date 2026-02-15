/// Grammar classification tags derived from JMdict pos codes.
///
/// All values come exclusively from the JMdict `pos` field. Register,
/// orthography, and style metadata live in [MiscTag].
enum PosTag {
  ichidanVerb,
  godanVerb,
  suruVerb,
  kuruVerb,
  transitive,
  intransitive,
  iAdjective,
  naAdjective,
  noAdjective,
  noun,
  adverb,
  pronoun,
  particle,
  counter,
  conjunction,
  interjection,
  expression,
  prefix,
  suffix,
}
