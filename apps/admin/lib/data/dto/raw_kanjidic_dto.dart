import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/raw_kanjidic.dart';

part 'raw_kanjidic_dto.freezed.dart';
part 'raw_kanjidic_dto.g.dart';

@freezed
abstract class RawKanjidicDto with _$RawKanjidicDto {
  const factory RawKanjidicDto({
    @JsonKey(name: 'import_id') required int importId,
    required String literal,
    @JsonKey(name: 'stroke_count') required int strokeCount,
    @JsonKey(name: 'stroke_count_misstrokes') List<int>? strokeCountMisstrokes,
    int? grade,
    int? jlpt,
    int? frequency,
    required KanjidicCodepointsDto codepoints,
    required KanjidicRadicalsDto radicals,
    @JsonKey(name: 'dict_refs') KanjidicDictRefsDto? dictRefs,
    @JsonKey(name: 'query_codes') KanjidicQueryCodesDto? queryCodes,
    required KanjidicReadingsDto readings,
    List<String>? nanori,
    required Map<String, List<String>> meanings,
    List<KanjidicVariantDto>? variants,
    @JsonKey(name: 'radical_names') List<String>? radicalNames,
  }) = _RawKanjidicDto;

  const RawKanjidicDto._();

  factory RawKanjidicDto.fromJson(Map<String, Object?> json) =>
      _$RawKanjidicDtoFromJson(json);

  factory RawKanjidicDto.fromDomain(RawKanjidic entity) => RawKanjidicDto(
        importId: entity.importId,
        literal: entity.literal,
        strokeCount: entity.strokeCount,
        strokeCountMisstrokes: entity.strokeCountMisstrokes,
        grade: entity.grade,
        jlpt: entity.jlpt,
        frequency: entity.frequency,
        codepoints: KanjidicCodepointsDto.fromDomain(entity.codepoints),
        radicals: KanjidicRadicalsDto.fromDomain(entity.radicals),
        dictRefs: entity.dictRefs != null
            ? KanjidicDictRefsDto.fromDomain(entity.dictRefs!)
            : null,
        queryCodes: entity.queryCodes != null
            ? KanjidicQueryCodesDto.fromDomain(entity.queryCodes!)
            : null,
        readings: KanjidicReadingsDto.fromDomain(entity.readings),
        nanori: entity.nanori,
        meanings: entity.meanings,
        variants: entity.variants
            ?.map(KanjidicVariantDto.fromDomain)
            .toList(),
        radicalNames: entity.radicalNames,
      );

  RawKanjidic toDomain() => RawKanjidic(
        importId: importId,
        literal: this.literal,
        strokeCount: strokeCount,
        strokeCountMisstrokes: strokeCountMisstrokes,
        grade: grade,
        jlpt: jlpt,
        frequency: frequency,
        codepoints: codepoints.toDomain(),
        radicals: radicals.toDomain(),
        dictRefs: dictRefs?.toDomain(),
        queryCodes: queryCodes?.toDomain(),
        readings: readings.toDomain(),
        nanori: nanori,
        meanings: meanings,
        variants: variants?.map((v) => v.toDomain()).toList(),
        radicalNames: radicalNames,
      );
}

@freezed
abstract class KanjidicCodepointsDto with _$KanjidicCodepointsDto {
  const factory KanjidicCodepointsDto({
    required String ucs,
    String? jis208,
    String? jis212,
    String? jis213,
  }) = _KanjidicCodepointsDto;

  const KanjidicCodepointsDto._();

  factory KanjidicCodepointsDto.fromJson(Map<String, Object?> json) =>
      _$KanjidicCodepointsDtoFromJson(json);

  factory KanjidicCodepointsDto.fromDomain(KanjidicCodepoints entity) =>
      KanjidicCodepointsDto(
        ucs: entity.ucs,
        jis208: entity.jis208,
        jis212: entity.jis212,
        jis213: entity.jis213,
      );

  KanjidicCodepoints toDomain() => KanjidicCodepoints(
        ucs: ucs,
        jis208: jis208,
        jis212: jis212,
        jis213: jis213,
      );
}

