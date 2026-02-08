import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_kanji.freezed.dart';

@freezed
abstract class VocabularyKanji with _$VocabularyKanji {
  const factory VocabularyKanji({
    required int id,
    required int vocabularyId,
    required int kanjiId,
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VocabularyKanji;
}
