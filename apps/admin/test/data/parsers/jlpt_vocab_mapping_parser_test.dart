import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/jlpt_vocab_mapping_parser.dart';

void main() {
  group('JlptVocabMappingParser', () {
    // ---------------------------------------------------------------
    // parse() — single file
    // ---------------------------------------------------------------

    test('parses real N5 entries with quoted meanings', () {
      const csv = '''expression,reading,meaning,tags,guid
ああ,ああ,"Ah!, Oh!",JLPT JLPT_4 JLPT_5 JLPT_N5,HI-.Ij?HS~
会う,あう,"to meet, to see",JLPT JLPT_3 JLPT_5 JLPT_N5,kupB!kWE}<
青,あお,blue,JLPT JLPT_5 JLPT_N5,HB)I{+\$j.i''';

      final results = JlptVocabMappingParser.parse(csv, level: 5);

      expect(results, hasLength(3));

      expect(results[0].expression, 'ああ');
      expect(results[0].reading, 'ああ');
      expect(results[0].level, 5);

      expect(results[1].expression, '会う');
      expect(results[1].reading, 'あう');
      expect(results[1].level, 5);

      expect(results[2].expression, '青');
      expect(results[2].reading, 'あお');
      expect(results[2].level, 5);
    });

    test('parses real N4 entries including semicolons in meaning', () {
      const csv = '''expression,reading,meaning,tags,guid
盗む,ぬすむ,to steal; to rob,Genki Genki_Ln.21 JLPT JLPT_N4,yRRr.o{S!G
大抵,たいてい,"generally, usually",Genki Genki_Ln.3 JLPT JLPT_N4,F4RWhn9KV7''';

      final results = JlptVocabMappingParser.parse(csv, level: 4);

      expect(results, hasLength(2));
      expect(results[0].expression, '盗む');
      expect(results[0].reading, 'ぬすむ');
      expect(results[0].level, 4);
    });

    test('parses real N3 entries with multiple commas in meaning', () {
      const csv = '''expression,reading,meaning,tags,guid
作法,さほう,"manners, etiquette, propriety",JLPT JLPT_2 JLPT_3,HYeQ[!t+v+
様々,さまざま,"varied, various",JLPT JLPT_2 JLPT_3,l>?/o{CjV<''';

      final results = JlptVocabMappingParser.parse(csv, level: 3);

      expect(results, hasLength(2));
      expect(results[0].expression, '作法');
      expect(results[0].reading, 'さほう');
      expect(results[1].expression, '様々');
      expect(results[1].reading, 'さまざま');
    });

    test('copies expression to reading for empty reading (real N4 edge case)', () {
      // Real entries: ごらんになる and かまう have empty readings in n4.csv.
      const csv = '''expression,reading,meaning,tags,guid
ごらんになる,,"(honorific) to see, to look at",JLPT JLPT_N4,abc123
かまう,,to care about,JLPT JLPT_N4,def456''';

      final results = JlptVocabMappingParser.parse(csv, level: 4);

      expect(results, hasLength(2));
      expect(results[0].expression, 'ごらんになる');
      expect(results[0].reading, 'ごらんになる');
      expect(results[1].expression, 'かまう');
      expect(results[1].reading, 'かまう');
    });

    test('parses homograph pair at same level (real N5: 開く あく)', () {
      const csv = '''expression,reading,meaning,tags,guid
開く,あく,"to open, to become open",JLPT JLPT_3 JLPT_5 JLPT_N5,m[4![DH*c~
開く,ひらく,"to open (transitive)",JLPT JLPT_3 JLPT_N5,xyz789''';

      final results = JlptVocabMappingParser.parse(csv, level: 5);

      // Both should be kept — different readings.
      expect(results, hasLength(2));
      expect(results[0].reading, 'あく');
      expect(results[1].reading, 'ひらく');
    });

    test('deduplicates identical (expression, reading) within same file', () {
      const csv = '''expression,reading,meaning,tags,guid
する,する,to do,JLPT JLPT_N5,abc
する,する,to make,JLPT JLPT_N5,def''';

      final results = JlptVocabMappingParser.parse(csv, level: 5);

      expect(results, hasLength(1));
      expect(results[0].expression, 'する');
    });

    test('skips empty lines', () {
      const csv = '''expression,reading,meaning,tags,guid
青,あお,blue,JLPT JLPT_N5,abc

赤,あか,red,JLPT JLPT_N5,def

''';

      final results = JlptVocabMappingParser.parse(csv, level: 5);
      expect(results, hasLength(2));
    });

    test('returns empty list for header-only content', () {
      const csv = 'expression,reading,meaning,tags,guid\n';
      final results = JlptVocabMappingParser.parse(csv, level: 5);
      expect(results, isEmpty);
    });

    test('throws ArgumentError for invalid level', () {
      expect(
        () => JlptVocabMappingParser.parse('', level: 0),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => JlptVocabMappingParser.parse('', level: 6),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws FormatException for too few columns', () {
      const csv = 'expression,reading,meaning,tags,guid\nonly_one';
      expect(
        () => JlptVocabMappingParser.parse(csv, level: 5),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for empty expression', () {
      const csv = 'expression,reading,meaning,tags,guid\n,あお,blue,JLPT,abc';
      expect(
        () => JlptVocabMappingParser.parse(csv, level: 5),
        throwsA(isA<FormatException>()),
      );
    });

    // ---------------------------------------------------------------
    // parseAll() — cross-file merging
    // ---------------------------------------------------------------

    test('merges files keeping easiest level (する in N5 and N2)', () {
      // Real duplicate: する appears in both n5.csv and n2.csv.
      const n5Csv = '''expression,reading,meaning,tags,guid
する,する,to do,JLPT JLPT_N5,abc''';

      const n2Csv = '''expression,reading,meaning,tags,guid
する,する,to do; to make,JLPT JLPT_N2,xyz''';

      final results = JlptVocabMappingParser.parseAll({
        5: n5Csv,
        2: n2Csv,
      });

      expect(results, hasLength(1));
      expect(results[0].expression, 'する');
      expect(results[0].level, 5); // N5 is easiest (highest number)
    });

    test('merges files preserving unique entries from each level', () {
      const n5Csv = '''expression,reading,meaning,tags,guid
会う,あう,"to meet, to see",JLPT,abc''';

      const n3Csv = '''expression,reading,meaning,tags,guid
様々,さまざま,"varied, various",JLPT,def''';

      final results = JlptVocabMappingParser.parseAll({
        5: n5Csv,
        3: n3Csv,
      });

      expect(results, hasLength(2));
      final byExpression = {for (final r in results) r.expression: r};
      expect(byExpression['会う']!.level, 5);
      expect(byExpression['様々']!.level, 3);
    });

    test('keeps homographs with different readings as separate entries', () {
      // Real: 開く has reading あく at N5 and ひらく at N3.
      const n5Csv = '''expression,reading,meaning,tags,guid
開く,あく,"to open (intransitive)",JLPT,abc''';

      const n3Csv = '''expression,reading,meaning,tags,guid
開く,ひらく,"to open (transitive)",JLPT,def''';

      final results = JlptVocabMappingParser.parseAll({
        5: n5Csv,
        3: n3Csv,
      });

      expect(results, hasLength(2));
      final byReading = {for (final r in results) r.reading: r};
      expect(byReading['あく']!.level, 5);
      expect(byReading['ひらく']!.level, 3);
    });
  });
}
