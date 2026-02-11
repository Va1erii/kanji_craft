// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_radical_variant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftRadicalVariant {

 int get id; int get draftRadicalId; String get shape; Position get position; bool get isLocked; String? get svgFileName; String? get svgFileUrl; String? get svgHash; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DraftRadicalVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftRadicalVariantCopyWith<DraftRadicalVariant> get copyWith => _$DraftRadicalVariantCopyWithImpl<DraftRadicalVariant>(this as DraftRadicalVariant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftRadicalVariant&&(identical(other.id, id) || other.id == id)&&(identical(other.draftRadicalId, draftRadicalId) || other.draftRadicalId == draftRadicalId)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.position, position) || other.position == position)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,draftRadicalId,shape,position,isLocked,svgFileName,svgFileUrl,svgHash,createdAt,updatedAt);

@override
String toString() {
  return 'DraftRadicalVariant(id: $id, draftRadicalId: $draftRadicalId, shape: $shape, position: $position, isLocked: $isLocked, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DraftRadicalVariantCopyWith<$Res>  {
  factory $DraftRadicalVariantCopyWith(DraftRadicalVariant value, $Res Function(DraftRadicalVariant) _then) = _$DraftRadicalVariantCopyWithImpl;
@useResult
$Res call({
 int id, int draftRadicalId, String shape, Position position, bool isLocked, String? svgFileName, String? svgFileUrl, String? svgHash, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DraftRadicalVariantCopyWithImpl<$Res>
    implements $DraftRadicalVariantCopyWith<$Res> {
  _$DraftRadicalVariantCopyWithImpl(this._self, this._then);

  final DraftRadicalVariant _self;
  final $Res Function(DraftRadicalVariant) _then;

/// Create a copy of DraftRadicalVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? draftRadicalId = null,Object? shape = null,Object? position = null,Object? isLocked = null,Object? svgFileName = freezed,Object? svgFileUrl = freezed,Object? svgHash = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,draftRadicalId: null == draftRadicalId ? _self.draftRadicalId : draftRadicalId // ignore: cast_nullable_to_non_nullable
as int,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,svgFileName: freezed == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String?,svgFileUrl: freezed == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String?,svgHash: freezed == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftRadicalVariant].
extension DraftRadicalVariantPatterns on DraftRadicalVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftRadicalVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftRadicalVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftRadicalVariant value)  $default,){
final _that = this;
switch (_that) {
case _DraftRadicalVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftRadicalVariant value)?  $default,){
final _that = this;
switch (_that) {
case _DraftRadicalVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int draftRadicalId,  String shape,  Position position,  bool isLocked,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftRadicalVariant() when $default != null:
return $default(_that.id,_that.draftRadicalId,_that.shape,_that.position,_that.isLocked,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int draftRadicalId,  String shape,  Position position,  bool isLocked,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DraftRadicalVariant():
return $default(_that.id,_that.draftRadicalId,_that.shape,_that.position,_that.isLocked,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int draftRadicalId,  String shape,  Position position,  bool isLocked,  String? svgFileName,  String? svgFileUrl,  String? svgHash,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DraftRadicalVariant() when $default != null:
return $default(_that.id,_that.draftRadicalId,_that.shape,_that.position,_that.isLocked,_that.svgFileName,_that.svgFileUrl,_that.svgHash,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DraftRadicalVariant implements DraftRadicalVariant {
  const _DraftRadicalVariant({required this.id, required this.draftRadicalId, required this.shape, required this.position, required this.isLocked, this.svgFileName, this.svgFileUrl, this.svgHash, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int draftRadicalId;
@override final  String shape;
@override final  Position position;
@override final  bool isLocked;
@override final  String? svgFileName;
@override final  String? svgFileUrl;
@override final  String? svgHash;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DraftRadicalVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftRadicalVariantCopyWith<_DraftRadicalVariant> get copyWith => __$DraftRadicalVariantCopyWithImpl<_DraftRadicalVariant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftRadicalVariant&&(identical(other.id, id) || other.id == id)&&(identical(other.draftRadicalId, draftRadicalId) || other.draftRadicalId == draftRadicalId)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.position, position) || other.position == position)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.svgFileName, svgFileName) || other.svgFileName == svgFileName)&&(identical(other.svgFileUrl, svgFileUrl) || other.svgFileUrl == svgFileUrl)&&(identical(other.svgHash, svgHash) || other.svgHash == svgHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,draftRadicalId,shape,position,isLocked,svgFileName,svgFileUrl,svgHash,createdAt,updatedAt);

@override
String toString() {
  return 'DraftRadicalVariant(id: $id, draftRadicalId: $draftRadicalId, shape: $shape, position: $position, isLocked: $isLocked, svgFileName: $svgFileName, svgFileUrl: $svgFileUrl, svgHash: $svgHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DraftRadicalVariantCopyWith<$Res> implements $DraftRadicalVariantCopyWith<$Res> {
  factory _$DraftRadicalVariantCopyWith(_DraftRadicalVariant value, $Res Function(_DraftRadicalVariant) _then) = __$DraftRadicalVariantCopyWithImpl;
@override @useResult
$Res call({
 int id, int draftRadicalId, String shape, Position position, bool isLocked, String? svgFileName, String? svgFileUrl, String? svgHash, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DraftRadicalVariantCopyWithImpl<$Res>
    implements _$DraftRadicalVariantCopyWith<$Res> {
  __$DraftRadicalVariantCopyWithImpl(this._self, this._then);

  final _DraftRadicalVariant _self;
  final $Res Function(_DraftRadicalVariant) _then;

/// Create a copy of DraftRadicalVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? draftRadicalId = null,Object? shape = null,Object? position = null,Object? isLocked = null,Object? svgFileName = freezed,Object? svgFileUrl = freezed,Object? svgHash = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DraftRadicalVariant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,draftRadicalId: null == draftRadicalId ? _self.draftRadicalId : draftRadicalId // ignore: cast_nullable_to_non_nullable
as int,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,svgFileName: freezed == svgFileName ? _self.svgFileName : svgFileName // ignore: cast_nullable_to_non_nullable
as String?,svgFileUrl: freezed == svgFileUrl ? _self.svgFileUrl : svgFileUrl // ignore: cast_nullable_to_non_nullable
as String?,svgHash: freezed == svgHash ? _self.svgHash : svgHash // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
