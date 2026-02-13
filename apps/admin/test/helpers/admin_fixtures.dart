import 'dart:convert';

import 'package:kanji_craft_admin/domain/entities/data_import.dart';
import 'package:kanji_craft_admin/domain/entities/draft_kanji.dart';
import 'package:kanji_craft_admin/domain/entities/draft_radical.dart';
import 'package:kanji_craft_admin/domain/entities/draft_radical_i18n.dart';
import 'package:kanji_craft_admin/domain/entities/draft_radical_variant.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';
import 'package:kanji_craft_admin/domain/entities/jmdict_furigana.dart';
import 'package:kanji_craft_admin/domain/entities/kanji_component_review.dart';
import 'package:kanji_craft_admin/domain/entities/raw_jmdict.dart';
import 'package:kanji_craft_admin/domain/entities/raw_kanjidic.dart';
import 'package:kanji_craft_admin/domain/entities/raw_kanjivg.dart';
import 'package:kanji_craft_admin/domain/entities/vocab_level.dart';
import 'package:kanji_craft_core/domain/entities/kanji/kanji_component.dart';
import 'package:kanji_craft_core/domain/entities/logic_hint.dart';
import 'package:kanji_craft_core/domain/entities/radical/position.dart';
import 'package:kanji_craft_core/domain/entities/radical_type.dart';
import 'package:kanji_craft_core/domain/entities/verification_status.dart';

final _epoch = DateTime.utc(2025, 1, 1);

int _nextId = 1;

void resetFixtureIds() => _nextId = 1;

