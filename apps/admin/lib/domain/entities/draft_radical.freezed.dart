// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_radical.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftRadical {

 int get id; String get masterSymbol; int? get strokeCount; int? get impactScore; int? get minJlptLevel; int? get minGrade; String? get svgFileName; String? get svgFileUrl; String? get svgHash; bool get isOfficial; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DraftRadical
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftRadicalCopyWith<DraftRadical> get copyWith => _$DraftRadicalCopyWithImpl<DraftRadical>(this as DraftRadical, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftRadical&&(identical(other.id, id) || other.id == id)&&(identical(other.masterSymbol, masterSymbol) || other.masterSymbol == masterSymbol)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&(identical(other.impactScore, impactScore) || other.impactScore == impactScore)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,masterSymbol,strokeCount,impactScore,minJlptLevel,minGrade,svgFileName,svgFileUrl,svgHash,isOfficial,createdAt,updatedAt);

@override
String toString() {
  return 'DraftRadical(id: $id, masterSymbol: $masterSymbol, strokeCount: $strokeCount, impactScore: $impactScore, minJlptLevel: $minJlptLevel, minGrade: $minGrade, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, isOfficial: $isOfficial, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DraftRadicalCopyWith<$Res>  {
  factory $DraftRadicalCopyWith(DraftRadical value, $Res Function(DraftRadical) _then) = _$DraftRadicalCopyWithImpl;
@useResult
$Res call({
 int id, String masterSymbol, int? strokeCount, int? impactScore, int? minJlptLevel, int? minGrade, String? svgFileName, String? svgFileUrl, String? svgHash, bool isOfficial, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DraftRadicalCopyWithImpl<$Res>
    implements $DraftRadicalCopyWith<$Res> {
  _$DraftRadicalCopyWithImpl(this._self, this._then);

  final DraftRadical _self;
  final $Res Function(DraftRadical) _then;

/// Create a copy of DraftRadical
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? masterSymbol = null,Object? strokeCount = freezed,Object? impactScore = freezed,Object? minJlptLevel = freezed,Object? minGrade = freezed,Object? svgFileName = freezed,Object? svgFileUrl = freezed,Object? svgHash = freezed,Object? isOfficial = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,masterSymbol: null == masterSymbol ? _self.masterSymbol : masterSymbol // ignore: cast_nullable_to_non_nullable
as String,strokeCount: freezed == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int?,impactScore: freezed == impactScore ? _self.impactScore : impactScore // ignore: cast_nullable_to_non_nullable
as int?,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,minGrade: freezed == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as int?,svgFileName: freezed == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String?,svgFileUrl: freezed == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String?,svgHash: freezed == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String?,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftRadical].
extension DraftRadicalPatterns on DraftRadical {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftRadical value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftRadical() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftRadical value)  $default,){
final _that = this;
switch (_that) {
case _DraftRadical():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftRadical value)?  $default,){
final _that = this;
switch (_that) {
case _DraftRadical() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String masterSymbol,  int? strokeCount,  int? impactScore,  int? minJlptLevel,  int? minGrade,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  bool isOfficial,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftRadical() when $default != null:
return $default(_that.id,_that.masterSymbol,_that.strokeCount,_that.impactScore,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.isOfficial,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String masterSymbol,  int? strokeCount,  int? impactScore,  int? minJlptLevel,  int? minGrade,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  bool isOfficial,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DraftRadical():
return $default(_that.id,_that.masterSymbol,_that.strokeCount,_that.impactScore,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.isOfficial,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String masterSymbol,  int? strokeCount,  int? impactScore,  int? minJlptLevel,  int? minGrade,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  bool isOfficial,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DraftRadical() when $default != null:
return $default(_that.id,_that.masterSymbol,_that.strokeCount,_that.impactScore,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.isOfficial,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DraftRadical implements DraftRadical {
  const _DraftRadical({required this.id, required this.masterSymbol, this.strokeCount, this.impactScore, this.minJlptLevel, this.minGrade, this.svgFileName, this.svgFileUrl, this.svgHash, required this.isOfficial, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  String masterSymbol;
@override final  int? strokeCount;
@override final  int? impactScore;
@override final  int? minJlptLevel;
@override final  int? minGrade;
@override final  String? svgFileName;
@override final  String? svgFileUrl;
@override final  String? svgHash;
@override final  bool isOfficial;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DraftRadical
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftRadicalCopyWith<_DraftRadical> get copyWith => __$DraftRadicalCopyWithImpl<_DraftRadical>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftRadical&&(identical(other.id, id) || other.id == id)&&(identical(other.masterSymbol, masterSymbol) || other.masterSymbol == masterSymbol)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&(identical(other.impactScore, impactScore) || other.impactScore == impactScore)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,masterSymbol,strokeCount,impactScore,minJlptLevel,minGrade,svgFileName,svgFileUrl,svgHash,isOfficial,createdAt,updatedAt);

@override
String toString() {
  return 'DraftRadical(id: $id, masterSymbol: $masterSymbol, strokeCount: $strokeCount, impactScore: $impactScore, minJlptLevel: $minJlptLevel, minGrade: $minGrade, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, isOfficial: $isOfficial, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DraftRadicalCopyWith<$Res> implements $DraftRadicalCopyWith<$Res> {
  factory _$DraftRadicalCopyWith(_DraftRadical value, $Res Function(_DraftRadical) _then) = __$DraftRadicalCopyWithImpl;
@override @useResult
$Res call({
 int id, String masterSymbol, int? strokeCount, int? impactScore, int? minJlptLevel, int? minGrade, String? svgFileName, String? svgFileUrl, String? svgHash, bool isOfficial, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DraftRadicalCopyWithImpl<$Res>
    implements _$DraftRadicalCopyWith<$Res> {
  __$DraftRadicalCopyWithImpl(this._self, this._then);

  final _DraftRadical _self;
  final $Res Function(_DraftRadical) _then;

/// Create a copy of DraftRadical
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? masterSymbol = null,Object? strokeCount = freezed,Object? impactScore = freezed,Object? minJlptLevel = freezed,Object? minGrade = freezed,Object? svgFileName = freezed,Object? svgFileUrl = freezed,Object? svgHash = freezed,Object? isOfficial = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DraftRadical(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,masterSymbol: null == masterSymbol ? _self.masterSymbol : masterSymbol // ignore: cast_nullable_to_non_nullable
as String,strokeCount: freezed == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int?,impactScore: freezed == impactScore ? _self.impactScore : impactScore // ignore: cast_nullable_to_non_nullable
as int?,minJlptLevel: freezed == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int?,minGrade: freezed == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as int?,svgFileName: freezed == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String?,svgFileUrl: freezed == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String?,svgHash: freezed == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String?,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
