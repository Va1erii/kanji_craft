// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_import.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DataImport {

 int get id; ImportSource get source; String get sourceVersion; ImportStatus get status; int? get recordCount; DateTime get startedAt; DateTime? get ingestedAt; DateTime? get processedAt; DateTime? get promotedAt; String? get errorMessage; Map<String, Object?>? get metadata; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DataImport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataImportCopyWith<DataImport> get copyWith => _$DataImportCopyWithImpl<DataImport>(this as DataImport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataImport&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceVersion, sourceVersion) || other.sourceVersion == sourceVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordCount, recordCount) || other.recordCount == recordCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.ingestedAt, ingestedAt) || other.ingestedAt == ingestedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.promotedAt, promotedAt) || other.promotedAt == promotedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,source,sourceVersion,status,recordCount,startedAt,ingestedAt,processedAt,promotedAt,errorMessage,const DeepCollectionEquality().hash(metadata),createdAt,updatedAt);

@override
String toString() {
  return 'DataImport(id: $id, source: $source, sourceVersion: $sourceVersion, status: $status, recordCount: $recordCount, startedAt: $startedAt, ingestedAt: $ingestedAt, processedAt: $processedAt, promotedAt: $promotedAt, errorMessage: $errorMessage, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DataImportCopyWith<$Res>  {
  factory $DataImportCopyWith(DataImport value, $Res Function(DataImport) _then) = _$DataImportCopyWithImpl;
@useResult
$Res call({
 int id, ImportSource source, String sourceVersion, ImportStatus status, int? recordCount, DateTime startedAt, DateTime? ingestedAt, DateTime? processedAt, DateTime? promotedAt, String? errorMessage, Map<String, Object?>? metadata, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DataImportCopyWithImpl<$Res>
    implements $DataImportCopyWith<$Res> {
  _$DataImportCopyWithImpl(this._self, this._then);

  final DataImport _self;
  final $Res Function(DataImport) _then;

/// Create a copy of DataImport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? sourceVersion = null,Object? status = null,Object? recordCount = freezed,Object? startedAt = null,Object? ingestedAt = freezed,Object? processedAt = freezed,Object? promotedAt = freezed,Object? errorMessage = freezed,Object? metadata = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ImportSource,sourceVersion: null == sourceVersion ? _self.sourceVersion : sourceVersion // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportStatus,recordCount: freezed == recordCount ? _self.recordCount : recordCount // ignore: cast_nullable_to_non_nullable
as int?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ingestedAt: freezed == ingestedAt ? _self.ingestedAt : ingestedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,promotedAt: freezed == promotedAt ? _self.promotedAt : promotedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DataImport].
extension DataImportPatterns on DataImport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataImport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataImport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataImport value)  $default,){
final _that = this;
switch (_that) {
case _DataImport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataImport value)?  $default,){
final _that = this;
switch (_that) {
case _DataImport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  ImportSource source,  String sourceVersion,  ImportStatus status,  int? recordCount,  DateTime startedAt,  DateTime? ingestedAt,  DateTime? processedAt,  DateTime? promotedAt,  String? errorMessage,  Map<String, Object?>? metadata,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataImport() when $default != null:
return $default(_that.id,_that.source,_that.sourceVersion,_that.status,_that.recordCount,_that.startedAt,_that.ingestedAt,_that.processedAt,_that.promotedAt,_that.errorMessage,_that.metadata,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  ImportSource source,  String sourceVersion,  ImportStatus status,  int? recordCount,  DateTime startedAt,  DateTime? ingestedAt,  DateTime? processedAt,  DateTime? promotedAt,  String? errorMessage,  Map<String, Object?>? metadata,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DataImport():
return $default(_that.id,_that.source,_that.sourceVersion,_that.status,_that.recordCount,_that.startedAt,_that.ingestedAt,_that.processedAt,_that.promotedAt,_that.errorMessage,_that.metadata,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  ImportSource source,  String sourceVersion,  ImportStatus status,  int? recordCount,  DateTime startedAt,  DateTime? ingestedAt,  DateTime? processedAt,  DateTime? promotedAt,  String? errorMessage,  Map<String, Object?>? metadata,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DataImport() when $default != null:
return $default(_that.id,_that.source,_that.sourceVersion,_that.status,_that.recordCount,_that.startedAt,_that.ingestedAt,_that.processedAt,_that.promotedAt,_that.errorMessage,_that.metadata,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DataImport implements DataImport {
  const _DataImport({required this.id, required this.source, required this.sourceVersion, required this.status, this.recordCount, required this.startedAt, this.ingestedAt, this.processedAt, this.promotedAt, this.errorMessage, final  Map<String, Object?>? metadata, required this.createdAt, required this.updatedAt}): _metadata = metadata;
  

@override final  int id;
@override final  ImportSource source;
@override final  String sourceVersion;
@override final  ImportStatus status;
@override final  int? recordCount;
@override final  DateTime startedAt;
@override final  DateTime? ingestedAt;
@override final  DateTime? processedAt;
@override final  DateTime? promotedAt;
@override final  String? errorMessage;
 final  Map<String, Object?>? _metadata;
@override Map<String, Object?>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DataImport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataImportCopyWith<_DataImport> get copyWith => __$DataImportCopyWithImpl<_DataImport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataImport&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceVersion, sourceVersion) || other.sourceVersion == sourceVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordCount, recordCount) || other.recordCount == recordCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.ingestedAt, ingestedAt) || other.ingestedAt == ingestedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.promotedAt, promotedAt) || other.promotedAt == promotedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,source,sourceVersion,status,recordCount,startedAt,ingestedAt,processedAt,promotedAt,errorMessage,const DeepCollectionEquality().hash(_metadata),createdAt,updatedAt);

@override
String toString() {
  return 'DataImport(id: $id, source: $source, sourceVersion: $sourceVersion, status: $status, recordCount: $recordCount, startedAt: $startedAt, ingestedAt: $ingestedAt, processedAt: $processedAt, promotedAt: $promotedAt, errorMessage: $errorMessage, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DataImportCopyWith<$Res> implements $DataImportCopyWith<$Res> {
  factory _$DataImportCopyWith(_DataImport value, $Res Function(_DataImport) _then) = __$DataImportCopyWithImpl;
@override @useResult
$Res call({
 int id, ImportSource source, String sourceVersion, ImportStatus status, int? recordCount, DateTime startedAt, DateTime? ingestedAt, DateTime? processedAt, DateTime? promotedAt, String? errorMessage, Map<String, Object?>? metadata, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DataImportCopyWithImpl<$Res>
    implements _$DataImportCopyWith<$Res> {
  __$DataImportCopyWithImpl(this._self, this._then);

  final _DataImport _self;
  final $Res Function(_DataImport) _then;

/// Create a copy of DataImport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? sourceVersion = null,Object? status = null,Object? recordCount = freezed,Object? startedAt = null,Object? ingestedAt = freezed,Object? processedAt = freezed,Object? promotedAt = freezed,Object? errorMessage = freezed,Object? metadata = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DataImport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ImportSource,sourceVersion: null == sourceVersion ? _self.sourceVersion : sourceVersion // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportStatus,recordCount: freezed == recordCount ? _self.recordCount : recordCount // ignore: cast_nullable_to_non_nullable
as int?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ingestedAt: freezed == ingestedAt ? _self.ingestedAt : ingestedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,promotedAt: freezed == promotedAt ? _self.promotedAt : promotedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
