// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanji_component_review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KanjiComponentReviewDto _$KanjiComponentReviewDtoFromJson(
  Map<String, dynamic> json,
) => _KanjiComponentReviewDto(
  id: (json['id'] as num).toInt(),
  kanjiComponentId: (json['kanji_component_id'] as num).toInt(),
  verificationStatus: $enumDecode(
    _$VerificationStatusEnumMap,
    json['verification_status'],
  ),
  aiConfidence: (json['ai_confidence'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$KanjiComponentReviewDtoToJson(
  _KanjiComponentReviewDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'kanji_component_id': instance.kanjiComponentId,
  'verification_status':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'ai_confidence': instance.aiConfidence,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.draft: 'draft',
  VerificationStatus.verified: 'verified',
  VerificationStatus.flagged: 'flagged',
};
