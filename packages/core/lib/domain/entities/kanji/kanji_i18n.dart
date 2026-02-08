import 'package:freezed_annotation/freezed_annotation.dart';

part 'kanji_i18n.freezed.dart';

@freezed
abstract class KanjiI18n with _$KanjiI18n {
  const factory KanjiI18n({
    required int id,
    required int kanjiId,
    required String langCode,
    required List<String> meanings,
    required String systemMnemonic,
    required List<String> searchTags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KanjiI18n;
}
