import 'package:freezed_annotation/freezed_annotation.dart';

import '../verification_status.dart';

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
    required VerificationStatus verificationStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VocabularySentence;
}
