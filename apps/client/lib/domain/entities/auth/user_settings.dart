import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kanji_craft_core/domain/entities/study_path.dart';

part 'user_settings.freezed.dart';

@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    required int id,
    required String userId,
    required StudyPath studyPath,
    required int currentLevel,
    required int dailyLessonLimit,
    required int dailyReviewLimit,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserSettings;
}
