import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_sentence_i18n.freezed.dart';

@freezed
abstract class VocabularySentenceI18n with _$VocabularySentenceI18n {
  const factory VocabularySentenceI18n({
    required int id,
    required int vocabularySentenceId,
    required String langCode,
    required String sentenceTranslated,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VocabularySentenceI18n;
}
