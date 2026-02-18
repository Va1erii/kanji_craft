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
  tarec("Complement of Tare"),
  nyoc("Complement of Nyo"),
  kamaec("Complement of Kamae"),
  unknown("Unknown Position");

  final String description;

  const Position(this.description);
}
