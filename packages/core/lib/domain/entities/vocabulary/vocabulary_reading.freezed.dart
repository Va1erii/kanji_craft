// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabularyReading {

 int get id; int get vocabularyId; String get reading; ReadingPriority get priority; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of VocabularyReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyReadingCopyWith<VocabularyReading> get copyWith => _$VocabularyReadingCopyWithImpl<VocabularyReading>(this as VocabularyReading, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyReading&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularyId, vocabularyId) || other.vocabularyId == vocabularyId)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vocabularyId,reading,priority,createdAt,updatedAt);

@override
String toString() {
  return 'VocabularyReading(id: $id, vocabularyId: $vocabularyId, reading: $reading, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VocabularyReadingCopyWith<$Res>  {
  factory $VocabularyReadingCopyWith(VocabularyReading value, $Res Function(VocabularyReading) _then) = _$VocabularyReadingCopyWithImpl;
@useResult
$Res call({
 int id, int vocabularyId, String reading, ReadingPriority priority, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$VocabularyReadingCopyWithImpl<$Res>
    implements $VocabularyReadingCopyWith<$Res> {
  _$VocabularyReadingCopyWithImpl(this._self, this._then);

  final VocabularyReading _self;
  final $Res Function(VocabularyReading) _then;

/// Create a copy of VocabularyReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vocabularyId = null,Object? reading = null,Object? priority = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vocabularyId: null == vocabularyId ? _self.vocabularyId : vocabularyId // ignore: cast_nullable_to_non_nullable
as int,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ReadingPriority,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularyReading].
extension VocabularyReadingPatterns on VocabularyReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularyReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularyReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularyReading value)  $default,){
final _that = this;
switch (_that) {
case _VocabularyReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularyReading value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularyReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vocabularyId,  String reading,  ReadingPriority priority,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularyReading() when $default != null:
return $default(_that.id,_that.vocabularyId,_that.reading,_that.priority,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vocabularyId,  String reading,  ReadingPriority priority,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _VocabularyReading():
return $default(_that.id,_that.vocabularyId,_that.reading,_that.priority,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vocabularyId,  String reading,  ReadingPriority priority,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _VocabularyReading() when $default != null:
return $default(_that.id,_that.vocabularyId,_that.reading,_that.priority,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _VocabularyReading implements VocabularyReading {
  const _VocabularyReading({required this.id, required this.vocabularyId, required this.reading, required this.priority, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int vocabularyId;
@override final  String reading;
@override final  ReadingPriority priority;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of VocabularyReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyReadingCopyWith<_VocabularyReading> get copyWith => __$VocabularyReadingCopyWithImpl<_VocabularyReading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyReading&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularyId, vocabularyId) || other.vocabularyId == vocabularyId)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vocabularyId,reading,priority,createdAt,updatedAt);

@override
String toString() {
  return 'VocabularyReading(id: $id, vocabularyId: $vocabularyId, reading: $reading, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VocabularyReadingCopyWith<$Res> implements $VocabularyReadingCopyWith<$Res> {
  factory _$VocabularyReadingCopyWith(_VocabularyReading value, $Res Function(_VocabularyReading) _then) = __$VocabularyReadingCopyWithImpl;
@override @useResult
$Res call({
 int id, int vocabularyId, String reading, ReadingPriority priority, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$VocabularyReadingCopyWithImpl<$Res>
    implements _$VocabularyReadingCopyWith<$Res> {
  __$VocabularyReadingCopyWithImpl(this._self, this._then);

  final _VocabularyReading _self;
  final $Res Function(_VocabularyReading) _then;

/// Create a copy of VocabularyReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vocabularyId = null,Object? reading = null,Object? priority = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_VocabularyReading(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vocabularyId: null == vocabularyId ? _self.vocabularyId : vocabularyId // ignore: cast_nullable_to_non_nullable
as int,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ReadingPriority,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
