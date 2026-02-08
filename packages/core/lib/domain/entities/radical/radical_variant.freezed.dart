// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radical_variant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RadicalVariant {

 int get id; int get radicalId; String get shape; Position get position; bool get isLocked; String get svgFileName; String get svgFileUrl; String get svgHash; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of RadicalVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadicalVariantCopyWith<RadicalVariant> get copyWith => _$RadicalVariantCopyWithImpl<RadicalVariant>(this as RadicalVariant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadicalVariant&&(identical(other.id, id) || other.id == id)&&(identical(other.radicalId, radicalId) || other.radicalId == radicalId)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.position, position) || other.position == position)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,radicalId,shape,position,isLocked,svgFileName,svgFileUrl,svgHash,createdAt,updatedAt);

@override
String toString() {
  return 'RadicalVariant(id: $id, radicalId: $radicalId, shape: $shape, position: $position, isLocked: $isLocked, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RadicalVariantCopyWith<$Res>  {
  factory $RadicalVariantCopyWith(RadicalVariant value, $Res Function(RadicalVariant) _then) = _$RadicalVariantCopyWithImpl;
@useResult
$Res call({
 int id, int radicalId, String shape, Position position, bool isLocked, String svgFileName, String svgFileUrl, String svgHash, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RadicalVariantCopyWithImpl<$Res>
    implements $RadicalVariantCopyWith<$Res> {
  _$RadicalVariantCopyWithImpl(this._self, this._then);

  final RadicalVariant _self;
  final $Res Function(RadicalVariant) _then;

/// Create a copy of RadicalVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? radicalId = null,Object? shape = null,Object? position = null,Object? isLocked = null,Object? svgFileName = null,Object? svgFileUrl = null,Object? svgHash = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,radicalId: null == radicalId ? _self.radicalId : radicalId // ignore: cast_nullable_to_non_nullable
as int,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,svgFileName: null == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String,svgFileUrl: null == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String,svgHash: null == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RadicalVariant].
extension RadicalVariantPatterns on RadicalVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadicalVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadicalVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadicalVariant value)  $default,){
final _that = this;
switch (_that) {
case _RadicalVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadicalVariant value)?  $default,){
final _that = this;
switch (_that) {
case _RadicalVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int radicalId,  String shape,  Position position,  bool isLocked,  String svgFileName,  String svgFileUrl,  String svgHash,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadicalVariant() when $default != null:
return $default(_that.id,_that.radicalId,_that.shape,_that.position,_that.isLocked,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int radicalId,  String shape,  Position position,  bool isLocked,  String svgFileName,  String svgFileUrl,  String svgHash,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RadicalVariant():
return $default(_that.id,_that.radicalId,_that.shape,_that.position,_that.isLocked,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int radicalId,  String shape,  Position position,  bool isLocked,  String svgFileName,  String svgFileUrl,  String svgHash,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RadicalVariant() when $default != null:
return $default(_that.id,_that.radicalId,_that.shape,_that.position,_that.isLocked,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _RadicalVariant implements RadicalVariant {
  const _RadicalVariant({required this.id, required this.radicalId, required this.shape, required this.position, required this.isLocked, required this.svgFileName, required this.svgFileUrl, required this.svgHash, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int radicalId;
@override final  String shape;
@override final  Position position;
@override final  bool isLocked;
@override final  String svgFileName;
@override final  String svgFileUrl;
@override final  String svgHash;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of RadicalVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadicalVariantCopyWith<_RadicalVariant> get copyWith => __$RadicalVariantCopyWithImpl<_RadicalVariant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadicalVariant&&(identical(other.id, id) || other.id == id)&&(identical(other.radicalId, radicalId) || other.radicalId == radicalId)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.position, position) || other.position == position)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,radicalId,shape,position,isLocked,svgFileName,svgFileUrl,svgHash,createdAt,updatedAt);

@override
String toString() {
  return 'RadicalVariant(id: $id, radicalId: $radicalId, shape: $shape, position: $position, isLocked: $isLocked, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RadicalVariantCopyWith<$Res> implements $RadicalVariantCopyWith<$Res> {
  factory _$RadicalVariantCopyWith(_RadicalVariant value, $Res Function(_RadicalVariant) _then) = __$RadicalVariantCopyWithImpl;
@override @useResult
$Res call({
 int id, int radicalId, String shape, Position position, bool isLocked, String svgFileName, String svgFileUrl, String svgHash, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RadicalVariantCopyWithImpl<$Res>
    implements _$RadicalVariantCopyWith<$Res> {
  __$RadicalVariantCopyWithImpl(this._self, this._then);

  final _RadicalVariant _self;
  final $Res Function(_RadicalVariant) _then;

/// Create a copy of RadicalVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? radicalId = null,Object? shape = null,Object? position = null,Object? isLocked = null,Object? svgFileName = null,Object? svgFileUrl = null,Object? svgHash = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RadicalVariant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,radicalId: null == radicalId ? _self.radicalId : radicalId // ignore: cast_nullable_to_non_nullable
as int,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,svgFileName: null == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String,svgFileUrl: null == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String,svgHash: null == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
