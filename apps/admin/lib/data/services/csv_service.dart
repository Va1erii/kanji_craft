import 'dart:convert';
import 'dart:io';

/// Shared stateless service for CSV read/write operations.
///
/// Uses UTF-8 with BOM for Excel compatibility with Japanese characters.
/// Search tags are pipe-delimited within a single cell.
class CsvService {
  /// UTF-8 BOM bytes for Excel compatibility.
  static const _bom = '\uFEFF';

  /// Writes a CSV file with headers and rows.
  ///
  /// Writes UTF-8 BOM prefix for Excel/Sheets compatibility.
  Future<void> writeCsv({
    required String filePath,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    final buffer = StringBuffer(_bom);
    buffer.writeln(_encodeCsvRow(headers));
    for (final row in rows) {
      buffer.writeln(_encodeCsvRow(row));
    }
    final file = File(filePath);
    await file.writeAsString(buffer.toString(), encoding: utf8);
  }

  /// Parses CSV content, validating required headers.
  ///
  /// Returns parsed rows (as maps of header→value) and any warnings.
  /// Strips UTF-8 BOM if present.
  ({List<Map<String, String>> rows, List<String> warnings}) parseCsv({
    required String content,
    required List<String> requiredHeaders,
  }) {
    // Strip BOM if present.
    var text = content;
    if (text.startsWith(_bom)) {
      text = text.substring(1);
    }

    final lines = _parseCsvLines(text);
    if (lines.isEmpty) {
      throw const FormatException('CSV file is empty');
    }

    final headers = lines.first;
    final warnings = <String>[];

    // Validate required headers.
    for (final required in requiredHeaders) {
      if (!headers.contains(required)) {
        throw FormatException('Missing required header: $required');
      }
    }

    final rows = <Map<String, String>>[];
    for (var i = 1; i < lines.length; i++) {
      final fields = lines[i];
      if (fields.length != headers.length) {
        warnings.add('Row ${i + 1}: expected ${headers.length} columns, '
            'got ${fields.length} — skipped');
        continue;
      }
      final map = <String, String>{};
      for (var j = 0; j < headers.length; j++) {
        map[headers[j]] = fields[j];
      }
      rows.add(map);
    }

    return (rows: rows, warnings: warnings);
  }

  /// Splits a pipe-delimited tag string into a deduplicated list.
  List<String> parsePipeTags(String value) {
    if (value.trim().isEmpty) return [];
    final tags = value.split('|').map((t) => t.trim()).where((t) => t.isNotEmpty);
    return tags.toSet().toList();
  }

  /// Joins a list of tags into a pipe-delimited string.
  String joinPipeTags(List<String> tags) => tags.join('|');

  // -- Private helpers --

  /// Encodes a single CSV row with proper quoting.
  String _encodeCsvRow(List<String> fields) {
    return fields.map(_escapeCsvField).join(',');
  }

  /// Escapes a CSV field value, quoting if it contains comma, quote, or newline.
  String _escapeCsvField(String value) {
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Parses CSV text into a list of rows, each row being a list of fields.
  ///
  /// Handles quoted fields with embedded commas, newlines, and escaped quotes.
  List<List<String>> _parseCsvLines(String text) {
    final rows = <List<String>>[];
    var current = <String>[];
    var field = StringBuffer();
    var inQuotes = false;
    var i = 0;

    while (i < text.length) {
      final c = text[i];

      if (inQuotes) {
        if (c == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            // Escaped quote.
            field.write('"');
            i += 2;
          } else {
            // End of quoted field.
            inQuotes = false;
            i++;
          }
        } else {
          field.write(c);
          i++;
        }
      } else {
        if (c == '"' && field.isEmpty) {
          // Start of quoted field.
          inQuotes = true;
          i++;
        } else if (c == ',') {
          current.add(field.toString());
          field = StringBuffer();
          i++;
        } else if (c == '\r') {
          // Handle \r\n or standalone \r.
          current.add(field.toString());
          if (current.length > 1 || current.first.isNotEmpty) {
            rows.add(current);
          }
          current = <String>[];
          field = StringBuffer();
          i++;
          if (i < text.length && text[i] == '\n') i++;
        } else if (c == '\n') {
          current.add(field.toString());
          if (current.length > 1 || current.first.isNotEmpty) {
            rows.add(current);
          }
          current = <String>[];
          field = StringBuffer();
          i++;
        } else {
          field.write(c);
          i++;
        }
      }
    }

    // Handle last field/row.
    if (inQuotes || field.isNotEmpty || current.isNotEmpty) {
      current.add(field.toString());
      if (current.length > 1 || current.first.isNotEmpty) {
        rows.add(current);
      }
    }

    return rows;
  }
}
