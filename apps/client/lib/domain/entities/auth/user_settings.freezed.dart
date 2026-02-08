// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSettings {

 int get id; String get userId; StudyPath get studyPath; int get currentLevel; int get dailyLessonLimit; int get dailyReviewLimit; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.studyPath, studyPath) || other.studyPath == studyPath)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.dailyLessonLimit, dailyLessonLimit) || other.dailyLessonLimit == dailyLessonLimit)&&(identical(other.dailyReviewLimit, dailyReviewLimit) || other.dailyReviewLimit == dailyReviewLimit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,studyPath,currentLevel,dailyLessonLimit,dailyReviewLimit,createdAt,updatedAt);

@override
String toString() {
  return 'UserSettings(id: $id, userId: $userId, studyPath: $studyPath, currentLevel: $currentLevel, dailyLessonLimit: $dailyLessonLimit, dailyReviewLimit: $dailyReviewLimit, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 int id, String userId, StudyPath studyPath, int currentLevel, int dailyLessonLimit, int dailyReviewLimit, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? studyPath = null,Object? currentLevel = null,Object? dailyLessonLimit = null,Object? dailyReviewLimit = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,studyPath: null == studyPath ? _self.studyPath : studyPath // ignore: cast_nullable_to_non_nullable
as StudyPath,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as int,dailyLessonLimit: null == dailyLessonLimit ? _self.dailyLessonLimit : dailyLessonLimit // ignore: cast_nullable_to_non_nullable
as int,dailyReviewLimit: null == dailyReviewLimit ? _self.dailyReviewLimit : dailyReviewLimit // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String userId,  StudyPath studyPath,  int currentLevel,  int dailyLessonLimit,  int dailyReviewLimit,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.id,_that.userId,_that.studyPath,_that.currentLevel,_that.dailyLessonLimit,_that.dailyReviewLimit,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String userId,  StudyPath studyPath,  int currentLevel,  int dailyLessonLimit,  int dailyReviewLimit,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.id,_that.userId,_that.studyPath,_that.currentLevel,_that.dailyLessonLimit,_that.dailyReviewLimit,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String userId,  StudyPath studyPath,  int currentLevel,  int dailyLessonLimit,  int dailyReviewLimit,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.id,_that.userId,_that.studyPath,_that.currentLevel,_that.dailyLessonLimit,_that.dailyReviewLimit,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserSettings implements UserSettings {
  const _UserSettings({required this.id, required this.userId, required this.studyPath, required this.currentLevel, required this.dailyLessonLimit, required this.dailyReviewLimit, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  String userId;
@override final  StudyPath studyPath;
@override final  int currentLevel;
@override final  int dailyLessonLimit;
@override final  int dailyReviewLimit;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.studyPath, studyPath) || other.studyPath == studyPath)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.dailyLessonLimit, dailyLessonLimit) || other.dailyLessonLimit == dailyLessonLimit)&&(identical(other.dailyReviewLimit, dailyReviewLimit) || other.dailyReviewLimit == dailyReviewLimit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,studyPath,currentLevel,dailyLessonLimit,dailyReviewLimit,createdAt,updatedAt);

@override
String toString() {
  return 'UserSettings(id: $id, userId: $userId, studyPath: $studyPath, currentLevel: $currentLevel, dailyLessonLimit: $dailyLessonLimit, dailyReviewLimit: $dailyReviewLimit, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 int id, String userId, StudyPath studyPath, int currentLevel, int dailyLessonLimit, int dailyReviewLimit, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? studyPath = null,Object? currentLevel = null,Object? dailyLessonLimit = null,Object? dailyReviewLimit = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,studyPath: null == studyPath ? _self.studyPath : studyPath // ignore: cast_nullable_to_non_nullable
as StudyPath,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as int,dailyLessonLimit: null == dailyLessonLimit ? _self.dailyLessonLimit : dailyLessonLimit // ignore: cast_nullable_to_non_nullable
as int,dailyReviewLimit: null == dailyReviewLimit ? _self.dailyReviewLimit : dailyReviewLimit // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
