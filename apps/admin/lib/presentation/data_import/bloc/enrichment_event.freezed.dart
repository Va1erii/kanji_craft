// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrichment_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnrichmentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrichmentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnrichmentEvent()';
}


}

/// @nodoc
class $EnrichmentEventCopyWith<$Res>  {
$EnrichmentEventCopyWith(EnrichmentEvent _, $Res Function(EnrichmentEvent) __);
}


/// Adds pattern-matching-related methods to [EnrichmentEvent].
extension EnrichmentEventPatterns on EnrichmentEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ImportsUpdated value)?  importsUpdated,TResult Function( _SetOutputDir value)?  setOutputDir,TResult Function( _ExportBatch value)?  exportBatch,TResult Function( _ImportBatch value)?  importBatch,TResult Function( _RefreshStatus value)?  refreshStatus,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that);case _SetOutputDir() when setOutputDir != null:
return setOutputDir(_that);case _ExportBatch() when exportBatch != null:
return exportBatch(_that);case _ImportBatch() when importBatch != null:
return importBatch(_that);case _RefreshStatus() when refreshStatus != null:
return refreshStatus(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ImportsUpdated value)  importsUpdated,required TResult Function( _SetOutputDir value)  setOutputDir,required TResult Function( _ExportBatch value)  exportBatch,required TResult Function( _ImportBatch value)  importBatch,required TResult Function( _RefreshStatus value)  refreshStatus,}){
final _that = this;
switch (_that) {
case _ImportsUpdated():
return importsUpdated(_that);case _SetOutputDir():
return setOutputDir(_that);case _ExportBatch():
return exportBatch(_that);case _ImportBatch():
return importBatch(_that);case _RefreshStatus():
return refreshStatus(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ImportsUpdated value)?  importsUpdated,TResult? Function( _SetOutputDir value)?  setOutputDir,TResult? Function( _ExportBatch value)?  exportBatch,TResult? Function( _ImportBatch value)?  importBatch,TResult? Function( _RefreshStatus value)?  refreshStatus,}){
final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that);case _SetOutputDir() when setOutputDir != null:
return setOutputDir(_that);case _ExportBatch() when exportBatch != null:
return exportBatch(_that);case _ImportBatch() when importBatch != null:
return importBatch(_that);case _RefreshStatus() when refreshStatus != null:
return refreshStatus(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<DataImport> imports)?  importsUpdated,TResult Function( String path)?  setOutputDir,TResult Function( EnrichmentBatchType batchType)?  exportBatch,TResult Function( EnrichmentBatchType batchType,  String filePath)?  importBatch,TResult Function()?  refreshStatus,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that.imports);case _SetOutputDir() when setOutputDir != null:
return setOutputDir(_that.path);case _ExportBatch() when exportBatch != null:
return exportBatch(_that.batchType);case _ImportBatch() when importBatch != null:
return importBatch(_that.batchType,_that.filePath);case _RefreshStatus() when refreshStatus != null:
return refreshStatus();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<DataImport> imports)  importsUpdated,required TResult Function( String path)  setOutputDir,required TResult Function( EnrichmentBatchType batchType)  exportBatch,required TResult Function( EnrichmentBatchType batchType,  String filePath)  importBatch,required TResult Function()  refreshStatus,}) {final _that = this;
switch (_that) {
case _ImportsUpdated():
return importsUpdated(_that.imports);case _SetOutputDir():
return setOutputDir(_that.path);case _ExportBatch():
return exportBatch(_that.batchType);case _ImportBatch():
return importBatch(_that.batchType,_that.filePath);case _RefreshStatus():
return refreshStatus();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<DataImport> imports)?  importsUpdated,TResult? Function( String path)?  setOutputDir,TResult? Function( EnrichmentBatchType batchType)?  exportBatch,TResult? Function( EnrichmentBatchType batchType,  String filePath)?  importBatch,TResult? Function()?  refreshStatus,}) {final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that.imports);case _SetOutputDir() when setOutputDir != null:
return setOutputDir(_that.path);case _ExportBatch() when exportBatch != null:
return exportBatch(_that.batchType);case _ImportBatch() when importBatch != null:
return importBatch(_that.batchType,_that.filePath);case _RefreshStatus() when refreshStatus != null:
return refreshStatus();case _:
  return null;

}
}

}

/// @nodoc


class _ImportsUpdated implements EnrichmentEvent {
  const _ImportsUpdated({required final  List<DataImport> imports}): _imports = imports;
  

