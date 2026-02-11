// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_kanjidic_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RawKanjidicDto _$RawKanjidicDtoFromJson(
  Map<String, dynamic> json,
) => _RawKanjidicDto(
  importId: (json['import_id'] as num).toInt(),
  literal: json['literal'] as String,
  strokeCount: (json['stroke_count'] as num).toInt(),
  strokeCountMisstrokes: (json['stroke_count_misstrokes'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  grade: (json['grade'] as num?)?.toInt(),
  jlpt: (json['jlpt'] as num?)?.toInt(),
  frequency: (json['frequency'] as num?)?.toInt(),
  codepoints: KanjidicCodepointsDto.fromJson(
    json['codepoints'] as Map<String, dynamic>,
  ),
  radicals: KanjidicRadicalsDto.fromJson(
    json['radicals'] as Map<String, dynamic>,
  ),
  dictRefs: json['dict_refs'] == null
      ? null
      : KanjidicDictRefsDto.fromJson(json['dict_refs'] as Map<String, dynamic>),
  queryCodes: json['query_codes'] == null
      ? null
      : KanjidicQueryCodesDto.fromJson(
          json['query_codes'] as Map<String, dynamic>,
        ),
  readings: KanjidicReadingsDto.fromJson(
    json['readings'] as Map<String, dynamic>,
  ),
  nanori: (json['nanori'] as List<dynamic>?)?.map((e) => e as String).toList(),
  meanings: (json['meanings'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
  variants: (json['variants'] as List<dynamic>?)
      ?.map((e) => KanjidicVariantDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  radicalNames: (json['radical_names'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RawKanjidicDtoToJson(_RawKanjidicDto instance) =>
    <String, dynamic>{
      'import_id': instance.importId,
      'literal': instance.literal,
      'stroke_count': instance.strokeCount,
      'stroke_count_misstrokes': instance.strokeCountMisstrokes,
      'grade': instance.grade,
      'jlpt': instance.jlpt,
      'frequency': instance.frequency,
      'codepoints': instance.codepoints,
      'radicals': instance.radicals,
      'dict_refs': instance.dictRefs,
      'query_codes': instance.queryCodes,
      'readings': instance.readings,
      'nanori': instance.nanori,
      'meanings': instance.meanings,
      'variants': instance.variants,
      'radical_names': instance.radicalNames,
    };

_KanjidicCodepointsDto _$KanjidicCodepointsDtoFromJson(
  Map<String, dynamic> json,
) => _KanjidicCodepointsDto(
  ucs: json['ucs'] as String,
  jis208: json['jis208'] as String?,
  jis212: json['jis212'] as String?,
  jis213: json['jis213'] as String?,
);

Map<String, dynamic> _$KanjidicCodepointsDtoToJson(
  _KanjidicCodepointsDto instance,
) => <String, dynamic>{
  'ucs': instance.ucs,
  'jis208': instance.jis208,
  'jis212': instance.jis212,
  'jis213': instance.jis213,
};

_KanjidicRadicalsDto _$KanjidicRadicalsDtoFromJson(Map<String, dynamic> json) =>
    _KanjidicRadicalsDto(
      classical: (json['classical'] as num).toInt(),
      nelsonC: (json['nelson_c'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KanjidicRadicalsDtoToJson(
  _KanjidicRadicalsDto instance,
) => <String, dynamic>{
  'classical': instance.classical,
  'nelson_c': instance.nelsonC,
};

_KanjidicDictRefsDto _$KanjidicDictRefsDtoFromJson(Map<String, dynamic> json) =>
    _KanjidicDictRefsDto(
      nelsonC: json['nelson_c'] as String?,
      nelsonN: json['nelson_n'] as String?,
      halpernNjecd: json['halpern_njecd'] as String?,
      halpernKkd: json['halpern_kkd'] as String?,
      halpernKkld: json['halpern_kkld'] as String?,
      halpernKkld2ed: json['halpern_kkld_2ed'] as String?,
      heisig: json['heisig'] as String?,
      heisig6: json['heisig6'] as String?,
      gakken: json['gakken'] as String?,
      oneillNames: json['oneill_names'] as String?,
      oneillKk: json['oneill_kk'] as String?,
      moro: json['moro'] == null
          ? null
          : KanjidicMoroRefDto.fromJson(json['moro'] as Map<String, dynamic>),
      henshall: json['henshall'] as String?,
      shKk: json['sh_kk'] as String?,
      shKk2: json['sh_kk2'] as String?,
      jfCards: json['jf_cards'] as String?,
      tuttCards: json['tutt_cards'] as String?,
      kanjiInContext: json['kanji_in_context'] as String?,
      kodanshaCompact: json['kodansha_compact'] as String?,
      skip: json['skip'] as String?,
      busyPeople: json['busy_people'] as String?,
    );

Map<String, dynamic> _$KanjidicDictRefsDtoToJson(
  _KanjidicDictRefsDto instance,
) => <String, dynamic>{
  'nelson_c': instance.nelsonC,
  'nelson_n': instance.nelsonN,
  'halpern_njecd': instance.halpernNjecd,
  'halpern_kkd': instance.halpernKkd,
  'halpern_kkld': instance.halpernKkld,
  'halpern_kkld_2ed': instance.halpernKkld2ed,
  'heisig': instance.heisig,
  'heisig6': instance.heisig6,
  'gakken': instance.gakken,
  'oneill_names': instance.oneillNames,
  'oneill_kk': instance.oneillKk,
  'moro': instance.moro,
  'henshall': instance.henshall,
  'sh_kk': instance.shKk,
  'sh_kk2': instance.shKk2,
  'jf_cards': instance.jfCards,
  'tutt_cards': instance.tuttCards,
  'kanji_in_context': instance.kanjiInContext,
  'kodansha_compact': instance.kodanshaCompact,
  'skip': instance.skip,
  'busy_people': instance.busyPeople,
};

_KanjidicMoroRefDto _$KanjidicMoroRefDtoFromJson(Map<String, dynamic> json) =>
    _KanjidicMoroRefDto(
      volume: json['volume'] as String,
      page: json['page'] as String,
    );

Map<String, dynamic> _$KanjidicMoroRefDtoToJson(_KanjidicMoroRefDto instance) =>
    <String, dynamic>{'volume': instance.volume, 'page': instance.page};

_KanjidicQueryCodesDto _$KanjidicQueryCodesDtoFromJson(
  Map<String, dynamic> json,
) => _KanjidicQueryCodesDto(
  skip: json['skip'] as String?,
  fourCorner: json['four_corner'] as String?,
  shDesc: json['sh_desc'] as String?,
  deroo: json['deroo'] as String?,
  misclass: (json['misclass'] as List<dynamic>?)
      ?.map((e) => KanjidicMisclassDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$KanjidicQueryCodesDtoToJson(
  _KanjidicQueryCodesDto instance,
) => <String, dynamic>{
  'skip': instance.skip,
  'four_corner': instance.fourCorner,
  'sh_desc': instance.shDesc,
  'deroo': instance.deroo,
  'misclass': instance.misclass,
};

_KanjidicMisclassDto _$KanjidicMisclassDtoFromJson(Map<String, dynamic> json) =>
    _KanjidicMisclassDto(
      type: json['type'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$KanjidicMisclassDtoToJson(
  _KanjidicMisclassDto instance,
) => <String, dynamic>{'type': instance.type, 'value': instance.value};

_KanjidicVariantDto _$KanjidicVariantDtoFromJson(Map<String, dynamic> json) =>
    _KanjidicVariantDto(
      varType: json['var_type'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$KanjidicVariantDtoToJson(_KanjidicVariantDto instance) =>
    <String, dynamic>{'var_type': instance.varType, 'value': instance.value};

_KanjidicReadingsDto _$KanjidicReadingsDtoFromJson(Map<String, dynamic> json) =>
    _KanjidicReadingsDto(
      jaOn: (json['ja_on'] as List<dynamic>).map((e) => e as String).toList(),
      jaKun: (json['ja_kun'] as List<dynamic>).map((e) => e as String).toList(),
      pinyin: (json['pinyin'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      koreanR: (json['korean_r'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      koreanH: (json['korean_h'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$KanjidicReadingsDtoToJson(
  _KanjidicReadingsDto instance,
) => <String, dynamic>{
  'ja_on': instance.jaOn,
  'ja_kun': instance.jaKun,
  'pinyin': instance.pinyin,
  'korean_r': instance.koreanR,
  'korean_h': instance.koreanH,
};
