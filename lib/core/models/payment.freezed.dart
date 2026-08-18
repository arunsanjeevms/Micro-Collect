// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Payment {

 String get id; String get receiptNo; String get borrowerId; String get borrowerName; String get loanId; List<String> get installmentIds; double get amount; PaymentMode get mode; String? get notes; DateTime get paidAt;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&const DeepCollectionEquality().equals(other.installmentIds, installmentIds)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,receiptNo,borrowerId,borrowerName,loanId,const DeepCollectionEquality().hash(installmentIds),amount,mode,notes,paidAt);

@override
String toString() {
  return 'Payment(id: $id, receiptNo: $receiptNo, borrowerId: $borrowerId, borrowerName: $borrowerName, loanId: $loanId, installmentIds: $installmentIds, amount: $amount, mode: $mode, notes: $notes, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id, String receiptNo, String borrowerId, String borrowerName, String loanId, List<String> installmentIds, double amount, PaymentMode mode, String? notes, DateTime paidAt
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? receiptNo = null,Object? borrowerId = null,Object? borrowerName = null,Object? loanId = null,Object? installmentIds = null,Object? amount = null,Object? mode = null,Object? notes = freezed,Object? paidAt = null,}) {
  return _then(Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNo: null == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as String,installmentIds: null == installmentIds ? _self.installmentIds : installmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String receiptNo,  String borrowerId,  String borrowerName,  String loanId,  List<String> installmentIds,  double amount,  PaymentMode mode,  String? notes,  DateTime paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.receiptNo,_that.borrowerId,_that.borrowerName,_that.loanId,_that.installmentIds,_that.amount,_that.mode,_that.notes,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String receiptNo,  String borrowerId,  String borrowerName,  String loanId,  List<String> installmentIds,  double amount,  PaymentMode mode,  String? notes,  DateTime paidAt)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.receiptNo,_that.borrowerId,_that.borrowerName,_that.loanId,_that.installmentIds,_that.amount,_that.mode,_that.notes,_that.paidAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String receiptNo,  String borrowerId,  String borrowerName,  String loanId,  List<String> installmentIds,  double amount,  PaymentMode mode,  String? notes,  DateTime paidAt)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.receiptNo,_that.borrowerId,_that.borrowerName,_that.loanId,_that.installmentIds,_that.amount,_that.mode,_that.notes,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc


class _Payment implements Payment {
  const _Payment({required this.id, required this.receiptNo, required this.borrowerId, required this.borrowerName, required this.loanId, required  List<String> installmentIds, required this.amount, required this.mode, this.notes, required this.paidAt}): _installmentIds = installmentIds;
  

@override final  String id;
@override final  String receiptNo;
@override final  String borrowerId;
@override final  String borrowerName;
@override final  String loanId;
 final  List<String> _installmentIds;
@override List<String> get installmentIds {
  if (_installmentIds is EqualUnmodifiableListView) return _installmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_installmentIds);
}

@override final  double amount;
@override final  PaymentMode mode;
@override final  String? notes;
@override final  DateTime paidAt;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&const DeepCollectionEquality().equals(other._installmentIds, _installmentIds)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,receiptNo,borrowerId,borrowerName,loanId,const DeepCollectionEquality().hash(_installmentIds),amount,mode,notes,paidAt);

@override
String toString() {
  return 'Payment(id: $id, receiptNo: $receiptNo, borrowerId: $borrowerId, borrowerName: $borrowerName, loanId: $loanId, installmentIds: $installmentIds, amount: $amount, mode: $mode, notes: $notes, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String receiptNo, String borrowerId, String borrowerName, String loanId, List<String> installmentIds, double amount, PaymentMode mode, String? notes, DateTime paidAt
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? receiptNo = null,Object? borrowerId = null,Object? borrowerName = null,Object? loanId = null,Object? installmentIds = null,Object? amount = null,Object? mode = null,Object? notes = freezed,Object? paidAt = null,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNo: null == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as String,installmentIds: null == installmentIds ? _self._installmentIds : installmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
