import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_kanji.freezed.dart';

@freezed
abstract class DraftKanji with _$DraftKanji {
  const factory DraftKanji({
    required int id,
    required String character,
    required int strokeCount,
    required int frequencyRank,
    int? minJlptLevel,
    int? minGrade,
    String? svgFileName,
    String? svgFileUrl,
    String? svgHash,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DraftKanji;
}
