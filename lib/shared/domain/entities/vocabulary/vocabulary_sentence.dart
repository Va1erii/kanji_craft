import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_sentence.freezed.dart';

@freezed
abstract class VocabularySentence with _$VocabularySentence {
  const factory VocabularySentence({
    required int id,
    required int vocabularyId,
    required String langCode,
    required String sentenceJa,
    required String sentenceFurigana,
    required String sentenceTranslated,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VocabularySentence;
}
