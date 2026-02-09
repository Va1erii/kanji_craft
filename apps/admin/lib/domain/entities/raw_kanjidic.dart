import 'package:freezed_annotation/freezed_annotation.dart';

part 'raw_kanjidic.freezed.dart';

@freezed
abstract class RawKanjidic with _$RawKanjidic {
  const factory RawKanjidic({
    required int importId,
    required String literal,
    required int strokeCount,
    List<int>? strokeCountMisstrokes,
    int? grade,
    int? jlpt,
    int? frequency,
    required KanjidicCodepoints codepoints,
    required KanjidicRadicals radicals,
    KanjidicDictRefs? dictRefs,
    KanjidicQueryCodes? queryCodes,
    required KanjidicReadings readings,
    List<String>? nanori,
    required Map<String, List<String>> meanings,
    List<KanjidicVariant>? variants,
    List<String>? radicalNames,
    required DateTime createdAt,
  }) = _RawKanjidic;
}

@freezed
abstract class KanjidicCodepoints with _$KanjidicCodepoints {
  const factory KanjidicCodepoints({
    required String ucs,
    String? jis208,
    String? jis212,
    String? jis213,
  }) = _KanjidicCodepoints;
}

@freezed
abstract class KanjidicRadicals with _$KanjidicRadicals {
  const factory KanjidicRadicals({
    required int classical,
    int? nelsonC,
  }) = _KanjidicRadicals;
}

@freezed
abstract class KanjidicDictRefs with _$KanjidicDictRefs {
  const factory KanjidicDictRefs({
    String? nelsonC,
    String? nelsonN,
    String? halpernNjecd,
    String? halpernKkd,
    String? halpernKkld,
    String? halpernKkld2ed,
    String? heisig,
    String? heisig6,
    String? gakken,
    String? oneillNames,
    String? oneillKk,
    KanjidicMoroRef? moro,
    String? henshall,
    String? shKk,
    String? shKk2,
    String? jfCards,
    String? tuttCards,
    String? kanjiInContext,
    String? kodanshaCompact,
    String? skip,
    String? busyPeople,
  }) = _KanjidicDictRefs;
}

@freezed
abstract class KanjidicMoroRef with _$KanjidicMoroRef {
  const factory KanjidicMoroRef({
    required String volume,
    required String page,
  }) = _KanjidicMoroRef;
}

@freezed
abstract class KanjidicQueryCodes with _$KanjidicQueryCodes {
  const factory KanjidicQueryCodes({
    String? skip,
    String? fourCorner,
    String? shDesc,
    String? deroo,
    List<KanjidicMisclass>? misclass,
  }) = _KanjidicQueryCodes;
}

@freezed
abstract class KanjidicMisclass with _$KanjidicMisclass {
  const factory KanjidicMisclass({
    required String type,
    required String value,
  }) = _KanjidicMisclass;
}

@freezed
abstract class KanjidicVariant with _$KanjidicVariant {
  const factory KanjidicVariant({
    required String varType,
    required String value,
  }) = _KanjidicVariant;
}

@freezed
abstract class KanjidicReadings with _$KanjidicReadings {
  const factory KanjidicReadings({
    required List<String> jaOn,
    required List<String> jaKun,
    List<String>? pinyin,
    List<String>? koreanR,
    List<String>? koreanH,
  }) = _KanjidicReadings;
}
