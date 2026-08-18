// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dev_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DevSettings {

 bool get isOnline; LatencyProfile get latency; Set<MockOp> get failingOps;
/// Create a copy of DevSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevSettingsCopyWith<DevSettings> get copyWith => _$DevSettingsCopyWithImpl<DevSettings>(this as DevSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DevSettings&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.latency, latency) || other.latency == latency)&&const DeepCollectionEquality().equals(other.failingOps, failingOps));
}


@override
int get hashCode => Object.hash(runtimeType,isOnline,latency,const DeepCollectionEquality().hash(failingOps));

@override
String toString() {
  return 'DevSettings(isOnline: $isOnline, latency: $latency, failingOps: $failingOps)';
}


}

/// @nodoc
abstract mixin class $DevSettingsCopyWith<$Res>  {
  factory $DevSettingsCopyWith(DevSettings value, $Res Function(DevSettings) _then) = _$DevSettingsCopyWithImpl;
@useResult
$Res call({
 bool isOnline, LatencyProfile latency, Set<MockOp> failingOps
});




}
/// @nodoc
class _$DevSettingsCopyWithImpl<$Res>
    implements $DevSettingsCopyWith<$Res> {
  _$DevSettingsCopyWithImpl(this._self, this._then);

  final DevSettings _self;
  final $Res Function(DevSettings) _then;

/// Create a copy of DevSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOnline = null,Object? latency = null,Object? failingOps = null,}) {
  return _then(DevSettings(
isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as LatencyProfile,failingOps: null == failingOps ? _self.failingOps : failingOps // ignore: cast_nullable_to_non_nullable
as Set<MockOp>,
  ));
}

}


/// Adds pattern-matching-related methods to [DevSettings].
extension DevSettingsPatterns on DevSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DevSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DevSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DevSettings value)  $default,){
final _that = this;
switch (_that) {
case _DevSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DevSettings value)?  $default,){
final _that = this;
switch (_that) {
case _DevSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isOnline,  LatencyProfile latency,  Set<MockOp> failingOps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DevSettings() when $default != null:
return $default(_that.isOnline,_that.latency,_that.failingOps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isOnline,  LatencyProfile latency,  Set<MockOp> failingOps)  $default,) {final _that = this;
switch (_that) {
case _DevSettings():
return $default(_that.isOnline,_that.latency,_that.failingOps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isOnline,  LatencyProfile latency,  Set<MockOp> failingOps)?  $default,) {final _that = this;
switch (_that) {
case _DevSettings() when $default != null:
return $default(_that.isOnline,_that.latency,_that.failingOps);case _:
  return null;

}
}

}

/// @nodoc


class _DevSettings extends DevSettings {
  const _DevSettings({this.isOnline = true, this.latency = LatencyProfile.realistic,  Set<MockOp> failingOps = const <MockOp>{}}): _failingOps = failingOps,super._();
  

@override@JsonKey() final  bool isOnline;
@override@JsonKey() final  LatencyProfile latency;
 final  Set<MockOp> _failingOps;
@override@JsonKey() Set<MockOp> get failingOps {
  if (_failingOps is EqualUnmodifiableSetView) return _failingOps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_failingOps);
}


/// Create a copy of DevSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DevSettingsCopyWith<_DevSettings> get copyWith => __$DevSettingsCopyWithImpl<_DevSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DevSettings&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.latency, latency) || other.latency == latency)&&const DeepCollectionEquality().equals(other._failingOps, _failingOps));
}


@override
int get hashCode => Object.hash(runtimeType,isOnline,latency,const DeepCollectionEquality().hash(_failingOps));

@override
String toString() {
  return 'DevSettings(isOnline: $isOnline, latency: $latency, failingOps: $failingOps)';
}


}

/// @nodoc
abstract mixin class _$DevSettingsCopyWith<$Res> implements $DevSettingsCopyWith<$Res> {
  factory _$DevSettingsCopyWith(_DevSettings value, $Res Function(_DevSettings) _then) = __$DevSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool isOnline, LatencyProfile latency, Set<MockOp> failingOps
});




}
/// @nodoc
class __$DevSettingsCopyWithImpl<$Res>
    implements _$DevSettingsCopyWith<$Res> {
  __$DevSettingsCopyWithImpl(this._self, this._then);

  final _DevSettings _self;
  final $Res Function(_DevSettings) _then;

/// Create a copy of DevSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOnline = null,Object? latency = null,Object? failingOps = null,}) {
  return _then(_DevSettings(
isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as LatencyProfile,failingOps: null == failingOps ? _self._failingOps : failingOps // ignore: cast_nullable_to_non_nullable
as Set<MockOp>,
  ));
}


}

// dart format on
