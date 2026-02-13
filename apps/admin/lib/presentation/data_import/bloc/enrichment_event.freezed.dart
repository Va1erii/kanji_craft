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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ImportsUpdated value)?  importsUpdated,TResult Function( _SetOutputDir value)?  setOutputDir,TResult Function( _ExportSubBatch value)?  exportSubBatch,TResult Function( _ImportSubBatch value)?  importSubBatch,TResult Function( _RefreshStatus value)?  refreshStatus,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that);case _SetOutputDir() when setOutputDir != null:
return setOutputDir(_that);case _ExportSubBatch() when exportSubBatch != null:
return exportSubBatch(_that);case _ImportSubBatch() when importSubBatch != null:
return importSubBatch(_that);case _RefreshStatus() when refreshStatus != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ImportsUpdated value)  importsUpdated,required TResult Function( _SetOutputDir value)  setOutputDir,required TResult Function( _ExportSubBatch value)  exportSubBatch,required TResult Function( _ImportSubBatch value)  importSubBatch,required TResult Function( _RefreshStatus value)  refreshStatus,}){
final _that = this;
switch (_that) {
case _ImportsUpdated():
return importsUpdated(_that);case _SetOutputDir():
return setOutputDir(_that);case _ExportSubBatch():
return exportSubBatch(_that);case _ImportSubBatch():
return importSubBatch(_that);case _RefreshStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ImportsUpdated value)?  importsUpdated,TResult? Function( _SetOutputDir value)?  setOutputDir,TResult? Function( _ExportSubBatch value)?  exportSubBatch,TResult? Function( _ImportSubBatch value)?  importSubBatch,TResult? Function( _RefreshStatus value)?  refreshStatus,}){
final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that);case _SetOutputDir() when setOutputDir != null:
return setOutputDir(_that);case _ExportSubBatch() when exportSubBatch != null:
return exportSubBatch(_that);case _ImportSubBatch() when importSubBatch != null:
return importSubBatch(_that);case _RefreshStatus() when refreshStatus != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<DataImport> imports)?  importsUpdated,TResult Function( String path)?  setOutputDir,TResult Function( EnrichmentBatchType batchType,  int subBatchIndex)?  exportSubBatch,TResult Function( EnrichmentBatchType batchType,  int subBatchIndex,  String filePath)?  importSubBatch,TResult Function()?  refreshStatus,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that.imports);case _SetOutputDir() when setOutputDir != null:
return setOutputDir(_that.path);case _ExportSubBatch() when exportSubBatch != null:
return exportSubBatch(_that.batchType,_that.subBatchIndex);case _ImportSubBatch() when importSubBatch != null:
return importSubBatch(_that.batchType,_that.subBatchIndex,_that.filePath);case _RefreshStatus() when refreshStatus != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<DataImport> imports)  importsUpdated,required TResult Function( String path)  setOutputDir,required TResult Function( EnrichmentBatchType batchType,  int subBatchIndex)  exportSubBatch,required TResult Function( EnrichmentBatchType batchType,  int subBatchIndex,  String filePath)  importSubBatch,required TResult Function()  refreshStatus,}) {final _that = this;
switch (_that) {
case _ImportsUpdated():
return importsUpdated(_that.imports);case _SetOutputDir():
return setOutputDir(_that.path);case _ExportSubBatch():
return exportSubBatch(_that.batchType,_that.subBatchIndex);case _ImportSubBatch():
return importSubBatch(_that.batchType,_that.subBatchIndex,_that.filePath);case _RefreshStatus():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<DataImport> imports)?  importsUpdated,TResult? Function( String path)?  setOutputDir,TResult? Function( EnrichmentBatchType batchType,  int subBatchIndex)?  exportSubBatch,TResult? Function( EnrichmentBatchType batchType,  int subBatchIndex,  String filePath)?  importSubBatch,TResult? Function()?  refreshStatus,}) {final _that = this;
switch (_that) {
case _ImportsUpdated() when importsUpdated != null:
return importsUpdated(_that.imports);case _SetOutputDir() when setOutputDir != null:
return setOutputDir(_that.path);case _ExportSubBatch() when exportSubBatch != null:
return exportSubBatch(_that.batchType,_that.subBatchIndex);case _ImportSubBatch() when importSubBatch != null:
return importSubBatch(_that.batchType,_that.subBatchIndex,_that.filePath);case _RefreshStatus() when refreshStatus != null:
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


class _ExportSubBatch implements EnrichmentEvent {
  const _ExportSubBatch({required this.batchType, required this.subBatchIndex});
  

 final  EnrichmentBatchType batchType;
 final  int subBatchIndex;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportSubBatchCopyWith<_ExportSubBatch> get copyWith => __$ExportSubBatchCopyWithImpl<_ExportSubBatch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportSubBatch&&(identical(other.batchType, batchType) || other.batchType == batchType)&&(identical(other.subBatchIndex, subBatchIndex) || other.subBatchIndex == subBatchIndex));
}


@override
int get hashCode => Object.hash(runtimeType,batchType,subBatchIndex);

@override
String toString() {
  return 'EnrichmentEvent.exportSubBatch(batchType: $batchType, subBatchIndex: $subBatchIndex)';
}


}

