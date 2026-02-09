// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_jmdict_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RawJmdictDto _$RawJmdictDtoFromJson(Map<String, dynamic> json) =>
    _RawJmdictDto(
      importId: (json['import_id'] as num).toInt(),
      entSeq: (json['ent_seq'] as num).toInt(),
      kanjiElements: (json['kanji_elements'] as List<dynamic>)
          .map((e) => JmdictKanjiElementDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      readingElements: (json['reading_elements'] as List<dynamic>)
          .map(
            (e) => JmdictReadingElementDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      senses: (json['senses'] as List<dynamic>)
          .map((e) => JmdictSenseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$RawJmdictDtoToJson(_RawJmdictDto instance) =>
    <String, dynamic>{
      'import_id': instance.importId,
      'ent_seq': instance.entSeq,
      'kanji_elements': instance.kanjiElements,
      'reading_elements': instance.readingElements,
      'senses': instance.senses,
      'created_at': instance.createdAt.toIso8601String(),
    };

_JmdictKanjiElementDto _$JmdictKanjiElementDtoFromJson(
  Map<String, dynamic> json,
) => _JmdictKanjiElementDto(
  keb: json['keb'] as String,
  keInf: (json['ke_inf'] as List<dynamic>?)?.map((e) => e as String).toList(),
  kePri: (json['ke_pri'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$JmdictKanjiElementDtoToJson(
  _JmdictKanjiElementDto instance,
) => <String, dynamic>{
  'keb': instance.keb,
  'ke_inf': instance.keInf,
  'ke_pri': instance.kePri,
};

_JmdictReadingElementDto _$JmdictReadingElementDtoFromJson(
  Map<String, dynamic> json,
) => _JmdictReadingElementDto(
  reb: json['reb'] as String,
  reNokanji: json['re_nokanji'] as bool? ?? false,
  reRestr: (json['re_restr'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  reInf: (json['re_inf'] as List<dynamic>?)?.map((e) => e as String).toList(),
  rePri: (json['re_pri'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$JmdictReadingElementDtoToJson(
  _JmdictReadingElementDto instance,
) => <String, dynamic>{
  'reb': instance.reb,
  're_nokanji': instance.reNokanji,
  're_restr': instance.reRestr,
  're_inf': instance.reInf,
  're_pri': instance.rePri,
};

_JmdictSenseDto _$JmdictSenseDtoFromJson(
  Map<String, dynamic> json,
) => _JmdictSenseDto(
  stagk: (json['stagk'] as List<dynamic>?)?.map((e) => e as String).toList(),
  stagr: (json['stagr'] as List<dynamic>?)?.map((e) => e as String).toList(),
  pos: (json['pos'] as List<dynamic>?)?.map((e) => e as String).toList(),
  xref: (json['xref'] as List<dynamic>?)?.map((e) => e as String).toList(),
  ant: (json['ant'] as List<dynamic>?)?.map((e) => e as String).toList(),
  field: (json['field'] as List<dynamic>?)?.map((e) => e as String).toList(),
  misc: (json['misc'] as List<dynamic>?)?.map((e) => e as String).toList(),
  sInf: (json['s_inf'] as List<dynamic>?)?.map((e) => e as String).toList(),
  lsource: (json['lsource'] as List<dynamic>?)
      ?.map((e) => JmdictLsourceDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  dial: (json['dial'] as List<dynamic>?)?.map((e) => e as String).toList(),
  glosses: (json['glosses'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
);

Map<String, dynamic> _$JmdictSenseDtoToJson(_JmdictSenseDto instance) =>
    <String, dynamic>{
      'stagk': instance.stagk,
      'stagr': instance.stagr,
      'pos': instance.pos,
      'xref': instance.xref,
      'ant': instance.ant,
      'field': instance.field,
      'misc': instance.misc,
      's_inf': instance.sInf,
      'lsource': instance.lsource,
      'dial': instance.dial,
      'glosses': instance.glosses,
    };

_JmdictLsourceDto _$JmdictLsourceDtoFromJson(Map<String, dynamic> json) =>
    _JmdictLsourceDto(
      lang: json['lang'] as String,
      value: json['value'] as String?,
      lsType: json['ls_type'] as String?,
      lsWasei: json['ls_wasei'] as bool? ?? false,
    );

Map<String, dynamic> _$JmdictLsourceDtoToJson(_JmdictLsourceDto instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'value': instance.value,
      'ls_type': instance.lsType,
      'ls_wasei': instance.lsWasei,
    };
