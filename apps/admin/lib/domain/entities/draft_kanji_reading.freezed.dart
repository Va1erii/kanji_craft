// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_kanji_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftKanjiReading {

 int get id; int get draftKanjiId; String get reading; ReadingType get readingType; ReadingPriority get priority; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DraftKanjiReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftKanjiReadingCopyWith<DraftKanjiReading> get copyWith => _$DraftKanjiReadingCopyWithImpl<DraftKanjiReading>(this as DraftKanjiReading, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftKanjiReading&&(identical(other.id, id) || other.id == id)&&(identical(other.draftKanjiId, draftKanjiId) || other.draftKanjiId == draftKanjiId)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.readingType, readingType) || other.readingType == readingType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,draftKanjiId,reading,readingType,priority,createdAt,updatedAt);

@override
String toString() {
  return 'DraftKanjiReading(id: $id, draftKanjiId: $draftKanjiId, reading: $reading, readingType: $readingType, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DraftKanjiReadingCopyWith<$Res>  {
  factory $DraftKanjiReadingCopyWith(DraftKanjiReading value, $Res Function(DraftKanjiReading) _then) = _$DraftKanjiReadingCopyWithImpl;
@useResult
$Res call({
 int id, int draftKanjiId, String reading, ReadingType readingType, ReadingPriority priority, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DraftKanjiReadingCopyWithImpl<$Res>
    implements $DraftKanjiReadingCopyWith<$Res> {
  _$DraftKanjiReadingCopyWithImpl(this._self, this._then);

  final DraftKanjiReading _self;
  final $Res Function(DraftKanjiReading) _then;

/// Create a copy of DraftKanjiReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? draftKanjiId = null,Object? reading = null,Object? readingType = null,Object? priority = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,draftKanjiId: null == draftKanjiId ? _self.draftKanjiId : draftKanjiId // ignore: cast_nullable_to_non_nullable
as int,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as String,readingType: null == readingType ? _self.readingType : readingType // ignore: cast_nullable_to_non_nullable
as ReadingType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ReadingPriority,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftKanjiReading].
extension DraftKanjiReadingPatterns on DraftKanjiReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftKanjiReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftKanjiReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftKanjiReading value)  $default,){
final _that = this;
switch (_that) {
case _DraftKanjiReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftKanjiReading value)?  $default,){
final _that = this;
switch (_that) {
case _DraftKanjiReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int draftKanjiId,  String reading,  ReadingType readingType,  ReadingPriority priority,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftKanjiReading() when $default != null:
return $default(_that.id,_that.draftKanjiId,_that.reading,_that.readingType,_that.priority,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int draftKanjiId,  String reading,  ReadingType readingType,  ReadingPriority priority,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DraftKanjiReading():
return $default(_that.id,_that.draftKanjiId,_that.reading,_that.readingType,_that.priority,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int draftKanjiId,  String reading,  ReadingType readingType,  ReadingPriority priority,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DraftKanjiReading() when $default != null:
return $default(_that.id,_that.draftKanjiId,_that.reading,_that.readingType,_that.priority,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DraftKanjiReading implements DraftKanjiReading {
  const _DraftKanjiReading({required this.id, required this.draftKanjiId, required this.reading, required this.readingType, required this.priority, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int draftKanjiId;
@override final  String reading;
@override final  ReadingType readingType;
@override final  ReadingPriority priority;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DraftKanjiReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftKanjiReadingCopyWith<_DraftKanjiReading> get copyWith => __$DraftKanjiReadingCopyWithImpl<_DraftKanjiReading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftKanjiReading&&(identical(other.id, id) || other.id == id)&&(identical(other.draftKanjiId, draftKanjiId) || other.draftKanjiId == draftKanjiId)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.readingType, readingType) || other.readingType == readingType)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,draftKanjiId,reading,readingType,priority,createdAt,updatedAt);

@override
String toString() {
  return 'DraftKanjiReading(id: $id, draftKanjiId: $draftKanjiId, reading: $reading, readingType: $readingType, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DraftKanjiReadingCopyWith<$Res> implements $DraftKanjiReadingCopyWith<$Res> {
  factory _$DraftKanjiReadingCopyWith(_DraftKanjiReading value, $Res Function(_DraftKanjiReading) _then) = __$DraftKanjiReadingCopyWithImpl;
@override @useResult
$Res call({
 int id, int draftKanjiId, String reading, ReadingType readingType, ReadingPriority priority, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DraftKanjiReadingCopyWithImpl<$Res>
    implements _$DraftKanjiReadingCopyWith<$Res> {
  __$DraftKanjiReadingCopyWithImpl(this._self, this._then);

  final _DraftKanjiReading _self;
  final $Res Function(_DraftKanjiReading) _then;

/// Create a copy of DraftKanjiReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? draftKanjiId = null,Object? reading = null,Object? readingType = null,Object? priority = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DraftKanjiReading(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,draftKanjiId: null == draftKanjiId ? _self.draftKanjiId : draftKanjiId // ignore: cast_nullable_to_non_nullable
as int,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as String,readingType: null == readingType ? _self.readingType : readingType // ignore: cast_nullable_to_non_nullable
as ReadingType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ReadingPriority,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
