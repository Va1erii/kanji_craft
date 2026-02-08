import 'package:freezed_annotation/freezed_annotation.dart';

part 'raw_jmdict.freezed.dart';

@freezed
abstract class RawJmdict with _$RawJmdict {
  const factory RawJmdict({
    required int id,
    required int importId,
    required int entSeq,
    required List<JmdictKanjiElement> kanjiElements,
    required List<JmdictReadingElement> readingElements,
    required List<JmdictSense> senses,
    required DateTime createdAt,
  }) = _RawJmdict;
}

@freezed
abstract class JmdictKanjiElement with _$JmdictKanjiElement {
  const factory JmdictKanjiElement({
    required String keb,
    List<String>? keInf,
    List<String>? kePri,
  }) = _JmdictKanjiElement;
}

@freezed
abstract class JmdictReadingElement with _$JmdictReadingElement {
  const factory JmdictReadingElement({
    required String reb,
    @Default(false) bool reNokanji,
    List<String>? reRestr,
    List<String>? reInf,
    List<String>? rePri,
  }) = _JmdictReadingElement;
}

@freezed
abstract class JmdictSense with _$JmdictSense {
  const factory JmdictSense({
    List<String>? stagk,
    List<String>? stagr,
    List<String>? pos,
    List<String>? xref,
    List<String>? ant,
    List<String>? field,
    List<String>? misc,
    List<String>? sInf,
    List<JmdictLsource>? lsource,
    List<String>? dial,
    required Map<String, List<String>> glosses,
  }) = _JmdictSense;
}

@freezed
abstract class JmdictLsource with _$JmdictLsource {
  const factory JmdictLsource({
    required String lang,
    String? value,
    String? lsType,
    @Default(false) bool lsWasei,
  }) = _JmdictLsource;
}
