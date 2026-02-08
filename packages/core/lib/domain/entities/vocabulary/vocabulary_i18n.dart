import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_i18n.freezed.dart';

@freezed
abstract class VocabularyI18n with _$VocabularyI18n {
  const factory VocabularyI18n({
    required int id,
    required int vocabularyId,
    required String langCode,
    required List<String> meanings,
    String? systemMnemonic,
    required List<String> searchTags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VocabularyI18n;
}