/// @nodoc
abstract mixin class _$ExportSubBatchCopyWith<$Res> implements $EnrichmentEventCopyWith<$Res> {
  factory _$ExportSubBatchCopyWith(_ExportSubBatch value, $Res Function(_ExportSubBatch) _then) = __$ExportSubBatchCopyWithImpl;
@useResult
$Res call({
 EnrichmentBatchType batchType, int subBatchIndex
});




}
/// @nodoc
class __$ExportSubBatchCopyWithImpl<$Res>
    implements _$ExportSubBatchCopyWith<$Res> {
  __$ExportSubBatchCopyWithImpl(this._self, this._then);

  final _ExportSubBatch _self;
  final $Res Function(_ExportSubBatch) _then;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? batchType = null,Object? subBatchIndex = null,}) {
  return _then(_ExportSubBatch(
batchType: null == batchType ? _self.batchType : batchType // ignore: cast_nullable_to_non_nullable
as EnrichmentBatchType,subBatchIndex: null == subBatchIndex ? _self.subBatchIndex : subBatchIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ImportSubBatch implements EnrichmentEvent {
  const _ImportSubBatch({required this.batchType, required this.subBatchIndex, required this.filePath});
  

 final  EnrichmentBatchType batchType;
 final  int subBatchIndex;
 final  String filePath;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportSubBatchCopyWith<_ImportSubBatch> get copyWith => __$ImportSubBatchCopyWithImpl<_ImportSubBatch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportSubBatch&&(identical(other.batchType, batchType) || other.batchType == batchType)&&(identical(other.subBatchIndex, subBatchIndex) || other.subBatchIndex == subBatchIndex)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode => Object.hash(runtimeType,batchType,subBatchIndex,filePath);

@override
String toString() {
  return 'EnrichmentEvent.importSubBatch(batchType: $batchType, subBatchIndex: $subBatchIndex, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class _$ImportSubBatchCopyWith<$Res> implements $EnrichmentEventCopyWith<$Res> {
  factory _$ImportSubBatchCopyWith(_ImportSubBatch value, $Res Function(_ImportSubBatch) _then) = __$ImportSubBatchCopyWithImpl;
@useResult
$Res call({
 EnrichmentBatchType batchType, int subBatchIndex, String filePath
});




}
/// @nodoc
class __$ImportSubBatchCopyWithImpl<$Res>
    implements _$ImportSubBatchCopyWith<$Res> {
  __$ImportSubBatchCopyWithImpl(this._self, this._then);

  final _ImportSubBatch _self;
  final $Res Function(_ImportSubBatch) _then;

/// Create a copy of EnrichmentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? batchType = null,Object? subBatchIndex = null,Object? filePath = null,}) {
  return _then(_ImportSubBatch(
batchType: null == batchType ? _self.batchType : batchType // ignore: cast_nullable_to_non_nullable
as EnrichmentBatchType,subBatchIndex: null == subBatchIndex ? _self.subBatchIndex : subBatchIndex // ignore: cast_nullable_to_non_nullable
as int,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
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