 final  List<DataImport> _imports;
 List<DataImport> get imports {
  if (_imports is EqualUnmodifiableListView) return _imports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imports);
}


/// Create a copy of EnrichmentEvent
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
  return 'EnrichmentEvent.importsUpdated(imports: $imports)';
}


}

/// @nodoc
abstract mixin class _$ImportsUpdatedCopyWith<$Res> implements $EnrichmentEventCopyWith<$Res> {
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

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? imports = null,}) {
  return _then(_ImportsUpdated(
imports: null == imports ? _self._imports : imports // ignore: cast_nullable_to_non_nullable
as List<DataImport>,
  ));
}


}

/// @nodoc


class _SetOutputDir implements EnrichmentEvent {
  const _SetOutputDir({required this.path});
  

 final  String path;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetOutputDirCopyWith<_SetOutputDir> get copyWith => __$SetOutputDirCopyWithImpl<_SetOutputDir>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetOutputDir&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'EnrichmentEvent.setOutputDir(path: $path)';
}


}

/// @nodoc
abstract mixin class _$SetOutputDirCopyWith<$Res> implements $EnrichmentEventCopyWith<$Res> {
  factory _$SetOutputDirCopyWith(_SetOutputDir value, $Res Function(_SetOutputDir) _then) = __$SetOutputDirCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class __$SetOutputDirCopyWithImpl<$Res>
    implements _$SetOutputDirCopyWith<$Res> {
  __$SetOutputDirCopyWithImpl(this._self, this._then);

  final _SetOutputDir _self;
  final $Res Function(_SetOutputDir) _then;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(_SetOutputDir(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ExportBatch implements EnrichmentEvent {
  const _ExportBatch({required this.batchType});
  

 final  EnrichmentBatchType batchType;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportBatchCopyWith<_ExportBatch> get copyWith => __$ExportBatchCopyWithImpl<_ExportBatch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportBatch&&(identical(other.batchType, batchType) || other.batchType == batchType));
}


@override
int get hashCode => Object.hash(runtimeType,batchType);

@override
String toString() {
  return 'EnrichmentEvent.exportBatch(batchType: $batchType)';
}


}

/// @nodoc
abstract mixin class _$ExportBatchCopyWith<$Res> implements $EnrichmentEventCopyWith<$Res> {
  factory _$ExportBatchCopyWith(_ExportBatch value, $Res Function(_ExportBatch) _then) = __$ExportBatchCopyWithImpl;
@useResult
$Res call({
 EnrichmentBatchType batchType
});




}
/// @nodoc
class __$ExportBatchCopyWithImpl<$Res>
    implements _$ExportBatchCopyWith<$Res> {
  __$ExportBatchCopyWithImpl(this._self, this._then);

  final _ExportBatch _self;
  final $Res Function(_ExportBatch) _then;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? batchType = null,}) {
  return _then(_ExportBatch(
batchType: null == batchType ? _self.batchType : batchType // ignore: cast_nullable_to_non_nullable
as EnrichmentBatchType,
  ));
}


}

/// @nodoc


class _ImportBatch implements EnrichmentEvent {
  const _ImportBatch({required this.batchType, required this.filePath});
  

 final  EnrichmentBatchType batchType;
 final  String filePath;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportBatchCopyWith<_ImportBatch> get copyWith => __$ImportBatchCopyWithImpl<_ImportBatch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportBatch&&(identical(other.batchType, batchType) || other.batchType == batchType)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode => Object.hash(runtimeType,batchType,filePath);

@override
String toString() {
  return 'EnrichmentEvent.importBatch(batchType: $batchType, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class _$ImportBatchCopyWith<$Res> implements $EnrichmentEventCopyWith<$Res> {
  factory _$ImportBatchCopyWith(_ImportBatch value, $Res Function(_ImportBatch) _then) = __$ImportBatchCopyWithImpl;
@useResult
$Res call({
 EnrichmentBatchType batchType, String filePath
});




}
/// @nodoc
class __$ImportBatchCopyWithImpl<$Res>
    implements _$ImportBatchCopyWith<$Res> {
  __$ImportBatchCopyWithImpl(this._self, this._then);

  final _ImportBatch _self;
  final $Res Function(_ImportBatch) _then;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? batchType = null,Object? filePath = null,}) {
  return _then(_ImportBatch(
batchType: null == batchType ? _self.batchType : batchType // ignore: cast_nullable_to_non_nullable
as EnrichmentBatchType,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RefreshStatus implements EnrichmentEvent {
  const _RefreshStatus();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnrichmentEvent.refreshStatus()';
}


}




// dart format on
