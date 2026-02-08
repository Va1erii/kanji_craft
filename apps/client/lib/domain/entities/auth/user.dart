import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_provider.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required AuthProvider authProvider,
    required String authProviderId,
    String? email,
    String? displayName,
    required String langCode,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;
}
