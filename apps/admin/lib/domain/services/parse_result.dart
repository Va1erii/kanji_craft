/// The result of parsing a source data file into raw domain entities.
///
/// Contains the successfully parsed [entries], the [totalElements] found in
/// the source file, and any [skipped] entries that could not be parsed.
/// Use [toMetadata] to serialise parse statistics for storage on a
/// [DataImport] record.
class ParseResult<T> {
  ParseResult({
    required this.entries,
    required this.totalElements,
    this.skipped = const [],
  });

  final List<T> entries;
  final int totalElements;
  final List<SkippedEntry> skipped;

  int get parsedCount => entries.length;
  int get skippedCount => skipped.length;

  Map<String, Object?> toMetadata() => {
        'total_elements': totalElements,
        'parsed_count': parsedCount,
        if (skipped.isNotEmpty)
          'skipped': skipped.map((s) => s.toMap()).toList(),
      };
}

/// An entry that was present in the source file but could not be parsed.
class SkippedEntry {
  SkippedEntry({required this.id, required this.reason});

  final String id;
  final String reason;

  Map<String, String> toMap() => {'id': id, 'reason': reason};
}