@freezed
abstract class KanjidicRadicalsDto with _$KanjidicRadicalsDto {
  const factory KanjidicRadicalsDto({
    required int classical,
    @JsonKey(name: 'nelson_c') int? nelsonC,
  }) = _KanjidicRadicalsDto;

  const KanjidicRadicalsDto._();

  factory KanjidicRadicalsDto.fromJson(Map<String, Object?> json) =>
      _$KanjidicRadicalsDtoFromJson(json);

  factory KanjidicRadicalsDto.fromDomain(KanjidicRadicals entity) =>
      KanjidicRadicalsDto(
        classical: entity.classical,
        nelsonC: entity.nelsonC,
      );

  KanjidicRadicals toDomain() => KanjidicRadicals(
        classical: classical,
        nelsonC: nelsonC,
      );
}

@freezed
abstract class KanjidicDictRefsDto with _$KanjidicDictRefsDto {
  const factory KanjidicDictRefsDto({
    @JsonKey(name: 'nelson_c') String? nelsonC,
    @JsonKey(name: 'nelson_n') String? nelsonN,
    @JsonKey(name: 'halpern_njecd') String? halpernNjecd,
    @JsonKey(name: 'halpern_kkd') String? halpernKkd,
    @JsonKey(name: 'halpern_kkld') String? halpernKkld,
    @JsonKey(name: 'halpern_kkld_2ed') String? halpernKkld2ed,
    String? heisig,
    String? heisig6,
    String? gakken,
    @JsonKey(name: 'oneill_names') String? oneillNames,
    @JsonKey(name: 'oneill_kk') String? oneillKk,
    KanjidicMoroRefDto? moro,
    String? henshall,
    @JsonKey(name: 'sh_kk') String? shKk,
    @JsonKey(name: 'sh_kk2') String? shKk2,
    @JsonKey(name: 'jf_cards') String? jfCards,
    @JsonKey(name: 'tutt_cards') String? tuttCards,
    @JsonKey(name: 'kanji_in_context') String? kanjiInContext,
    @JsonKey(name: 'kodansha_compact') String? kodanshaCompact,
    String? skip,
    @JsonKey(name: 'busy_people') String? busyPeople,
  }) = _KanjidicDictRefsDto;

  const KanjidicDictRefsDto._();

  factory KanjidicDictRefsDto.fromJson(Map<String, Object?> json) =>
      _$KanjidicDictRefsDtoFromJson(json);

  factory KanjidicDictRefsDto.fromDomain(KanjidicDictRefs entity) =>
      KanjidicDictRefsDto(
        nelsonC: entity.nelsonC,
        nelsonN: entity.nelsonN,
        halpernNjecd: entity.halpernNjecd,
        halpernKkd: entity.halpernKkd,
        halpernKkld: entity.halpernKkld,
        halpernKkld2ed: entity.halpernKkld2ed,
        heisig: entity.heisig,
        heisig6: entity.heisig6,
        gakken: entity.gakken,
        oneillNames: entity.oneillNames,
        oneillKk: entity.oneillKk,
        moro: entity.moro != null
            ? KanjidicMoroRefDto.fromDomain(entity.moro!)
            : null,
        henshall: entity.henshall,
        shKk: entity.shKk,
        shKk2: entity.shKk2,
        jfCards: entity.jfCards,
        tuttCards: entity.tuttCards,
        kanjiInContext: entity.kanjiInContext,
        kodanshaCompact: entity.kodanshaCompact,
        skip: entity.skip,
        busyPeople: entity.busyPeople,
      );

