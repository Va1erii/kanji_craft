// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_kanji.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftKanji {

 int get id; String get character; int get strokeCount; int get frequencyRank; int? get minJlptLevel; int? get minGrade; String? get svgFileName; String? get svgFileUrl; String? get svgHash; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DraftKanji
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftKanjiCopyWith<DraftKanji> get copyWith => _$DraftKanjiCopyWithImpl<DraftKanji>(this as DraftKanji, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftKanji&&(identical(other.id, id) || other.id == id)&&(identical(other.character, character) || other.character == character)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&(identical(other.frequencyRank, frequencyRank) || other.frequencyRank == frequencyRank)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,character,strokeCount,frequencyRank,minJlptLevel,minGrade,svgFileName,svgFileUrl,svgHash,createdAt,updatedAt);

@override
String toString() {
  return 'DraftKanji(id: $id, character: $character, strokeCount: $strokeCount, frequencyRank: $frequencyRank, minJlptLevel: $minJlptLevel, minGrade: $minGrade, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DraftKanjiCopyWith<$Res>  {
  factory $DraftKanjiCopyWith(DraftKanji value, $Res Function(DraftKanji) _then) = _$DraftKanjiCopyWithImpl;
@useResult
$Res call({
 int id, String character, int strokeCount, int frequencyRank, int? minJlptLevel, int? minGrade, String? svgFileName, String? svgFileUrl, String? svgHash, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DraftKanjiCopyWithImpl<$Res>
    implements $DraftKanjiCopyWith<$Res> {
  _$DraftKanjiCopyWithImpl(this._self, this._then);

  final DraftKanji _self;
  final $Res Function(DraftKanji) _then;

/// Create a copy of DraftKanji
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? character = null,Object? strokeCount = null,Object? frequencyRank = null,Object? minJlptLevel = freezed,Object? minGrade = freezed,Object? svgFileName = freezed,Object? svgFileUrl = freezed,Object? svgHash = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,frequencyRank: null == frequencyRank ? _self.frequencyRank : frequencyRank // ignore: cast_nullable_to_non_nullable
as int,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,minGrade: freezed == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as int?,svgFileName: freezed == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String?,svgFileUrl: freezed == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String?,svgHash: freezed == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftKanji].
extension DraftKanjiPatterns on DraftKanji {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftKanji value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftKanji() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftKanji value)  $default,){
final _that = this;
switch (_that) {
case _DraftKanji():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftKanji value)?  $default,){
final _that = this;
switch (_that) {
case _DraftKanji() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String character,  int strokeCount,  int frequencyRank,  int? minJlptLevel,  int? minGrade,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftKanji() when $default != null:
return $default(_that.id,_that.character,_that.strokeCount,_that.frequencyRank,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String character,  int strokeCount,  int frequencyRank,  int? minJlptLevel,  int? minGrade,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DraftKanji():
return $default(_that.id,_that.character,_that.strokeCount,_that.frequencyRank,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String character,  int strokeCount,  int frequencyRank,  int? minJlptLevel,  int? minGrade,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DraftKanji() when $default != null:
return $default(_that.id,_that.character,_that.strokeCount,_that.frequencyRank,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DraftKanji implements DraftKanji {
  const _DraftKanji({required this.id, required this.character, required this.strokeCount, required this.frequencyRank, this.minJlptLevel, this.minGrade, this.svgFileName, this.svgFileUrl, this.svgHash, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  String character;
@override final  int strokeCount;
@override final  int frequencyRank;
@override final  int? minJlptLevel;
@override final  int? minGrade;
@override final  String? svgFileName;
@override final  String? svgFileUrl;
@override final  String? svgHash;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DraftKanji
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftKanjiCopyWith<_DraftKanji> get copyWith => __$DraftKanjiCopyWithImpl<_DraftKanji>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftKanji&&(identical(other.id, id) || other.id == id)&&(identical(other.character, character) || other.character == character)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&(identical(other.frequencyRank, frequencyRank) || other.frequencyRank == frequencyRank)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,character,strokeCount,frequencyRank,minJlptLevel,minGrade,svgFileName,svgFileUrl,svgHash,createdAt,updatedAt);

@override
String toString() {
  return 'DraftKanji(id: $id, character: $character, strokeCount: $strokeCount, frequencyRank: $frequencyRank, minJlptLevel: $minJlptLevel, minGrade: $minGrade, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DraftKanjiCopyWith<$Res> implements $DraftKanjiCopyWith<$Res> {
  factory _$DraftKanjiCopyWith(_DraftKanji value, $Res Function(_DraftKanji) _then) = __$DraftKanjiCopyWithImpl;
@override @useResult
$Res call({
 int id, String character, int strokeCount, int frequencyRank, int? minJlptLevel, int? minGrade, String? svgFileName, String? svgFileUrl, String? svgHash, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DraftKanjiCopyWithImpl<$Res>
    implements _$DraftKanjiCopyWith<$Res> {
  __$DraftKanjiCopyWithImpl(this._self, this._then);

  final _DraftKanji _self;
  final $Res Function(_DraftKanji) _then;

/// Create a copy of DraftKanji
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? character = null,Object? strokeCount = null,Object? frequencyRank = null,Object? minJlptLevel = freezed,Object? minGrade = freezed,Object? svgFileName = freezed,Object? svgFileUrl = freezed,Object? svgHash = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DraftKanji(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,frequencyRank: null == frequencyRank ? _self.frequencyRank : frequencyRank // ignore: cast_nullable_to_non_nullable
as int,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,minGrade: freezed == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as int?,svgFileName: freezed == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String?,svgFileUrl: freezed == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String?,svgHash: freezed == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
