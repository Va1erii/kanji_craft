// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_import_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DataImportEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataImportEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DataImportEvent()';
}


}

/// @nodoc
class $DataImportEventCopyWith<$Res>  {
$DataImportEventCopyWith(DataImportEvent _, $Res Function(DataImportEvent) __);
}


/// Adds pattern-matching-related methods to [DataImportEvent].
extension DataImportEventPatterns on DataImportEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,TResult Function( _StartIngestion value)?  startIngestion,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _StartIngestion() when startIngestion != null:
return startIngestion(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,required TResult Function( _StartIngestion value)  startIngestion,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);case _StartIngestion():
return startIngestion(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,TResult? Function( _StartIngestion value)?  startIngestion,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _StartIngestion() when startIngestion != null:
return startIngestion(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function( ImportSource source,  String sourceVersion,  String filePath)?  startIngestion,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load();case _StartIngestion() when startIngestion != null:
return startIngestion(_that.source,_that.sourceVersion,_that.filePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function( ImportSource source,  String sourceVersion,  String filePath)  startIngestion,}) {final _that = this;
switch (_that) {
case _Load():
return load();case _StartIngestion():
return startIngestion(_that.source,_that.sourceVersion,_that.filePath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function( ImportSource source,  String sourceVersion,  String filePath)?  startIngestion,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load();case _StartIngestion() when startIngestion != null:
return startIngestion(_that.source,_that.sourceVersion,_that.filePath);case _:
  return null;

}
}

}

/// @nodoc


class _Load implements DataImportEvent {
  const _Load();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DataImportEvent.load()';
}


}




/// @nodoc


class _StartIngestion implements DataImportEvent {
  const _StartIngestion({required this.source, required this.sourceVersion, required this.filePath});
  

 final  ImportSource source;
 final  String sourceVersion;
 final  String filePath;

/// Create a copy of DataImportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartIngestionCopyWith<_StartIngestion> get copyWith => __$StartIngestionCopyWithImpl<_StartIngestion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartIngestion&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceVersion, sourceVersion) || other.sourceVersion == sourceVersion)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode => Object.hash(runtimeType,source,sourceVersion,filePath);

@override
String toString() {
  return 'DataImportEvent.startIngestion(source: $source, sourceVersion: $sourceVersion, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class _$StartIngestionCopyWith<$Res> implements $DataImportEventCopyWith<$Res> {
  factory _$StartIngestionCopyWith(_StartIngestion value, $Res Function(_StartIngestion) _then) = __$StartIngestionCopyWithImpl;
@useResult
$Res call({
 ImportSource source, String sourceVersion, String filePath
});




}
/// @nodoc
class __$StartIngestionCopyWithImpl<$Res>
    implements _$StartIngestionCopyWith<$Res> {
  __$StartIngestionCopyWithImpl(this._self, this._then);

  final _StartIngestion _self;
  final $Res Function(_StartIngestion) _then;

/// Create a copy of DataImportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? source = null,Object? sourceVersion = null,Object? filePath = null,}) {
  return _then(_StartIngestion(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ImportSource,sourceVersion: null == sourceVersion ? _self.sourceVersion : sourceVersion // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
