import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_radical_i18n.freezed.dart';

@freezed
abstract class DraftRadicalI18n with _$DraftRadicalI18n {
  const factory DraftRadicalI18n({
    required int id,
    required int draftRadicalId,
    required String langCode,
    required String name,
    required String systemMnemonic,
    required List<String> searchTags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DraftRadicalI18n;
}
