import '../../domain/entities/jlpt_level.dart';

class JlptMappingParser {
  static List<JlptLevel> parse(String csvContent) {
    final lines = csvContent.split('\n');
    final results = <JlptLevel>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      if (i == 0 && line == 'kanji,level') continue;

      final parts = line.split(',');
      if (parts.length != 2) {
        throw FormatException('Expected 2 columns, got ${parts.length}', line, i + 1);
      }

      final character = parts[0];
      if (character.runes.length != 1) {
        throw FormatException(
          'Character must be a single Unicode code point, '
          'got ${character.runes.length}',
          line,
          i + 1,
        );
      }

      final level = int.tryParse(parts[1]);
      if (level == null || level < 1 || level > 5) {
        throw FormatException(
          'Level must be an integer 1–5, got "${parts[1]}"',
          line,
          i + 1,
        );
      }

      results.add(JlptLevel(character: character, level: level));
    }

    return results;
  }
}
