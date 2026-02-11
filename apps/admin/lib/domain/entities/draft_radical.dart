import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_radical.freezed.dart';

@freezed
abstract class DraftRadical with _$DraftRadical {
  const factory DraftRadical({
    required int id,
    required String masterSymbol,
    int? strokeCount,
    int? impactScore,
    int? minJlptLevel,
    int? minGrade,
    String? svgFileName,
    String? svgFileUrl,
    String? svgHash,
    required bool isOfficial,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DraftRadical;
}
