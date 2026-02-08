import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/parsers/jmdict_parser.dart';
import 'package:xml/xml.dart';

/// Minimal JMDict wrapper.
String _wrap(String entries) => '<JMdict>\n$entries\n</JMdict>';

/// JMDict with a DTD containing entity definitions.
String _wrapWithDtd(String entries, {String dtd = ''}) => '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE JMdict [
$dtd
]>
<JMdict>
$entries
</JMdict>
''';

/// A full entry for 食べる with all fields populated.
const _fullEntry = '''
<entry>
  <ent_seq>1358280</ent_seq>
  <k_ele>
    <keb>食べる</keb>
    <ke_pri>ichi1</ke_pri>
    <ke_pri>news2</ke_pri>
  </k_ele>
  <r_ele>
    <reb>たべる</reb>
    <re_pri>ichi1</re_pri>
    <re_pri>news2</re_pri>
  </r_ele>
  <sense>
    <pos>Ichidan verb</pos>
    <pos>transitive verb</pos>
    <gloss>to eat</gloss>
    <gloss>to live on (e.g. a salary)</gloss>
    <gloss xml:lang="ger">essen</gloss>
    <gloss xml:lang="fre">manger</gloss>
  </sense>
</entry>
''';

void main() {
  late JmdictParser parser;

  setUp(() {
    parser = JmdictParser();
  });

  group('JmdictParser', () {
    test('parses full entry with kanji elements, readings, and senses', () {
      final results =
          parser.parseXmlString(xmlString: _wrap(_fullEntry), importId: 42);

      expect(results, hasLength(1));
      final entry = results.first;

      expect(entry.id, 0);
      expect(entry.importId, 42);
      expect(entry.entSeq, 1358280);
      expect(entry.kanjiElements, hasLength(1));
      expect(entry.kanjiElements.first.keb, '食べる');
      expect(entry.kanjiElements.first.kePri, ['ichi1', 'news2']);
      expect(entry.readingElements, hasLength(1));
      expect(entry.readingElements.first.reb, 'たべる');
      expect(entry.senses, hasLength(1));
    });

    test('parses multi-language glosses (xml:lang defaults to "eng")', () {
      final entry =
          parser.parseXmlString(xmlString: _wrap(_fullEntry), importId: 1).first;

      final sense = entry.senses.first;
      expect(sense.glosses['eng'], ['to eat', 'to live on (e.g. a salary)']);
      expect(sense.glosses['ger'], ['essen']);
      expect(sense.glosses['fre'], ['manger']);
    });

    test('parses entry with no kanji elements (kana-only word)', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000010</ent_seq>
  <r_ele>
    <reb>おはよう</reb>
  </r_ele>
  <sense>
    <gloss>good morning</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.kanjiElements, isEmpty);
      expect(entry.readingElements, hasLength(1));
      expect(entry.readingElements.first.reb, 'おはよう');
    });

    test('resolves DTD entity references', () {
      final xml = _wrapWithDtd(
        '''
<entry>
  <ent_seq>1000020</ent_seq>
  <r_ele>
    <reb>すし</reb>
  </r_ele>
  <sense>
    <pos>noun (common) (futsuumeishi)</pos>
    <gloss>sushi</gloss>
  </sense>
</entry>
''',
        dtd: '''
<!ENTITY n "noun (common) (futsuumeishi)">
<!ENTITY v1 "Ichidan verb">
''',
      );

      final results = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(results, hasLength(1));
      expect(results.first.senses.first.pos, ['noun (common) (futsuumeishi)']);
    });

    test('resolves entity references in element text', () {
      final xml = _wrapWithDtd(
        '''
<entry>
  <ent_seq>1000030</ent_seq>
  <r_ele>
    <reb>テスト</reb>
  </r_ele>
  <sense>
    <pos>&n;</pos>
    <misc>&uk;</misc>
    <gloss>test</gloss>
  </sense>
</entry>
''',
        dtd: '''
