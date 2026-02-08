import 'package:kanji_craft_admin/domain/entities/data_import.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';
import 'package:kanji_craft_admin/domain/entities/kanji_component_review.dart';
import 'package:kanji_craft_admin/domain/entities/raw_kanjidic.dart';
import 'package:kanji_craft_admin/domain/entities/raw_kanjivg.dart';
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
  DateTime? promotedAt,
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
      promotedAt: promotedAt,
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
  int? id,
  int importId = 1,
  String character = '木',
  String unicodeHex = '6728',
  String viewBox = '0 0 109 109',
  int strokeCount = 4,
  List<KanjiVgStroke>? strokes,
  KanjiVgComponent? components,
  DateTime? createdAt,
}) =>
    RawKanjiVg(
      id: id ?? _nextId++,
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
      createdAt: createdAt ?? _epoch,
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
  int? id,
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
  DateTime? createdAt,
}) =>
    RawKanjidic(
      id: id ?? _nextId++,
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
      createdAt: createdAt ?? _epoch,
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
