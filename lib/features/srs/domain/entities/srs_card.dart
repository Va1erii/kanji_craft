import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kanji_craft/shared/domain/entities/item_type.dart';

import 'card_state.dart';

part 'srs_card.freezed.dart';

@freezed
abstract class SrsCard with _$SrsCard {
  const factory SrsCard({
    required int id,
    required String userId,
    required ItemType itemType,
    required int itemId,
    required CardState state,
    required DateTime due,
    required double stability,
    required double difficulty,
    required int elapsedDays,
    required int scheduledDays,
    required int reps,
    required int lapses,
    DateTime? lastReview,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SrsCard;
}
