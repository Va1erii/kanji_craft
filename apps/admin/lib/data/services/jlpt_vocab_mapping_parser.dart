import '../../domain/entities/vocab_level.dart';

/// Parses JLPT vocabulary mapping CSV files (n1.csv–n5.csv) into
/// [VocabLevel] entries.
///
/// Each file has columns: expression, reading, meaning, tags, guid.
/// Only `expression` and `reading` are consumed; the level is derived
/// from the file name, not from tags.
///
/// When the same `(expression, reading)` appears across multiple files,
/// the easiest level (highest number) is kept — the word is available at
/// the earliest JLPT stage where learners need it.
class JlptVocabMappingParser {
  /// Parses a single CSV file content at the given [level] (1–5).
  ///
  /// Returns a list of [VocabLevel] entries. Duplicate
  /// `(expression, reading)` pairs within the same file are deduplicated
  /// by keeping the first occurrence.
  static List<VocabLevel> parse(String csvContent, {required int level}) {
    if (level < 1 || level > 5) {
      throw ArgumentError.value(level, 'level', 'Must be between 1 and 5');
    }

    final lines = csvContent.split('\n');
    final results = <VocabLevel>[];
    final seen = <String>{};

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      if (i == 0 && line.startsWith('expression,')) continue;

      final fields = _parseCsvLine(line);
      if (fields.length < 2) {
        throw FormatException(
          'Expected at least 2 columns, got ${fields.length}',
          line,
          i + 1,
        );
      }

      final expression = fields[0];
      final reading = fields[1];

      if (expression.isEmpty) {
        throw FormatException('Empty expression', line, i + 1);
      }

      // For kana-only entries with empty reading, copy expression to reading.
      final effectiveReading = reading.isEmpty ? expression : reading;

      final key = '$expression\t$effectiveReading';
      if (seen.contains(key)) continue;
      seen.add(key);

      results.add(VocabLevel(
        expression: expression,
        reading: effectiveReading,
        level: level,
      ));
    }

    return results;
  }

  /// Parses multiple CSV files and merges them, keeping the easiest level
  /// (highest number) for duplicate `(expression, reading)` pairs.
  ///
  /// [filesByLevel] maps JLPT level (1–5) to CSV content.
  static List<VocabLevel> parseAll(Map<int, String> filesByLevel) {
    final merged = <String, VocabLevel>{};

    for (final entry in filesByLevel.entries) {
      final items = parse(entry.value, level: entry.key);
      for (final item in items) {
        final key = '${item.expression}\t${item.reading}';
        final existing = merged[key];
        // Keep easiest level (highest number: 5=N5 easiest, 1=N1 hardest).
        if (existing == null || item.level > existing.level) {
          merged[key] = item;
        }
      }
    }

    return merged.values.toList();
  }

  /// Parses a single CSV line, handling quoted fields (RFC 4180).
  static List<String> _parseCsvLine(String line) {
    final fields = <String>[];
    var i = 0;

    while (i < line.length) {
      if (line[i] == '"') {
        // Quoted field.
        final buffer = StringBuffer();
        i++; // skip opening quote
        while (i < line.length) {
          if (line[i] == '"') {
            if (i + 1 < line.length && line[i + 1] == '"') {
              buffer.write('"');
              i += 2;
            } else {
              i++; // skip closing quote
              break;
            }
          } else {
            buffer.write(line[i]);
            i++;
          }
        }
        fields.add(buffer.toString());
        // Skip comma after quoted field.
        if (i < line.length && line[i] == ',') i++;
      } else {
        // Unquoted field.
        final start = i;
        while (i < line.length && line[i] != ',') {
          i++;
        }
        fields.add(line.substring(start, i));
        if (i < line.length) i++; // skip comma
      }
    }

    // A trailing comma means there's a final empty field (RFC 4180).
    if (line.endsWith(',')) fields.add('');

    return fields;
  }
}
