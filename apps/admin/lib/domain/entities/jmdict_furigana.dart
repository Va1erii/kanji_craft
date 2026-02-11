/// A single furigana mapping from the JmdictFurigana dataset.
///
/// Stores the raw JSON string for the furigana segments to avoid
/// an intermediate domain type for this staging-only data.
class JmdictFurigana {
  const JmdictFurigana({
    required this.text,
    required this.reading,
    required this.furigana,
  });

  /// The word as written (kanji or kana).
  final String text;

  /// The full pronunciation in kana.
  final String reading;

  /// The furigana segments as a raw JSON string (array of {ruby, rt?} objects).
  final String furigana;
}
