// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_mnemonic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserMnemonic {

 int get id; String get userId; ItemType get itemType; int get itemId; String get text; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserMnemonic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserMnemonicCopyWith<UserMnemonic> get copyWith => _$UserMnemonicCopyWithImpl<UserMnemonic>(this as UserMnemonic, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserMnemonic&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,itemType,itemId,text,createdAt,updatedAt);

@override
String toString() {
  return 'UserMnemonic(id: $id, userId: $userId, itemType: $itemType, itemId: $itemId, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserMnemonicCopyWith<$Res>  {
  factory $UserMnemonicCopyWith(UserMnemonic value, $Res Function(UserMnemonic) _then) = _$UserMnemonicCopyWithImpl;
@useResult
$Res call({
 int id, String userId, ItemType itemType, int itemId, String text, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserMnemonicCopyWithImpl<$Res>
    implements $UserMnemonicCopyWith<$Res> {
  _$UserMnemonicCopyWithImpl(this._self, this._then);

  final UserMnemonic _self;
  final $Res Function(UserMnemonic) _then;

/// Create a copy of UserMnemonic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? itemType = null,Object? itemId = null,Object? text = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as ItemType,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserMnemonic].
extension UserMnemonicPatterns on UserMnemonic {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserMnemonic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserMnemonic() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserMnemonic value)  $default,){
final _that = this;
switch (_that) {
case _UserMnemonic():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserMnemonic value)?  $default,){
final _that = this;
switch (_that) {
case _UserMnemonic() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String userId,  ItemType itemType,  int itemId,  String text,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserMnemonic() when $default != null:
return $default(_that.id,_that.userId,_that.itemType,_that.itemId,_that.text,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String userId,  ItemType itemType,  int itemId,  String text,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserMnemonic():
return $default(_that.id,_that.userId,_that.itemType,_that.itemId,_that.text,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String userId,  ItemType itemType,  int itemId,  String text,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserMnemonic() when $default != null:
return $default(_that.id,_that.userId,_that.itemType,_that.itemId,_that.text,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserMnemonic implements UserMnemonic {
  const _UserMnemonic({required this.id, required this.userId, required this.itemType, required this.itemId, required this.text, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  String userId;
@override final  ItemType itemType;
@override final  int itemId;
@override final  String text;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserMnemonic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserMnemonicCopyWith<_UserMnemonic> get copyWith => __$UserMnemonicCopyWithImpl<_UserMnemonic>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserMnemonic&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,itemType,itemId,text,createdAt,updatedAt);

@override
String toString() {
  return 'UserMnemonic(id: $id, userId: $userId, itemType: $itemType, itemId: $itemId, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserMnemonicCopyWith<$Res> implements $UserMnemonicCopyWith<$Res> {
  factory _$UserMnemonicCopyWith(_UserMnemonic value, $Res Function(_UserMnemonic) _then) = __$UserMnemonicCopyWithImpl;
@override @useResult
$Res call({
 int id, String userId, ItemType itemType, int itemId, String text, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserMnemonicCopyWithImpl<$Res>
    implements _$UserMnemonicCopyWith<$Res> {
  __$UserMnemonicCopyWithImpl(this._self, this._then);

  final _UserMnemonic _self;
  final $Res Function(_UserMnemonic) _then;

/// Create a copy of UserMnemonic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? itemType = null,Object? itemId = null,Object? text = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserMnemonic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as ItemType,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
