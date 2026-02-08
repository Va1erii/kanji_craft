import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/kanji_component_review.dart';
import 'package:kanji_craft/shared/domain/entities/verification_status.dart';

part 'kanji_component_review_dto.freezed.dart';
part 'kanji_component_review_dto.g.dart';

@freezed
abstract class KanjiComponentReviewDto with _$KanjiComponentReviewDto {
  const factory KanjiComponentReviewDto({
    required int id,
    @JsonKey(name: 'kanji_component_id') required int kanjiComponentId,
    @JsonKey(name: 'verification_status')
    required VerificationStatus verificationStatus,
    @JsonKey(name: 'ai_confidence') double? aiConfidence,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _KanjiComponentReviewDto;

  const KanjiComponentReviewDto._();

  factory KanjiComponentReviewDto.fromJson(Map<String, Object?> json) =>
      _$KanjiComponentReviewDtoFromJson(json);

  factory KanjiComponentReviewDto.fromDomain(KanjiComponentReview entity) =>
      KanjiComponentReviewDto(
        id: entity.id,
        kanjiComponentId: entity.kanjiComponentId,
        verificationStatus: entity.verificationStatus,
        aiConfidence: entity.aiConfidence,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  KanjiComponentReview toDomain() => KanjiComponentReview(
        id: id,
        kanjiComponentId: kanjiComponentId,
        verificationStatus: verificationStatus,
        aiConfidence: aiConfidence,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
