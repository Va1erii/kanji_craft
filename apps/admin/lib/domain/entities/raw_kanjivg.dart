import 'package:freezed_annotation/freezed_annotation.dart';

part 'raw_kanjivg.freezed.dart';

@freezed
abstract class RawKanjiVg with _$RawKanjiVg {
  const factory RawKanjiVg({
    required int importId,
    required String character,
    required String unicodeHex,
    required String viewBox,
    required int strokeCount,
    required List<KanjiVgStroke> strokes,
    required KanjiVgComponent components,
    required DateTime createdAt,
  }) = _RawKanjiVg;
}

@freezed
abstract class KanjiVgStroke with _$KanjiVgStroke {
  const factory KanjiVgStroke({
    required int number,
    required String type,
    required String pathData,
  }) = _KanjiVgStroke;
}

@freezed
abstract class KanjiVgComponent with _$KanjiVgComponent {
  const factory KanjiVgComponent({
    required String element,
    String? position,
    bool? variant,
    String? original,
    int? part,
    int? number,
    String? radical,
    String? phon,
    String? tradForm,
    bool? partial,
    bool? radicalForm,
    required List<int> strokeIndices,
    required List<KanjiVgComponent> children,
  }) = _KanjiVgComponent;
}
