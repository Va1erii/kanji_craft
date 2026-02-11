import 'dart:convert';

import '../../domain/entities/jmdict_furigana_entry.dart';
import '../../domain/services/parse_result.dart';

/// Parses the JmdictFurigana JSON dataset into [JmdictFuriganaEntry] entries.
///
/// The source file is a JSON array of objects with `text`, `reading`, and
/// `furigana` fields. The `furigana` array is stored as a raw JSON string
/// on the entry — no intermediate domain type is needed for staging data.
///
/// Handles UTF-8 BOM (`\xEF\xBB\xBF`) at the start of the file.
class JmdictFuriganaParser {
  static ParseResult<JmdictFuriganaEntry> parse(String jsonContent) {
    // Strip UTF-8 BOM if present.
    final content =
        jsonContent.startsWith('\uFEFF') ? jsonContent.substring(1) : jsonContent;

    final list = jsonDecode(content) as List;
    final entries = <JmdictFuriganaEntry>[];
    final skipped = <SkippedEntry>[];

    for (var i = 0; i < list.length; i++) {
      final item = list[i] as Map<String, Object?>;

      final text = item['text'] as String?;
      final reading = item['reading'] as String?;
      final furigana = item['furigana'] as List?;

      if (text == null || text.isEmpty) {
        skipped.add(SkippedEntry(id: 'index:$i', reason: 'missing text'));
        continue;
      }
      if (reading == null || reading.isEmpty) {
        skipped.add(SkippedEntry(id: text, reason: 'missing reading'));
        continue;
      }
      if (furigana == null || furigana.isEmpty) {
        skipped.add(SkippedEntry(id: '$text/$reading', reason: 'missing furigana'));
        continue;
      }

      entries.add(JmdictFuriganaEntry(
        text: text,
        reading: reading,
        furigana: jsonEncode(furigana),
      ));
    }

    return ParseResult(
      entries: entries,
      totalElements: list.length,
      skipped: skipped,
    );
  }
}
