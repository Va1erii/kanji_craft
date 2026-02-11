// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_sentence_i18n.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabularySentenceI18n {

 int get id; int get vocabularySentenceId; String get langCode; String get sentenceTranslated; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of VocabularySentenceI18n
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularySentenceI18nCopyWith<VocabularySentenceI18n> get copyWith => _$VocabularySentenceI18nCopyWithImpl<VocabularySentenceI18n>(this as VocabularySentenceI18n, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularySentenceI18n&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularySentenceId, vocabularySentenceId) || other.vocabularySentenceId == vocabularySentenceId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&(identical(other.sentenceTranslated, sentenceTranslated) || other.sentenceTranslated == sentenceTranslated)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vocabularySentenceId,langCode,sentenceTranslated,createdAt,updatedAt);

@override
String toString() {
  return 'VocabularySentenceI18n(id: $id, vocabularySentenceId: $vocabularySentenceId, langCode: $langCode, sentenceTranslated: $sentenceTranslated, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VocabularySentenceI18nCopyWith<$Res>  {
  factory $VocabularySentenceI18nCopyWith(VocabularySentenceI18n value, $Res Function(VocabularySentenceI18n) _then) = _$VocabularySentenceI18nCopyWithImpl;
@useResult
$Res call({
 int id, int vocabularySentenceId, String langCode, String sentenceTranslated, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$VocabularySentenceI18nCopyWithImpl<$Res>
    implements $VocabularySentenceI18nCopyWith<$Res> {
  _$VocabularySentenceI18nCopyWithImpl(this._self, this._then);

  final VocabularySentenceI18n _self;
  final $Res Function(VocabularySentenceI18n) _then;

/// Create a copy of VocabularySentenceI18n
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vocabularySentenceId = null,Object? langCode = null,Object? sentenceTranslated = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vocabularySentenceId: null == vocabularySentenceId ? _self.vocabularySentenceId : vocabularySentenceId // ignore: cast_nullable_to_non_nullable
as int,langCode: null == langCode ? _self.langCode : langCode // ignore: cast_nullable_to_non_nullable
as String,sentenceTranslated: null == sentenceTranslated ? _self.sentenceTranslated : sentenceTranslated // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularySentenceI18n].
extension VocabularySentenceI18nPatterns on VocabularySentenceI18n {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularySentenceI18n value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularySentenceI18n() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularySentenceI18n value)  $default,){
final _that = this;
switch (_that) {
case _VocabularySentenceI18n():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularySentenceI18n value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularySentenceI18n() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vocabularySentenceId,  String langCode,  String sentenceTranslated,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularySentenceI18n() when $default != null:
return $default(_that.id,_that.vocabularySentenceId,_that.langCode,_that.sentenceTranslated,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vocabularySentenceId,  String langCode,  String sentenceTranslated,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _VocabularySentenceI18n():
return $default(_that.id,_that.vocabularySentenceId,_that.langCode,_that.sentenceTranslated,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vocabularySentenceId,  String langCode,  String sentenceTranslated,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _VocabularySentenceI18n() when $default != null:
return $default(_that.id,_that.vocabularySentenceId,_that.langCode,_that.sentenceTranslated,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _VocabularySentenceI18n implements VocabularySentenceI18n {
  const _VocabularySentenceI18n({required this.id, required this.vocabularySentenceId, required this.langCode, required this.sentenceTranslated, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int vocabularySentenceId;
@override final  String langCode;
@override final  String sentenceTranslated;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of VocabularySentenceI18n
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularySentenceI18nCopyWith<_VocabularySentenceI18n> get copyWith => __$VocabularySentenceI18nCopyWithImpl<_VocabularySentenceI18n>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularySentenceI18n&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularySentenceId, vocabularySentenceId) || other.vocabularySentenceId == vocabularySentenceId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&(identical(other.sentenceTranslated, sentenceTranslated) || other.sentenceTranslated == sentenceTranslated)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vocabularySentenceId,langCode,sentenceTranslated,createdAt,updatedAt);

@override
String toString() {
  return 'VocabularySentenceI18n(id: $id, vocabularySentenceId: $vocabularySentenceId, langCode: $langCode, sentenceTranslated: $sentenceTranslated, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VocabularySentenceI18nCopyWith<$Res> implements $VocabularySentenceI18nCopyWith<$Res> {
  factory _$VocabularySentenceI18nCopyWith(_VocabularySentenceI18n value, $Res Function(_VocabularySentenceI18n) _then) = __$VocabularySentenceI18nCopyWithImpl;
@override @useResult
$Res call({
 int id, int vocabularySentenceId, String langCode, String sentenceTranslated, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$VocabularySentenceI18nCopyWithImpl<$Res>
    implements _$VocabularySentenceI18nCopyWith<$Res> {
  __$VocabularySentenceI18nCopyWithImpl(this._self, this._then);

  final _VocabularySentenceI18n _self;
  final $Res Function(_VocabularySentenceI18n) _then;

/// Create a copy of VocabularySentenceI18n
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vocabularySentenceId = null,Object? langCode = null,Object? sentenceTranslated = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_VocabularySentenceI18n(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vocabularySentenceId: null == vocabularySentenceId ? _self.vocabularySentenceId : vocabularySentenceId // ignore: cast_nullable_to_non_nullable
as int,langCode: null == langCode ? _self.langCode : langCode // ignore: cast_nullable_to_non_nullable
as String,sentenceTranslated: null == sentenceTranslated ? _self.sentenceTranslated : sentenceTranslated // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
