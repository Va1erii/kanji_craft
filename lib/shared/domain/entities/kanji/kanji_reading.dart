import 'package:freezed_annotation/freezed_annotation.dart';

import '../reading_priority.dart';
import 'reading_type.dart';

part 'kanji_reading.freezed.dart';

@freezed
abstract class KanjiReading with _$KanjiReading {
  const factory KanjiReading({
    required int id,
    required int kanjiId,
    required String reading,
    required ReadingType readingType,
    required ReadingPriority priority,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KanjiReading;
}