DataImport fakeDataImport({
  int? id,
  ImportSource source = ImportSource.kanjivg,
  String sourceVersion = '1.0.0',
  ImportStatus status = ImportStatus.pending,
  int? recordCount,
  DateTime? startedAt,
  DateTime? ingestedAt,
  DateTime? processedAt,
  String? errorMessage,
  Map<String, Object?>? metadata,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    DataImport(
      id: id ?? _nextId++,
      source: source,
      sourceVersion: sourceVersion,
      status: status,
      recordCount: recordCount,
      startedAt: startedAt ?? _epoch,
      ingestedAt: ingestedAt,
      processedAt: processedAt,
      errorMessage: errorMessage,
      metadata: metadata,
      createdAt: createdAt ?? _epoch,
      updatedAt: updatedAt ?? _epoch,
    );

KanjiVgStroke fakeStroke({
  int number = 1,
  String type = 'brush',
  String pathData = 'M10,20 C30,40 50,60 70,80',
}) =>
    KanjiVgStroke(number: number, type: type, pathData: pathData);

KanjiVgComponent fakeComponent({
  String element = '木',
  String? position,
  bool? variant,
  String? original,
  int? part,
  String? radical,
  String? phon,
  String? tradForm,
  List<int> strokeIndices = const [0, 1],
  List<KanjiVgComponent> children = const [],
}) =>
    KanjiVgComponent(
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

RawKanjiVg fakeRawKanjiVg({
  int importId = 1,
  String character = '木',
  String unicodeHex = '6728',
  String viewBox = '0 0 109 109',
  int strokeCount = 4,
  List<KanjiVgStroke>? strokes,
  KanjiVgComponent? components,
}) =>
    RawKanjiVg(
      importId: importId,
      character: character,
      unicodeHex: unicodeHex,
      viewBox: viewBox,
      strokeCount: strokeCount,
      strokes: strokes ??
          [
            fakeStroke(number: 1),
            fakeStroke(number: 2, type: 'press', pathData: 'M20,30 L40,50'),
          ],
      components: components ?? fakeComponent(),
    );

KanjidicCodepoints fakeCodepoints({
  String ucs = '6728',
  String? jis208,
  String? jis212,
  String? jis213,
}) =>
    KanjidicCodepoints(
      ucs: ucs,
      jis208: jis208,
      jis212: jis212,
      jis213: jis213,
    );

KanjidicRadicals fakeRadicals({
  int classical = 75,
  int? nelsonC,
}) =>
    KanjidicRadicals(classical: classical, nelsonC: nelsonC);

KanjidicReadings fakeReadings({
  List<String> jaOn = const ['モク', 'ボク'],
  List<String> jaKun = const ['き', 'こ'],
  List<String>? pinyin,
  List<String>? koreanR,
  List<String>? koreanH,
}) =>
    KanjidicReadings(
      jaOn: jaOn,
      jaKun: jaKun,
      pinyin: pinyin,
      koreanR: koreanR,
      koreanH: koreanH,
    );

RawKanjidic fakeRawKanjidic({
  int importId = 1,
  String literal = '木',
  int strokeCount = 4,
  List<int>? strokeCountMisstrokes,
  int? grade,
  int? jlpt,
  int? frequency,
  KanjidicCodepoints? codepoints,
  KanjidicRadicals? radicals,
  KanjidicDictRefs? dictRefs,
  KanjidicQueryCodes? queryCodes,
  KanjidicReadings? readings,
  List<String>? nanori,
  Map<String, List<String>>? meanings,
  List<KanjidicVariant>? variants,
  List<String>? radicalNames,
}) =>
    RawKanjidic(
      importId: importId,
      literal: literal,
      strokeCount: strokeCount,
      strokeCountMisstrokes: strokeCountMisstrokes,
      grade: grade,
      jlpt: jlpt,
      frequency: frequency,
      codepoints: codepoints ?? fakeCodepoints(),
      radicals: radicals ?? fakeRadicals(),
      dictRefs: dictRefs,
      queryCodes: queryCodes,
      readings: readings ?? fakeReadings(),
      nanori: nanori,
      meanings: meanings ?? {'en': ['tree', 'wood']},
      variants: variants,
      radicalNames: radicalNames,
    );

KanjiComponentReview fakeReview({
  int? id,
  int kanjiComponentId = 100,
  VerificationStatus verificationStatus = VerificationStatus.draft,
  double? aiConfidence,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    KanjiComponentReview(
      id: id ?? _nextId++,
      kanjiComponentId: kanjiComponentId,
      verificationStatus: verificationStatus,
      aiConfidence: aiConfidence,
      createdAt: createdAt ?? _epoch,
      updatedAt: updatedAt ?? _epoch,
    );

VocabLevel fakeVocabLevel({
  String expression = '食べる',
  String reading = 'たべる',
  int level = 5,
}) =>
    VocabLevel(expression: expression, reading: reading, level: level);

JmdictFurigana fakeJmdictFurigana({
  String text = '食べる',
  String reading = 'たべる',
  List<Map<String, String>>? furiganaSegments,
}) =>
    JmdictFurigana(
      text: text,
      reading: reading,
      furigana: jsonEncode(furiganaSegments ??
          [
            {'ruby': text.substring(0, 1), 'rt': reading.substring(0, 1)},
            {'ruby': text.substring(1)},
          ]),
    );

DraftKanji fakeDraftKanji({
  int? id,
  String character = '木',
  int strokeCount = 4,
  int frequencyRank = 1000,
  int? minJlptLevel,
  int? minGrade,
  String? svgFileName,
  String? svgFileUrl,
  String? svgHash,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    DraftKanji(
      id: id ?? _nextId++,
      character: character,
      strokeCount: strokeCount,
      frequencyRank: frequencyRank,
      minJlptLevel: minJlptLevel,
      minGrade: minGrade,
      svgFileName: svgFileName,
      svgFileUrl: svgFileUrl,
      svgHash: svgHash,
      createdAt: createdAt ?? _epoch,
      updatedAt: updatedAt ?? _epoch,
    );

DraftRadicalI18n fakeDraftRadicalI18n({
  int? id,
  int draftRadicalId = 1,
  String langCode = 'en',
  String name = 'tree',
  String systemMnemonic = '',
  List<String> searchTags = const [],
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    DraftRadicalI18n(
      id: id ?? _nextId++,
      draftRadicalId: draftRadicalId,
      langCode: langCode,
      name: name,
      systemMnemonic: systemMnemonic,
      searchTags: searchTags,
      createdAt: createdAt ?? _epoch,
      updatedAt: updatedAt ?? _epoch,
    );

DraftRadical fakeDraftRadical({
  int? id,
  String masterSymbol = '木',
  int? strokeCount = 4,
  int? impactScore,
  int? minJlptLevel,
  int? minGrade,
  String? svgFileName,
  String? svgFileUrl,
  String? svgHash,
  bool isOfficial = false,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    DraftRadical(
      id: id ?? _nextId++,
      masterSymbol: masterSymbol,
      strokeCount: strokeCount,
      impactScore: impactScore,
      minJlptLevel: minJlptLevel,
      minGrade: minGrade,
      svgFileName: svgFileName,
      svgFileUrl: svgFileUrl,
      svgHash: svgHash,
      isOfficial: isOfficial,
      createdAt: createdAt ?? _epoch,
      updatedAt: updatedAt ?? _epoch,
    );

DraftRadicalVariant fakeDraftRadicalVariant({
  int? id,
  int draftRadicalId = 1,
  String shape = '木',
  Position position = Position.unknown,
  bool isLocked = false,
  String? svgFileName,
  String? svgFileUrl,
  String? svgHash,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    DraftRadicalVariant(
      id: id ?? _nextId++,
      draftRadicalId: draftRadicalId,
      shape: shape,
      position: position,
      isLocked: isLocked,
      svgFileName: svgFileName,
      svgFileUrl: svgFileUrl,
      svgHash: svgHash,
      createdAt: createdAt ?? _epoch,
      updatedAt: updatedAt ?? _epoch,
    );

const _kanjiElementSentinel = [JmdictKanjiElement(keb: '_sentinel_')];

RawJmdict fakeRawJmdict({
  int importId = 1,
  int? entSeq,
  List<JmdictKanjiElement>? kanjiElements = _kanjiElementSentinel,
  List<JmdictReadingElement>? readingElements,
  List<JmdictSense>? senses,
  List<JmdictExample>? examples,
}) =>
    RawJmdict(
      importId: importId,
      entSeq: entSeq ?? _nextId++,
      kanjiElements: identical(kanjiElements, _kanjiElementSentinel)
          ? [const JmdictKanjiElement(keb: '食べる', kePri: ['ichi1'])]
          : kanjiElements,
      readingElements: readingElements ??
          [
            const JmdictReadingElement(reb: 'たべる', rePri: ['ichi1']),
          ],
      senses: senses ??
          [
            const JmdictSense(
              pos: ['v1', 'vt'],
              glosses: {
                'en': ['to eat'],
              },
            ),
          ],
      examples: examples,
    );

KanjiComponent fakeKanjiComponent({
  int? id,
  int kanjiId = 1,
  int radicalId = 1,
  Position position = Position.unknown,
  LogicHint logicHint = LogicHint.semantic,
  RadicalType radicalType = RadicalType.component,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    KanjiComponent(
      id: id ?? _nextId++,
      kanjiId: kanjiId,
      radicalId: radicalId,
      position: position,
      logicHint: logicHint,
      radicalType: radicalType,
      createdAt: createdAt ?? _epoch,
      updatedAt: updatedAt ?? _epoch,
    );
