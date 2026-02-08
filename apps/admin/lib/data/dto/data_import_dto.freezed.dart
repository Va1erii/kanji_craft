// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_import_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DataImportDto {

 int get id; ImportSource get source;@JsonKey(name: 'source_version') String get sourceVersion; ImportStatus get status;@JsonKey(name: 'record_count') int? get recordCount;@JsonKey(name: 'started_at') DateTime get startedAt;@JsonKey(name: 'ingested_at') DateTime? get ingestedAt;@JsonKey(name: 'processed_at') DateTime? get processedAt;@JsonKey(name: 'promoted_at') DateTime? get promotedAt;@JsonKey(name: 'error_message') String? get errorMessage; Map<String, Object?>? get metadata;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of DataImportDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataImportDtoCopyWith<DataImportDto> get copyWith => _$DataImportDtoCopyWithImpl<DataImportDto>(this as DataImportDto, _$identity);

  /// Serializes this DataImportDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataImportDto&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceVersion, sourceVersion) || other.sourceVersion == sourceVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordCount, recordCount) || other.recordCount == recordCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.ingestedAt, ingestedAt) || other.ingestedAt == ingestedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.promotedAt, promotedAt) || other.promotedAt == promotedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,sourceVersion,status,recordCount,startedAt,ingestedAt,processedAt,promotedAt,errorMessage,const DeepCollectionEquality().hash(metadata),createdAt,updatedAt);

@override
String toString() {
  return 'DataImportDto(id: $id, source: $source, sourceVersion: $sourceVersion, status: $status, recordCount: $recordCount, startedAt: $startedAt, ingestedAt: $ingestedAt, processedAt: $processedAt, promotedAt: $promotedAt, errorMessage: $errorMessage, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DataImportDtoCopyWith<$Res>  {
  factory $DataImportDtoCopyWith(DataImportDto value, $Res Function(DataImportDto) _then) = _$DataImportDtoCopyWithImpl;
@useResult
$Res call({
 int id, ImportSource source,@JsonKey(name: 'source_version') String sourceVersion, ImportStatus status,@JsonKey(name: 'record_count') int? recordCount,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'ingested_at') DateTime? ingestedAt,@JsonKey(name: 'processed_at') DateTime? processedAt,@JsonKey(name: 'promoted_at') DateTime? promotedAt,@JsonKey(name: 'error_message') String? errorMessage, Map<String, Object?>? metadata,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$DataImportDtoCopyWithImpl<$Res>
    implements $DataImportDtoCopyWith<$Res> {
  _$DataImportDtoCopyWithImpl(this._self, this._then);

  final DataImportDto _self;
  final $Res Function(DataImportDto) _then;

/// Create a copy of DataImportDto
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


/// Adds pattern-matching-related methods to [DataImportDto].
extension DataImportDtoPatterns on DataImportDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataImportDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataImportDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataImportDto value)  $default,){
final _that = this;
switch (_that) {
case _DataImportDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataImportDto value)?  $default,){
final _that = this;
switch (_that) {
case _DataImportDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  ImportSource source, @JsonKey(name: 'source_version')  String sourceVersion,  ImportStatus status, @JsonKey(name: 'record_count')  int? recordCount, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'ingested_at')  DateTime? ingestedAt, @JsonKey(name: 'processed_at')  DateTime? processedAt, @JsonKey(name: 'promoted_at')  DateTime? promotedAt, @JsonKey(name: 'error_message')  String? errorMessage,  Map<String, Object?>? metadata, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataImportDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  ImportSource source, @JsonKey(name: 'source_version')  String sourceVersion,  ImportStatus status, @JsonKey(name: 'record_count')  int? recordCount, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'ingested_at')  DateTime? ingestedAt, @JsonKey(name: 'processed_at')  DateTime? processedAt, @JsonKey(name: 'promoted_at')  DateTime? promotedAt, @JsonKey(name: 'error_message')  String? errorMessage,  Map<String, Object?>? metadata, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DataImportDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  ImportSource source, @JsonKey(name: 'source_version')  String sourceVersion,  ImportStatus status, @JsonKey(name: 'record_count')  int? recordCount, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'ingested_at')  DateTime? ingestedAt, @JsonKey(name: 'processed_at')  DateTime? processedAt, @JsonKey(name: 'promoted_at')  DateTime? promotedAt, @JsonKey(name: 'error_message')  String? errorMessage,  Map<String, Object?>? metadata, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DataImportDto() when $default != null:
return $default(_that.id,_that.source,_that.sourceVersion,_that.status,_that.recordCount,_that.startedAt,_that.ingestedAt,_that.processedAt,_that.promotedAt,_that.errorMessage,_that.metadata,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DataImportDto extends DataImportDto {
  const _DataImportDto({required this.id, required this.source, @JsonKey(name: 'source_version') required this.sourceVersion, required this.status, @JsonKey(name: 'record_count') this.recordCount, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'ingested_at') this.ingestedAt, @JsonKey(name: 'processed_at') this.processedAt, @JsonKey(name: 'promoted_at') this.promotedAt, @JsonKey(name: 'error_message') this.errorMessage, final  Map<String, Object?>? metadata, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _metadata = metadata,super._();
  factory _DataImportDto.fromJson(Map<String, dynamic> json) => _$DataImportDtoFromJson(json);

@override final  int id;
@override final  ImportSource source;
@override@JsonKey(name: 'source_version') final  String sourceVersion;
@override final  ImportStatus status;
@override@JsonKey(name: 'record_count') final  int? recordCount;
@override@JsonKey(name: 'started_at') final  DateTime startedAt;
@override@JsonKey(name: 'ingested_at') final  DateTime? ingestedAt;
@override@JsonKey(name: 'processed_at') final  DateTime? processedAt;
@override@JsonKey(name: 'promoted_at') final  DateTime? promotedAt;
@override@JsonKey(name: 'error_message') final  String? errorMessage;
 final  Map<String, Object?>? _metadata;
@override Map<String, Object?>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of DataImportDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataImportDtoCopyWith<_DataImportDto> get copyWith => __$DataImportDtoCopyWithImpl<_DataImportDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataImportDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataImportDto&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceVersion, sourceVersion) || other.sourceVersion == sourceVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordCount, recordCount) || other.recordCount == recordCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.ingestedAt, ingestedAt) || other.ingestedAt == ingestedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.promotedAt, promotedAt) || other.promotedAt == promotedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,sourceVersion,status,recordCount,startedAt,ingestedAt,processedAt,promotedAt,errorMessage,const DeepCollectionEquality().hash(_metadata),createdAt,updatedAt);

