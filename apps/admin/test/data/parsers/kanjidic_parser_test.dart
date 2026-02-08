import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/parsers/kanjidic_parser.dart';
import 'package:xml/xml.dart';

/// Minimal KANJIDIC2 wrapper to avoid repeating the root element.
String _wrap(String characters) =>
    '<kanjidic2><header/>\n$characters\n</kanjidic2>';

/// A full entry with all fields populated for 亜.
const _fullEntry = '''
<character>
  <literal>亜</literal>
  <codepoint>
    <cp_value cp_type="ucs">4e9c</cp_value>
    <cp_value cp_type="jis208">16-01</cp_value>
  </codepoint>
  <radical>
    <rad_value rad_type="classical">7</rad_value>
    <rad_value rad_type="nelson_c">1</rad_value>
  </radical>
  <misc>
    <grade>8</grade>
    <stroke_count>7</stroke_count>
    <variant var_type="jis208">48-19</variant>
    <freq>1509</freq>
    <jlpt>1</jlpt>
  </misc>
  <dic_number>
    <dic_ref dr_type="nelson_c">43</dic_ref>
    <dic_ref dr_type="nelson_n">81</dic_ref>
    <dic_ref dr_type="halpern_njecd">3540</dic_ref>
    <dic_ref dr_type="heisig">1809</dic_ref>
    <dic_ref dr_type="moro" m_vol="1" m_page="0525">272</dic_ref>
    <dic_ref dr_type="busy_people">1</dic_ref>
  </dic_number>
  <query_code>
    <q_code qc_type="skip">4-7-1</q_code>
    <q_code qc_type="four_corner">1010.6</q_code>
    <q_code qc_type="sh_desc">0a7.14</q_code>
    <q_code qc_type="skip" skip_misclass="stroke_count">2-1-6</q_code>
  </query_code>
  <reading_meaning>
    <rmgroup>
      <reading r_type="ja_on">ア</reading>
      <reading r_type="ja_kun">つ.ぐ</reading>
      <reading r_type="pinyin">ya4</reading>
      <reading r_type="korean_r">a</reading>
      <reading r_type="korean_h">아</reading>
      <meaning>Asia</meaning>
      <meaning>rank next</meaning>
      <meaning m_lang="es">sub-</meaning>
      <meaning m_lang="es">Asia</meaning>
      <meaning m_lang="fr">Asie</meaning>
    </rmgroup>
    <nanori>や</nanori>
    <nanori>つぎ</nanori>
  </reading_meaning>
</character>
''';

