import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

import '../../domain/services/parse_result.dart';
import '../../domain/entities/raw_kanjidic.dart';

class KanjidicParser {
  ParseResult<RawKanjidic> parseFile({
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

  ParseResult<RawKanjidic> parseXmlString({
    required String xmlString,
    required int importId,
  }) {
    final document = XmlDocument.parse(xmlString);
    final characters = document.findAllElements('character').toList();
    final results = <RawKanjidic>[];

    for (final character in characters) {
      results.add(_parseCharacter(character, importId));
    }

    return ParseResult(
      entries: results,
      totalElements: characters.length,
    );
  }

  RawKanjidic _parseCharacter(XmlElement character, int importId) {
    final literal = _text(character, 'literal');
    final codepoints = _parseCodepoints(character);
    final radicals = _parseRadicals(character);
    final misc = character.findElements('misc').firstOrNull;

    final strokeCounts = misc?.findElements('stroke_count').toList() ?? [];
    final strokeCount =
        strokeCounts.isNotEmpty ? int.parse(strokeCounts.first.innerText) : 0;
    final strokeCountMisstrokes = strokeCounts.length > 1
        ? strokeCounts.skip(1).map((e) => int.parse(e.innerText)).toList()
        : null;

    final gradeText = _textOrNull(misc, 'grade');
    final jlptText = _textOrNull(misc, 'jlpt');
    final freqText = _textOrNull(misc, 'freq');

    final variants = _parseVariants(misc);
    final dictRefs = _parseDictRefs(character);
    final queryCodes = _parseQueryCodes(character);
    final readingMeaning = character.findElements('reading_meaning').firstOrNull;
    final rmGroup = readingMeaning?.findElements('rmgroup').firstOrNull;
    final readings = _parseReadings(rmGroup);
    final nanori = _parseNanori(readingMeaning);
    final meanings = _parseMeanings(rmGroup);
    final radicalNames = _parseRadicalNames(readingMeaning);

    return RawKanjidic(
      importId: importId,
      literal: literal,
      strokeCount: strokeCount,
      strokeCountMisstrokes: strokeCountMisstrokes,
      grade: gradeText != null ? int.parse(gradeText) : null,
      jlpt: jlptText != null ? int.parse(jlptText) : null,
      frequency: freqText != null ? int.parse(freqText) : null,
      codepoints: codepoints,
      radicals: radicals,
      dictRefs: dictRefs,
      queryCodes: queryCodes,
      readings: readings,
      nanori: nanori,
      meanings: meanings,
      variants: variants,
      radicalNames: radicalNames,
      createdAt: DateTime.now(),
    );
  }

  KanjidicCodepoints _parseCodepoints(XmlElement character) {
    final cpNode = character.findElements('codepoint').firstOrNull;
    String? ucs, jis208, jis212, jis213;

    if (cpNode != null) {
      for (final cp in cpNode.findElements('cp_value')) {
        final type = cp.getAttribute('cp_type');
        switch (type) {
          case 'ucs':
            ucs = cp.innerText;
          case 'jis208':
            jis208 = cp.innerText;
          case 'jis212':
            jis212 = cp.innerText;
          case 'jis213':
            jis213 = cp.innerText;
        }
      }
    }

    return KanjidicCodepoints(
      ucs: ucs ?? '',
      jis208: jis208,
      jis212: jis212,
      jis213: jis213,
    );
  }

  KanjidicRadicals _parseRadicals(XmlElement character) {
    final radNode = character.findElements('radical').firstOrNull;
    int? classical, nelsonC;

    if (radNode != null) {
      for (final rv in radNode.findElements('rad_value')) {
        final type = rv.getAttribute('rad_type');
        switch (type) {
          case 'classical':
            classical = int.parse(rv.innerText);
          case 'nelson_c':
            nelsonC = int.parse(rv.innerText);
        }
      }
    }

    return KanjidicRadicals(
      classical: classical ?? 0,
      nelsonC: nelsonC,
    );
  }

  List<KanjidicVariant>? _parseVariants(XmlElement? misc) {
    if (misc == null) return null;
    final varElements = misc.findElements('variant').toList();
    if (varElements.isEmpty) return null;

    return varElements
        .map((v) => KanjidicVariant(
              varType: v.getAttribute('var_type') ?? '',
              value: v.innerText,
            ))
        .toList();
  }

  KanjidicDictRefs? _parseDictRefs(XmlElement character) {
    final dicNode = character.findElements('dic_number').firstOrNull;
    if (dicNode == null) return null;

    final refs = dicNode.findElements('dic_ref').toList();
    if (refs.isEmpty) return null;

    String? nelsonC,
        nelsonN,
        halpernNjecd,
        halpernKkd,
        halpernKkld,
        halpernKkld2ed,
        heisig,
        heisig6,
        gakken,
        oneillNames,
        oneillKk,
        henshall,
        shKk,
        shKk2,
        jfCards,
        tuttCards,
        kanjiInContext,
        kodanshaCompact,
        skip,
        busyPeople;
    KanjidicMoroRef? moro;

    for (final ref in refs) {
      final type = ref.getAttribute('dr_type');
      final value = ref.innerText;

      switch (type) {
        case 'nelson_c':
          nelsonC = value;
        case 'nelson_n':
          nelsonN = value;
        case 'halpern_njecd':
          halpernNjecd = value;
        case 'halpern_kkd':
          halpernKkd = value;
        case 'halpern_kkld':
          halpernKkld = value;
        case 'halpern_kkld_2ed':
          halpernKkld2ed = value;
        case 'heisig':
          heisig = value;
        case 'heisig6':
          heisig6 = value;
        case 'gakken':
          gakken = value;
        case 'oneill_names':
          oneillNames = value;
        case 'oneill_kk':
          oneillKk = value;
        case 'moro':
          final vol = ref.getAttribute('m_vol');
          final page = ref.getAttribute('m_page');
          moro = (vol != null && page != null)
              ? KanjidicMoroRef(volume: vol, page: page)
              : null;
        case 'henshall':
          henshall = value;
        case 'sh_kk':
          shKk = value;
        case 'sh_kk2':
          shKk2 = value;
        case 'jf_cards':
          jfCards = value;
        case 'tutt_cards':
          tuttCards = value;
        case 'kanji_in_context':
          kanjiInContext = value;
        case 'kodansha_compact':
          kodanshaCompact = value;
        case 'skip':
          skip = value;
        case 'busy_people':
          busyPeople = value;
      }
    }

    return KanjidicDictRefs(
      nelsonC: nelsonC,
      nelsonN: nelsonN,
      halpernNjecd: halpernNjecd,
      halpernKkd: halpernKkd,
      halpernKkld: halpernKkld,
      halpernKkld2ed: halpernKkld2ed,
      heisig: heisig,
      heisig6: heisig6,
      gakken: gakken,
      oneillNames: oneillNames,
      oneillKk: oneillKk,
      moro: moro,
      henshall: henshall,
      shKk: shKk,
      shKk2: shKk2,
      jfCards: jfCards,
      tuttCards: tuttCards,
      kanjiInContext: kanjiInContext,
      kodanshaCompact: kodanshaCompact,
      skip: skip,
      busyPeople: busyPeople,
    );
  }

  KanjidicQueryCodes? _parseQueryCodes(XmlElement character) {
    final qcNode = character.findElements('query_code').firstOrNull;
    if (qcNode == null) return null;

    final codes = qcNode.findElements('q_code').toList();
    if (codes.isEmpty) return null;

    String? skip, fourCorner, shDesc, deroo;
    final misclass = <KanjidicMisclass>[];

    for (final code in codes) {
      final type = code.getAttribute('qc_type');
      final value = code.innerText;
      final skipMisclass = code.getAttribute('skip_misclass');

      if (skipMisclass != null) {
        misclass.add(KanjidicMisclass(type: skipMisclass, value: value));
        continue;
      }

      switch (type) {
        case 'skip':
          skip = value;
        case 'four_corner':
          fourCorner = value;
        case 'sh_desc':
          shDesc = value;
        case 'deroo':
          deroo = value;
      }
    }

    return KanjidicQueryCodes(
      skip: skip,
      fourCorner: fourCorner,
      shDesc: shDesc,
      deroo: deroo,
      misclass: misclass.isEmpty ? null : misclass,
    );
  }

  KanjidicReadings _parseReadings(XmlElement? rmGroup) {
    final jaOn = <String>[];
    final jaKun = <String>[];
    final pinyin = <String>[];
    final koreanR = <String>[];
    final koreanH = <String>[];

    if (rmGroup != null) {
      for (final reading in rmGroup.findElements('reading')) {
        final type = reading.getAttribute('r_type');
        final value = reading.innerText;

        switch (type) {
          case 'ja_on':
            jaOn.add(value);
          case 'ja_kun':
            jaKun.add(value);
          case 'pinyin':
            pinyin.add(value);
          case 'korean_r':
            koreanR.add(value);
          case 'korean_h':
            koreanH.add(value);
        }
      }
    }

    return KanjidicReadings(
      jaOn: jaOn,
      jaKun: jaKun,
      pinyin: pinyin.isEmpty ? null : pinyin,
      koreanR: koreanR.isEmpty ? null : koreanR,
      koreanH: koreanH.isEmpty ? null : koreanH,
    );
  }

  List<String>? _parseNanori(XmlElement? readingMeaning) {
    if (readingMeaning == null) return null;
    final nanoris =
        readingMeaning.findElements('nanori').map((e) => e.innerText).toList();
    return nanoris.isEmpty ? null : nanoris;
  }

  Map<String, List<String>> _parseMeanings(XmlElement? rmGroup) {
    final meanings = <String, List<String>>{};

    if (rmGroup != null) {
      for (final meaning in rmGroup.findElements('meaning')) {
        final lang = meaning.getAttribute('m_lang') ?? 'en';
        meanings.putIfAbsent(lang, () => []).add(meaning.innerText);
      }
    }

    return meanings;
  }

  List<String>? _parseRadicalNames(XmlElement? readingMeaning) {
    if (readingMeaning == null) return null;
    final names = readingMeaning
        .findElements('rad_name')
        .map((e) => e.innerText)
        .toList();
    return names.isEmpty ? null : names;
  }

  String _text(XmlElement parent, String name) {
    return parent.findElements(name).first.innerText;
  }

  String? _textOrNull(XmlElement? parent, String name) {
    if (parent == null) return null;
    final el = parent.findElements(name).firstOrNull;
    return el?.innerText;
  }
}
