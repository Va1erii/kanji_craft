import 'package:freezed_annotation/freezed_annotation.dart';

part 'radical_i18n.freezed.dart';

@freezed
abstract class RadicalI18n with _$RadicalI18n {
  const factory RadicalI18n({
    required int id,
    required int radicalId,
    required String langCode,
    required String name,
    required String systemMnemonic,
    required List<String> searchTags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RadicalI18n;
}
