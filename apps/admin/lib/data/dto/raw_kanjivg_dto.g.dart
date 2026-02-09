// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_kanjivg_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RawKanjiVgDto _$RawKanjiVgDtoFromJson(Map<String, dynamic> json) =>
    _RawKanjiVgDto(
      importId: (json['import_id'] as num).toInt(),
      character: json['character'] as String,
      unicodeHex: json['unicode_hex'] as String,
      viewBox: json['view_box'] as String,
      strokeCount: (json['stroke_count'] as num).toInt(),
      strokes: (json['strokes'] as List<dynamic>)
          .map((e) => KanjiVgStrokeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      components: KanjiVgComponentDto.fromJson(
        json['components'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$RawKanjiVgDtoToJson(_RawKanjiVgDto instance) =>
    <String, dynamic>{
      'import_id': instance.importId,
      'character': instance.character,
      'unicode_hex': instance.unicodeHex,
      'view_box': instance.viewBox,
      'stroke_count': instance.strokeCount,
      'strokes': instance.strokes,
      'components': instance.components,
      'created_at': instance.createdAt.toIso8601String(),
    };

_KanjiVgStrokeDto _$KanjiVgStrokeDtoFromJson(Map<String, dynamic> json) =>
    _KanjiVgStrokeDto(
      number: (json['number'] as num).toInt(),
      type: json['type'] as String,
      pathData: json['path_data'] as String,
    );

Map<String, dynamic> _$KanjiVgStrokeDtoToJson(_KanjiVgStrokeDto instance) =>
    <String, dynamic>{
      'number': instance.number,
      'type': instance.type,
      'path_data': instance.pathData,
    };

_KanjiVgComponentDto _$KanjiVgComponentDtoFromJson(Map<String, dynamic> json) =>
    _KanjiVgComponentDto(
      element: json['element'] as String,
      position: json['position'] as String?,
      variant: json['variant'] as bool?,
      original: json['original'] as String?,
      part: (json['part'] as num?)?.toInt(),
      radical: json['radical'] as String?,
      phon: json['phon'] as String?,
      tradForm: json['trad_form'] as String?,
      strokeIndices: (json['stroke_indices'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      children: (json['children'] as List<dynamic>)
          .map((e) => KanjiVgComponentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KanjiVgComponentDtoToJson(
  _KanjiVgComponentDto instance,
) => <String, dynamic>{
  'element': instance.element,
  'position': instance.position,
  'variant': instance.variant,
  'original': instance.original,
  'part': instance.part,
  'radical': instance.radical,
  'phon': instance.phon,
  'trad_form': instance.tradForm,
  'stroke_indices': instance.strokeIndices,
  'children': instance.children,
};
