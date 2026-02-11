/// A vocabulary word mapped to its JLPT level from the Tanos word lists.
class VocabLevel {
  const VocabLevel({
    required this.expression,
    required this.reading,
    required this.level,
  });

  final String expression;
  final String reading;
  final int level;
}
