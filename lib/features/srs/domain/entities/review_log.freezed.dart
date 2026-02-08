// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewLog {

 int get id; int get cardId; Rating get rating; CardState get stateBefore; double get stabilityBefore; double get difficultyBefore; DateTime get reviewedAt; DateTime get createdAt;
/// Create a copy of ReviewLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewLogCopyWith<ReviewLog> get copyWith => _$ReviewLogCopyWithImpl<ReviewLog>(this as ReviewLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewLog&&(identical(other.id, id) || other.id == id)&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.stateBefore, stateBefore) || other.stateBefore == stateBefore)&&(identical(other.stabilityBefore, stabilityBefore) || other.stabilityBefore == stabilityBefore)&&(identical(other.difficultyBefore, difficultyBefore) || other.difficultyBefore == difficultyBefore)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,cardId,rating,stateBefore,stabilityBefore,difficultyBefore,reviewedAt,createdAt);

@override
String toString() {
  return 'ReviewLog(id: $id, cardId: $cardId, rating: $rating, stateBefore: $stateBefore, stabilityBefore: $stabilityBefore, difficultyBefore: $difficultyBefore, reviewedAt: $reviewedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReviewLogCopyWith<$Res>  {
  factory $ReviewLogCopyWith(ReviewLog value, $Res Function(ReviewLog) _then) = _$ReviewLogCopyWithImpl;
@useResult
$Res call({
 int id, int cardId, Rating rating, CardState stateBefore, double stabilityBefore, double difficultyBefore, DateTime reviewedAt, DateTime createdAt
});




}
/// @nodoc
class _$ReviewLogCopyWithImpl<$Res>
    implements $ReviewLogCopyWith<$Res> {
  _$ReviewLogCopyWithImpl(this._self, this._then);

  final ReviewLog _self;
  final $Res Function(ReviewLog) _then;

/// Create a copy of ReviewLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cardId = null,Object? rating = null,Object? stateBefore = null,Object? stabilityBefore = null,Object? difficultyBefore = null,Object? reviewedAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as Rating,stateBefore: null == stateBefore ? _self.stateBefore : stateBefore // ignore: cast_nullable_to_non_nullable
as CardState,stabilityBefore: null == stabilityBefore ? _self.stabilityBefore : stabilityBefore // ignore: cast_nullable_to_non_nullable
as double,difficultyBefore: null == difficultyBefore ? _self.difficultyBefore : difficultyBefore // ignore: cast_nullable_to_non_nullable
as double,reviewedAt: null == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewLog].
extension ReviewLogPatterns on ReviewLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewLog value)  $default,){
final _that = this;
switch (_that) {
case _ReviewLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewLog value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int cardId,  Rating rating,  CardState stateBefore,  double stabilityBefore,  double difficultyBefore,  DateTime reviewedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewLog() when $default != null:
return $default(_that.id,_that.cardId,_that.rating,_that.stateBefore,_that.stabilityBefore,_that.difficultyBefore,_that.reviewedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int cardId,  Rating rating,  CardState stateBefore,  double stabilityBefore,  double difficultyBefore,  DateTime reviewedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReviewLog():
return $default(_that.id,_that.cardId,_that.rating,_that.stateBefore,_that.stabilityBefore,_that.difficultyBefore,_that.reviewedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int cardId,  Rating rating,  CardState stateBefore,  double stabilityBefore,  double difficultyBefore,  DateTime reviewedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReviewLog() when $default != null:
return $default(_that.id,_that.cardId,_that.rating,_that.stateBefore,_that.stabilityBefore,_that.difficultyBefore,_that.reviewedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewLog implements ReviewLog {
  const _ReviewLog({required this.id, required this.cardId, required this.rating, required this.stateBefore, required this.stabilityBefore, required this.difficultyBefore, required this.reviewedAt, required this.createdAt});
  

@override final  int id;
@override final  int cardId;
@override final  Rating rating;
@override final  CardState stateBefore;
@override final  double stabilityBefore;
@override final  double difficultyBefore;
@override final  DateTime reviewedAt;
@override final  DateTime createdAt;

/// Create a copy of ReviewLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewLogCopyWith<_ReviewLog> get copyWith => __$ReviewLogCopyWithImpl<_ReviewLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewLog&&(identical(other.id, id) || other.id == id)&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.stateBefore, stateBefore) || other.stateBefore == stateBefore)&&(identical(other.stabilityBefore, stabilityBefore) || other.stabilityBefore == stabilityBefore)&&(identical(other.difficultyBefore, difficultyBefore) || other.difficultyBefore == difficultyBefore)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,cardId,rating,stateBefore,stabilityBefore,difficultyBefore,reviewedAt,createdAt);

@override
String toString() {
  return 'ReviewLog(id: $id, cardId: $cardId, rating: $rating, stateBefore: $stateBefore, stabilityBefore: $stabilityBefore, difficultyBefore: $difficultyBefore, reviewedAt: $reviewedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewLogCopyWith<$Res> implements $ReviewLogCopyWith<$Res> {
  factory _$ReviewLogCopyWith(_ReviewLog value, $Res Function(_ReviewLog) _then) = __$ReviewLogCopyWithImpl;
@override @useResult
$Res call({
 int id, int cardId, Rating rating, CardState stateBefore, double stabilityBefore, double difficultyBefore, DateTime reviewedAt, DateTime createdAt
});




}
/// @nodoc
class __$ReviewLogCopyWithImpl<$Res>
    implements _$ReviewLogCopyWith<$Res> {
  __$ReviewLogCopyWithImpl(this._self, this._then);

  final _ReviewLog _self;
  final $Res Function(_ReviewLog) _then;

/// Create a copy of ReviewLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cardId = null,Object? rating = null,Object? stateBefore = null,Object? stabilityBefore = null,Object? difficultyBefore = null,Object? reviewedAt = null,Object? createdAt = null,}) {
  return _then(_ReviewLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as Rating,stateBefore: null == stateBefore ? _self.stateBefore : stateBefore // ignore: cast_nullable_to_non_nullable
as CardState,stabilityBefore: null == stabilityBefore ? _self.stabilityBefore : stabilityBefore // ignore: cast_nullable_to_non_nullable
as double,difficultyBefore: null == difficultyBefore ? _self.difficultyBefore : difficultyBefore // ignore: cast_nullable_to_non_nullable
as double,reviewedAt: null == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
