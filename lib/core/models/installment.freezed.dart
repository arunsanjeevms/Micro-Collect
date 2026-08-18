// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'installment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Installment {

 String get id; int get number; DateTime get dueDate; double get amount; double? get paidAmount; DateTime? get paidDate; InstallmentStatus get status;
/// Create a copy of Installment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstallmentCopyWith<Installment> get copyWith => _$InstallmentCopyWithImpl<Installment>(this as Installment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Installment&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,number,dueDate,amount,paidAmount,paidDate,status);

@override
String toString() {
  return 'Installment(id: $id, number: $number, dueDate: $dueDate, amount: $amount, paidAmount: $paidAmount, paidDate: $paidDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $InstallmentCopyWith<$Res>  {
  factory $InstallmentCopyWith(Installment value, $Res Function(Installment) _then) = _$InstallmentCopyWithImpl;
@useResult
$Res call({
 String id, int number, DateTime dueDate, double amount, double? paidAmount, DateTime? paidDate, InstallmentStatus status
});




}
/// @nodoc
class _$InstallmentCopyWithImpl<$Res>
    implements $InstallmentCopyWith<$Res> {
  _$InstallmentCopyWithImpl(this._self, this._then);

  final Installment _self;
  final $Res Function(Installment) _then;

/// Create a copy of Installment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? dueDate = null,Object? amount = null,Object? paidAmount = freezed,Object? paidDate = freezed,Object? status = null,}) {
  return _then(Installment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double?,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InstallmentStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Installment].
extension InstallmentPatterns on Installment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Installment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Installment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Installment value)  $default,){
final _that = this;
switch (_that) {
case _Installment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Installment value)?  $default,){
final _that = this;
switch (_that) {
case _Installment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  DateTime dueDate,  double amount,  double? paidAmount,  DateTime? paidDate,  InstallmentStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Installment() when $default != null:
return $default(_that.id,_that.number,_that.dueDate,_that.amount,_that.paidAmount,_that.paidDate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  DateTime dueDate,  double amount,  double? paidAmount,  DateTime? paidDate,  InstallmentStatus status)  $default,) {final _that = this;
switch (_that) {
case _Installment():
return $default(_that.id,_that.number,_that.dueDate,_that.amount,_that.paidAmount,_that.paidDate,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  DateTime dueDate,  double amount,  double? paidAmount,  DateTime? paidDate,  InstallmentStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Installment() when $default != null:
return $default(_that.id,_that.number,_that.dueDate,_that.amount,_that.paidAmount,_that.paidDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _Installment implements Installment {
  const _Installment({required this.id, required this.number, required this.dueDate, required this.amount, this.paidAmount, this.paidDate, required this.status});
  

@override final  String id;
@override final  int number;
@override final  DateTime dueDate;
@override final  double amount;
@override final  double? paidAmount;
@override final  DateTime? paidDate;
@override final  InstallmentStatus status;

/// Create a copy of Installment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstallmentCopyWith<_Installment> get copyWith => __$InstallmentCopyWithImpl<_Installment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Installment&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,number,dueDate,amount,paidAmount,paidDate,status);

@override
String toString() {
  return 'Installment(id: $id, number: $number, dueDate: $dueDate, amount: $amount, paidAmount: $paidAmount, paidDate: $paidDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$InstallmentCopyWith<$Res> implements $InstallmentCopyWith<$Res> {
  factory _$InstallmentCopyWith(_Installment value, $Res Function(_Installment) _then) = __$InstallmentCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, DateTime dueDate, double amount, double? paidAmount, DateTime? paidDate, InstallmentStatus status
});




}
/// @nodoc
class __$InstallmentCopyWithImpl<$Res>
    implements _$InstallmentCopyWith<$Res> {
  __$InstallmentCopyWithImpl(this._self, this._then);

  final _Installment _self;
  final $Res Function(_Installment) _then;

/// Create a copy of Installment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? dueDate = null,Object? amount = null,Object? paidAmount = freezed,Object? paidDate = freezed,Object? status = null,}) {
  return _then(_Installment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double?,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InstallmentStatus,
  ));
}


}

// dart format on
