import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/raw_kanjivg.dart';

part 'raw_kanjivg_dto.freezed.dart';
part 'raw_kanjivg_dto.g.dart';

@freezed
abstract class RawKanjiVgDto with _$RawKanjiVgDto {
  const factory RawKanjiVgDto({
    @JsonKey(name: 'import_id') required int importId,
    required String character,
    @JsonKey(name: 'unicode_hex') required String unicodeHex,
    @JsonKey(name: 'view_box') required String viewBox,
    @JsonKey(name: 'stroke_count') required int strokeCount,
    required List<KanjiVgStrokeDto> strokes,
    required KanjiVgComponentDto components,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _RawKanjiVgDto;

  const RawKanjiVgDto._();

  factory RawKanjiVgDto.fromJson(Map<String, Object?> json) =>
      _$RawKanjiVgDtoFromJson(json);

  factory RawKanjiVgDto.fromDomain(RawKanjiVg entity) => RawKanjiVgDto(
        importId: entity.importId,
        character: entity.character,
        unicodeHex: entity.unicodeHex,
        viewBox: entity.viewBox,
        strokeCount: entity.strokeCount,
        strokes: entity.strokes.map(KanjiVgStrokeDto.fromDomain).toList(),
        components: KanjiVgComponentDto.fromDomain(entity.components),
        createdAt: entity.createdAt,
      );

  RawKanjiVg toDomain() => RawKanjiVg(
        importId: importId,
        character: character,
        unicodeHex: unicodeHex,
        viewBox: viewBox,
        strokeCount: strokeCount,
        strokes: strokes.map((s) => s.toDomain()).toList(),
        components: components.toDomain(),
        createdAt: createdAt,
      );
}

@freezed
abstract class KanjiVgStrokeDto with _$KanjiVgStrokeDto {
  const factory KanjiVgStrokeDto({
    required int number,
    required String type,
    @JsonKey(name: 'path_data') required String pathData,
  }) = _KanjiVgStrokeDto;

  const KanjiVgStrokeDto._();

  factory KanjiVgStrokeDto.fromJson(Map<String, Object?> json) =>
      _$KanjiVgStrokeDtoFromJson(json);

  factory KanjiVgStrokeDto.fromDomain(KanjiVgStroke entity) =>
      KanjiVgStrokeDto(
        number: entity.number,
        type: entity.type,
        pathData: entity.pathData,
      );

  KanjiVgStroke toDomain() => KanjiVgStroke(
        number: number,
        type: type,
        pathData: pathData,
      );
}

@freezed
abstract class KanjiVgComponentDto with _$KanjiVgComponentDto {
  const factory KanjiVgComponentDto({
    required String element,
    String? position,
    bool? variant,
    String? original,
    int? part,
    String? radical,
    String? phon,
    @JsonKey(name: 'trad_form') String? tradForm,
    @JsonKey(name: 'stroke_indices') required List<int> strokeIndices,
    required List<KanjiVgComponentDto> children,
  }) = _KanjiVgComponentDto;

  const KanjiVgComponentDto._();

  factory KanjiVgComponentDto.fromJson(Map<String, Object?> json) =>
      _$KanjiVgComponentDtoFromJson(json);

  factory KanjiVgComponentDto.fromDomain(KanjiVgComponent entity) =>
      KanjiVgComponentDto(
        element: entity.element,
        position: entity.position,
        variant: entity.variant,
        original: entity.original,
        part: entity.part,
        radical: entity.radical,
        phon: entity.phon,
        tradForm: entity.tradForm,
        strokeIndices: entity.strokeIndices,
        children: entity.children.map(KanjiVgComponentDto.fromDomain).toList(),
      );

  KanjiVgComponent toDomain() => KanjiVgComponent(
        element: element,
        position: position,
        variant: variant,
        original: original,
        part: part,
        radical: radical,
        phon: phon,
        tradForm: tradForm,
        strokeIndices: strokeIndices,
        children: children.map((c) => c.toDomain()).toList(),
      );
}
