import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/csv_service.dart';

void main() {
  late CsvService csvService;
  late Directory tempDir;

  setUp(() {
    csvService = CsvService();
    tempDir = Directory.systemTemp.createTempSync('csv_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  group('writeCsv', () {
    test('writes UTF-8 BOM and correct content', () async {
      final filePath = '${tempDir.path}/test.csv';
      await csvService.writeCsv(
        filePath: filePath,
        headers: ['id', 'name', 'value'],
        rows: [
          ['1', 'hello', 'world'],
          ['2', 'foo', 'bar'],
        ],
      );

      // Verify BOM via raw bytes (readAsString may strip BOM).
      final bytes = await File(filePath).readAsBytes();
      expect(bytes[0], 0xEF, reason: 'UTF-8 BOM byte 1');
      expect(bytes[1], 0xBB, reason: 'UTF-8 BOM byte 2');
      expect(bytes[2], 0xBF, reason: 'UTF-8 BOM byte 3');

      final content = utf8.decode(bytes.sublist(3));
      final lines = content.trim().split('\n');
      expect(lines.length, 3);
      expect(lines[0].trim(), 'id,name,value');
      expect(lines[1].trim(), '1,hello,world');
      expect(lines[2].trim(), '2,foo,bar');
    });

    test('escapes fields with commas, quotes, and newlines', () async {
      final filePath = '${tempDir.path}/escape.csv';
      await csvService.writeCsv(
        filePath: filePath,
        headers: ['text'],
        rows: [
          ['hello, world'],
          ['say "hi"'],
          ['line1\nline2'],
        ],
      );

      final content = await File(filePath).readAsString();
      // Remove BOM.
      final body = content.substring(1);
      expect(body, contains('"hello, world"'));
      expect(body, contains('"say ""hi"""'));
      expect(body, contains('"line1\nline2"'));
    });

    test('writes Japanese characters correctly', () async {
      final filePath = '${tempDir.path}/japanese.csv';
      await csvService.writeCsv(
        filePath: filePath,
        headers: ['symbol', 'name'],
        rows: [
          ['木', 'tree'],
          ['水', 'water'],
        ],
      );

      final content = await File(filePath).readAsString();
      expect(content, contains('木'));
      expect(content, contains('水'));
    });
  });

  group('parseCsv', () {
    test('parses basic CSV with BOM', () {
      const content = '\uFEFFid,name\n1,hello\n2,world\n';
      final result = csvService.parseCsv(
        content: content,
        requiredHeaders: ['id', 'name'],
      );

      expect(result.rows.length, 2);
      expect(result.rows[0]['id'], '1');
      expect(result.rows[0]['name'], 'hello');
      expect(result.rows[1]['id'], '2');
      expect(result.rows[1]['name'], 'world');
      expect(result.warnings, isEmpty);
    });

    test('parses CSV without BOM', () {
      const content = 'id,name\n1,hello\n';
      final result = csvService.parseCsv(
        content: content,
        requiredHeaders: ['id', 'name'],
      );

      expect(result.rows.length, 1);
      expect(result.rows[0]['id'], '1');
    });

    test('handles quoted fields with commas', () {
      const content = 'id,text\n1,"hello, world"\n';
      final result = csvService.parseCsv(
        content: content,
        requiredHeaders: ['id', 'text'],
      );

      expect(result.rows[0]['text'], 'hello, world');
    });

    test('handles escaped quotes', () {
      const content = 'id,text\n1,"say ""hi"""\n';
      final result = csvService.parseCsv(
        content: content,
        requiredHeaders: ['id', 'text'],
      );

      expect(result.rows[0]['text'], 'say "hi"');
    });

    test('handles multiline quoted fields', () {
      const content = 'id,text\n1,"line1\nline2"\n';
      final result = csvService.parseCsv(
        content: content,
        requiredHeaders: ['id', 'text'],
      );

      expect(result.rows[0]['text'], 'line1\nline2');
    });

    test('throws on missing required header', () {
      const content = 'id,other\n1,val\n';
      expect(
        () => csvService.parseCsv(
          content: content,
          requiredHeaders: ['id', 'name'],
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws on empty content', () {
      expect(
        () => csvService.parseCsv(content: '', requiredHeaders: ['id']),
        throwsA(isA<FormatException>()),
      );
    });

    test('warns on column count mismatch', () {
      const content = 'id,name\n1,hello\n2\n';
      final result = csvService.parseCsv(
        content: content,
        requiredHeaders: ['id', 'name'],
      );

      expect(result.rows.length, 1);
      expect(result.warnings.length, 1);
      expect(result.warnings[0], contains('expected 2 columns'));
    });
  });

  group('parsePipeTags', () {
    test('splits pipe-delimited tags', () {
      expect(csvService.parsePipeTags('tree|wood|forest'), ['tree', 'wood', 'forest']);
    });

    test('deduplicates tags', () {
      expect(csvService.parsePipeTags('tree|wood|tree'), ['tree', 'wood']);
    });

    test('trims whitespace', () {
      expect(csvService.parsePipeTags(' tree | wood '), ['tree', 'wood']);
    });

    test('returns empty list for empty string', () {
      expect(csvService.parsePipeTags(''), isEmpty);
      expect(csvService.parsePipeTags('   '), isEmpty);
    });

    test('filters empty segments', () {
      expect(csvService.parsePipeTags('tree||wood'), ['tree', 'wood']);
    });
  });

  group('joinPipeTags', () {
    test('joins tags with pipe', () {
      expect(csvService.joinPipeTags(['tree', 'wood']), 'tree|wood');
    });

    test('returns empty string for empty list', () {
      expect(csvService.joinPipeTags([]), '');
    });
  });

  group('roundtrip', () {
    test('write then parse preserves data', () async {
      final filePath = '${tempDir.path}/roundtrip.csv';
      await csvService.writeCsv(
        filePath: filePath,
        headers: ['id', 'symbol', 'mnemonic', 'tags'],
        rows: [
          ['1', '木', 'A tall tree growing from the ground', 'tree|wood'],
          ['2', '水', 'Water flowing, like "say, hello"', 'water|liquid'],
        ],
      );

      final content = await File(filePath).readAsString();
      final result = csvService.parseCsv(
        content: content,
        requiredHeaders: ['id', 'symbol', 'mnemonic', 'tags'],
      );

      expect(result.rows.length, 2);
      expect(result.rows[0]['symbol'], '木');
      expect(result.rows[0]['mnemonic'], 'A tall tree growing from the ground');
      expect(result.rows[0]['tags'], 'tree|wood');
      expect(result.rows[1]['symbol'], '水');
    });
  });
}
