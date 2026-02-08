import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kanji_craft_core/domain/entities/verification_status.dart';

part 'kanji_component_review.freezed.dart';

@freezed
abstract class KanjiComponentReview with _$KanjiComponentReview {
  const factory KanjiComponentReview({
    required int id,
    required int kanjiComponentId,
    required VerificationStatus verificationStatus,
    double? aiConfidence,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KanjiComponentReview;
}
