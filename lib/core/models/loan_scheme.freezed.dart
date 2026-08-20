// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_scheme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanScheme {

 String get id; String get code; String get name; bool get active; double get principalMin; double get principalMax; int get tenureMin; int get tenureMax; String get tenureUnit; String get frequency;
/// Create a copy of LoanScheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanSchemeCopyWith<LoanScheme> get copyWith => _$LoanSchemeCopyWithImpl<LoanScheme>(this as LoanScheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanScheme&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.active, active) || other.active == active)&&(identical(other.principalMin, principalMin) || other.principalMin == principalMin)&&(identical(other.principalMax, principalMax) || other.principalMax == principalMax)&&(identical(other.tenureMin, tenureMin) || other.tenureMin == tenureMin)&&(identical(other.tenureMax, tenureMax) || other.tenureMax == tenureMax)&&(identical(other.tenureUnit, tenureUnit) || other.tenureUnit == tenureUnit)&&(identical(other.frequency, frequency) || other.frequency == frequency));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,name,active,principalMin,principalMax,tenureMin,tenureMax,tenureUnit,frequency);

@override
String toString() {
  return 'LoanScheme(id: $id, code: $code, name: $name, active: $active, principalMin: $principalMin, principalMax: $principalMax, tenureMin: $tenureMin, tenureMax: $tenureMax, tenureUnit: $tenureUnit, frequency: $frequency)';
}


}

/// @nodoc
abstract mixin class $LoanSchemeCopyWith<$Res>  {
  factory $LoanSchemeCopyWith(LoanScheme value, $Res Function(LoanScheme) _then) = _$LoanSchemeCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, bool active, double principalMin, double principalMax, int tenureMin, int tenureMax, String tenureUnit, String frequency
});




}
/// @nodoc
class _$LoanSchemeCopyWithImpl<$Res>
    implements $LoanSchemeCopyWith<$Res> {
  _$LoanSchemeCopyWithImpl(this._self, this._then);

  final LoanScheme _self;
  final $Res Function(LoanScheme) _then;

/// Create a copy of LoanScheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? active = null,Object? principalMin = null,Object? principalMax = null,Object? tenureMin = null,Object? tenureMax = null,Object? tenureUnit = null,Object? frequency = null,}) {
  return _then(LoanScheme(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,principalMin: null == principalMin ? _self.principalMin : principalMin // ignore: cast_nullable_to_non_nullable
as double,principalMax: null == principalMax ? _self.principalMax : principalMax // ignore: cast_nullable_to_non_nullable
as double,tenureMin: null == tenureMin ? _self.tenureMin : tenureMin // ignore: cast_nullable_to_non_nullable
as int,tenureMax: null == tenureMax ? _self.tenureMax : tenureMax // ignore: cast_nullable_to_non_nullable
as int,tenureUnit: null == tenureUnit ? _self.tenureUnit : tenureUnit // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanScheme].
extension LoanSchemePatterns on LoanScheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanScheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanScheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanScheme value)  $default,){
final _that = this;
switch (_that) {
case _LoanScheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanScheme value)?  $default,){
final _that = this;
switch (_that) {
case _LoanScheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  bool active,  double principalMin,  double principalMax,  int tenureMin,  int tenureMax,  String tenureUnit,  String frequency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanScheme() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.active,_that.principalMin,_that.principalMax,_that.tenureMin,_that.tenureMax,_that.tenureUnit,_that.frequency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  bool active,  double principalMin,  double principalMax,  int tenureMin,  int tenureMax,  String tenureUnit,  String frequency)  $default,) {final _that = this;
switch (_that) {
case _LoanScheme():
return $default(_that.id,_that.code,_that.name,_that.active,_that.principalMin,_that.principalMax,_that.tenureMin,_that.tenureMax,_that.tenureUnit,_that.frequency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  bool active,  double principalMin,  double principalMax,  int tenureMin,  int tenureMax,  String tenureUnit,  String frequency)?  $default,) {final _that = this;
switch (_that) {
case _LoanScheme() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.active,_that.principalMin,_that.principalMax,_that.tenureMin,_that.tenureMax,_that.tenureUnit,_that.frequency);case _:
  return null;

}
}

}

/// @nodoc


class _LoanScheme implements LoanScheme {
  const _LoanScheme({required this.id, required this.code, required this.name, required this.active, required this.principalMin, required this.principalMax, required this.tenureMin, required this.tenureMax, required this.tenureUnit, required this.frequency});
  

@override final  String id;
@override final  String code;
@override final  String name;
@override final  bool active;
@override final  double principalMin;
@override final  double principalMax;
@override final  int tenureMin;
@override final  int tenureMax;
@override final  String tenureUnit;
@override final  String frequency;

/// Create a copy of LoanScheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanSchemeCopyWith<_LoanScheme> get copyWith => __$LoanSchemeCopyWithImpl<_LoanScheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanScheme&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.active, active) || other.active == active)&&(identical(other.principalMin, principalMin) || other.principalMin == principalMin)&&(identical(other.principalMax, principalMax) || other.principalMax == principalMax)&&(identical(other.tenureMin, tenureMin) || other.tenureMin == tenureMin)&&(identical(other.tenureMax, tenureMax) || other.tenureMax == tenureMax)&&(identical(other.tenureUnit, tenureUnit) || other.tenureUnit == tenureUnit)&&(identical(other.frequency, frequency) || other.frequency == frequency));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,name,active,principalMin,principalMax,tenureMin,tenureMax,tenureUnit,frequency);

@override
String toString() {
  return 'LoanScheme(id: $id, code: $code, name: $name, active: $active, principalMin: $principalMin, principalMax: $principalMax, tenureMin: $tenureMin, tenureMax: $tenureMax, tenureUnit: $tenureUnit, frequency: $frequency)';
}


}

/// @nodoc
abstract mixin class _$LoanSchemeCopyWith<$Res> implements $LoanSchemeCopyWith<$Res> {
  factory _$LoanSchemeCopyWith(_LoanScheme value, $Res Function(_LoanScheme) _then) = __$LoanSchemeCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, bool active, double principalMin, double principalMax, int tenureMin, int tenureMax, String tenureUnit, String frequency
});




}
/// @nodoc
class __$LoanSchemeCopyWithImpl<$Res>
    implements _$LoanSchemeCopyWith<$Res> {
  __$LoanSchemeCopyWithImpl(this._self, this._then);

  final _LoanScheme _self;
  final $Res Function(_LoanScheme) _then;

/// Create a copy of LoanScheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? active = null,Object? principalMin = null,Object? principalMax = null,Object? tenureMin = null,Object? tenureMax = null,Object? tenureUnit = null,Object? frequency = null,}) {
  return _then(_LoanScheme(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,principalMin: null == principalMin ? _self.principalMin : principalMin // ignore: cast_nullable_to_non_nullable
as double,principalMax: null == principalMax ? _self.principalMax : principalMax // ignore: cast_nullable_to_non_nullable
as double,tenureMin: null == tenureMin ? _self.tenureMin : tenureMin // ignore: cast_nullable_to_non_nullable
as int,tenureMax: null == tenureMax ? _self.tenureMax : tenureMax // ignore: cast_nullable_to_non_nullable
as int,tenureUnit: null == tenureUnit ? _self.tenureUnit : tenureUnit // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
