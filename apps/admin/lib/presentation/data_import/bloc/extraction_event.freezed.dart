// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extraction_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExtractionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExtractionEvent()';
}


}

/// @nodoc
class $ExtractionEventCopyWith<$Res>  {
$ExtractionEventCopyWith(ExtractionEvent _, $Res Function(ExtractionEvent) __);
}


/// Adds pattern-matching-related methods to [ExtractionEvent].
extension ExtractionEventPatterns on ExtractionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ImportsUpdated value)?  importsUpdated,TResult Function( _RunPhase value)?  runPhase,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that);case _RunPhase() when runPhase != null:
return runPhase(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ImportsUpdated value)  importsUpdated,required TResult Function( _RunPhase value)  runPhase,}){
final _that = this;
switch (_that) {
case _ImportsUpdated():
return importsUpdated(_that);case _RunPhase():
return runPhase(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ImportsUpdated value)?  importsUpdated,TResult? Function( _RunPhase value)?  runPhase,}){
final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that);case _RunPhase() when runPhase != null:
return runPhase(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<DataImport> imports)?  importsUpdated,TResult Function( ExtractionPhase phase)?  runPhase,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that.imports);case _RunPhase() when runPhase != null:
return runPhase(_that.phase);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<DataImport> imports)  importsUpdated,required TResult Function( ExtractionPhase phase)  runPhase,}) {final _that = this;
switch (_that) {
case _ImportsUpdated():
return importsUpdated(_that.imports);case _RunPhase():
return runPhase(_that.phase);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<DataImport> imports)?  importsUpdated,TResult? Function( ExtractionPhase phase)?  runPhase,}) {final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that.imports);case _RunPhase() when runPhase != null:
return runPhase(_that.phase);case _:
  return null;

}
}

}

/// @nodoc


class _ImportsUpdated implements ExtractionEvent {
  const _ImportsUpdated({required final  List<DataImport> imports}): _imports = imports;
  

 final  List<DataImport> _imports;
 List<DataImport> get imports {
  if (_imports is EqualUnmodifiableListView) return _imports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imports);
}


/// Create a copy of ExtractionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportsUpdatedCopyWith<_ImportsUpdated> get copyWith => __$ImportsUpdatedCopyWithImpl<_ImportsUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportsUpdated&&const DeepCollectionEquality().equals(other._imports, _imports));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_imports));

@override
String toString() {
  return 'ExtractionEvent.importsUpdated(imports: $imports)';
}


}

/// @nodoc
abstract mixin class _$ImportsUpdatedCopyWith<$Res> implements $ExtractionEventCopyWith<$Res> {
  factory _$ImportsUpdatedCopyWith(_ImportsUpdated value, $Res Function(_ImportsUpdated) _then) = __$ImportsUpdatedCopyWithImpl;
@useResult
$Res call({
 List<DataImport> imports
});




}
/// @nodoc
class __$ImportsUpdatedCopyWithImpl<$Res>
    implements _$ImportsUpdatedCopyWith<$Res> {
  __$ImportsUpdatedCopyWithImpl(this._self, this._then);

  final _ImportsUpdated _self;
  final $Res Function(_ImportsUpdated) _then;

/// Create a copy of ExtractionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? imports = null,}) {
  return _then(_ImportsUpdated(
imports: null == imports ? _self._imports : imports // ignore: cast_nullable_to_non_nullable
as List<DataImport>,
  ));
}


}

/// @nodoc


class _RunPhase implements ExtractionEvent {
  const _RunPhase({required this.phase});
  

 final  ExtractionPhase phase;

/// Create a copy of ExtractionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunPhaseCopyWith<_RunPhase> get copyWith => __$RunPhaseCopyWithImpl<_RunPhase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunPhase&&(identical(other.phase, phase) || other.phase == phase));
}


@override
int get hashCode => Object.hash(runtimeType,phase);

@override
String toString() {
  return 'ExtractionEvent.runPhase(phase: $phase)';
}


}

/// @nodoc
abstract mixin class _$RunPhaseCopyWith<$Res> implements $ExtractionEventCopyWith<$Res> {
  factory _$RunPhaseCopyWith(_RunPhase value, $Res Function(_RunPhase) _then) = __$RunPhaseCopyWithImpl;
@useResult
$Res call({
 ExtractionPhase phase
});




}
/// @nodoc
class __$RunPhaseCopyWithImpl<$Res>
    implements _$RunPhaseCopyWith<$Res> {
  __$RunPhaseCopyWithImpl(this._self, this._then);

  final _RunPhase _self;
  final $Res Function(_RunPhase) _then;

/// Create a copy of ExtractionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phase = null,}) {
  return _then(_RunPhase(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ExtractionPhase,
  ));
}


}

// dart format on
