// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radical.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Radical {

 int get id; String get masterSymbol; String? get familySymbol; List<Position> get positions; int get strokeCount; int get impactScore; int get minJlptLevel; int get minGrade; String get svgFileName; String get svgFileUrl; String get svgHash; bool get isOfficial; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Radical
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadicalCopyWith<Radical> get copyWith => _$RadicalCopyWithImpl<Radical>(this as Radical, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Radical&&(identical(other.id, id) || other.id == id)&&(identical(other.masterSymbol, masterSymbol) || other.masterSymbol == masterSymbol)&&(identical(other.familySymbol, familySymbol) || other.familySymbol == familySymbol)&&const DeepCollectionEquality().equals(other.positions, positions)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&(identical(other.impactScore, impactScore) || other.impactScore == impactScore)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,masterSymbol,familySymbol,const DeepCollectionEquality().hash(positions),strokeCount,impactScore,minJlptLevel,minGrade,svgFileName,svgFileUrl,svgHash,isOfficial,createdAt,updatedAt);

@override
String toString() {
  return 'Radical(id: $id, masterSymbol: $masterSymbol, familySymbol: $familySymbol, positions: $positions, strokeCount: $strokeCount, impactScore: $impactScore, minJlptLevel: $minJlptLevel, minGrade: $minGrade, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, isOfficial: $isOfficial, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RadicalCopyWith<$Res>  {
  factory $RadicalCopyWith(Radical value, $Res Function(Radical) _then) = _$RadicalCopyWithImpl;
@useResult
$Res call({
 int id, String masterSymbol, String? familySymbol, List<Position> positions, int strokeCount, int impactScore, int minJlptLevel, int minGrade, String svgFileName, String svgFileUrl, String svgHash, bool isOfficial, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RadicalCopyWithImpl<$Res>
    implements $RadicalCopyWith<$Res> {
  _$RadicalCopyWithImpl(this._self, this._then);

  final Radical _self;
  final $Res Function(Radical) _then;

/// Create a copy of Radical
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? masterSymbol = null,Object? familySymbol = freezed,Object? positions = null,Object? strokeCount = null,Object? impactScore = null,Object? minJlptLevel = null,Object? minGrade = null,Object? svgFileName = null,Object? svgFileUrl = null,Object? svgHash = null,Object? isOfficial = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,masterSymbol: null == masterSymbol ? _self.masterSymbol : masterSymbol // ignore: cast_nullable_to_non_nullable
as String,familySymbol: freezed == familySymbol ? _self.familySymbol : familySymbol // ignore: cast_nullable_to_non_nullable
as String?,positions: null == positions ? _self.positions : positions // ignore: cast_nullable_to_non_nullable
as List<Position>,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,impactScore: null == impactScore ? _self.impactScore : impactScore // ignore: cast_nullable_to_non_nullable
as int,minJlptLevel: null == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int,minGrade: null == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as int,svgFileName: null == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String,svgFileUrl: null == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String,svgHash: null == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Radical].
extension RadicalPatterns on Radical {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Radical value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Radical() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Radical value)  $default,){
final _that = this;
switch (_that) {
case _Radical():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Radical value)?  $default,){
final _that = this;
switch (_that) {
case _Radical() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String masterSymbol,  String? familySymbol,  List<Position> positions,  int strokeCount,  int impactScore,  int minJlptLevel,  int minGrade,  String svgFileName,  String svgFileUrl,  String svgHash,  bool isOfficial,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Radical() when $default != null:
return $default(_that.id,_that.masterSymbol,_that.familySymbol,_that.positions,_that.strokeCount,_that.impactScore,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.isOfficial,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String masterSymbol,  String? familySymbol,  List<Position> positions,  int strokeCount,  int impactScore,  int minJlptLevel,  int minGrade,  String svgFileName,  String svgFileUrl,  String svgHash,  bool isOfficial,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Radical():
return $default(_that.id,_that.masterSymbol,_that.familySymbol,_that.positions,_that.strokeCount,_that.impactScore,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.isOfficial,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String masterSymbol,  String? familySymbol,  List<Position> positions,  int strokeCount,  int impactScore,  int minJlptLevel,  int minGrade,  String svgFileName,  String svgFileUrl,  String svgHash,  bool isOfficial,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Radical() when $default != null:
return $default(_that.id,_that.masterSymbol,_that.familySymbol,_that.positions,_that.strokeCount,_that.impactScore,_that.minJlptLevel,_that.minGrade,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.isOfficial,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Radical implements Radical {
  const _Radical({required this.id, required this.masterSymbol, this.familySymbol, required final  List<Position> positions, required this.strokeCount, required this.impactScore, required this.minJlptLevel, required this.minGrade, required this.svgFileName, required this.svgFileUrl, required this.svgHash, required this.isOfficial, required this.createdAt, required this.updatedAt}): _positions = positions;
  

@override final  int id;
@override final  String masterSymbol;
@override final  String? familySymbol;
 final  List<Position> _positions;
@override List<Position> get positions {
  if (_positions is EqualUnmodifiableListView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_positions);
}

@override final  int strokeCount;
@override final  int impactScore;
@override final  int minJlptLevel;
@override final  int minGrade;
@override final  String svgFileName;
@override final  String svgFileUrl;
@override final  String svgHash;
@override final  bool isOfficial;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Radical
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadicalCopyWith<_Radical> get copyWith => __$RadicalCopyWithImpl<_Radical>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Radical&&(identical(other.id, id) || other.id == id)&&(identical(other.masterSymbol, masterSymbol) || other.masterSymbol == masterSymbol)&&(identical(other.familySymbol, familySymbol) || other.familySymbol == familySymbol)&&const DeepCollectionEquality().equals(other._positions, _positions)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount)&&(identical(other.impactScore, impactScore) || other.impactScore == impactScore)&&(identical(other.minJlptLevel, minJlptLevel) || other.minJlptLevel == minJlptLevel)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,masterSymbol,familySymbol,const DeepCollectionEquality().hash(_positions),strokeCount,impactScore,minJlptLevel,minGrade,svgFileName,svgFileUrl,svgHash,isOfficial,createdAt,updatedAt);

@override
String toString() {
  return 'Radical(id: $id, masterSymbol: $masterSymbol, familySymbol: $familySymbol, positions: $positions, strokeCount: $strokeCount, impactScore: $impactScore, minJlptLevel: $minJlptLevel, minGrade: $minGrade, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, isOfficial: $isOfficial, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RadicalCopyWith<$Res> implements $RadicalCopyWith<$Res> {
  factory _$RadicalCopyWith(_Radical value, $Res Function(_Radical) _then) = __$RadicalCopyWithImpl;
@override @useResult
$Res call({
 int id, String masterSymbol, String? familySymbol, List<Position> positions, int strokeCount, int impactScore, int minJlptLevel, int minGrade, String svgFileName, String svgFileUrl, String svgHash, bool isOfficial, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RadicalCopyWithImpl<$Res>
    implements _$RadicalCopyWith<$Res> {
  __$RadicalCopyWithImpl(this._self, this._then);

  final _Radical _self;
  final $Res Function(_Radical) _then;

/// Create a copy of Radical
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? masterSymbol = null,Object? familySymbol = freezed,Object? positions = null,Object? strokeCount = null,Object? impactScore = null,Object? minJlptLevel = null,Object? minGrade = null,Object? svgFileName = null,Object? svgFileUrl = null,Object? svgHash = null,Object? isOfficial = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Radical(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,masterSymbol: null == masterSymbol ? _self.masterSymbol : masterSymbol // ignore: cast_nullable_to_non_nullable
as String,familySymbol: freezed == familySymbol ? _self.familySymbol : familySymbol // ignore: cast_nullable_to_non_nullable
as String?,positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as List<Position>,strokeCount: null == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int,impactScore: null == impactScore ? _self.impactScore : impactScore // ignore: cast_nullable_to_non_nullable
as int,minJlptLevel: null == minJlptLevel ? _self.minJlptLevel : minJlptLevel // ignore: cast_nullable_to_non_nullable
as int,minGrade: null == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as int,svgFileName: null == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String,svgFileUrl: null == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String,svgHash: null == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
