// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'srs_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SrsCard {

 int get id; String get userId; ItemType get itemType; int get itemId; CardState get state; DateTime get due; double get stability; double get difficulty; int get elapsedDays; int get scheduledDays; int get reps; int get lapses; DateTime? get lastReview; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SrsCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SrsCardCopyWith<SrsCard> get copyWith => _$SrsCardCopyWithImpl<SrsCard>(this as SrsCard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SrsCard&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.state, state) || other.state == state)&&(identical(other.due, due) || other.due == due)&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.elapsedDays, elapsedDays) || other.elapsedDays == elapsedDays)&&(identical(other.scheduledDays, scheduledDays) || other.scheduledDays == scheduledDays)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.lapses, lapses) || other.lapses == lapses)&&(identical(other.lastReview, lastReview) || other.lastReview == lastReview)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,itemType,itemId,state,due,stability,difficulty,elapsedDays,scheduledDays,reps,lapses,lastReview,createdAt,updatedAt);

@override
String toString() {
  return 'SrsCard(id: $id, userId: $userId, itemType: $itemType, itemId: $itemId, state: $state, due: $due, stability: $stability, difficulty: $difficulty, elapsedDays: $elapsedDays, scheduledDays: $scheduledDays, reps: $reps, lapses: $lapses, lastReview: $lastReview, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SrsCardCopyWith<$Res>  {
  factory $SrsCardCopyWith(SrsCard value, $Res Function(SrsCard) _then) = _$SrsCardCopyWithImpl;
@useResult
$Res call({
 int id, String userId, ItemType itemType, int itemId, CardState state, DateTime due, double stability, double difficulty, int elapsedDays, int scheduledDays, int reps, int lapses, DateTime? lastReview, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SrsCardCopyWithImpl<$Res>
    implements $SrsCardCopyWith<$Res> {
  _$SrsCardCopyWithImpl(this._self, this._then);

  final SrsCard _self;
  final $Res Function(SrsCard) _then;

/// Create a copy of SrsCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? itemType = null,Object? itemId = null,Object? state = null,Object? due = null,Object? stability = null,Object? difficulty = null,Object? elapsedDays = null,Object? scheduledDays = null,Object? reps = null,Object? lapses = null,Object? lastReview = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as ItemType,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as CardState,due: null == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DateTime,stability: null == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as double,elapsedDays: null == elapsedDays ? _self.elapsedDays : elapsedDays // ignore: cast_nullable_to_non_nullable
as int,scheduledDays: null == scheduledDays ? _self.scheduledDays : scheduledDays // ignore: cast_nullable_to_non_nullable
as int,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,lapses: null == lapses ? _self.lapses : lapses // ignore: cast_nullable_to_non_nullable
as int,lastReview: freezed == lastReview ? _self.lastReview : lastReview // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SrsCard].
extension SrsCardPatterns on SrsCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SrsCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SrsCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SrsCard value)  $default,){
final _that = this;
switch (_that) {
case _SrsCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SrsCard value)?  $default,){
final _that = this;
switch (_that) {
case _SrsCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String userId,  ItemType itemType,  int itemId,  CardState state,  DateTime due,  double stability,  double difficulty,  int elapsedDays,  int scheduledDays,  int reps,  int lapses,  DateTime? lastReview,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SrsCard() when $default != null:
return $default(_that.id,_that.userId,_that.itemType,_that.itemId,_that.state,_that.due,_that.stability,_that.difficulty,_that.elapsedDays,_that.scheduledDays,_that.reps,_that.lapses,_that.lastReview,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String userId,  ItemType itemType,  int itemId,  CardState state,  DateTime due,  double stability,  double difficulty,  int elapsedDays,  int scheduledDays,  int reps,  int lapses,  DateTime? lastReview,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SrsCard():
return $default(_that.id,_that.userId,_that.itemType,_that.itemId,_that.state,_that.due,_that.stability,_that.difficulty,_that.elapsedDays,_that.scheduledDays,_that.reps,_that.lapses,_that.lastReview,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String userId,  ItemType itemType,  int itemId,  CardState state,  DateTime due,  double stability,  double difficulty,  int elapsedDays,  int scheduledDays,  int reps,  int lapses,  DateTime? lastReview,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SrsCard() when $default != null:
return $default(_that.id,_that.userId,_that.itemType,_that.itemId,_that.state,_that.due,_that.stability,_that.difficulty,_that.elapsedDays,_that.scheduledDays,_that.reps,_that.lapses,_that.lastReview,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SrsCard implements SrsCard {
  const _SrsCard({required this.id, required this.userId, required this.itemType, required this.itemId, required this.state, required this.due, required this.stability, required this.difficulty, required this.elapsedDays, required this.scheduledDays, required this.reps, required this.lapses, this.lastReview, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  String userId;
@override final  ItemType itemType;
@override final  int itemId;
@override final  CardState state;
@override final  DateTime due;
@override final  double stability;
@override final  double difficulty;
@override final  int elapsedDays;
@override final  int scheduledDays;
@override final  int reps;
@override final  int lapses;
@override final  DateTime? lastReview;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SrsCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SrsCardCopyWith<_SrsCard> get copyWith => __$SrsCardCopyWithImpl<_SrsCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SrsCard&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.state, state) || other.state == state)&&(identical(other.due, due) || other.due == due)&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.elapsedDays, elapsedDays) || other.elapsedDays == elapsedDays)&&(identical(other.scheduledDays, scheduledDays) || other.scheduledDays == scheduledDays)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.lapses, lapses) || other.lapses == lapses)&&(identical(other.lastReview, lastReview) || other.lastReview == lastReview)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,itemType,itemId,state,due,stability,difficulty,elapsedDays,scheduledDays,reps,lapses,lastReview,createdAt,updatedAt);

@override
String toString() {
  return 'SrsCard(id: $id, userId: $userId, itemType: $itemType, itemId: $itemId, state: $state, due: $due, stability: $stability, difficulty: $difficulty, elapsedDays: $elapsedDays, scheduledDays: $scheduledDays, reps: $reps, lapses: $lapses, lastReview: $lastReview, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SrsCardCopyWith<$Res> implements $SrsCardCopyWith<$Res> {
  factory _$SrsCardCopyWith(_SrsCard value, $Res Function(_SrsCard) _then) = __$SrsCardCopyWithImpl;
@override @useResult
$Res call({
 int id, String userId, ItemType itemType, int itemId, CardState state, DateTime due, double stability, double difficulty, int elapsedDays, int scheduledDays, int reps, int lapses, DateTime? lastReview, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SrsCardCopyWithImpl<$Res>
    implements _$SrsCardCopyWith<$Res> {
  __$SrsCardCopyWithImpl(this._self, this._then);

  final _SrsCard _self;
  final $Res Function(_SrsCard) _then;

/// Create a copy of SrsCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? itemType = null,Object? itemId = null,Object? state = null,Object? due = null,Object? stability = null,Object? difficulty = null,Object? elapsedDays = null,Object? scheduledDays = null,Object? reps = null,Object? lapses = null,Object? lastReview = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SrsCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as ItemType,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as CardState,due: null == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DateTime,stability: null == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as double,elapsedDays: null == elapsedDays ? _self.elapsedDays : elapsedDays // ignore: cast_nullable_to_non_nullable
as int,scheduledDays: null == scheduledDays ? _self.scheduledDays : scheduledDays // ignore: cast_nullable_to_non_nullable
as int,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,lapses: null == lapses ? _self.lapses : lapses // ignore: cast_nullable_to_non_nullable
as int,lastReview: freezed == lastReview ? _self.lastReview : lastReview // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
