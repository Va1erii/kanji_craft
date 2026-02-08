import 'package:freezed_annotation/freezed_annotation.dart';

part 'kanji.freezed.dart';

@freezed
abstract class Kanji with _$Kanji {
  const factory Kanji({
    required int id,
    required String character,
    required int strokeCount,
    int? minJlptLevel,
    int? minGrade,
    required int frequencyRank,
    required String svgFileName,
    required String svgFileUrl,
    required String svgHash,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Kanji;
}
