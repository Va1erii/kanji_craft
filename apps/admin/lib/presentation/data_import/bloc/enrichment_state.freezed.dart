// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrichment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnrichmentState {

 String get outputDir; Map<EnrichmentBatchType, BatchTypeStatus> get batches; int get batchSize;
/// Create a copy of EnrichmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrichmentStateCopyWith<EnrichmentState> get copyWith => _$EnrichmentStateCopyWithImpl<EnrichmentState>(this as EnrichmentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrichmentState&&(identical(other.outputDir, outputDir) || other.outputDir == outputDir)&&const DeepCollectionEquality().equals(other.batches, batches)&&(identical(other.batchSize, batchSize) || other.batchSize == batchSize));
}


@override
int get hashCode => Object.hash(runtimeType,outputDir,const DeepCollectionEquality().hash(batches),batchSize);

@override
String toString() {
  return 'EnrichmentState(outputDir: $outputDir, batches: $batches, batchSize: $batchSize)';
}


}

/// @nodoc
abstract mixin class $EnrichmentStateCopyWith<$Res>  {
  factory $EnrichmentStateCopyWith(EnrichmentState value, $Res Function(EnrichmentState) _then) = _$EnrichmentStateCopyWithImpl;
@useResult
$Res call({
 String outputDir, Map<EnrichmentBatchType, BatchTypeStatus> batches, int batchSize
});




}
/// @nodoc
class _$EnrichmentStateCopyWithImpl<$Res>
    implements $EnrichmentStateCopyWith<$Res> {
  _$EnrichmentStateCopyWithImpl(this._self, this._then);

  final EnrichmentState _self;
  final $Res Function(EnrichmentState) _then;

/// Create a copy of EnrichmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outputDir = null,Object? batches = null,Object? batchSize = null,}) {
  return _then(_self.copyWith(
outputDir: null == outputDir ? _self.outputDir : outputDir // ignore: cast_nullable_to_non_nullable
as String,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as Map<EnrichmentBatchType, BatchTypeStatus>,batchSize: null == batchSize ? _self.batchSize : batchSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EnrichmentState].
extension EnrichmentStatePatterns on EnrichmentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrichmentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrichmentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrichmentState value)  $default,){
final _that = this;
switch (_that) {
case _EnrichmentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrichmentState value)?  $default,){
final _that = this;
switch (_that) {
case _EnrichmentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String outputDir,  Map<EnrichmentBatchType, BatchTypeStatus> batches,  int batchSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrichmentState() when $default != null:
return $default(_that.outputDir,_that.batches,_that.batchSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String outputDir,  Map<EnrichmentBatchType, BatchTypeStatus> batches,  int batchSize)  $default,) {final _that = this;
switch (_that) {
case _EnrichmentState():
return $default(_that.outputDir,_that.batches,_that.batchSize);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String outputDir,  Map<EnrichmentBatchType, BatchTypeStatus> batches,  int batchSize)?  $default,) {final _that = this;
switch (_that) {
case _EnrichmentState() when $default != null:
return $default(_that.outputDir,_that.batches,_that.batchSize);case _:
  return null;

}
}

}

/// @nodoc


class _EnrichmentState implements EnrichmentState {
  const _EnrichmentState({this.outputDir = '', final  Map<EnrichmentBatchType, BatchTypeStatus> batches = const {}, this.batchSize = 150}): _batches = batches;
  

@override@JsonKey() final  String outputDir;
 final  Map<EnrichmentBatchType, BatchTypeStatus> _batches;
@override@JsonKey() Map<EnrichmentBatchType, BatchTypeStatus> get batches {
  if (_batches is EqualUnmodifiableMapView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_batches);
}

@override@JsonKey() final  int batchSize;

/// Create a copy of EnrichmentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrichmentStateCopyWith<_EnrichmentState> get copyWith => __$EnrichmentStateCopyWithImpl<_EnrichmentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrichmentState&&(identical(other.outputDir, outputDir) || other.outputDir == outputDir)&&const DeepCollectionEquality().equals(other._batches, _batches)&&(identical(other.batchSize, batchSize) || other.batchSize == batchSize));
}


@override
int get hashCode => Object.hash(runtimeType,outputDir,const DeepCollectionEquality().hash(_batches),batchSize);

@override
String toString() {
  return 'EnrichmentState(outputDir: $outputDir, batches: $batches, batchSize: $batchSize)';
}


}

/// @nodoc
abstract mixin class _$EnrichmentStateCopyWith<$Res> implements $EnrichmentStateCopyWith<$Res> {
  factory _$EnrichmentStateCopyWith(_EnrichmentState value, $Res Function(_EnrichmentState) _then) = __$EnrichmentStateCopyWithImpl;
@override @useResult
$Res call({
 String outputDir, Map<EnrichmentBatchType, BatchTypeStatus> batches, int batchSize
});




}
/// @nodoc
class __$EnrichmentStateCopyWithImpl<$Res>
    implements _$EnrichmentStateCopyWith<$Res> {
  __$EnrichmentStateCopyWithImpl(this._self, this._then);

  final _EnrichmentState _self;
  final $Res Function(_EnrichmentState) _then;

/// Create a copy of EnrichmentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outputDir = null,Object? batches = null,Object? batchSize = null,}) {
  return _then(_EnrichmentState(
outputDir: null == outputDir ? _self.outputDir : outputDir // ignore: cast_nullable_to_non_nullable
as String,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as Map<EnrichmentBatchType, BatchTypeStatus>,batchSize: null == batchSize ? _self.batchSize : batchSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
