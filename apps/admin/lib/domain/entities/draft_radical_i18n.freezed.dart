// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_radical_i18n.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftRadicalI18n {

 int get id; int get draftRadicalId; String get langCode; String get name; String get systemMnemonic; List<String> get searchTags; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DraftRadicalI18n
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftRadicalI18nCopyWith<DraftRadicalI18n> get copyWith => _$DraftRadicalI18nCopyWithImpl<DraftRadicalI18n>(this as DraftRadicalI18n, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftRadicalI18n&&(identical(other.id, id) || other.id == id)&&(identical(other.draftRadicalId, draftRadicalId) || other.draftRadicalId == draftRadicalId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.systemMnemonic, systemMnemonic) || other.systemMnemonic == systemMnemonic)&&const DeepCollectionEquality().equals(other.searchTags, searchTags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,draftRadicalId,langCode,name,systemMnemonic,const DeepCollectionEquality().hash(searchTags),createdAt,updatedAt);

@override
String toString() {
  return 'DraftRadicalI18n(id: $id, draftRadicalId: $draftRadicalId, langCode: $langCode, name: $name, systemMnemonic: $systemMnemonic, searchTags: $searchTags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DraftRadicalI18nCopyWith<$Res>  {
  factory $DraftRadicalI18nCopyWith(DraftRadicalI18n value, $Res Function(DraftRadicalI18n) _then) = _$DraftRadicalI18nCopyWithImpl;
@useResult
$Res call({
 int id, int draftRadicalId, String langCode, String name, String systemMnemonic, List<String> searchTags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DraftRadicalI18nCopyWithImpl<$Res>
    implements $DraftRadicalI18nCopyWith<$Res> {
  _$DraftRadicalI18nCopyWithImpl(this._self, this._then);

  final DraftRadicalI18n _self;
  final $Res Function(DraftRadicalI18n) _then;

/// Create a copy of DraftRadicalI18n
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? draftRadicalId = null,Object? langCode = null,Object? name = null,Object? systemMnemonic = null,Object? searchTags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,draftRadicalId: null == draftRadicalId ? _self.draftRadicalId : draftRadicalId // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [DraftRadicalI18n].
extension DraftRadicalI18nPatterns on DraftRadicalI18n {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftRadicalI18n value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftRadicalI18n() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftRadicalI18n value)  $default,){
final _that = this;
switch (_that) {
case _DraftRadicalI18n():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftRadicalI18n value)?  $default,){
final _that = this;
switch (_that) {
case _DraftRadicalI18n() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int draftRadicalId,  String langCode,  String name,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftRadicalI18n() when $default != null:
return $default(_that.id,_that.draftRadicalId,_that.langCode,_that.name,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int draftRadicalId,  String langCode,  String name,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DraftRadicalI18n():
return $default(_that.id,_that.draftRadicalId,_that.langCode,_that.name,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int draftRadicalId,  String langCode,  String name,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DraftRadicalI18n() when $default != null:
return $default(_that.id,_that.draftRadicalId,_that.langCode,_that.name,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DraftRadicalI18n implements DraftRadicalI18n {
  const _DraftRadicalI18n({required this.id, required this.draftRadicalId, required this.langCode, required this.name, required this.systemMnemonic, required final  List<String> searchTags, required this.createdAt, required this.updatedAt}): _searchTags = searchTags;
  

@override final  int id;
@override final  int draftRadicalId;
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

/// Create a copy of DraftRadicalI18n
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftRadicalI18nCopyWith<_DraftRadicalI18n> get copyWith => __$DraftRadicalI18nCopyWithImpl<_DraftRadicalI18n>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftRadicalI18n&&(identical(other.id, id) || other.id == id)&&(identical(other.draftRadicalId, draftRadicalId) || other.draftRadicalId == draftRadicalId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.systemMnemonic, systemMnemonic) || other.systemMnemonic == systemMnemonic)&&const DeepCollectionEquality().equals(other._searchTags, _searchTags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,draftRadicalId,langCode,name,systemMnemonic,const DeepCollectionEquality().hash(_searchTags),createdAt,updatedAt);

@override
String toString() {
  return 'DraftRadicalI18n(id: $id, draftRadicalId: $draftRadicalId, langCode: $langCode, name: $name, systemMnemonic: $systemMnemonic, searchTags: $searchTags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DraftRadicalI18nCopyWith<$Res> implements $DraftRadicalI18nCopyWith<$Res> {
  factory _$DraftRadicalI18nCopyWith(_DraftRadicalI18n value, $Res Function(_DraftRadicalI18n) _then) = __$DraftRadicalI18nCopyWithImpl;
@override @useResult
$Res call({
 int id, int draftRadicalId, String langCode, String name, String systemMnemonic, List<String> searchTags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DraftRadicalI18nCopyWithImpl<$Res>
    implements _$DraftRadicalI18nCopyWith<$Res> {
  __$DraftRadicalI18nCopyWithImpl(this._self, this._then);

  final _DraftRadicalI18n _self;
  final $Res Function(_DraftRadicalI18n) _then;

/// Create a copy of DraftRadicalI18n
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? draftRadicalId = null,Object? langCode = null,Object? name = null,Object? systemMnemonic = null,Object? searchTags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DraftRadicalI18n(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,draftRadicalId: null == draftRadicalId ? _self.draftRadicalId : draftRadicalId // ignore: cast_nullable_to_non_nullable
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
