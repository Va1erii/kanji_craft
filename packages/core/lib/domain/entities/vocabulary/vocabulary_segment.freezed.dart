// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_segment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabularySegment {

 String get text; String? get reading; int? get kanjiId; List<int>? get kanjiIds;
/// Create a copy of VocabularySegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularySegmentCopyWith<VocabularySegment> get copyWith => _$VocabularySegmentCopyWithImpl<VocabularySegment>(this as VocabularySegment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularySegment&&(identical(other.text, text) || other.text == text)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.kanjiId, kanjiId) || other.kanjiId == kanjiId)&&const DeepCollectionEquality().equals(other.kanjiIds, kanjiIds));
}


@override
int get hashCode => Object.hash(runtimeType,text,reading,kanjiId,const DeepCollectionEquality().hash(kanjiIds));

@override
String toString() {
  return 'VocabularySegment(text: $text, reading: $reading, kanjiId: $kanjiId, kanjiIds: $kanjiIds)';
}


}

/// @nodoc
abstract mixin class $VocabularySegmentCopyWith<$Res>  {
  factory $VocabularySegmentCopyWith(VocabularySegment value, $Res Function(VocabularySegment) _then) = _$VocabularySegmentCopyWithImpl;
@useResult
$Res call({
 String text, String? reading, int? kanjiId, List<int>? kanjiIds
});




}
/// @nodoc
class _$VocabularySegmentCopyWithImpl<$Res>
    implements $VocabularySegmentCopyWith<$Res> {
  _$VocabularySegmentCopyWithImpl(this._self, this._then);

  final VocabularySegment _self;
  final $Res Function(VocabularySegment) _then;

/// Create a copy of VocabularySegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? reading = freezed,Object? kanjiId = freezed,Object? kanjiIds = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reading: freezed == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as String?,kanjiId: freezed == kanjiId ? _self.kanjiId : kanjiId // ignore: cast_nullable_to_non_nullable
as int?,kanjiIds: freezed == kanjiIds ? _self.kanjiIds : kanjiIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularySegment].
extension VocabularySegmentPatterns on VocabularySegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularySegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularySegment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularySegment value)  $default,){
final _that = this;
switch (_that) {
case _VocabularySegment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularySegment value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularySegment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String? reading,  int? kanjiId,  List<int>? kanjiIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularySegment() when $default != null:
return $default(_that.text,_that.reading,_that.kanjiId,_that.kanjiIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String? reading,  int? kanjiId,  List<int>? kanjiIds)  $default,) {final _that = this;
switch (_that) {
case _VocabularySegment():
return $default(_that.text,_that.reading,_that.kanjiId,_that.kanjiIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String? reading,  int? kanjiId,  List<int>? kanjiIds)?  $default,) {final _that = this;
switch (_that) {
case _VocabularySegment() when $default != null:
return $default(_that.text,_that.reading,_that.kanjiId,_that.kanjiIds);case _:
  return null;

}
}

}

/// @nodoc


class _VocabularySegment implements VocabularySegment {
  const _VocabularySegment({required this.text, this.reading, this.kanjiId, final  List<int>? kanjiIds}): _kanjiIds = kanjiIds;
  

@override final  String text;
@override final  String? reading;
@override final  int? kanjiId;
 final  List<int>? _kanjiIds;
@override List<int>? get kanjiIds {
  final value = _kanjiIds;
  if (value == null) return null;
  if (_kanjiIds is EqualUnmodifiableListView) return _kanjiIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of VocabularySegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularySegmentCopyWith<_VocabularySegment> get copyWith => __$VocabularySegmentCopyWithImpl<_VocabularySegment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularySegment&&(identical(other.text, text) || other.text == text)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.kanjiId, kanjiId) || other.kanjiId == kanjiId)&&const DeepCollectionEquality().equals(other._kanjiIds, _kanjiIds));
}


@override
int get hashCode => Object.hash(runtimeType,text,reading,kanjiId,const DeepCollectionEquality().hash(_kanjiIds));

@override
String toString() {
  return 'VocabularySegment(text: $text, reading: $reading, kanjiId: $kanjiId, kanjiIds: $kanjiIds)';
}


}

/// @nodoc
abstract mixin class _$VocabularySegmentCopyWith<$Res> implements $VocabularySegmentCopyWith<$Res> {
  factory _$VocabularySegmentCopyWith(_VocabularySegment value, $Res Function(_VocabularySegment) _then) = __$VocabularySegmentCopyWithImpl;
@override @useResult
$Res call({
 String text, String? reading, int? kanjiId, List<int>? kanjiIds
});




}
/// @nodoc
class __$VocabularySegmentCopyWithImpl<$Res>
    implements _$VocabularySegmentCopyWith<$Res> {
  __$VocabularySegmentCopyWithImpl(this._self, this._then);

  final _VocabularySegment _self;
  final $Res Function(_VocabularySegment) _then;

/// Create a copy of VocabularySegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? reading = freezed,Object? kanjiId = freezed,Object? kanjiIds = freezed,}) {
  return _then(_VocabularySegment(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reading: freezed == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as String?,kanjiId: freezed == kanjiId ? _self.kanjiId : kanjiId // ignore: cast_nullable_to_non_nullable
as int?,kanjiIds: freezed == kanjiIds ? _self._kanjiIds : kanjiIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}

// dart format on
