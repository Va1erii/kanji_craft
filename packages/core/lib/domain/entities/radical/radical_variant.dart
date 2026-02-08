import 'package:freezed_annotation/freezed_annotation.dart';

import 'position.dart';

part 'radical_variant.freezed.dart';

@freezed
abstract class RadicalVariant with _$RadicalVariant {
  const factory RadicalVariant({
    required int id,
    required int radicalId,
    required String shape,
    required Position position,
    required bool isLocked,
    required String svgFileName,
    required String svgFileUrl,
    required String svgHash,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RadicalVariant;
}
