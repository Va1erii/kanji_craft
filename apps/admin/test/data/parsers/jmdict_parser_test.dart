import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/jmdict_parser.dart';
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
          parser.parseXmlString(xmlString: _wrap(_fullEntry), importId: 42).entries;

      expect(results, hasLength(1));
      final entry = results.first;

      expect(entry.importId, 42);
      expect(entry.entSeq, 1358280);
      expect(entry.kanjiElements, isNotNull);
      expect(entry.kanjiElements, hasLength(1));
      expect(entry.kanjiElements!.first.keb, '食べる');
      expect(entry.kanjiElements!.first.kePri, ['ichi1', 'news2']);
      expect(entry.readingElements, hasLength(1));
      expect(entry.readingElements.first.reb, 'たべる');
      expect(entry.senses, hasLength(1));
      expect(entry.examples, isNull);
    });

    test('parses multi-language glosses (xml:lang defaults to "eng")', () {
      final entry =
          parser.parseXmlString(xmlString: _wrap(_fullEntry), importId: 1).entries.first;

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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
      expect(entry.kanjiElements, isNull);
      expect(entry.readingElements, hasLength(1));
      expect(entry.readingElements.first.reb, 'おはよう');
    });

    test('resolves DTD entity references to entity codes', () {
      final xml = _wrapWithDtd(
        '''
<entry>
  <ent_seq>1000020</ent_seq>
  <r_ele>
    <reb>すし</reb>
  </r_ele>
  <sense>
    <pos>&n;</pos>
    <gloss>sushi</gloss>
  </sense>
</entry>
''',
        dtd: '''
<!ENTITY n "noun (common) (futsuumeishi)">
<!ENTITY v1 "Ichidan verb">
''',
      );

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results, hasLength(1));
      // Stores the entity code, not the expanded text.
      expect(results.first.senses.first.pos, ['n']);
    });

    test('resolves entity references in misc and other fields', () {
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

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results.first.senses.first.pos, ['n']);
      expect(results.first.senses.first.misc, ['uk']);
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
      expect(entry.senses.first.lsource, isNotNull);
      expect(entry.senses.first.lsource, hasLength(1));
      expect(entry.senses.first.lsource!.first.lang, 'dut');
      expect(entry.senses.first.lsource!.first.value, 'koffie');
      expect(entry.senses.first.lsource!.first.lsType, 'full');
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
      final ls = entry.senses.first.lsource!.first;
      expect(ls.lang, 'eng');
      expect(ls.value, 'salary');
      expect(ls.lsType, 'part');
      expect(ls.lsWasei, isTrue);
    });

    test('lsource defaults lsType to "full" when absent', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000071</ent_seq>
  <r_ele>
    <reb>パン</reb>
  </r_ele>
  <sense>
    <lsource xml:lang="por">pão</lsource>
    <gloss>bread</gloss>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
      expect(entry.senses.first.lsource!.first.lsType, 'full');
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

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results, hasLength(2));
      expect(results[0].entSeq, 1000001);
      expect(results[1].entSeq, 1000002);
    });

    test('returns empty result for empty document', () {
      final result =
          parser.parseXmlString(xmlString: '<JMdict></JMdict>', importId: 1);
      expect(result.entries, isEmpty);
      expect(result.totalElements, 0);
    });

    test('totalElements matches number of entry elements', () {
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

      final result = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(result.totalElements, 2);
      expect(result.parsedCount, 2);
      expect(result.skipped, isEmpty);
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
      expect(entry.kanjiElements!.first.keInf, ['irregular kanji usage']);
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
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

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
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

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results.first.senses.first.glosses['eng'], ['Smith & Jones']);
    });

    test('parses example sentences from JMdict_e_examp format', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1594720</ent_seq>
  <k_ele><keb>収集</keb></k_ele>
  <r_ele><reb>しゅうしゅう</reb></r_ele>
  <sense>
    <gloss>collection</gloss>
    <example>
      <ex_srce exsrc_type="tat">77194</ex_srce>
      <ex_text>収集</ex_text>
      <ex_sent xml:lang="jpn">切手を収集しています。</ex_sent>
      <ex_sent xml:lang="eng">I collect stamps.</ex_sent>
    </example>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
      expect(entry.examples, isNotNull);
      expect(entry.examples, hasLength(1));
      expect(entry.examples!.first.sentenceJa, '切手を収集しています。');
      expect(entry.examples!.first.sentenceEn, 'I collect stamps.');
    });

    test('collects examples from multiple senses', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000200</ent_seq>
  <r_ele><reb>テスト</reb></r_ele>
  <sense>
    <gloss>test</gloss>
    <example>
      <ex_sent xml:lang="jpn">テストに合格した。</ex_sent>
      <ex_sent xml:lang="eng">I passed the test.</ex_sent>
    </example>
  </sense>
  <sense>
    <gloss xml:lang="fre">test</gloss>
    <example>
      <ex_sent xml:lang="jpn">テストを受ける。</ex_sent>
      <ex_sent xml:lang="eng">To take a test.</ex_sent>
    </example>
  </sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
      expect(entry.examples, hasLength(2));
      expect(entry.examples![0].sentenceJa, 'テストに合格した。');
      expect(entry.examples![1].sentenceJa, 'テストを受ける。');
    });

    test('examples is null for base JMdict entries (no example elements)', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000210</ent_seq>
  <r_ele><reb>テスト</reb></r_ele>
  <sense><gloss>test</gloss></sense>
</entry>
''');

      final entry = parser.parseXmlString(xmlString: xml, importId: 1).entries.first;
      expect(entry.examples, isNull);
    });

    test('same source produces identical parse results (deterministic)', () {
      final xml = _wrap('''
<entry>
  <ent_seq>1000300</ent_seq>
  <k_ele><keb>日本</keb></k_ele>
  <r_ele><reb>にほん</reb></r_ele>
  <sense><gloss>Japan</gloss></sense>
</entry>
''');

      final result1 = parser.parseXmlString(xmlString: xml, importId: 5);
      final result2 = parser.parseXmlString(xmlString: xml, importId: 5);

      expect(result1.entries.length, result2.entries.length);
      final e1 = result1.entries.first;
      final e2 = result2.entries.first;
      expect(e1.importId, e2.importId);
      expect(e1.entSeq, e2.entSeq);
      expect(e1.kanjiElements!.first.keb, e2.kanjiElements!.first.keb);
      expect(e1.readingElements.first.reb, e2.readingElements.first.reb);
      expect(e1.senses.first.glosses, e2.senses.first.glosses);
    });
  });
}
