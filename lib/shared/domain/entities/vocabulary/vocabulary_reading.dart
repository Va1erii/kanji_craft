import 'package:freezed_annotation/freezed_annotation.dart';

import '../reading_priority.dart';

part 'vocabulary_reading.freezed.dart';

@freezed
abstract class VocabularyReading with _$VocabularyReading {
  const factory VocabularyReading({
    required int id,
    required int vocabularyId,
    required String reading,
    required ReadingPriority priority,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VocabularyReading;
}
