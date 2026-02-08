/// The spatial position a radical occupies within a kanji character.
///
/// Traditional Japanese naming conventions are used (hen, tsukuri, etc.).
/// Each value carries a human-readable [description].
enum Position {
  hen("Left Side"),
  tsukuri("Right Side"),
  kanmuri("Top Crown"),
  ashi("Bottom Legs"),
  kamae("Enclosure"),
  tare("Hanging Top-Left"),
  nyo("Wrapping Bottom-Left"),
  unknown("Unknown Position");

  final String description;

  const Position(this.description);
}
