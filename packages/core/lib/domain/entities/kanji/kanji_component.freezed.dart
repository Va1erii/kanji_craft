// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanji_component.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KanjiComponent {

 int get id; int get kanjiId; int get radicalId; Position get position; LogicHint get logicHint; RadicalType get radicalType; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of KanjiComponent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiComponentCopyWith<KanjiComponent> get copyWith => _$KanjiComponentCopyWithImpl<KanjiComponent>(this as KanjiComponent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjiComponent&&(identical(other.id, id) || other.id == id)&&(identical(other.kanjiId, kanjiId) || other.kanjiId == kanjiId)&&(identical(other.radicalId, radicalId) || other.radicalId == radicalId)&&(identical(other.position, position) || other.position == position)&&(identical(other.logicHint, logicHint) || other.logicHint == logicHint)&&(identical(other.radicalType, radicalType) || other.radicalType == radicalType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kanjiId,radicalId,position,logicHint,radicalType,createdAt,updatedAt);

@override
String toString() {
  return 'KanjiComponent(id: $id, kanjiId: $kanjiId, radicalId: $radicalId, position: $position, logicHint: $logicHint, radicalType: $radicalType, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $KanjiComponentCopyWith<$Res>  {
  factory $KanjiComponentCopyWith(KanjiComponent value, $Res Function(KanjiComponent) _then) = _$KanjiComponentCopyWithImpl;
@useResult
$Res call({
 int id, int kanjiId, int radicalId, Position position, LogicHint logicHint, RadicalType radicalType, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$KanjiComponentCopyWithImpl<$Res>
    implements $KanjiComponentCopyWith<$Res> {
  _$KanjiComponentCopyWithImpl(this._self, this._then);

  final KanjiComponent _self;
  final $Res Function(KanjiComponent) _then;

/// Create a copy of KanjiComponent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kanjiId = null,Object? radicalId = null,Object? position = null,Object? logicHint = null,Object? radicalType = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kanjiId: null == kanjiId ? _self.kanjiId : kanjiId // ignore: cast_nullable_to_non_nullable
as int,radicalId: null == radicalId ? _self.radicalId : radicalId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,logicHint: null == logicHint ? _self.logicHint : logicHint // ignore: cast_nullable_to_non_nullable
as LogicHint,radicalType: null == radicalType ? _self.radicalType : radicalType // ignore: cast_nullable_to_non_nullable
as RadicalType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjiComponent].
extension KanjiComponentPatterns on KanjiComponent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjiComponent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjiComponent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjiComponent value)  $default,){
final _that = this;
switch (_that) {
case _KanjiComponent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjiComponent value)?  $default,){
final _that = this;
switch (_that) {
case _KanjiComponent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int kanjiId,  int radicalId,  Position position,  LogicHint logicHint,  RadicalType radicalType,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjiComponent() when $default != null:
return $default(_that.id,_that.kanjiId,_that.radicalId,_that.position,_that.logicHint,_that.radicalType,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int kanjiId,  int radicalId,  Position position,  LogicHint logicHint,  RadicalType radicalType,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _KanjiComponent():
return $default(_that.id,_that.kanjiId,_that.radicalId,_that.position,_that.logicHint,_that.radicalType,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int kanjiId,  int radicalId,  Position position,  LogicHint logicHint,  RadicalType radicalType,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _KanjiComponent() when $default != null:
return $default(_that.id,_that.kanjiId,_that.radicalId,_that.position,_that.logicHint,_that.radicalType,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _KanjiComponent extends KanjiComponent {
  const _KanjiComponent({required this.id, required this.kanjiId, required this.radicalId, required this.position, required this.logicHint, required this.radicalType, required this.createdAt, required this.updatedAt}): super._();
  

@override final  int id;
@override final  int kanjiId;
@override final  int radicalId;
@override final  Position position;
@override final  LogicHint logicHint;
@override final  RadicalType radicalType;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of KanjiComponent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiComponentCopyWith<_KanjiComponent> get copyWith => __$KanjiComponentCopyWithImpl<_KanjiComponent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjiComponent&&(identical(other.id, id) || other.id == id)&&(identical(other.kanjiId, kanjiId) || other.kanjiId == kanjiId)&&(identical(other.radicalId, radicalId) || other.radicalId == radicalId)&&(identical(other.position, position) || other.position == position)&&(identical(other.logicHint, logicHint) || other.logicHint == logicHint)&&(identical(other.radicalType, radicalType) || other.radicalType == radicalType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kanjiId,radicalId,position,logicHint,radicalType,createdAt,updatedAt);

@override
String toString() {
  return 'KanjiComponent(id: $id, kanjiId: $kanjiId, radicalId: $radicalId, position: $position, logicHint: $logicHint, radicalType: $radicalType, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$KanjiComponentCopyWith<$Res> implements $KanjiComponentCopyWith<$Res> {
  factory _$KanjiComponentCopyWith(_KanjiComponent value, $Res Function(_KanjiComponent) _then) = __$KanjiComponentCopyWithImpl;
@override @useResult
$Res call({
 int id, int kanjiId, int radicalId, Position position, LogicHint logicHint, RadicalType radicalType, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$KanjiComponentCopyWithImpl<$Res>
    implements _$KanjiComponentCopyWith<$Res> {
  __$KanjiComponentCopyWithImpl(this._self, this._then);

  final _KanjiComponent _self;
  final $Res Function(_KanjiComponent) _then;

/// Create a copy of KanjiComponent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kanjiId = null,Object? radicalId = null,Object? position = null,Object? logicHint = null,Object? radicalType = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_KanjiComponent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kanjiId: null == kanjiId ? _self.kanjiId : kanjiId // ignore: cast_nullable_to_non_nullable
as int,radicalId: null == radicalId ? _self.radicalId : radicalId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,logicHint: null == logicHint ? _self.logicHint : logicHint // ignore: cast_nullable_to_non_nullable
as LogicHint,radicalType: null == radicalType ? _self.radicalType : radicalType // ignore: cast_nullable_to_non_nullable
as RadicalType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
