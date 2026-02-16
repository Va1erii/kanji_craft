import 'package:freezed_annotation/freezed_annotation.dart';

import 'position.dart';

part 'radical.freezed.dart';

@freezed
abstract class Radical with _$Radical {
  const factory Radical({
    required int id,
    required String masterSymbol,
    String? familySymbol,
    required List<Position> positions,
    required int strokeCount,
    required int impactScore,
    required int minJlptLevel,
    required int minGrade,
    required String svgFileName,
    required String svgFileUrl,
    required String svgHash,
    required bool isOfficial,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Radical;
}
