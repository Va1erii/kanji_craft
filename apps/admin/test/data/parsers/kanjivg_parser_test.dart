import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/kanjivg_parser.dart';
import 'package:xml/xml.dart';

void main() {
  late KanjiVgParser parser;

  setUp(() {
    parser = KanjiVgParser();
  });

  group('KanjiVgParser', () {
    test('parses simple single-stroke entry', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04e00">
    <g id="kvg:04e00" kvg:element="一"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <path id="kvg:04e00-s1" kvg:type="㇐"
            d="M 10,50 C 30,48 70,48 100,50"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 42).entries;

      expect(results, hasLength(1));
      final entry = results.first;
      expect(entry.importId, 42);
      expect(entry.character, '一');
      expect(entry.unicodeHex, '04e00');
      expect(entry.viewBox, '0 0 109 109');
      expect(entry.strokeCount, 1);
      expect(entry.strokes, hasLength(1));
      expect(entry.strokes.first.number, 1);
      expect(entry.strokes.first.type, '㇐');
      expect(entry.strokes.first.pathData, 'M 10,50 C 30,48 70,48 100,50');
    });

    test('parses character and unicodeHex correctly from hex id', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_06728">
    <g id="kvg:06728" kvg:element="木"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <path id="kvg:06728-s1" d="M 50,10 L 50,90"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;

      expect(results.first.character, '木');
      expect(results.first.unicodeHex, '06728');
    });

    test('pads unicodeHex to 5 characters', () {
      // 一 is U+4E00 which is 4 hex digits
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_4e00">
    <g id="kvg:4e00" kvg:element="一"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results.first.unicodeHex, '04e00');
    });

    test('parses nested components with two children', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04f11">
    <g id="kvg:04f11" kvg:element="休"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <g id="kvg:04f11-g1" kvg:element="亻" kvg:position="left"
         kvg:variant="true" kvg:original="人" kvg:radical="general">
        <path id="kvg:04f11-s1" d="M 28,25 L 15,90"/>
        <path id="kvg:04f11-s2" d="M 28,25 L 50,90"/>
      </g>
      <g id="kvg:04f11-g2" kvg:element="木" kvg:position="right">
        <path id="kvg:04f11-s3" d="M 60,20 L 60,90"/>
        <path id="kvg:04f11-s4" d="M 55,50 L 95,50"/>
        <path id="kvg:04f11-s5" d="M 60,52 L 55,90"/>
        <path id="kvg:04f11-s6" d="M 60,52 L 95,90"/>
      </g>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results, hasLength(1));
      final entry = results.first;

      expect(entry.character, '休');
      expect(entry.strokeCount, 6);

      final root = entry.components;
      expect(root.element, '休');
      expect(root.position, isNull);
      expect(root.strokeIndices, [0, 1, 2, 3, 4, 5]);
      expect(root.children, hasLength(2));

      final left = root.children[0];
      expect(left.element, '亻');
      expect(left.position, 'left');
      expect(left.variant, true);
      expect(left.original, '人');
      expect(left.radical, 'general');
      expect(left.strokeIndices, [0, 1]);
      expect(left.children, isEmpty);

      final right = root.children[1];
      expect(right.element, '木');
      expect(right.position, 'right');
      expect(right.variant, isNull);
      expect(right.strokeIndices, [2, 3, 4, 5]);
      expect(right.children, isEmpty);
    });

    test('parses deeply nested component tree', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_05316">
    <g id="kvg:05316" kvg:element="化"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <g id="kvg:05316-g1" kvg:element="匚" kvg:position="kamae">
        <path d="M 10,10 L 10,90"/>
        <g id="kvg:05316-g2" kvg:element="丁">
          <path d="M 40,30 L 80,30"/>
          <path d="M 60,30 L 60,70"/>
        </g>
      </g>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final root = results.first.components;
      expect(root.children, hasLength(1));

      final mid = root.children[0];
      expect(mid.element, '匚');
      expect(mid.position, 'kamae');
      expect(mid.strokeIndices, [0, 1, 2]);
      expect(mid.children, hasLength(1));

      final inner = mid.children[0];
      expect(inner.element, '丁');
      expect(inner.strokeIndices, [1, 2]);
    });

    test('assigns stroke numbers 1-based in document order', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04e09">
    <g id="kvg:04e09" kvg:element="上"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 50,30 L 50,80"/>
      <path d="M 30,55 L 80,55"/>
      <path d="M 20,80 L 90,80"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final strokes = results.first.strokes;

      expect(strokes[0].number, 1);
      expect(strokes[1].number, 2);
      expect(strokes[2].number, 3);
    });

    test('strokes without kvg:type have empty string', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04e00">
    <g id="kvg:04e00" kvg:element="一"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results.first.strokes.first.type, '');
    });

    test('parses phon attribute', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_05fd9">
    <g id="kvg:05fd9" kvg:element="忙"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <g id="kvg:05fd9-g1" kvg:element="忄" kvg:position="left">
        <path d="M 10,30 L 10,80"/>
      </g>
      <g id="kvg:05fd9-g2" kvg:element="亡" kvg:position="right"
         kvg:phon="ボウ">
        <path d="M 50,20 L 90,20"/>
      </g>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final right = results.first.components.children[1];
      expect(right.phon, 'ボウ');
    });

    test('parses tradForm attribute', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_05b66">
    <g id="kvg:05b66" kvg:element="学"
       xmlns:kvg="http://kanjivg.tagaini.net"
       kvg:tradForm="學">
      <path d="M 10,10 L 90,10"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results.first.components.tradForm, '學');
    });

    test('parses part attribute for split components', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_09053">
    <g id="kvg:09053" kvg:element="道"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <g id="kvg:09053-g1" kvg:element="辶" kvg:part="1">
        <path d="M 10,10 L 20,20"/>
      </g>
      <g id="kvg:09053-g2" kvg:element="首">
        <path d="M 40,10 L 40,80"/>
      </g>
      <g id="kvg:09053-g3" kvg:element="辶" kvg:part="2">
        <path d="M 10,80 L 90,80"/>
      </g>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final children = results.first.components.children;
      expect(children[0].element, '辶');
      expect(children[0].part, 1);
      expect(children[2].element, '辶');
      expect(children[2].part, 2);
    });

    test('parses number attribute for disambiguating split parts', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_05716">
    <g id="kvg:05716" kvg:element="圖"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <g id="kvg:05716-g1" kvg:element="口" kvg:number="1" kvg:part="1">
        <path d="M 10,10 L 20,20"/>
      </g>
      <g id="kvg:05716-g2" kvg:element="口" kvg:number="2" kvg:part="1">
        <path d="M 30,10 L 40,20"/>
      </g>
      <g id="kvg:05716-g3" kvg:element="口" kvg:number="1" kvg:part="2">
        <path d="M 10,50 L 20,60"/>
      </g>
      <g id="kvg:05716-g4" kvg:element="口" kvg:number="2" kvg:part="2">
        <path d="M 30,50 L 40,60"/>
      </g>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final children = results.first.components.children;
      expect(children[0].number, 1);
      expect(children[0].part, 1);
      expect(children[1].number, 2);
      expect(children[1].part, 1);
      expect(children[2].number, 1);
      expect(children[2].part, 2);
      expect(children[3].number, 2);
      expect(children[3].part, 2);
    });

    test('parses partial attribute', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_06728">
    <g id="kvg:06728" kvg:element="木"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <g id="kvg:06728-g1" kvg:element="十" kvg:partial="true">
        <path d="M 50,10 L 50,90"/>
      </g>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final child = results.first.components.children[0];
      expect(child.element, '十');
      expect(child.partial, true);
    });

    test('parses radicalForm attribute', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_06c34">
    <g id="kvg:06c34" kvg:element="水"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <g id="kvg:06c34-g1" kvg:element="⺡"
         kvg:radicalForm="true" kvg:original="水">
        <path d="M 10,30 L 10,80"/>
      </g>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final child = results.first.components.children[0];
      expect(child.element, '⺡');
      expect(child.radicalForm, true);
      expect(child.original, '水');
    });

    test('missing number, partial, radicalForm default to null', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04e00">
    <g id="kvg:04e00" kvg:element="一"
       xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final root = results.first.components;
      expect(root.number, isNull);
      expect(root.partial, isNull);
      expect(root.radicalForm, isNull);
    });

    test('handles multiple kanji entries', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04e00">
    <g kvg:element="一" xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
  <kanji id="kvg:kanji_04e8c">
    <g kvg:element="二" xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 20,30 L 80,30"/>
      <path d="M 10,70 L 90,70"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results, hasLength(2));
      expect(results[0].character, '一');
      expect(results[0].strokeCount, 1);
      expect(results[1].character, '二');
      expect(results[1].strokeCount, 2);
    });

    test('skips kanji with invalid id format and records in skipped', () {
      final xml = '''
<kanjivg>
  <kanji id="invalid">
    <g kvg:element="?" xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
  <kanji id="kvg:kanji_04e00">
    <g kvg:element="一" xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
</kanjivg>
''';

      final result = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(result.entries, hasLength(1));
      expect(result.entries.first.character, '一');
      expect(result.totalElements, 2);
      expect(result.skippedCount, 1);
      expect(result.skipped.first.id, 'invalid');
      expect(result.skipped.first.reason, 'invalid id format');
    });

    test('skips kanji with missing root <g> and records in skipped', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04e01">
    <path d="M 10,50 L 100,50"/>
  </kanji>
  <kanji id="kvg:kanji_04e00">
    <g kvg:element="一" xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
</kanjivg>
''';

      final result = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(result.entries, hasLength(1));
      expect(result.totalElements, 2);
      expect(result.skippedCount, 1);
      expect(result.skipped.first.id, 'kvg:kanji_04e01');
      expect(result.skipped.first.reason, 'missing root <g>');
    });

    test('produces deterministic output (no createdAt in domain)', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04e00">
    <g kvg:element="一" xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
</kanjivg>
''';

      final result1 =
          parser.parseXmlString(xmlString: xml, importId: 1).entries;
      final result2 =
          parser.parseXmlString(xmlString: xml, importId: 1).entries;

      expect(result1.first, equals(result2.first));
    });

    test('leaf component has empty children list', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_04e00">
    <g kvg:element="一" xmlns:kvg="http://kanjivg.tagaini.net">
      <path d="M 10,50 L 100,50"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results.first.components.children, isEmpty);
    });

    test('throws on malformed XML', () {
      const xml = '<not-closed>';

      expect(
        () => parser.parseXmlString(xmlString: xml, importId: 1),
        throwsA(isA<XmlTagException>()),
      );
    });

    test('returns empty result for XML with no kanji elements', () {
      const xml = '<kanjivg></kanjivg>';

      final result = parser.parseXmlString(xmlString: xml, importId: 1);
      expect(result.entries, isEmpty);
      expect(result.totalElements, 0);
      expect(result.skipped, isEmpty);
    });

    test('nelson radical marker parsed correctly', () {
      final xml = '''
<kanjivg>
  <kanji id="kvg:kanji_06c34">
    <g id="kvg:06c34" kvg:element="水"
       xmlns:kvg="http://kanjivg.tagaini.net"
       kvg:radical="nelson">
      <path d="M 50,10 L 50,90"/>
    </g>
  </kanji>
</kanjivg>
''';

      final results = parser.parseXmlString(xmlString: xml, importId: 1).entries;
      expect(results.first.components.radical, 'nelson');
    });
  });
}
