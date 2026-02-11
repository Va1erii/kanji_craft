import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/jlpt_mapping_parser.dart';

void main() {
  group('JlptMappingParser', () {
    test('parses valid CSV with header', () {
      const csv = 'kanji,level\n一,5\n力,4\n刀,1\n';
      final results = JlptMappingParser.parse(csv);

      expect(results, hasLength(3));
      expect(results[0].character, '一');
      expect(results[0].level, 5);
      expect(results[1].character, '力');
      expect(results[1].level, 4);
      expect(results[2].character, '刀');
      expect(results[2].level, 1);
    });

    test('skips empty lines', () {
      const csv = 'kanji,level\n一,5\n\n力,4\n\n';
      final results = JlptMappingParser.parse(csv);

      expect(results, hasLength(2));
      expect(results[0].character, '一');
      expect(results[1].character, '力');
    });

    test('handles trailing newline', () {
      const csv = 'kanji,level\n一,5\n';
      final results = JlptMappingParser.parse(csv);

      expect(results, hasLength(1));
      expect(results[0].character, '一');
      expect(results[0].level, 5);
    });

    test('returns empty list for header-only content', () {
      const csv = 'kanji,level\n';
      final results = JlptMappingParser.parse(csv);

      expect(results, isEmpty);
    });

    test('throws FormatException for level 0', () {
      const csv = 'kanji,level\n一,0\n';
      expect(
        () => JlptMappingParser.parse(csv),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for level 6', () {
      const csv = 'kanji,level\n一,6\n';
      expect(
        () => JlptMappingParser.parse(csv),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for non-integer level', () {
      const csv = 'kanji,level\n一,abc\n';
      expect(
        () => JlptMappingParser.parse(csv),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for missing column', () {
      const csv = 'kanji,level\n一\n';
      expect(
        () => JlptMappingParser.parse(csv),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for multi-codepoint character', () {
      const csv = 'kanji,level\n一二,5\n';
      expect(
        () => JlptMappingParser.parse(csv),
        throwsA(isA<FormatException>()),
      );
    });

    test('parses all five JLPT levels', () {
      const csv = 'kanji,level\n亜,1\n圧,2\n安,3\n以,4\n一,5\n';
      final results = JlptMappingParser.parse(csv);

      expect(results, hasLength(5));
      expect(results.map((e) => e.level), [1, 2, 3, 4, 5]);
    });
  });
}
