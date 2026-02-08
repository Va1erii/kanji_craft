// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanji_component_review_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KanjiComponentReviewDto {

 int get id;@JsonKey(name: 'kanji_component_id') int get kanjiComponentId;@JsonKey(name: 'verification_status') VerificationStatus get verificationStatus;@JsonKey(name: 'ai_confidence') double? get aiConfidence;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of KanjiComponentReviewDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiComponentReviewDtoCopyWith<KanjiComponentReviewDto> get copyWith => _$KanjiComponentReviewDtoCopyWithImpl<KanjiComponentReviewDto>(this as KanjiComponentReviewDto, _$identity);

  /// Serializes this KanjiComponentReviewDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjiComponentReviewDto&&(identical(other.id, id) || other.id == id)&&(identical(other.kanjiComponentId, kanjiComponentId) || other.kanjiComponentId == kanjiComponentId)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.aiConfidence, aiConfidence) || other.aiConfidence == aiConfidence)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kanjiComponentId,verificationStatus,aiConfidence,createdAt,updatedAt);

@override
String toString() {
  return 'KanjiComponentReviewDto(id: $id, kanjiComponentId: $kanjiComponentId, verificationStatus: $verificationStatus, aiConfidence: $aiConfidence, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $KanjiComponentReviewDtoCopyWith<$Res>  {
  factory $KanjiComponentReviewDtoCopyWith(KanjiComponentReviewDto value, $Res Function(KanjiComponentReviewDto) _then) = _$KanjiComponentReviewDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'kanji_component_id') int kanjiComponentId,@JsonKey(name: 'verification_status') VerificationStatus verificationStatus,@JsonKey(name: 'ai_confidence') double? aiConfidence,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$KanjiComponentReviewDtoCopyWithImpl<$Res>
    implements $KanjiComponentReviewDtoCopyWith<$Res> {
  _$KanjiComponentReviewDtoCopyWithImpl(this._self, this._then);

  final KanjiComponentReviewDto _self;
  final $Res Function(KanjiComponentReviewDto) _then;

/// Create a copy of KanjiComponentReviewDto
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


/// Adds pattern-matching-related methods to [KanjiComponentReviewDto].
extension KanjiComponentReviewDtoPatterns on KanjiComponentReviewDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjiComponentReviewDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjiComponentReviewDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjiComponentReviewDto value)  $default,){
final _that = this;
switch (_that) {
case _KanjiComponentReviewDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjiComponentReviewDto value)?  $default,){
final _that = this;
switch (_that) {
case _KanjiComponentReviewDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'kanji_component_id')  int kanjiComponentId, @JsonKey(name: 'verification_status')  VerificationStatus verificationStatus, @JsonKey(name: 'ai_confidence')  double? aiConfidence, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjiComponentReviewDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'kanji_component_id')  int kanjiComponentId, @JsonKey(name: 'verification_status')  VerificationStatus verificationStatus, @JsonKey(name: 'ai_confidence')  double? aiConfidence, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _KanjiComponentReviewDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'kanji_component_id')  int kanjiComponentId, @JsonKey(name: 'verification_status')  VerificationStatus verificationStatus, @JsonKey(name: 'ai_confidence')  double? aiConfidence, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _KanjiComponentReviewDto() when $default != null:
return $default(_that.id,_that.kanjiComponentId,_that.verificationStatus,_that.aiConfidence,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanjiComponentReviewDto extends KanjiComponentReviewDto {
  const _KanjiComponentReviewDto({required this.id, @JsonKey(name: 'kanji_component_id') required this.kanjiComponentId, @JsonKey(name: 'verification_status') required this.verificationStatus, @JsonKey(name: 'ai_confidence') this.aiConfidence, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _KanjiComponentReviewDto.fromJson(Map<String, dynamic> json) => _$KanjiComponentReviewDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'kanji_component_id') final  int kanjiComponentId;
@override@JsonKey(name: 'verification_status') final  VerificationStatus verificationStatus;
@override@JsonKey(name: 'ai_confidence') final  double? aiConfidence;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of KanjiComponentReviewDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiComponentReviewDtoCopyWith<_KanjiComponentReviewDto> get copyWith => __$KanjiComponentReviewDtoCopyWithImpl<_KanjiComponentReviewDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanjiComponentReviewDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjiComponentReviewDto&&(identical(other.id, id) || other.id == id)&&(identical(other.kanjiComponentId, kanjiComponentId) || other.kanjiComponentId == kanjiComponentId)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.aiConfidence, aiConfidence) || other.aiConfidence == aiConfidence)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kanjiComponentId,verificationStatus,aiConfidence,createdAt,updatedAt);

@override
String toString() {
  return 'KanjiComponentReviewDto(id: $id, kanjiComponentId: $kanjiComponentId, verificationStatus: $verificationStatus, aiConfidence: $aiConfidence, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$KanjiComponentReviewDtoCopyWith<$Res> implements $KanjiComponentReviewDtoCopyWith<$Res> {
  factory _$KanjiComponentReviewDtoCopyWith(_KanjiComponentReviewDto value, $Res Function(_KanjiComponentReviewDto) _then) = __$KanjiComponentReviewDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'kanji_component_id') int kanjiComponentId,@JsonKey(name: 'verification_status') VerificationStatus verificationStatus,@JsonKey(name: 'ai_confidence') double? aiConfidence,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$KanjiComponentReviewDtoCopyWithImpl<$Res>
    implements _$KanjiComponentReviewDtoCopyWith<$Res> {
  __$KanjiComponentReviewDtoCopyWithImpl(this._self, this._then);

  final _KanjiComponentReviewDto _self;
  final $Res Function(_KanjiComponentReviewDto) _then;

/// Create a copy of KanjiComponentReviewDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kanjiComponentId = null,Object? verificationStatus = null,Object? aiConfidence = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_KanjiComponentReviewDto(
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
