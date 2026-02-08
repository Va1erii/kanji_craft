import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kanji_craft_core/domain/entities/item_type.dart';

part 'user_mnemonic.freezed.dart';

@freezed
abstract class UserMnemonic with _$UserMnemonic {
  const factory UserMnemonic({
    required int id,
    required String userId,
    required ItemType itemType,
    required int itemId,
    required String text,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserMnemonic;
}