  KanjidicDictRefs toDomain() => KanjidicDictRefs(
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
        moro: moro?.toDomain(),
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

@freezed
abstract class KanjidicMoroRefDto with _$KanjidicMoroRefDto {
  const factory KanjidicMoroRefDto({
    required String volume,
    required String page,
  }) = _KanjidicMoroRefDto;

  const KanjidicMoroRefDto._();

  factory KanjidicMoroRefDto.fromJson(Map<String, Object?> json) =>
      _$KanjidicMoroRefDtoFromJson(json);

  factory KanjidicMoroRefDto.fromDomain(KanjidicMoroRef entity) =>
      KanjidicMoroRefDto(
        volume: entity.volume,
        page: entity.page,
      );

  KanjidicMoroRef toDomain() => KanjidicMoroRef(
        volume: volume,
        page: page,
      );
}

@freezed
abstract class KanjidicQueryCodesDto with _$KanjidicQueryCodesDto {
  const factory KanjidicQueryCodesDto({
    String? skip,
    @JsonKey(name: 'four_corner') String? fourCorner,
    @JsonKey(name: 'sh_desc') String? shDesc,
    String? deroo,
    List<KanjidicMisclassDto>? misclass,
  }) = _KanjidicQueryCodesDto;

  const KanjidicQueryCodesDto._();

  factory KanjidicQueryCodesDto.fromJson(Map<String, Object?> json) =>
      _$KanjidicQueryCodesDtoFromJson(json);

  factory KanjidicQueryCodesDto.fromDomain(KanjidicQueryCodes entity) =>
      KanjidicQueryCodesDto(
        skip: entity.skip,
        fourCorner: entity.fourCorner,
        shDesc: entity.shDesc,
        deroo: entity.deroo,
        misclass: entity.misclass
            ?.map(KanjidicMisclassDto.fromDomain)
            .toList(),
      );

  KanjidicQueryCodes toDomain() => KanjidicQueryCodes(
        skip: skip,
        fourCorner: fourCorner,
        shDesc: shDesc,
        deroo: deroo,
        misclass: misclass?.map((m) => m.toDomain()).toList(),
      );
}

@freezed
abstract class KanjidicMisclassDto with _$KanjidicMisclassDto {
  const factory KanjidicMisclassDto({
    required String type,
    required String value,
  }) = _KanjidicMisclassDto;

  const KanjidicMisclassDto._();

  factory KanjidicMisclassDto.fromJson(Map<String, Object?> json) =>
      _$KanjidicMisclassDtoFromJson(json);

  factory KanjidicMisclassDto.fromDomain(KanjidicMisclass entity) =>
      KanjidicMisclassDto(
        type: entity.type,
        value: entity.value,
      );

  KanjidicMisclass toDomain() => KanjidicMisclass(
        type: type,
        value: value,
      );
}

@freezed
abstract class KanjidicVariantDto with _$KanjidicVariantDto {
  const factory KanjidicVariantDto({
    @JsonKey(name: 'var_type') required String varType,
    required String value,
  }) = _KanjidicVariantDto;

  const KanjidicVariantDto._();

  factory KanjidicVariantDto.fromJson(Map<String, Object?> json) =>
      _$KanjidicVariantDtoFromJson(json);

  factory KanjidicVariantDto.fromDomain(KanjidicVariant entity) =>
      KanjidicVariantDto(
        varType: entity.varType,
        value: entity.value,
      );

  KanjidicVariant toDomain() => KanjidicVariant(
        varType: varType,
        value: value,
      );
}

@freezed
abstract class KanjidicReadingsDto with _$KanjidicReadingsDto {
  const factory KanjidicReadingsDto({
    @JsonKey(name: 'ja_on') required List<String> jaOn,
    @JsonKey(name: 'ja_kun') required List<String> jaKun,
    List<String>? pinyin,
    @JsonKey(name: 'korean_r') List<String>? koreanR,
    @JsonKey(name: 'korean_h') List<String>? koreanH,
  }) = _KanjidicReadingsDto;

  const KanjidicReadingsDto._();

  factory KanjidicReadingsDto.fromJson(Map<String, Object?> json) =>
      _$KanjidicReadingsDtoFromJson(json);

  factory KanjidicReadingsDto.fromDomain(KanjidicReadings entity) =>
      KanjidicReadingsDto(
        jaOn: entity.jaOn,
        jaKun: entity.jaKun,
        pinyin: entity.pinyin,
        koreanR: entity.koreanR,
        koreanH: entity.koreanH,
      );

  KanjidicReadings toDomain() => KanjidicReadings(
        jaOn: jaOn,
        jaKun: jaKun,
        pinyin: pinyin,
        koreanR: koreanR,
        koreanH: koreanH,
      );
}