<!ENTITY n "noun (common) (futsuumeishi)">
<!ENTITY uk "word usually written using kana alone">
''',
      );

      final results = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(results.first.senses.first.pos,
          ['noun (common) (futsuumeishi)']);
      expect(results.first.senses.first.misc,
          ['word usually written using kana alone']);
    });

    test('parses multiple senses per entry', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000040</ent_seq>
  <k_ele>
    <keb>走る</keb>
  </k_ele>
  <r_ele>
    <reb>はしる</reb>
  </r_ele>
  <sense>
    <pos>Godan verb with ru ending</pos>
    <gloss>to run</gloss>
  </sense>
  <sense>
    <gloss>to travel (movement of vehicles)</gloss>
    <gloss>to drive</gloss>
  </sense>
  <sense>
    <gloss>to hurry to</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.senses, hasLength(3));
      expect(entry.senses[0].glosses['eng'], ['to run']);
      expect(entry.senses[1].glosses['eng'],
          ['to travel (movement of vehicles)', 'to drive']);
      expect(entry.senses[2].glosses['eng'], ['to hurry to']);
    });

    test('parses reading restrictions (re_restr)', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000050</ent_seq>
  <k_ele>
    <keb>明日</keb>
  </k_ele>
  <r_ele>
    <reb>あした</reb>
    <re_restr>明日</re_restr>
  </r_ele>
  <r_ele>
    <reb>あす</reb>
    <re_restr>明日</re_restr>
  </r_ele>
  <sense>
    <gloss>tomorrow</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.readingElements, hasLength(2));
      expect(entry.readingElements[0].reb, 'あした');
      expect(entry.readingElements[0].reRestr, ['明日']);
      expect(entry.readingElements[1].reb, 'あす');
      expect(entry.readingElements[1].reRestr, ['明日']);
    });

    test('parses loan source (lsource)', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000060</ent_seq>
  <r_ele>
    <reb>コーヒー</reb>
  </r_ele>
  <sense>
    <lsource xml:lang="dut">koffie</lsource>
    <gloss>coffee</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.senses.first.lsource, isNotNull);
      expect(entry.senses.first.lsource, hasLength(1));
      expect(entry.senses.first.lsource!.first.lang, 'dut');
      expect(entry.senses.first.lsource!.first.value, 'koffie');
    });

    test('parses lsource with ls_type and ls_wasei attributes', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000070</ent_seq>
  <r_ele>
    <reb>サラリーマン</reb>
  </r_ele>
  <sense>
    <lsource xml:lang="eng" ls_type="part" ls_wasei="y">salary</lsource>
    <gloss>office worker</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      final ls = entry.senses.first.lsource!.first;
      expect(ls.lang, 'eng');
      expect(ls.value, 'salary');
      expect(ls.lsType, 'part');
      expect(ls.lsWasei, isTrue);
    });

    test('parses multiple entries', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000001</ent_seq>
  <r_ele><reb>あ</reb></r_ele>
  <sense><gloss>ah</gloss></sense>
</entry>
<entry>
  <ent_seq>1000002</ent_seq>
  <r_ele><reb>い</reb></r_ele>
  <sense><gloss>stomach</gloss></sense>
</entry>
''');

      final results = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(results, hasLength(2));
      expect(results[0].entSeq, 1000001);
      expect(results[1].entSeq, 1000002);
    });

    test('returns empty list for empty document', () {
      final results =
          parser.parseXmlString(xmlString: '<JMdict></JMdict>', importId: 1);
      expect(results, isEmpty);
    });

    test('throws on malformed XML', () {
      expect(
        () => parser.parseXmlString(xmlString: '<bad>', importId: 1),
        throwsA(isA<XmlTagException>()),
      );
    });

    test('parses ke_inf (kanji information)', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000080</ent_seq>
  <k_ele>
    <keb>剥がす</keb>
    <ke_inf>irregular kanji usage</ke_inf>
  </k_ele>
  <r_ele><reb>はがす</reb></r_ele>
  <sense><gloss>to peel off</gloss></sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.kanjiElements.first.keInf, ['irregular kanji usage']);
    });

    test('parses re_nokanji flag', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000090</ent_seq>
  <k_ele><keb>御前</keb></k_ele>
  <r_ele>
    <reb>おまえ</reb>
    <re_nokanji/>
  </r_ele>
  <sense><gloss>you</gloss></sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.readingElements.first.reNokanji, isTrue);
    });

    test('parses sense restrictions (stagk, stagr)', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000100</ent_seq>
  <k_ele><keb>明日</keb></k_ele>
  <r_ele><reb>あした</reb></r_ele>
  <r_ele><reb>あす</reb></r_ele>
  <sense>
    <stagr>あした</stagr>
    <stagk>明日</stagk>
    <gloss>tomorrow</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.senses.first.stagr, ['あした']);
      expect(entry.senses.first.stagk, ['明日']);
    });

    test('parses cross-references and antonyms', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000110</ent_seq>
  <k_ele><keb>大きい</keb></k_ele>
  <r_ele><reb>おおきい</reb></r_ele>
  <sense>
    <xref>小さい</xref>
    <ant>小さい</ant>
    <gloss>big</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.senses.first.xref, ['小さい']);
      expect(entry.senses.first.ant, ['小さい']);
    });

    test('parses field and dialect tags', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000120</ent_seq>
  <r_ele><reb>テスト</reb></r_ele>
  <sense>
    <field>computing</field>
    <dial>Kansai-ben</dial>
    <gloss>test</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.senses.first.field, ['computing']);
      expect(entry.senses.first.dial, ['Kansai-ben']);
    });

    test('parses sense information (s_inf)', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000130</ent_seq>
  <r_ele><reb>テスト</reb></r_ele>
  <sense>
    <s_inf>often derogatory</s_inf>
    <gloss>test</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).first;
      expect(entry.senses.first.sInf, ['often derogatory']);
    });

    test('preserves XML built-in entities during resolution', () {
      final xml = _wrapWithDtd(
        '''
<entry>
  <ent_seq>1000140</ent_seq>
  <r_ele><reb>テスト</reb></r_ele>
  <sense>
    <gloss>Smith &amp; Jones</gloss>
  </sense>
</entry>
''',
        dtd: '<!ENTITY n "noun">',
      );

      final results = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(results.first.senses.first.glosses['eng'], ['Smith & Jones']);
    });
  });
}
