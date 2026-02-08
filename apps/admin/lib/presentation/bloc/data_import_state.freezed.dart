// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_import_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DataImportState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataImportState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DataImportState()';
}


}

/// @nodoc
class $DataImportStateCopyWith<$Res>  {
$DataImportStateCopyWith(DataImportState _, $Res Function(DataImportState) __);
}


/// Adds pattern-matching-related methods to [DataImportState].
extension DataImportStatePatterns on DataImportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( DataImportLoaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case DataImportLoaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( DataImportLoaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case DataImportLoaded():
return loaded(_that);case _Error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( DataImportLoaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case DataImportLoaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( List<DataImport> imports,  Map<int, IngestionProgress> activeIngestions)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case DataImportLoaded() when loaded != null:
return loaded(_that.imports,_that.activeIngestions);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( List<DataImport> imports,  Map<int, IngestionProgress> activeIngestions)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case DataImportLoaded():
return loaded(_that.imports,_that.activeIngestions);case _Error():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( List<DataImport> imports,  Map<int, IngestionProgress> activeIngestions)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case DataImportLoaded() when loaded != null:
return loaded(_that.imports,_that.activeIngestions);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements DataImportState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DataImportState.initial()';
}


}




/// @nodoc


class DataImportLoaded implements DataImportState {
  const DataImportLoaded({required final  List<DataImport> imports, final  Map<int, IngestionProgress> activeIngestions = const {}}): _imports = imports,_activeIngestions = activeIngestions;
  

 final  List<DataImport> _imports;
 List<DataImport> get imports {
  if (_imports is EqualUnmodifiableListView) return _imports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imports);
}

 final  Map<int, IngestionProgress> _activeIngestions;
@JsonKey() Map<int, IngestionProgress> get activeIngestions {
  if (_activeIngestions is EqualUnmodifiableMapView) return _activeIngestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_activeIngestions);
}


/// Create a copy of DataImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataImportLoadedCopyWith<DataImportLoaded> get copyWith => _$DataImportLoadedCopyWithImpl<DataImportLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataImportLoaded&&const DeepCollectionEquality().equals(other._imports, _imports)&&const DeepCollectionEquality().equals(other._activeIngestions, _activeIngestions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_imports),const DeepCollectionEquality().hash(_activeIngestions));

@override
String toString() {
  return 'DataImportState.loaded(imports: $imports, activeIngestions: $activeIngestions)';
}


}

/// @nodoc
abstract mixin class $DataImportLoadedCopyWith<$Res> implements $DataImportStateCopyWith<$Res> {
  factory $DataImportLoadedCopyWith(DataImportLoaded value, $Res Function(DataImportLoaded) _then) = _$DataImportLoadedCopyWithImpl;
@useResult
$Res call({
 List<DataImport> imports, Map<int, IngestionProgress> activeIngestions
});




}
/// @nodoc
class _$DataImportLoadedCopyWithImpl<$Res>
    implements $DataImportLoadedCopyWith<$Res> {
  _$DataImportLoadedCopyWithImpl(this._self, this._then);

  final DataImportLoaded _self;
  final $Res Function(DataImportLoaded) _then;

/// Create a copy of DataImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? imports = null,Object? activeIngestions = null,}) {
  return _then(DataImportLoaded(
imports: null == imports ? _self._imports : imports // ignore: cast_nullable_to_non_nullable
as List<DataImport>,activeIngestions: null == activeIngestions ? _self._activeIngestions : activeIngestions // ignore: cast_nullable_to_non_nullable
as Map<int, IngestionProgress>,
  ));
}


}

/// @nodoc


class _Error implements DataImportState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of DataImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DataImportState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $DataImportStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of DataImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$IngestionProgress {

 int get inserted; int get total;
/// Create a copy of IngestionProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngestionProgressCopyWith<IngestionProgress> get copyWith => _$IngestionProgressCopyWithImpl<IngestionProgress>(this as IngestionProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngestionProgress&&(identical(other.inserted, inserted) || other.inserted == inserted)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,inserted,total);

@override
String toString() {
  return 'IngestionProgress(inserted: $inserted, total: $total)';
}


}

/// @nodoc
abstract mixin class $IngestionProgressCopyWith<$Res>  {
  factory $IngestionProgressCopyWith(IngestionProgress value, $Res Function(IngestionProgress) _then) = _$IngestionProgressCopyWithImpl;
@useResult
$Res call({
 int inserted, int total
});




}
/// @nodoc
class _$IngestionProgressCopyWithImpl<$Res>
    implements $IngestionProgressCopyWith<$Res> {
  _$IngestionProgressCopyWithImpl(this._self, this._then);

  final IngestionProgress _self;
  final $Res Function(IngestionProgress) _then;

/// Create a copy of IngestionProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inserted = null,Object? total = null,}) {
  return _then(_self.copyWith(
inserted: null == inserted ? _self.inserted : inserted // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IngestionProgress].
extension IngestionProgressPatterns on IngestionProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngestionProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngestionProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngestionProgress value)  $default,){
final _that = this;
switch (_that) {
case _IngestionProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngestionProgress value)?  $default,){
final _that = this;
switch (_that) {
case _IngestionProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int inserted,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngestionProgress() when $default != null:
return $default(_that.inserted,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int inserted,  int total)  $default,) {final _that = this;
switch (_that) {
case _IngestionProgress():
return $default(_that.inserted,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int inserted,  int total)?  $default,) {final _that = this;
switch (_that) {
case _IngestionProgress() when $default != null:
return $default(_that.inserted,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _IngestionProgress implements IngestionProgress {
  const _IngestionProgress({required this.inserted, required this.total});
  

@override final  int inserted;
@override final  int total;

/// Create a copy of IngestionProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngestionProgressCopyWith<_IngestionProgress> get copyWith => __$IngestionProgressCopyWithImpl<_IngestionProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngestionProgress&&(identical(other.inserted, inserted) || other.inserted == inserted)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,inserted,total);

@override
String toString() {
  return 'IngestionProgress(inserted: $inserted, total: $total)';
}


}

/// @nodoc
abstract mixin class _$IngestionProgressCopyWith<$Res> implements $IngestionProgressCopyWith<$Res> {
  factory _$IngestionProgressCopyWith(_IngestionProgress value, $Res Function(_IngestionProgress) _then) = __$IngestionProgressCopyWithImpl;
@override @useResult
$Res call({
 int inserted, int total
});




}
/// @nodoc
class __$IngestionProgressCopyWithImpl<$Res>
    implements _$IngestionProgressCopyWith<$Res> {
  __$IngestionProgressCopyWithImpl(this._self, this._then);

  final _IngestionProgress _self;
  final $Res Function(_IngestionProgress) _then;

/// Create a copy of IngestionProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inserted = null,Object? total = null,}) {
  return _then(_IngestionProgress(
inserted: null == inserted ? _self.inserted : inserted // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
