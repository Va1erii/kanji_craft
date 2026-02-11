// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extraction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExtractionState {

 Map<ExtractionPhase, PhaseStatus> get phases;
/// Create a copy of ExtractionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractionStateCopyWith<ExtractionState> get copyWith => _$ExtractionStateCopyWithImpl<ExtractionState>(this as ExtractionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionState&&const DeepCollectionEquality().equals(other.phases, phases));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(phases));

@override
String toString() {
  return 'ExtractionState(phases: $phases)';
}


}

/// @nodoc
abstract mixin class $ExtractionStateCopyWith<$Res>  {
  factory $ExtractionStateCopyWith(ExtractionState value, $Res Function(ExtractionState) _then) = _$ExtractionStateCopyWithImpl;
@useResult
$Res call({
 Map<ExtractionPhase, PhaseStatus> phases
});




}
/// @nodoc
class _$ExtractionStateCopyWithImpl<$Res>
    implements $ExtractionStateCopyWith<$Res> {
  _$ExtractionStateCopyWithImpl(this._self, this._then);

  final ExtractionState _self;
  final $Res Function(ExtractionState) _then;

/// Create a copy of ExtractionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phases = null,}) {
  return _then(_self.copyWith(
phases: null == phases ? _self.phases : phases // ignore: cast_nullable_to_non_nullable
as Map<ExtractionPhase, PhaseStatus>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractionState].
extension ExtractionStatePatterns on ExtractionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractionState value)  $default,){
final _that = this;
switch (_that) {
case _ExtractionState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractionState value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<ExtractionPhase, PhaseStatus> phases)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractionState() when $default != null:
return $default(_that.phases);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<ExtractionPhase, PhaseStatus> phases)  $default,) {final _that = this;
switch (_that) {
case _ExtractionState():
return $default(_that.phases);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<ExtractionPhase, PhaseStatus> phases)?  $default,) {final _that = this;
switch (_that) {
case _ExtractionState() when $default != null:
return $default(_that.phases);case _:
  return null;

}
}

}

/// @nodoc


class _ExtractionState implements ExtractionState {
  const _ExtractionState({final  Map<ExtractionPhase, PhaseStatus> phases = const {}}): _phases = phases;
  

 final  Map<ExtractionPhase, PhaseStatus> _phases;
@override@JsonKey() Map<ExtractionPhase, PhaseStatus> get phases {
  if (_phases is EqualUnmodifiableMapView) return _phases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_phases);
}


/// Create a copy of ExtractionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractionStateCopyWith<_ExtractionState> get copyWith => __$ExtractionStateCopyWithImpl<_ExtractionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractionState&&const DeepCollectionEquality().equals(other._phases, _phases));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_phases));

@override
String toString() {
  return 'ExtractionState(phases: $phases)';
}


}

/// @nodoc
abstract mixin class _$ExtractionStateCopyWith<$Res> implements $ExtractionStateCopyWith<$Res> {
  factory _$ExtractionStateCopyWith(_ExtractionState value, $Res Function(_ExtractionState) _then) = __$ExtractionStateCopyWithImpl;
@override @useResult
$Res call({
 Map<ExtractionPhase, PhaseStatus> phases
});




}
/// @nodoc
class __$ExtractionStateCopyWithImpl<$Res>
    implements _$ExtractionStateCopyWith<$Res> {
  __$ExtractionStateCopyWithImpl(this._self, this._then);

  final _ExtractionState _self;
  final $Res Function(_ExtractionState) _then;

/// Create a copy of ExtractionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phases = null,}) {
  return _then(_ExtractionState(
phases: null == phases ? _self._phases : phases // ignore: cast_nullable_to_non_nullable
as Map<ExtractionPhase, PhaseStatus>,
  ));
}


}

// dart format on
