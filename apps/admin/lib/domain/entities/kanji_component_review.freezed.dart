// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanji_component_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KanjiComponentReview {

 int get id; int get kanjiComponentId; VerificationStatus get verificationStatus; double? get aiConfidence; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of KanjiComponentReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiComponentReviewCopyWith<KanjiComponentReview> get copyWith => _$KanjiComponentReviewCopyWithImpl<KanjiComponentReview>(this as KanjiComponentReview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjiComponentReview&&(identical(other.id, id) || other.id == id)&&(identical(other.kanjiComponentId, kanjiComponentId) || other.kanjiComponentId == kanjiComponentId)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.aiConfidence, aiConfidence) || other.aiConfidence == aiConfidence)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kanjiComponentId,verificationStatus,aiConfidence,createdAt,updatedAt);

@override
String toString() {
  return 'KanjiComponentReview(id: $id, kanjiComponentId: $kanjiComponentId, verificationStatus: $verificationStatus, aiConfidence: $aiConfidence, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $KanjiComponentReviewCopyWith<$Res>  {
  factory $KanjiComponentReviewCopyWith(KanjiComponentReview value, $Res Function(KanjiComponentReview) _then) = _$KanjiComponentReviewCopyWithImpl;
@useResult
$Res call({
 int id, int kanjiComponentId, VerificationStatus verificationStatus, double? aiConfidence, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$KanjiComponentReviewCopyWithImpl<$Res>
    implements $KanjiComponentReviewCopyWith<$Res> {
  _$KanjiComponentReviewCopyWithImpl(this._self, this._then);

  final KanjiComponentReview _self;
  final $Res Function(KanjiComponentReview) _then;

/// Create a copy of KanjiComponentReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kanjiComponentId = null,Object? verificationStatus = null,Object? aiConfidence = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kanjiComponentId: null == kanjiComponentId ? _self.kanjiComponentId : kanjiComponentId // ignore: cast_nullable_to_non_nullable
as int,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,aiConfidence: freezed == aiConfidence ? _self.aiConfidence : aiConfidence // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjiComponentReview].
extension KanjiComponentReviewPatterns on KanjiComponentReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjiComponentReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjiComponentReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjiComponentReview value)  $default,){
final _that = this;
switch (_that) {
case _KanjiComponentReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjiComponentReview value)?  $default,){
final _that = this;
switch (_that) {
case _KanjiComponentReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int kanjiComponentId,  VerificationStatus verificationStatus,  double? aiConfidence,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjiComponentReview() when $default != null:
return $default(_that.id,_that.kanjiComponentId,_that.verificationStatus,_that.aiConfidence,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int kanjiComponentId,  VerificationStatus verificationStatus,  double? aiConfidence,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _KanjiComponentReview():
return $default(_that.id,_that.kanjiComponentId,_that.verificationStatus,_that.aiConfidence,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int kanjiComponentId,  VerificationStatus verificationStatus,  double? aiConfidence,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _KanjiComponentReview() when $default != null:
return $default(_that.id,_that.kanjiComponentId,_that.verificationStatus,_that.aiConfidence,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _KanjiComponentReview implements KanjiComponentReview {
  const _KanjiComponentReview({required this.id, required this.kanjiComponentId, required this.verificationStatus, this.aiConfidence, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int kanjiComponentId;
@override final  VerificationStatus verificationStatus;
@override final  double? aiConfidence;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of KanjiComponentReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiComponentReviewCopyWith<_KanjiComponentReview> get copyWith => __$KanjiComponentReviewCopyWithImpl<_KanjiComponentReview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjiComponentReview&&(identical(other.id, id) || other.id == id)&&(identical(other.kanjiComponentId, kanjiComponentId) || other.kanjiComponentId == kanjiComponentId)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.aiConfidence, aiConfidence) || other.aiConfidence == aiConfidence)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kanjiComponentId,verificationStatus,aiConfidence,createdAt,updatedAt);

@override
String toString() {
  return 'KanjiComponentReview(id: $id, kanjiComponentId: $kanjiComponentId, verificationStatus: $verificationStatus, aiConfidence: $aiConfidence, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$KanjiComponentReviewCopyWith<$Res> implements $KanjiComponentReviewCopyWith<$Res> {
  factory _$KanjiComponentReviewCopyWith(_KanjiComponentReview value, $Res Function(_KanjiComponentReview) _then) = __$KanjiComponentReviewCopyWithImpl;
@override @useResult
$Res call({
 int id, int kanjiComponentId, VerificationStatus verificationStatus, double? aiConfidence, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$KanjiComponentReviewCopyWithImpl<$Res>
    implements _$KanjiComponentReviewCopyWith<$Res> {
  __$KanjiComponentReviewCopyWithImpl(this._self, this._then);

  final _KanjiComponentReview _self;
  final $Res Function(_KanjiComponentReview) _then;

/// Create a copy of KanjiComponentReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kanjiComponentId = null,Object? verificationStatus = null,Object? aiConfidence = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_KanjiComponentReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kanjiComponentId: null == kanjiComponentId ? _self.kanjiComponentId : kanjiComponentId // ignore: cast_nullable_to_non_nullable
as int,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,aiConfidence: freezed == aiConfidence ? _self.aiConfidence : aiConfidence // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
