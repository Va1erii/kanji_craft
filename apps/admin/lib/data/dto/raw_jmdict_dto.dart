import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/raw_jmdict.dart';

part 'raw_jmdict_dto.freezed.dart';
part 'raw_jmdict_dto.g.dart';

@freezed
abstract class RawJmdictDto with _$RawJmdictDto {
  const factory RawJmdictDto({
    required int id,
    @JsonKey(name: 'import_id') required int importId,
    @JsonKey(name: 'ent_seq') required int entSeq,
    @JsonKey(name: 'kanji_elements')
    required List<JmdictKanjiElementDto> kanjiElements,
    @JsonKey(name: 'reading_elements')
    required List<JmdictReadingElementDto> readingElements,
    required List<JmdictSenseDto> senses,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _RawJmdictDto;

  const RawJmdictDto._();

  factory RawJmdictDto.fromJson(Map<String, Object?> json) =>
      _$RawJmdictDtoFromJson(json);

  factory RawJmdictDto.fromDomain(RawJmdict entity) => RawJmdictDto(
        id: entity.id,
        importId: entity.importId,
        entSeq: entity.entSeq,
        kanjiElements: entity.kanjiElements
            .map(JmdictKanjiElementDto.fromDomain)
            .toList(),
        readingElements: entity.readingElements
            .map(JmdictReadingElementDto.fromDomain)
            .toList(),
        senses: entity.senses.map(JmdictSenseDto.fromDomain).toList(),
        createdAt: entity.createdAt,
      );

  RawJmdict toDomain() => RawJmdict(
        id: id,
        importId: importId,
        entSeq: entSeq,
        kanjiElements: kanjiElements.map((e) => e.toDomain()).toList(),
        readingElements: readingElements.map((e) => e.toDomain()).toList(),
        senses: senses.map((e) => e.toDomain()).toList(),
        createdAt: createdAt,
      );
}

@freezed
abstract class JmdictKanjiElementDto with _$JmdictKanjiElementDto {
  const factory JmdictKanjiElementDto({
    required String keb,
    @JsonKey(name: 'ke_inf') List<String>? keInf,
    @JsonKey(name: 'ke_pri') List<String>? kePri,
  }) = _JmdictKanjiElementDto;

  const JmdictKanjiElementDto._();

  factory JmdictKanjiElementDto.fromJson(Map<String, Object?> json) =>
      _$JmdictKanjiElementDtoFromJson(json);

  factory JmdictKanjiElementDto.fromDomain(JmdictKanjiElement entity) =>
      JmdictKanjiElementDto(
        keb: entity.keb,
        keInf: entity.keInf,
        kePri: entity.kePri,
      );

  JmdictKanjiElement toDomain() => JmdictKanjiElement(
        keb: keb,
        keInf: keInf,
        kePri: kePri,
      );
}

@freezed
abstract class JmdictReadingElementDto with _$JmdictReadingElementDto {
  const factory JmdictReadingElementDto({
    required String reb,
    @JsonKey(name: 're_nokanji') @Default(false) bool reNokanji,
    @JsonKey(name: 're_restr') List<String>? reRestr,
    @JsonKey(name: 're_inf') List<String>? reInf,
    @JsonKey(name: 're_pri') List<String>? rePri,
  }) = _JmdictReadingElementDto;

  const JmdictReadingElementDto._();

  factory JmdictReadingElementDto.fromJson(Map<String, Object?> json) =>
      _$JmdictReadingElementDtoFromJson(json);

  factory JmdictReadingElementDto.fromDomain(JmdictReadingElement entity) =>
      JmdictReadingElementDto(
        reb: entity.reb,
        reNokanji: entity.reNokanji,
        reRestr: entity.reRestr,
        reInf: entity.reInf,
        rePri: entity.rePri,
      );

  JmdictReadingElement toDomain() => JmdictReadingElement(
        reb: reb,
        reNokanji: reNokanji,
        reRestr: reRestr,
        reInf: reInf,
        rePri: rePri,
      );
}

@freezed
abstract class JmdictSenseDto with _$JmdictSenseDto {
  const factory JmdictSenseDto({
    List<String>? stagk,
    List<String>? stagr,
    List<String>? pos,
    List<String>? xref,
    List<String>? ant,
    List<String>? field,
    List<String>? misc,
    @JsonKey(name: 's_inf') List<String>? sInf,
    List<JmdictLsourceDto>? lsource,
    List<String>? dial,
    required Map<String, List<String>> glosses,
  }) = _JmdictSenseDto;

  const JmdictSenseDto._();

  factory JmdictSenseDto.fromJson(Map<String, Object?> json) =>
      _$JmdictSenseDtoFromJson(json);

  factory JmdictSenseDto.fromDomain(JmdictSense entity) => JmdictSenseDto(
        stagk: entity.stagk,
        stagr: entity.stagr,
        pos: entity.pos,
        xref: entity.xref,
        ant: entity.ant,
        field: entity.field,
        misc: entity.misc,
        sInf: entity.sInf,
        lsource: entity.lsource
            ?.map(JmdictLsourceDto.fromDomain)
            .toList(),
        dial: entity.dial,
        glosses: entity.glosses,
      );

  JmdictSense toDomain() => JmdictSense(
        stagk: stagk,
        stagr: stagr,
        pos: pos,
        xref: xref,
        ant: ant,
        field: field,
        misc: misc,
        sInf: sInf,
        lsource: lsource?.map((e) => e.toDomain()).toList(),
        dial: dial,
        glosses: glosses,
      );
}

@freezed
abstract class JmdictLsourceDto with _$JmdictLsourceDto {
  const factory JmdictLsourceDto({
    required String lang,
    String? value,
    @JsonKey(name: 'ls_type') String? lsType,
    @JsonKey(name: 'ls_wasei') @Default(false) bool lsWasei,
  }) = _JmdictLsourceDto;

  const JmdictLsourceDto._();

  factory JmdictLsourceDto.fromJson(Map<String, Object?> json) =>
      _$JmdictLsourceDtoFromJson(json);

  factory JmdictLsourceDto.fromDomain(JmdictLsource entity) =>
      JmdictLsourceDto(
        lang: entity.lang,
        value: entity.value,
        lsType: entity.lsType,
        lsWasei: entity.lsWasei,
      );

  JmdictLsource toDomain() => JmdictLsource(
        lang: lang,
        value: value,
        lsType: lsType,
        lsWasei: lsWasei,
      );
}
