// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Vocabulary {

 int get id; String get word; int? get minJlptLevel; int get frequencyRank; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Vocabulary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyCopyWith<Vocabulary> get copyWith => _$VocabularyCopyWithImpl<Vocabulary>(this as Vocabulary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vocabulary&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.frequencyRank, frequencyRank) || other.frequencyRank == frequencyRank)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,word,minJlptLevel,frequencyRank,createdAt,updatedAt);

@override
String toString() {
  return 'Vocabulary(id: $id, word: $word, minJlptLevel: $minJlptLevel, frequencyRank: $frequencyRank, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VocabularyCopyWith<$Res>  {
  factory $VocabularyCopyWith(Vocabulary value, $Res Function(Vocabulary) _then) = _$VocabularyCopyWithImpl;
@useResult
$Res call({
 int id, String word, int? minJlptLevel, int frequencyRank, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$VocabularyCopyWithImpl<$Res>
    implements $VocabularyCopyWith<$Res> {
  _$VocabularyCopyWithImpl(this._self, this._then);

  final Vocabulary _self;
  final $Res Function(Vocabulary) _then;

/// Create a copy of Vocabulary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? word = null,Object? minJlptLevel = freezed,Object? frequencyRank = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,frequencyRank: null == frequencyRank ? _self.frequencyRank : frequencyRank // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Vocabulary].
extension VocabularyPatterns on Vocabulary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vocabulary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vocabulary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vocabulary value)  $default,){
final _that = this;
switch (_that) {
case _Vocabulary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vocabulary value)?  $default,){
final _that = this;
switch (_that) {
case _Vocabulary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String word,  int? minJlptLevel,  int frequencyRank,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vocabulary() when $default != null:
return $default(_that.id,_that.word,_that.minJlptLevel,_that.frequencyRank,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String word,  int? minJlptLevel,  int frequencyRank,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Vocabulary():
return $default(_that.id,_that.word,_that.minJlptLevel,_that.frequencyRank,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String word,  int? minJlptLevel,  int frequencyRank,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Vocabulary() when $default != null:
return $default(_that.id,_that.word,_that.minJlptLevel,_that.frequencyRank,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Vocabulary implements Vocabulary {
  const _Vocabulary({required this.id, required this.word, this.minJlptLevel, required this.frequencyRank, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  String word;
@override final  int? minJlptLevel;
@override final  int frequencyRank;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Vocabulary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyCopyWith<_Vocabulary> get copyWith => __$VocabularyCopyWithImpl<_Vocabulary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vocabulary&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.frequencyRank, frequencyRank) || other.frequencyRank == frequencyRank)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,word,minJlptLevel,frequencyRank,createdAt,updatedAt);

@override
String toString() {
  return 'Vocabulary(id: $id, word: $word, minJlptLevel: $minJlptLevel, frequencyRank: $frequencyRank, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VocabularyCopyWith<$Res> implements $VocabularyCopyWith<$Res> {
  factory _$VocabularyCopyWith(_Vocabulary value, $Res Function(_Vocabulary) _then) = __$VocabularyCopyWithImpl;
@override @useResult
$Res call({
 int id, String word, int? minJlptLevel, int frequencyRank, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$VocabularyCopyWithImpl<$Res>
    implements _$VocabularyCopyWith<$Res> {
  __$VocabularyCopyWithImpl(this._self, this._then);

  final _Vocabulary _self;
  final $Res Function(_Vocabulary) _then;

/// Create a copy of Vocabulary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? word = null,Object? minJlptLevel = freezed,Object? frequencyRank = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Vocabulary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,frequencyRank: null == frequencyRank ? _self.frequencyRank : frequencyRank // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
