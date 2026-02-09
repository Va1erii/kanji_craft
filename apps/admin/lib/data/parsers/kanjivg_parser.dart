import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

import '../../domain/entities/raw_kanjivg.dart';

class KanjiVgParser {
  static const _kvgNamespace = 'http://kanjivg.tagaini.net';
  static const _viewBox = '0 0 109 109';

  List<RawKanjiVg> parseFile({
    required String filePath,
    required int importId,
  }) {
    final file = File(filePath);
    String xmlString;

    if (filePath.endsWith('.gz')) {
      final compressed = file.readAsBytesSync();
      final decompressed = gzip.decode(compressed);
      xmlString = utf8.decode(decompressed);
    } else {
      xmlString = file.readAsStringSync();
    }

    return parseXmlString(xmlString: xmlString, importId: importId);
  }

  List<RawKanjiVg> parseXmlString({
    required String xmlString,
    required int importId,
  }) {
    final document = XmlDocument.parse(xmlString);
    final kanjiElements = document.findAllElements('kanji');
    final results = <RawKanjiVg>[];

    for (final kanji in kanjiElements) {
      final parsed = _parseKanjiElement(kanji, importId);
      if (parsed != null) {
        results.add(parsed);
      }
    }

    return results;
  }

  RawKanjiVg? _parseKanjiElement(XmlElement kanji, int importId) {
    final id = kanji.getAttribute('id') ?? '';
    // Format: "kvg:kanji_{hex}"
    final match = RegExp(r'kvg:kanji_([0-9a-fA-F]+)').firstMatch(id);
    if (match == null) return null;

    final hex = match.group(1)!;
    final codePoint = int.parse(hex, radix: 16);
    final character = String.fromCharCode(codePoint);
    final unicodeHex = hex.toLowerCase().padLeft(5, '0');

    // Collect all path elements in document order
    final pathElements = kanji.findAllElements('path').toList();
    final strokes = <KanjiVgStroke>[];
    for (var i = 0; i < pathElements.length; i++) {
      final path = pathElements[i];
      final type = path.getAttributeNamed('type', namespace: _kvgNamespace) ??
          '';
      final pathData = path.getAttribute('d') ?? '';
      strokes.add(KanjiVgStroke(
        number: i + 1,
        type: type,
        pathData: pathData,
      ));
    }

    // Parse root <g> element for component tree
    final rootG = kanji.findElements('g').firstOrNull;
    if (rootG == null) return null;

    final components = _parseComponent(rootG, pathElements);

    return RawKanjiVg(
      importId: importId,
      character: character,
      unicodeHex: unicodeHex,
      viewBox: _viewBox,
      strokeCount: strokes.length,
      strokes: strokes,
      components: components,
      createdAt: DateTime.now(),
    );
  }

  KanjiVgComponent _parseComponent(
    XmlElement g,
    List<XmlElement> allPaths,
  ) {
    final element =
        g.getAttributeNamed('element', namespace: _kvgNamespace) ?? '';
    final position =
        g.getAttributeNamed('position', namespace: _kvgNamespace);
    final variantStr =
        g.getAttributeNamed('variant', namespace: _kvgNamespace);
    final original =
        g.getAttributeNamed('original', namespace: _kvgNamespace);
    final partStr = g.getAttributeNamed('part', namespace: _kvgNamespace);
    final radical =
        g.getAttributeNamed('radical', namespace: _kvgNamespace);
    final phon = g.getAttributeNamed('phon', namespace: _kvgNamespace);
    final tradForm =
        g.getAttributeNamed('tradForm', namespace: _kvgNamespace);

    final bool? variant =
        variantStr != null ? variantStr == 'true' : null;
    final int? part = partStr != null ? int.tryParse(partStr) : null;

    // Collect stroke indices for paths directly or nested in this <g>
    final nestedPaths = g.findAllElements('path').toList();
    final strokeIndices = <int>[];
    for (final path in nestedPaths) {
      final idx = allPaths.indexOf(path);
      if (idx >= 0) {
        strokeIndices.add(idx);
      }
    }

    // Parse child <g> elements (direct children only)
    final children = <KanjiVgComponent>[];
    for (final childG in g.childElements) {
      if (childG.localName == 'g') {
        children.add(_parseComponent(childG, allPaths));
      }
    }

    return KanjiVgComponent(
      element: element,
      position: position,
      variant: variant,
      original: original,
      part: part,
      radical: radical,
      phon: phon,
      tradForm: tradForm,
      strokeIndices: strokeIndices,
      children: children,
    );
  }
}

extension _XmlAttributeNamed on XmlElement {
  String? getAttributeNamed(String name, {required String namespace}) {
    for (final attr in attributes) {
      if (attr.localName == name &&
          attr.namespaceUri == namespace) {
        return attr.value;
      }
    }
    return null;
  }
}
