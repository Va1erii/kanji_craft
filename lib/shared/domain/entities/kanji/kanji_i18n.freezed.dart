// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanji_i18n.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KanjiI18n {

 int get id; int get kanjiId; String get langCode; List<String> get meanings; String get systemMnemonic; List<String> get searchTags; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of KanjiI18n
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanjiI18nCopyWith<KanjiI18n> get copyWith => _$KanjiI18nCopyWithImpl<KanjiI18n>(this as KanjiI18n, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanjiI18n&&(identical(other.id, id) || other.id == id)&&(identical(other.kanjiId, kanjiId) || other.kanjiId == kanjiId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&const DeepCollectionEquality().equals(other.meanings, meanings)&&(identical(other.systemMnemonic, systemMnemonic) || other.systemMnemonic == systemMnemonic)&&const DeepCollectionEquality().equals(other.searchTags, searchTags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kanjiId,langCode,const DeepCollectionEquality().hash(meanings),systemMnemonic,const DeepCollectionEquality().hash(searchTags),createdAt,updatedAt);

@override
String toString() {
  return 'KanjiI18n(id: $id, kanjiId: $kanjiId, langCode: $langCode, meanings: $meanings, systemMnemonic: $systemMnemonic, searchTags: $searchTags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $KanjiI18nCopyWith<$Res>  {
  factory $KanjiI18nCopyWith(KanjiI18n value, $Res Function(KanjiI18n) _then) = _$KanjiI18nCopyWithImpl;
@useResult
$Res call({
 int id, int kanjiId, String langCode, List<String> meanings, String systemMnemonic, List<String> searchTags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$KanjiI18nCopyWithImpl<$Res>
    implements $KanjiI18nCopyWith<$Res> {
  _$KanjiI18nCopyWithImpl(this._self, this._then);

  final KanjiI18n _self;
  final $Res Function(KanjiI18n) _then;

/// Create a copy of KanjiI18n
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kanjiId = null,Object? langCode = null,Object? meanings = null,Object? systemMnemonic = null,Object? searchTags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kanjiId: null == kanjiId ? _self.kanjiId : kanjiId // ignore: cast_nullable_to_non_nullable
as int,langCode: null == langCode ? _self.langCode : langCode // ignore: cast_nullable_to_non_nullable
as String,meanings: null == meanings ? _self.meanings : meanings // ignore: cast_nullable_to_non_nullable
as List<String>,systemMnemonic: null == systemMnemonic ? _self.systemMnemonic : systemMnemonic // ignore: cast_nullable_to_non_nullable
as String,searchTags: null == searchTags ? _self.searchTags : searchTags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [KanjiI18n].
extension KanjiI18nPatterns on KanjiI18n {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanjiI18n value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanjiI18n() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanjiI18n value)  $default,){
final _that = this;
switch (_that) {
case _KanjiI18n():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanjiI18n value)?  $default,){
final _that = this;
switch (_that) {
case _KanjiI18n() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int kanjiId,  String langCode,  List<String> meanings,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanjiI18n() when $default != null:
return $default(_that.id,_that.kanjiId,_that.langCode,_that.meanings,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int kanjiId,  String langCode,  List<String> meanings,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _KanjiI18n():
return $default(_that.id,_that.kanjiId,_that.langCode,_that.meanings,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int kanjiId,  String langCode,  List<String> meanings,  String systemMnemonic,  List<String> searchTags,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _KanjiI18n() when $default != null:
return $default(_that.id,_that.kanjiId,_that.langCode,_that.meanings,_that.systemMnemonic,_that.searchTags,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _KanjiI18n implements KanjiI18n {
  const _KanjiI18n({required this.id, required this.kanjiId, required this.langCode, required final  List<String> meanings, required this.systemMnemonic, required final  List<String> searchTags, required this.createdAt, required this.updatedAt}): _meanings = meanings,_searchTags = searchTags;
  

@override final  int id;
@override final  int kanjiId;
@override final  String langCode;
 final  List<String> _meanings;
@override List<String> get meanings {
  if (_meanings is EqualUnmodifiableListView) return _meanings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meanings);
}

@override final  String systemMnemonic;
 final  List<String> _searchTags;
@override List<String> get searchTags {
  if (_searchTags is EqualUnmodifiableListView) return _searchTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTags);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of KanjiI18n
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanjiI18nCopyWith<_KanjiI18n> get copyWith => __$KanjiI18nCopyWithImpl<_KanjiI18n>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanjiI18n&&(identical(other.id, id) || other.id == id)&&(identical(other.kanjiId, kanjiId) || other.kanjiId == kanjiId)&&(identical(other.langCode, langCode) || other.langCode == langCode)&&const DeepCollectionEquality().equals(other._meanings, _meanings)&&(identical(other.systemMnemonic, systemMnemonic) || other.systemMnemonic == systemMnemonic)&&const DeepCollectionEquality().equals(other._searchTags, _searchTags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kanjiId,langCode,const DeepCollectionEquality().hash(_meanings),systemMnemonic,const DeepCollectionEquality().hash(_searchTags),createdAt,updatedAt);

@override
String toString() {
  return 'KanjiI18n(id: $id, kanjiId: $kanjiId, langCode: $langCode, meanings: $meanings, systemMnemonic: $systemMnemonic, searchTags: $searchTags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$KanjiI18nCopyWith<$Res> implements $KanjiI18nCopyWith<$Res> {
  factory _$KanjiI18nCopyWith(_KanjiI18n value, $Res Function(_KanjiI18n) _then) = __$KanjiI18nCopyWithImpl;
@override @useResult
$Res call({
 int id, int kanjiId, String langCode, List<String> meanings, String systemMnemonic, List<String> searchTags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$KanjiI18nCopyWithImpl<$Res>
    implements _$KanjiI18nCopyWith<$Res> {
  __$KanjiI18nCopyWithImpl(this._self, this._then);

  final _KanjiI18n _self;
  final $Res Function(_KanjiI18n) _then;

/// Create a copy of KanjiI18n
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kanjiId = null,Object? langCode = null,Object? meanings = null,Object? systemMnemonic = null,Object? searchTags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_KanjiI18n(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kanjiId: null == kanjiId ? _self.kanjiId : kanjiId // ignore: cast_nullable_to_non_nullable
as int,langCode: null == langCode ? _self.langCode : langCode // ignore: cast_nullable_to_non_nullable
as String,meanings: null == meanings ? _self._meanings : meanings // ignore: cast_nullable_to_non_nullable
as List<String>,systemMnemonic: null == systemMnemonic ? _self.systemMnemonic : systemMnemonic // ignore: cast_nullable_to_non_nullable
as String,searchTags: null == searchTags ? _self._searchTags : searchTags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
