// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radical_i18n.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RadicalI18n {

 int get id; int get radicalId; String get langCode; String get name; String get systemMnemonic; List<String> get searchTags; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of RadicalI18n
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadicalI18nCopyWith<RadicalI18n> get copyWith => _$RadicalI18nCopyWithImpl<RadicalI18n>(this as RadicalI18n, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadicalI18n&&(identical(other.id, id) || other.id == id)&&(identical(other.radicalId, radicalId) || other.radicalId == radicalId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.systemMnemonic, systemMnemonic) || other.systemMnemonic == systemMnemonic)&&const DeepCollectionEquality().equals(other.searchTags, searchTags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,radicalId,langCode,name,systemMnemonic,const DeepCollectionEquality().hash(searchTags),createdAt,updatedAt);

@override
String toString() {
  return 'RadicalI18n(id: $id, radicalId: $radicalId, langCode: $langCode, name: $name, systemMnemonic: $systemMnemonic, searchTags: $searchTags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RadicalI18nCopyWith<$Res>  {
  factory $RadicalI18nCopyWith(RadicalI18n value, $Res Function(RadicalI18n) _then) = _$RadicalI18nCopyWithImpl;
@useResult
$Res call({
 int id, int radicalId, String langCode, String name, String systemMnemonic, List<String> searchTags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RadicalI18nCopyWithImpl<$Res>
    implements $RadicalI18nCopyWith<$Res> {
  _$RadicalI18nCopyWithImpl(this._self, this._then);

  final RadicalI18n _self;
  final $Res Function(RadicalI18n) _then;

/// Create a copy of RadicalI18n
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? radicalId = null,Object? langCode = null,Object? name = null,Object? systemMnemonic = null,Object? searchTags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,radicalId: null == radicalId ? _self.radicalId : radicalId // ignore: cast_nullable_to_non_nullable
as int,langCode: null == langCode ? _self.langCode : langCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,systemMnemonic: null == systemMnemonic ? _self.systemMnemonic : systemMnemonic // ignore: cast_nullable_to_non_nullable
as String,searchTags: null == searchTags ? _self.searchTags : searchTags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RadicalI18n].
extension RadicalI18nPatterns on RadicalI18n {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadicalI18n value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadicalI18n() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadicalI18n value)  $default,){
final _that = this;
switch (_that) {
case _RadicalI18n():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadicalI18n value)?  $default,){
final _that = this;
switch (_that) {
case _RadicalI18n() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int radicalId,  String langCode,  String name,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadicalI18n() when $default != null:
return $default(_that.id,_that.radicalId,_that.langCode,_that.name,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int radicalId,  String langCode,  String name,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RadicalI18n():
return $default(_that.id,_that.radicalId,_that.langCode,_that.name,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int radicalId,  String langCode,  String name,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RadicalI18n() when $default != null:
return $default(_that.id,_that.radicalId,_that.langCode,_that.name,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _RadicalI18n implements RadicalI18n {
  const _RadicalI18n({required this.id, required this.radicalId, required this.langCode, required this.name, required this.systemMnemonic, required final  List<String> searchTags, required this.createdAt, required this.updatedAt}): _searchTags = searchTags;
  

@override final  int id;
@override final  int radicalId;
@override final  String langCode;
@override final  String name;
@override final  String systemMnemonic;
 final  List<String> _searchTags;
@override List<String> get searchTags {
  if (_searchTags is EqualUnmodifiableListView) return _searchTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTags);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of RadicalI18n
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadicalI18nCopyWith<_RadicalI18n> get copyWith => __$RadicalI18nCopyWithImpl<_RadicalI18n>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadicalI18n&&(identical(other.id, id) || other.id == id)&&(identical(other.radicalId, radicalId) || other.radicalId == radicalId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.systemMnemonic, systemMnemonic) || other.systemMnemonic == systemMnemonic)&&const DeepCollectionEquality().equals(other._searchTags, _searchTags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,radicalId,langCode,name,systemMnemonic,const DeepCollectionEquality().hash(_searchTags),createdAt,updatedAt);

@override
String toString() {
  return 'RadicalI18n(id: $id, radicalId: $radicalId, langCode: $langCode, name: $name, systemMnemonic: $systemMnemonic, searchTags: $searchTags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RadicalI18nCopyWith<$Res> implements $RadicalI18nCopyWith<$Res> {
  factory _$RadicalI18nCopyWith(_RadicalI18n value, $Res Function(_RadicalI18n) _then) = __$RadicalI18nCopyWithImpl;
@override @useResult
$Res call({
 int id, int radicalId, String langCode, String name, String systemMnemonic, List<String> searchTags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RadicalI18nCopyWithImpl<$Res>
    implements _$RadicalI18nCopyWith<$Res> {
  __$RadicalI18nCopyWithImpl(this._self, this._then);

  final _RadicalI18n _self;
  final $Res Function(_RadicalI18n) _then;

/// Create a copy of RadicalI18n
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? radicalId = null,Object? langCode = null,Object? name = null,Object? systemMnemonic = null,Object? searchTags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RadicalI18n(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,radicalId: null == radicalId ? _self.radicalId : radicalId // ignore: cast_nullable_to_non_nullable
as int,langCode: null == langCode ? _self.langCode : langCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,systemMnemonic: null == systemMnemonic ? _self.systemMnemonic : systemMnemonic // ignore: cast_nullable_to_non_nullable
as String,searchTags: null == searchTags ? _self._searchTags : searchTags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