void main() {
  late KanjidicParser parser;

  setUp(() {
    parser = KanjidicParser();
  });

  group('KanjidicParser', () {
    test('parses full entry with all fields populated', () {
      final results =
          parser.parseXmlString(xmlString: _wrap(_fullEntry), importId: 42);

      expect(results, hasLength(1));
      final entry = results.first;

      expect(entry.id, 0);
      expect(entry.importId, 42);
      expect(entry.literal, '亜');
      expect(entry.strokeCount, 7);
      expect(entry.grade, 8);
      expect(entry.jlpt, 1);
      expect(entry.frequency, 1509);
    });

    test('parses codepoints correctly', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.codepoints.ucs, '4e9c');
      expect(entry.codepoints.jis208, '16-01');
      expect(entry.codepoints.jis212, isNull);
      expect(entry.codepoints.jis213, isNull);
    });

    test('parses radicals correctly', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.radicals.classical, 7);
      expect(entry.radicals.nelsonC, 1);
    });

    test('parses multi-language meanings grouped by m_lang', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.meanings['en'], ['Asia', 'rank next']);
      expect(entry.meanings['es'], ['sub-', 'Asia']);
      expect(entry.meanings['fr'], ['Asie']);
    });

    test('defaults meaning language to "en" when m_lang is absent', () {
      final xml = _wrap('''
<character>
  <literal>木</literal>
  <codepoint><cp_value cp_type="ucs">6728</cp_value></codepoint>
  <radical><rad_value rad_type="classical">75</rad_value></radical>
  <misc><stroke_count>4</stroke_count></misc>
  <reading_meaning>
    <rmgroup>
      <meaning>tree</meaning>
      <meaning>wood</meaning>
    </rmgroup>
  </reading_meaning>
</character>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.meanings['en'], ['tree', 'wood']);
      expect(entry.meanings.length, 1);
    });

    test('parses nanori readings', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.nanori, ['や', 'つぎ']);
    });

    test('parses all reading types', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.readings.jaOn, ['ア']);
      expect(entry.readings.jaKun, ['つ.ぐ']);
      expect(entry.readings.pinyin, ['ya4']);
      expect(entry.readings.koreanR, ['a']);
      expect(entry.readings.koreanH, ['아']);
    });

    test('parses dictionary references', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.dictRefs, isNotNull);
      expect(entry.dictRefs!.nelsonC, '43');
      expect(entry.dictRefs!.nelsonN, '81');
      expect(entry.dictRefs!.halpernNjecd, '3540');
      expect(entry.dictRefs!.heisig, '1809');
      expect(entry.dictRefs!.busyPeople, '1');
    });

    test('parses moro dict ref with volume and page', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.dictRefs!.moro, isNotNull);
      expect(entry.dictRefs!.moro!.volume, '1');
      expect(entry.dictRefs!.moro!.page, '0525');
    });

    test('parses query codes including skip', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.queryCodes, isNotNull);
      expect(entry.queryCodes!.skip, '4-7-1');
      expect(entry.queryCodes!.fourCorner, '1010.6');
      expect(entry.queryCodes!.shDesc, '0a7.14');
    });

    test('parses skip misclass entries', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.queryCodes!.misclass, isNotNull);
      expect(entry.queryCodes!.misclass, hasLength(1));
      expect(entry.queryCodes!.misclass!.first.type, 'stroke_count');
      expect(entry.queryCodes!.misclass!.first.value, '2-1-6');
    });

    test('parses variants', () {
      final entry = parser
          .parseXmlString(xmlString: _wrap(_fullEntry), importId: 1)
          .first;

      expect(entry.variants, isNotNull);
      expect(entry.variants, hasLength(1));
      expect(entry.variants!.first.varType, 'jis208');
      expect(entry.variants!.first.value, '48-19');
    });

    test('handles entry with missing optional fields', () {
      final xml = _wrap('''
<character>
  <literal>〇</literal>
  <codepoint><cp_value cp_type="ucs">3007</cp_value></codepoint>
  <radical><rad_value rad_type="classical">1</rad_value></radical>
  <misc><stroke_count>1</stroke_count></misc>
</character>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;

      expect(entry.literal, '〇');
      expect(entry.grade, isNull);
      expect(entry.jlpt, isNull);
      expect(entry.frequency, isNull);
      expect(entry.dictRefs, isNull);
      expect(entry.queryCodes, isNull);
      expect(entry.nanori, isNull);
      expect(entry.variants, isNull);
      expect(entry.radicalNames, isNull);
      expect(entry.meanings, isEmpty);
      expect(entry.readings.jaOn, isEmpty);
      expect(entry.readings.jaKun, isEmpty);
      expect(entry.readings.pinyin, isNull);
    });

    test('parses multiple stroke counts (misstrokes)', () {
      final xml = _wrap('''
<character>
  <literal>飛</literal>
  <codepoint><cp_value cp_type="ucs">98db</cp_value></codepoint>
  <radical><rad_value rad_type="classical">183</rad_value></radical>
  <misc>
    <stroke_count>9</stroke_count>
    <stroke_count>10</stroke_count>
    <stroke_count>11</stroke_count>
  </misc>
</character>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;

      expect(entry.strokeCount, 9);
      expect(entry.strokeCountMisstrokes, [10, 11]);
    });

    test('parses multiple entries', () {
      final xml = _wrap('''
<character>
  <literal>一</literal>
  <codepoint><cp_value cp_type="ucs">4e00</cp_value></codepoint>
  <radical><rad_value rad_type="classical">1</rad_value></radical>
  <misc><stroke_count>1</stroke_count></misc>
</character>
<character>
  <literal>二</literal>
  <codepoint><cp_value cp_type="ucs">4e8c</cp_value></codepoint>
  <radical><rad_value rad_type="classical">7</rad_value></radical>
  <misc><stroke_count>2</stroke_count></misc>
</character>
''');

      final results = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(results, hasLength(2));
      expect(results[0].literal, '一');
      expect(results[1].literal, '二');
    });

    test('parses radical names (rad_name)', () {
      final xml = _wrap('''
<character>
  <literal>水</literal>
  <codepoint><cp_value cp_type="ucs">6c34</cp_value></codepoint>
  <radical><rad_value rad_type="classical">85</rad_value></radical>
  <misc><stroke_count>4</stroke_count></misc>
  <reading_meaning>
    <rmgroup>
      <reading r_type="ja_on">スイ</reading>
      <meaning>water</meaning>
    </rmgroup>
    <rad_name>みず</rad_name>
    <rad_name>さんずい</rad_name>
  </reading_meaning>
</character>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.radicalNames, ['みず', 'さんずい']);
    });

    test('throws on malformed XML', () {
      expect(
        () => parser.parseXmlString(xmlString: '<bad>', importId: 1),
        throwsA(isA<XmlTagException>()),
      );
    });

    test('returns empty list for document with no character elements', () {
      final xml = '<kanjidic2><header/></kanjidic2>';
      final results = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(results, isEmpty);
    });

    test('parses jis212 and jis213 codepoints', () {
      final xml = _wrap('''
<character>
  <literal>丂</literal>
  <codepoint>
    <cp_value cp_type="ucs">4e02</cp_value>
    <cp_value cp_type="jis212">16-01</cp_value>
    <cp_value cp_type="jis213">2-01-02</cp_value>
  </codepoint>
  <radical><rad_value rad_type="classical">1</rad_value></radical>
  <misc><stroke_count>2</stroke_count></misc>
</character>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.codepoints.jis212, '16-01');
      expect(entry.codepoints.jis213, '2-01-02');
    });
  });
}
