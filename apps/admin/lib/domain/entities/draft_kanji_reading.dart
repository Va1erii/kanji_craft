import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

part 'draft_kanji_reading.freezed.dart';

@freezed
abstract class DraftKanjiReading with _$DraftKanjiReading {
  const factory DraftKanjiReading({
    required int id,
    required int draftKanjiId,
    required String reading,
    required ReadingType readingType,
    required ReadingPriority priority,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DraftKanjiReading;
}
