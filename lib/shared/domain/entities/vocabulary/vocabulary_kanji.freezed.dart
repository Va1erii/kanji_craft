// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_kanji.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabularyKanji {

 int get id; int get vocabularyId; int get kanjiId; int get position; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of VocabularyKanji
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyKanjiCopyWith<VocabularyKanji> get copyWith => _$VocabularyKanjiCopyWithImpl<VocabularyKanji>(this as VocabularyKanji, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyKanji&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularyId, vocabularyId) || other.vocabularyId == vocabularyId)&&(identical(other.kanjiId, kanjiId) || other.kanjiId == kanjiId)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vocabularyId,kanjiId,position,createdAt,updatedAt);

@override
String toString() {
  return 'VocabularyKanji(id: $id, vocabularyId: $vocabularyId, kanjiId: $kanjiId, position: $position, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VocabularyKanjiCopyWith<$Res>  {
  factory $VocabularyKanjiCopyWith(VocabularyKanji value, $Res Function(VocabularyKanji) _then) = _$VocabularyKanjiCopyWithImpl;
@useResult
$Res call({
 int id, int vocabularyId, int kanjiId, int position, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$VocabularyKanjiCopyWithImpl<$Res>
    implements $VocabularyKanjiCopyWith<$Res> {
  _$VocabularyKanjiCopyWithImpl(this._self, this._then);

  final VocabularyKanji _self;
  final $Res Function(VocabularyKanji) _then;

/// Create a copy of VocabularyKanji
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vocabularyId = null,Object? kanjiId = null,Object? position = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vocabularyId: null == vocabularyId ? _self.vocabularyId : vocabularyId // ignore: cast_nullable_to_non_nullable
as int,kanjiId: null == kanjiId ? _self.kanjiId : kanjiId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularyKanji].
extension VocabularyKanjiPatterns on VocabularyKanji {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularyKanji value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularyKanji() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularyKanji value)  $default,){
final _that = this;
switch (_that) {
case _VocabularyKanji():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularyKanji value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularyKanji() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vocabularyId,  int kanjiId,  int position,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularyKanji() when $default != null:
return $default(_that.id,_that.vocabularyId,_that.kanjiId,_that.position,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vocabularyId,  int kanjiId,  int position,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _VocabularyKanji():
return $default(_that.id,_that.vocabularyId,_that.kanjiId,_that.position,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vocabularyId,  int kanjiId,  int position,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _VocabularyKanji() when $default != null:
return $default(_that.id,_that.vocabularyId,_that.kanjiId,_that.position,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _VocabularyKanji implements VocabularyKanji {
  const _VocabularyKanji({required this.id, required this.vocabularyId, required this.kanjiId, required this.position, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int vocabularyId;
@override final  int kanjiId;
@override final  int position;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of VocabularyKanji
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyKanjiCopyWith<_VocabularyKanji> get copyWith => __$VocabularyKanjiCopyWithImpl<_VocabularyKanji>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyKanji&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularyId, vocabularyId) || other.vocabularyId == vocabularyId)&&(identical(other.kanjiId, kanjiId) || other.kanjiId == kanjiId)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vocabularyId,kanjiId,position,createdAt,updatedAt);

@override
String toString() {
  return 'VocabularyKanji(id: $id, vocabularyId: $vocabularyId, kanjiId: $kanjiId, position: $position, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VocabularyKanjiCopyWith<$Res> implements $VocabularyKanjiCopyWith<$Res> {
  factory _$VocabularyKanjiCopyWith(_VocabularyKanji value, $Res Function(_VocabularyKanji) _then) = __$VocabularyKanjiCopyWithImpl;
@override @useResult
$Res call({
 int id, int vocabularyId, int kanjiId, int position, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$VocabularyKanjiCopyWithImpl<$Res>
    implements _$VocabularyKanjiCopyWith<$Res> {
  __$VocabularyKanjiCopyWithImpl(this._self, this._then);

  final _VocabularyKanji _self;
  final $Res Function(_VocabularyKanji) _then;

/// Create a copy of VocabularyKanji
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vocabularyId = null,Object? kanjiId = null,Object? position = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_VocabularyKanji(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vocabularyId: null == vocabularyId ? _self.vocabularyId : vocabularyId // ignore: cast_nullable_to_non_nullable
as int,kanjiId: null == kanjiId ? _self.kanjiId : kanjiId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
