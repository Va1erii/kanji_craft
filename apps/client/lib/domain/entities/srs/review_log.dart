import 'package:freezed_annotation/freezed_annotation.dart';

import 'card_state.dart';
import 'rating.dart';

part 'review_log.freezed.dart';

@freezed
abstract class ReviewLog with _$ReviewLog {
  const factory ReviewLog({
    required int id,
    required int cardId,
    required Rating rating,
    required CardState stateBefore,
    required double stabilityBefore,
    required double difficultyBefore,
    required DateTime reviewedAt,
    required DateTime createdAt,
  }) = _ReviewLog;
}
