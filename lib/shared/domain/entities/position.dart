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
