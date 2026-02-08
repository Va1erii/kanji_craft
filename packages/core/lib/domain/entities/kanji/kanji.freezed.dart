// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanji.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Kanji {

 int get id; String get character; int get strokeCount; int? get minJlptLevel; int? get minGrade; int get frequencyRank; String get svgFileName; String get svgFileUrl; String get svgHash; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Kanji
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiCopyWith<Kanji> get copyWith => _$KanjiCopyWithImpl<Kanji>(this as Kanji, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Kanji&&(identical(other.id, id) || other.id == id)&&(identical(other.character, character) || other.character == character)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.frequencyRank, frequencyRank) || other.frequencyRank == frequencyRank)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,character,strokeCount,minJlptLevel,minGrade,frequencyRank,svgFileName,svgFileUrl,svgHash,createdAt,updatedAt);

@override
String toString() {
  return 'Kanji(id: $id, character: $character, strokeCount: $strokeCount, minJlptLevel: $minJlptLevel, minGrade: $minGrade, frequencyRank: $frequencyRank, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $KanjiCopyWith<$Res>  {
  factory $KanjiCopyWith(Kanji value, $Res Function(Kanji) _then) = _$KanjiCopyWithImpl;
@useResult
$Res call({
 int id, String character, int strokeCount, int? minJlptLevel, int? minGrade, int frequencyRank, String svgFileName, String svgFileUrl, String svgHash, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$KanjiCopyWithImpl<$Res>
    implements $KanjiCopyWith<$Res> {
  _$KanjiCopyWithImpl(this._self, this._then);

  final Kanji _self;
  final $Res Function(Kanji) _then;

/// Create a copy of Kanji
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? character = null,Object? strokeCount = null,Object? minJlptLevel = freezed,Object? minGrade = freezed,Object? frequencyRank = null,Object? svgFileName = null,Object? svgFileUrl = null,Object? svgHash = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,minGrade: freezed == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as int?,frequencyRank: null == frequencyRank ? _self.frequencyRank : frequencyRank // ignore: cast_nullable_to_non_nullable
as int,svgFileName: null == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String,svgFileUrl: null == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String,svgHash: null == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Kanji].
extension KanjiPatterns on Kanji {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Kanji value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Kanji() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Kanji value)  $default,){
final _that = this;
switch (_that) {
case _Kanji():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Kanji value)?  $default,){
final _that = this;
switch (_that) {
case _Kanji() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String character,  int strokeCount,  int? minJlptLevel,  int? minGrade,  int frequencyRank,  String svgFileName,  String svgFileUrl,  String svgHash,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Kanji() when $default != null:
return $default(_that.id,_that.character,_that.strokeCount,_that.minJlptLevel,_that.minGrade,_that.frequencyRank,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String character,  int strokeCount,  int? minJlptLevel,  int? minGrade,  int frequencyRank,  String svgFileName,  String svgFileUrl,  String svgHash,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Kanji():
return $default(_that.id,_that.character,_that.strokeCount,_that.minJlptLevel,_that.minGrade,_that.frequencyRank,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String character,  int strokeCount,  int? minJlptLevel,  int? minGrade,  int frequencyRank,  String svgFileName,  String svgFileUrl,  String svgHash,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Kanji() when $default != null:
return $default(_that.id,_that.character,_that.strokeCount,_that.minJlptLevel,_that.minGrade,_that.frequencyRank,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Kanji implements Kanji {
  const _Kanji({required this.id, required this.character, required this.strokeCount, this.minJlptLevel, this.minGrade, required this.frequencyRank, required this.svgFileName, required this.svgFileUrl, required this.svgHash, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  String character;
@override final  int strokeCount;
@override final  int? minJlptLevel;
@override final  int? minGrade;
@override final  int frequencyRank;
@override final  String svgFileName;
@override final  String svgFileUrl;
@override final  String svgHash;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Kanji
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiCopyWith<_Kanji> get copyWith => __$KanjiCopyWithImpl<_Kanji>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Kanji&&(identical(other.id, id) || other.id == id)&&(identical(other.character, character) || other.character == character)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.frequencyRank, frequencyRank) || other.frequencyRank == frequencyRank)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,character,strokeCount,minJlptLevel,minGrade,frequencyRank,svgFileName,svgFileUrl,svgHash,createdAt,updatedAt);

@override
String toString() {
  return 'Kanji(id: $id, character: $character, strokeCount: $strokeCount, minJlptLevel: $minJlptLevel, minGrade: $minGrade, frequencyRank: $frequencyRank, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$KanjiCopyWith<$Res> implements $KanjiCopyWith<$Res> {
  factory _$KanjiCopyWith(_Kanji value, $Res Function(_Kanji) _then) = __$KanjiCopyWithImpl;
@override @useResult
$Res call({
 int id, String character, int strokeCount, int? minJlptLevel, int? minGrade, int frequencyRank, String svgFileName, String svgFileUrl, String svgHash, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$KanjiCopyWithImpl<$Res>
    implements _$KanjiCopyWith<$Res> {
  __$KanjiCopyWithImpl(this._self, this._then);

  final _Kanji _self;
  final $Res Function(_Kanji) _then;

/// Create a copy of Kanji
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? character = null,Object? strokeCount = null,Object? minJlptLevel = freezed,Object? minGrade = freezed,Object? frequencyRank = null,Object? svgFileName = null,Object? svgFileUrl = null,Object? svgHash = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Kanji(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,minGrade: freezed == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as int?,frequencyRank: null == frequencyRank ? _self.frequencyRank : frequencyRank // ignore: cast_nullable_to_non_nullable
as int,svgFileName: null == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String,svgFileUrl: null == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String,svgHash: null == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
