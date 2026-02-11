// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hydration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HydrationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HydrationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HydrationState()';
}


}

/// @nodoc
class $HydrationStateCopyWith<$Res>  {
$HydrationStateCopyWith(HydrationState _, $Res Function(HydrationState) __);
}


/// Adds pattern-matching-related methods to [HydrationState].
extension HydrationStatePatterns on HydrationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HydrationInProgress value)?  inProgress,TResult Function( _Completed value)?  completed,TResult Function( _Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HydrationInProgress() when inProgress != null:
return inProgress(_that);case _Completed() when completed != null:
return completed(_that);case _Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HydrationInProgress value)  inProgress,required TResult Function( _Completed value)  completed,required TResult Function( _Failed value)  failed,}){
final _that = this;
switch (_that) {
case HydrationInProgress():
return inProgress(_that);case _Completed():
return completed(_that);case _Failed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HydrationInProgress value)?  inProgress,TResult? Function( _Completed value)?  completed,TResult? Function( _Failed value)?  failed,}){
final _that = this;
switch (_that) {
case HydrationInProgress() when inProgress != null:
return inProgress(_that);case _Completed() when completed != null:
return completed(_that);case _Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String step)?  inProgress,TResult Function()?  completed,TResult Function( String message)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HydrationInProgress() when inProgress != null:
return inProgress(_that.step);case _Completed() when completed != null:
return completed();case _Failed() when failed != null:
return failed(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String step)  inProgress,required TResult Function()  completed,required TResult Function( String message)  failed,}) {final _that = this;
switch (_that) {
case HydrationInProgress():
return inProgress(_that.step);case _Completed():
return completed();case _Failed():
return failed(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String step)?  inProgress,TResult? Function()?  completed,TResult? Function( String message)?  failed,}) {final _that = this;
switch (_that) {
case HydrationInProgress() when inProgress != null:
return inProgress(_that.step);case _Completed() when completed != null:
return completed();case _Failed() when failed != null:
return failed(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HydrationInProgress implements HydrationState {
  const HydrationInProgress(this.step);
  

 final  String step;

/// Create a copy of HydrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HydrationInProgressCopyWith<HydrationInProgress> get copyWith => _$HydrationInProgressCopyWithImpl<HydrationInProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HydrationInProgress&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,step);

@override
String toString() {
  return 'HydrationState.inProgress(step: $step)';
}


}

/// @nodoc
abstract mixin class $HydrationInProgressCopyWith<$Res> implements $HydrationStateCopyWith<$Res> {
  factory $HydrationInProgressCopyWith(HydrationInProgress value, $Res Function(HydrationInProgress) _then) = _$HydrationInProgressCopyWithImpl;
@useResult
$Res call({
 String step
});




}
/// @nodoc
class _$HydrationInProgressCopyWithImpl<$Res>
    implements $HydrationInProgressCopyWith<$Res> {
  _$HydrationInProgressCopyWithImpl(this._self, this._then);

  final HydrationInProgress _self;
  final $Res Function(HydrationInProgress) _then;

/// Create a copy of HydrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? step = null,}) {
  return _then(HydrationInProgress(
null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Completed implements HydrationState {
  const _Completed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Completed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HydrationState.completed()';
}


}




/// @nodoc


class _Failed implements HydrationState {
  const _Failed(this.message);
  

 final  String message;

/// Create a copy of HydrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailedCopyWith<_Failed> get copyWith => __$FailedCopyWithImpl<_Failed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HydrationState.failed(message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailedCopyWith<$Res> implements $HydrationStateCopyWith<$Res> {
  factory _$FailedCopyWith(_Failed value, $Res Function(_Failed) _then) = __$FailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$FailedCopyWithImpl<$Res>
    implements _$FailedCopyWith<$Res> {
  __$FailedCopyWithImpl(this._self, this._then);

  final _Failed _self;
  final $Res Function(_Failed) _then;

/// Create a copy of HydrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Failed(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
