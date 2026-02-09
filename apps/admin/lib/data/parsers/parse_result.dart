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

class SkippedEntry {
  SkippedEntry({required this.id, required this.reason});

  final String id;
  final String reason;

  Map<String, String> toMap() => {'id': id, 'reason': reason};
}
