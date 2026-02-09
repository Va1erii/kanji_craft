import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

import '../../domain/entities/raw_jmdict.dart';

class JmdictParser {
  List<RawJmdict> parseFile({
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

  List<RawJmdict> parseXmlString({
    required String xmlString,
    required int importId,
  }) {
    final resolved = _resolveEntities(xmlString);
    final document = XmlDocument.parse(resolved);
    final entries = document.findAllElements('entry');
    final results = <RawJmdict>[];

    for (final entry in entries) {
      results.add(_parseEntry(entry, importId));
    }

    return results;
  }

  /// Extracts entity definitions from the DTD, strips the DTD, and replaces
  /// all `&entity;` references with their resolved text values.
  String _resolveEntities(String xml) {
    final entityPattern = RegExp(r'<!ENTITY\s+(\S+)\s+"([^"]*)"');
    final entities = <String, String>{};

    for (final match in entityPattern.allMatches(xml)) {
      entities[match.group(1)!] = match.group(2)!;
    }

    if (entities.isEmpty) return xml;

    // Strip the DOCTYPE declaration (including the inline DTD).
    var result = xml.replaceFirst(
      RegExp(r'<!DOCTYPE[^[]*\[.*?\]>', dotAll: true),
      '',
    );

    // Replace entity references with their values.
    result = result.replaceAllMapped(
      RegExp(r'&(\w+);'),
      (match) {
        final name = match.group(1)!;
        // Preserve XML built-in entities.
        if (const {'amp', 'lt', 'gt', 'apos', 'quot'}.contains(name)) {
          return match.group(0)!;
        }
        return entities[name] ?? match.group(0)!;
      },
    );

    return result;
  }

  RawJmdict _parseEntry(XmlElement entry, int importId) {
    final entSeq = int.parse(entry.findElements('ent_seq').first.innerText);

    final kanjiElements = entry
        .findElements('k_ele')
        .map(_parseKanjiElement)
        .toList();

    final readingElements = entry
        .findElements('r_ele')
        .map(_parseReadingElement)
        .toList();

    final senses = entry
        .findElements('sense')
        .map(_parseSense)
        .toList();

    return RawJmdict(
      importId: importId,
      entSeq: entSeq,
      kanjiElements: kanjiElements,
      readingElements: readingElements,
      senses: senses,
      createdAt: DateTime.now(),
    );
  }

  JmdictKanjiElement _parseKanjiElement(XmlElement el) {
    final keb = el.findElements('keb').first.innerText;
    final keInf = _textList(el, 'ke_inf');
    final kePri = _textList(el, 'ke_pri');

    return JmdictKanjiElement(
      keb: keb,
      keInf: keInf,
      kePri: kePri,
    );
  }

  JmdictReadingElement _parseReadingElement(XmlElement el) {
    final reb = el.findElements('reb').first.innerText;
    final reNokanji = el.findElements('re_nokanji').isNotEmpty;
    final reRestr = _textList(el, 're_restr');
    final reInf = _textList(el, 're_inf');
    final rePri = _textList(el, 're_pri');

    return JmdictReadingElement(
      reb: reb,
      reNokanji: reNokanji,
      reRestr: reRestr,
      reInf: reInf,
      rePri: rePri,
    );
  }

  JmdictSense _parseSense(XmlElement el) {
    final stagk = _textList(el, 'stagk');
    final stagr = _textList(el, 'stagr');
    final pos = _textList(el, 'pos');
    final xref = _textList(el, 'xref');
    final ant = _textList(el, 'ant');
    final field = _textList(el, 'field');
    final misc = _textList(el, 'misc');
    final sInf = _textList(el, 's_inf');
    final dial = _textList(el, 'dial');

    final lsourceElements = el.findElements('lsource').toList();
    final lsource = lsourceElements.isNotEmpty
        ? lsourceElements.map(_parseLsource).toList()
        : null;

    final glosses = <String, List<String>>{};
    for (final gloss in el.findElements('gloss')) {
      final lang = gloss.getAttribute('xml:lang') ?? 'eng';
      glosses.putIfAbsent(lang, () => []).add(gloss.innerText);
    }

    return JmdictSense(
      stagk: stagk,
      stagr: stagr,
      pos: pos,
      xref: xref,
      ant: ant,
      field: field,
      misc: misc,
      sInf: sInf,
      lsource: lsource,
      dial: dial,
      glosses: glosses,
    );
  }

  JmdictLsource _parseLsource(XmlElement el) {
    final lang = el.getAttribute('xml:lang') ?? 'eng';
    final value = el.innerText.isEmpty ? null : el.innerText;
    final lsType = el.getAttribute('ls_type');
    final lsWasei = el.getAttribute('ls_wasei') == 'y';

    return JmdictLsource(
      lang: lang,
      value: value,
      lsType: lsType,
      lsWasei: lsWasei,
    );
  }

  List<String>? _textList(XmlElement parent, String name) {
    final elements = parent.findElements(name).toList();
    if (elements.isEmpty) return null;
    return elements.map((e) => e.innerText).toList();
  }
}
