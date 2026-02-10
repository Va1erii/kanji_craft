import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

import '../../domain/services/parse_result.dart';
import '../../domain/entities/raw_jmdict.dart';

class JmdictParser {
  ParseResult<RawJmdict> parseFile({
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

  ParseResult<RawJmdict> parseXmlString({
    required String xmlString,
    required int importId,
  }) {
    final resolved = _resolveEntities(xmlString);
    final document = XmlDocument.parse(resolved);
    final xmlEntries = document.findAllElements('entry').toList();
    final results = <RawJmdict>[];

    for (final entry in xmlEntries) {
      results.add(_parseEntry(entry, importId));
    }

    return ParseResult(
      entries: results,
      totalElements: xmlEntries.length,
    );
  }

  /// Extracts entity definitions from the DTD, strips the DTD, and replaces
  /// all `&entity;` references with their **entity code** (not the expanded
  /// text). This preserves the short DTD codes (e.g. `n`, `vs`, `comp`) in
  /// fields like `pos`, `field`, `misc`, `dial`, `ke_inf`, and `re_inf`.
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

    // Replace entity references with entity codes (not expanded text).
    result = result.replaceAllMapped(
      RegExp(r'&(\w+);'),
      (match) {
        final name = match.group(1)!;
        // Preserve XML built-in entities.
        if (const {'amp', 'lt', 'gt', 'apos', 'quot'}.contains(name)) {
          return match.group(0)!;
        }
        // Known DTD entity → store the code name.
        return entities.containsKey(name) ? name : match.group(0)!;
      },
    );

    return result;
  }

  RawJmdict _parseEntry(XmlElement entry, int importId) {
    final entSeq = int.parse(entry.findElements('ent_seq').first.innerText);

    final kanjiXml = entry.findElements('k_ele').toList();
    final kanjiElements = kanjiXml.isNotEmpty
        ? kanjiXml.map(_parseKanjiElement).toList()
        : null;

    final readingElements = entry
        .findElements('r_ele')
        .map(_parseReadingElement)
        .toList();

    final senses = entry
        .findElements('sense')
        .map(_parseSense)
        .toList();

    // Collect example sentence pairs from all senses (JMdict_e_examp only).
    final examples = <JmdictExample>[];
    for (final sense in entry.findElements('sense')) {
      for (final ex in sense.findElements('example')) {
        final ja = ex
            .findElements('ex_sent')
            .where((e) => e.getAttribute('xml:lang') == 'jpn')
            .firstOrNull
            ?.innerText;
        final en = ex
            .findElements('ex_sent')
            .where((e) => e.getAttribute('xml:lang') == 'eng')
            .firstOrNull
            ?.innerText;
        if (ja != null && en != null) {
          examples.add(JmdictExample(sentenceJa: ja, sentenceEn: en));
        }
      }
    }

    return RawJmdict(
      importId: importId,
      entSeq: entSeq,
      kanjiElements: kanjiElements,
      readingElements: readingElements,
      senses: senses,
      examples: examples.isNotEmpty ? examples : null,
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
    final lsType = el.getAttribute('ls_type') ?? 'full';
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
