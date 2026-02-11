import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_kanji_i18n.freezed.dart';

@freezed
abstract class DraftKanjiI18n with _$DraftKanjiI18n {
  const factory DraftKanjiI18n({
    required int id,
    required int draftKanjiId,
    required String langCode,
    required List<String> meanings,
    required String systemMnemonic,
    required List<String> searchTags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DraftKanjiI18n;
}
