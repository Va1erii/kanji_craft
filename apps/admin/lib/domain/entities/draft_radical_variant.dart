import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

part 'draft_radical_variant.freezed.dart';

@freezed
abstract class DraftRadicalVariant with _$DraftRadicalVariant {
  const factory DraftRadicalVariant({
    required int id,
    required int draftRadicalId,
    required String shape,
    required Position position,
    required bool isLocked,
    String? svgFileName,
    String? svgFileUrl,
    String? svgHash,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DraftRadicalVariant;
}
