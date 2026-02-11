import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/jmdict_furigana_parser.dart';

void main() {
  group('JmdictFuriganaParser', () {
    // ---------------------------------------------------------------
    // Real entries from JmdictFurigana.json
    // ---------------------------------------------------------------

    test('parses mixed kanji/kana entry (食べる)', () {
      final json = jsonEncode([
        {
          'text': '食べる',
          'reading': 'たべる',
          'furigana': [
            {'ruby': '食', 'rt': 'た'},
            {'ruby': 'べる'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);

      expect(result.entries, hasLength(1));
      expect(result.totalElements, 1);
      expect(result.skipped, isEmpty);

      final entry = result.entries[0];
      expect(entry.text, '食べる');
      expect(entry.reading, 'たべる');

      final furigana = jsonDecode(entry.furigana) as List;
      expect(furigana, hasLength(2));
      expect(furigana[0]['ruby'], '食');
      expect(furigana[0]['rt'], 'た');
      expect(furigana[1]['ruby'], 'べる');
      expect(furigana[1].containsKey('rt'), isFalse);
    });

    test('parses jukujikun entry (大人)', () {
      final json = jsonEncode([
        {
          'text': '大人',
          'reading': 'おとな',
          'furigana': [
            {'ruby': '大人', 'rt': 'おとな'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);

      expect(result.entries, hasLength(1));
      final entry = result.entries[0];
      expect(entry.text, '大人');
      expect(entry.reading, 'おとな');

      final furigana = jsonDecode(entry.furigana) as List;
      expect(furigana, hasLength(1));
      expect(furigana[0]['ruby'], '大人');
      expect(furigana[0]['rt'], 'おとな');
    });

    test('parses all-kanji entry (冷蔵庫)', () {
      final json = jsonEncode([
        {
          'text': '冷蔵庫',
          'reading': 'れいぞうこ',
          'furigana': [
            {'ruby': '冷', 'rt': 'れい'},
            {'ruby': '蔵', 'rt': 'ぞう'},
            {'ruby': '庫', 'rt': 'こ'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);

      expect(result.entries, hasLength(1));
      final entry = result.entries[0];
      expect(entry.text, '冷蔵庫');

      final furigana = jsonDecode(entry.furigana) as List;
      expect(furigana, hasLength(3));
      expect(furigana[0]['ruby'], '冷');
      expect(furigana[1]['ruby'], '蔵');
      expect(furigana[2]['ruby'], '庫');
    });

    test('parses multiple readings for same text (明白)', () {
      final json = jsonEncode([
        {
          'text': '明白',
          'reading': 'めいはく',
          'furigana': [
            {'ruby': '明', 'rt': 'めい'},
            {'ruby': '白', 'rt': 'はく'},
          ],
        },
        {
          'text': '明白',
          'reading': 'あからさま',
          'furigana': [
            {'ruby': '明白', 'rt': 'あからさま'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);

      expect(result.entries, hasLength(2));
      expect(result.entries[0].reading, 'めいはく');
      expect(result.entries[1].reading, 'あからさま');

      // Second entry is jukujikun.
      final furigana2 = jsonDecode(result.entries[1].furigana) as List;
      expect(furigana2[0]['ruby'], '明白');
      expect(furigana2[0]['rt'], 'あからさま');
    });

    // ---------------------------------------------------------------
    // BOM handling
    // ---------------------------------------------------------------

    test('strips UTF-8 BOM from start of content', () {
      final json = jsonEncode([
        {
          'text': '〃',
          'reading': 'おなじ',
          'furigana': [
            {'ruby': '〃', 'rt': 'おなじ'},
          ],
        },
      ]);
      final withBom = '\uFEFF$json';

      final result = JmdictFuriganaParser.parse(withBom);

      expect(result.entries, hasLength(1));
      expect(result.entries[0].text, '〃');
    });

    test('works without BOM', () {
      final json = jsonEncode([
        {
          'text': '食べる',
          'reading': 'たべる',
          'furigana': [
            {'ruby': '食', 'rt': 'た'},
            {'ruby': 'べる'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);
      expect(result.entries, hasLength(1));
    });

    // ---------------------------------------------------------------
    // Validation and skipping
    // ---------------------------------------------------------------

    test('skips entries with missing text', () {
      final json = jsonEncode([
        {
          'text': '',
          'reading': 'おなじ',
          'furigana': [
            {'ruby': '〃', 'rt': 'おなじ'},
          ],
        },
        {
          'text': '食べる',
          'reading': 'たべる',
          'furigana': [
            {'ruby': '食', 'rt': 'た'},
            {'ruby': 'べる'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);

      expect(result.entries, hasLength(1));
      expect(result.entries[0].text, '食べる');
      expect(result.skipped, hasLength(1));
      expect(result.skipped[0].reason, 'missing text');
    });

    test('skips entries with missing reading', () {
      final json = jsonEncode([
        {
          'text': '食べる',
          'reading': '',
          'furigana': [
            {'ruby': '食', 'rt': 'た'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);

      expect(result.entries, isEmpty);
      expect(result.skipped, hasLength(1));
      expect(result.skipped[0].id, '食べる');
      expect(result.skipped[0].reason, 'missing reading');
    });

    test('skips entries with empty furigana array', () {
      final json = jsonEncode([
        {
          'text': '食べる',
          'reading': 'たべる',
          'furigana': <Object>[],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);

      expect(result.entries, isEmpty);
      expect(result.skipped, hasLength(1));
      expect(result.skipped[0].reason, 'missing furigana');
    });

    // ---------------------------------------------------------------
    // Empty and edge cases
    // ---------------------------------------------------------------

    test('returns empty result for empty array', () {
      final result = JmdictFuriganaParser.parse('[]');

      expect(result.entries, isEmpty);
      expect(result.totalElements, 0);
      expect(result.skipped, isEmpty);
    });

    test('furigana field is stored as valid JSON string', () {
      final json = jsonEncode([
        {
          'text': '食べる',
          'reading': 'たべる',
          'furigana': [
            {'ruby': '食', 'rt': 'た'},
            {'ruby': 'べる'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);
      final entry = result.entries[0];

      // Verify the furigana is a valid JSON string that round-trips.
      final decoded = jsonDecode(entry.furigana);
      expect(decoded, isList);
      expect(decoded, hasLength(2));
    });

    test('totalElements counts all entries including skipped', () {
      final json = jsonEncode([
        {
          'text': '',
          'reading': 'skip',
          'furigana': [
            {'ruby': 'x'},
          ],
        },
        {
          'text': '食べる',
          'reading': 'たべる',
          'furigana': [
            {'ruby': '食', 'rt': 'た'},
            {'ruby': 'べる'},
          ],
        },
      ]);

      final result = JmdictFuriganaParser.parse(json);

      expect(result.totalElements, 2);
      expect(result.parsedCount, 1);
      expect(result.skippedCount, 1);
    });
  });
}