@override
String toString() {
  return 'DataImportDto(id: $id, source: $source, sourceVersion: $sourceVersion, status: $status, recordCount: $recordCount, startedAt: $startedAt, ingestedAt: $ingestedAt, processedAt: $processedAt, promotedAt: $promotedAt, errorMessage: $errorMessage, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DataImportDtoCopyWith<$Res> implements $DataImportDtoCopyWith<$Res> {
  factory _$DataImportDtoCopyWith(_DataImportDto value, $Res Function(_DataImportDto) _then) = __$DataImportDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, ImportSource source,@JsonKey(name: 'source_version') String sourceVersion, ImportStatus status,@JsonKey(name: 'record_count') int? recordCount,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'ingested_at') DateTime? ingestedAt,@JsonKey(name: 'processed_at') DateTime? processedAt,@JsonKey(name: 'promoted_at') DateTime? promotedAt,@JsonKey(name: 'error_message') String? errorMessage, Map<String, Object?>? metadata,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$DataImportDtoCopyWithImpl<$Res>
    implements _$DataImportDtoCopyWith<$Res> {
  __$DataImportDtoCopyWithImpl(this._self, this._then);

  final _DataImportDto _self;
  final $Res Function(_DataImportDto) _then;

/// Create a copy of DataImportDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? sourceVersion = null,Object? status = null,Object? recordCount = freezed,Object? startedAt = null,Object? ingestedAt = freezed,Object? processedAt = freezed,Object? promotedAt = freezed,Object? errorMessage = freezed,Object? metadata = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DataImportDto(
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
