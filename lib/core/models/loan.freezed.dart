// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Loan {

 String get id; String get borrowerId; String get borrowerName; double get principal; double get annualRate; int get tenureMonths; String get frequency; double get totalRepayable; double get totalPaid; int get paidInstallments; int get totalInstallments; DateTime get disbursementDate; DateTime? get closedDate; LoanStatus get status; List<Installment> get installments;
/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCopyWith<Loan> get copyWith => _$LoanCopyWithImpl<Loan>(this as Loan, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.principal, principal) || other.principal == principal)&&(identical(other.annualRate, annualRate) || other.annualRate == annualRate)&&(identical(other.tenureMonths, tenureMonths) || other.tenureMonths == tenureMonths)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.totalRepayable, totalRepayable) || other.totalRepayable == totalRepayable)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.paidInstallments, paidInstallments) || other.paidInstallments == paidInstallments)&&(identical(other.totalInstallments, totalInstallments) || other.totalInstallments == totalInstallments)&&(identical(other.disbursementDate, disbursementDate) || other.disbursementDate == disbursementDate)&&(identical(other.closedDate, closedDate) || other.closedDate == closedDate)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.installments, installments));
}


@override
int get hashCode => Object.hash(runtimeType,id,borrowerId,borrowerName,principal,annualRate,tenureMonths,frequency,totalRepayable,totalPaid,paidInstallments,totalInstallments,disbursementDate,closedDate,status,const DeepCollectionEquality().hash(installments));

@override
String toString() {
  return 'Loan(id: $id, borrowerId: $borrowerId, borrowerName: $borrowerName, principal: $principal, annualRate: $annualRate, tenureMonths: $tenureMonths, frequency: $frequency, totalRepayable: $totalRepayable, totalPaid: $totalPaid, paidInstallments: $paidInstallments, totalInstallments: $totalInstallments, disbursementDate: $disbursementDate, closedDate: $closedDate, status: $status, installments: $installments)';
}


}

/// @nodoc
abstract mixin class $LoanCopyWith<$Res>  {
  factory $LoanCopyWith(Loan value, $Res Function(Loan) _then) = _$LoanCopyWithImpl;
@useResult
$Res call({
 String id, String borrowerId, String borrowerName, double principal, double annualRate, int tenureMonths, String frequency, double totalRepayable, double totalPaid, int paidInstallments, int totalInstallments, DateTime disbursementDate, DateTime? closedDate, LoanStatus status, List<Installment> installments
});




}
/// @nodoc
class _$LoanCopyWithImpl<$Res>
    implements $LoanCopyWith<$Res> {
  _$LoanCopyWithImpl(this._self, this._then);

  final Loan _self;
  final $Res Function(Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? borrowerId = null,Object? borrowerName = null,Object? principal = null,Object? annualRate = null,Object? tenureMonths = null,Object? frequency = null,Object? totalRepayable = null,Object? totalPaid = null,Object? paidInstallments = null,Object? totalInstallments = null,Object? disbursementDate = null,Object? closedDate = freezed,Object? status = null,Object? installments = null,}) {
  return _then(Loan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,principal: null == principal ? _self.principal : principal // ignore: cast_nullable_to_non_nullable
as double,annualRate: null == annualRate ? _self.annualRate : annualRate // ignore: cast_nullable_to_non_nullable
as double,tenureMonths: null == tenureMonths ? _self.tenureMonths : tenureMonths // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,totalRepayable: null == totalRepayable ? _self.totalRepayable : totalRepayable // ignore: cast_nullable_to_non_nullable
as double,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as double,paidInstallments: null == paidInstallments ? _self.paidInstallments : paidInstallments // ignore: cast_nullable_to_non_nullable
as int,totalInstallments: null == totalInstallments ? _self.totalInstallments : totalInstallments // ignore: cast_nullable_to_non_nullable
as int,disbursementDate: null == disbursementDate ? _self.disbursementDate : disbursementDate // ignore: cast_nullable_to_non_nullable
as DateTime,closedDate: freezed == closedDate ? _self.closedDate : closedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoanStatus,installments: null == installments ? _self.installments : installments // ignore: cast_nullable_to_non_nullable
as List<Installment>,
  ));
}

}


/// Adds pattern-matching-related methods to [Loan].
extension LoanPatterns on Loan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Loan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Loan value)  $default,){
final _that = this;
switch (_that) {
case _Loan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Loan value)?  $default,){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String borrowerId,  String borrowerName,  double principal,  double annualRate,  int tenureMonths,  String frequency,  double totalRepayable,  double totalPaid,  int paidInstallments,  int totalInstallments,  DateTime disbursementDate,  DateTime? closedDate,  LoanStatus status,  List<Installment> installments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.borrowerId,_that.borrowerName,_that.principal,_that.annualRate,_that.tenureMonths,_that.frequency,_that.totalRepayable,_that.totalPaid,_that.paidInstallments,_that.totalInstallments,_that.disbursementDate,_that.closedDate,_that.status,_that.installments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String borrowerId,  String borrowerName,  double principal,  double annualRate,  int tenureMonths,  String frequency,  double totalRepayable,  double totalPaid,  int paidInstallments,  int totalInstallments,  DateTime disbursementDate,  DateTime? closedDate,  LoanStatus status,  List<Installment> installments)  $default,) {final _that = this;
switch (_that) {
case _Loan():
return $default(_that.id,_that.borrowerId,_that.borrowerName,_that.principal,_that.annualRate,_that.tenureMonths,_that.frequency,_that.totalRepayable,_that.totalPaid,_that.paidInstallments,_that.totalInstallments,_that.disbursementDate,_that.closedDate,_that.status,_that.installments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String borrowerId,  String borrowerName,  double principal,  double annualRate,  int tenureMonths,  String frequency,  double totalRepayable,  double totalPaid,  int paidInstallments,  int totalInstallments,  DateTime disbursementDate,  DateTime? closedDate,  LoanStatus status,  List<Installment> installments)?  $default,) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.borrowerId,_that.borrowerName,_that.principal,_that.annualRate,_that.tenureMonths,_that.frequency,_that.totalRepayable,_that.totalPaid,_that.paidInstallments,_that.totalInstallments,_that.disbursementDate,_that.closedDate,_that.status,_that.installments);case _:
  return null;

}
}

}

/// @nodoc


class _Loan extends Loan {
  const _Loan({required this.id, required this.borrowerId, required this.borrowerName, required this.principal, required this.annualRate, required this.tenureMonths, required this.frequency, required this.totalRepayable, required this.totalPaid, required this.paidInstallments, required this.totalInstallments, required this.disbursementDate, this.closedDate, required this.status, required  List<Installment> installments}): _installments = installments,super._();
  

@override final  String id;
@override final  String borrowerId;
@override final  String borrowerName;
@override final  double principal;
@override final  double annualRate;
@override final  int tenureMonths;
@override final  String frequency;
@override final  double totalRepayable;
@override final  double totalPaid;
@override final  int paidInstallments;
@override final  int totalInstallments;
@override final  DateTime disbursementDate;
@override final  DateTime? closedDate;
@override final  LoanStatus status;
 final  List<Installment> _installments;
@override List<Installment> get installments {
  if (_installments is EqualUnmodifiableListView) return _installments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_installments);
}


/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanCopyWith<_Loan> get copyWith => __$LoanCopyWithImpl<_Loan>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.principal, principal) || other.principal == principal)&&(identical(other.annualRate, annualRate) || other.annualRate == annualRate)&&(identical(other.tenureMonths, tenureMonths) || other.tenureMonths == tenureMonths)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.totalRepayable, totalRepayable) || other.totalRepayable == totalRepayable)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.paidInstallments, paidInstallments) || other.paidInstallments == paidInstallments)&&(identical(other.totalInstallments, totalInstallments) || other.totalInstallments == totalInstallments)&&(identical(other.disbursementDate, disbursementDate) || other.disbursementDate == disbursementDate)&&(identical(other.closedDate, closedDate) || other.closedDate == closedDate)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._installments, _installments));
}


@override
int get hashCode => Object.hash(runtimeType,id,borrowerId,borrowerName,principal,annualRate,tenureMonths,frequency,totalRepayable,totalPaid,paidInstallments,totalInstallments,disbursementDate,closedDate,status,const DeepCollectionEquality().hash(_installments));

@override
String toString() {
  return 'Loan(id: $id, borrowerId: $borrowerId, borrowerName: $borrowerName, principal: $principal, annualRate: $annualRate, tenureMonths: $tenureMonths, frequency: $frequency, totalRepayable: $totalRepayable, totalPaid: $totalPaid, paidInstallments: $paidInstallments, totalInstallments: $totalInstallments, disbursementDate: $disbursementDate, closedDate: $closedDate, status: $status, installments: $installments)';
}


}

/// @nodoc
abstract mixin class _$LoanCopyWith<$Res> implements $LoanCopyWith<$Res> {
  factory _$LoanCopyWith(_Loan value, $Res Function(_Loan) _then) = __$LoanCopyWithImpl;
@override @useResult
$Res call({
 String id, String borrowerId, String borrowerName, double principal, double annualRate, int tenureMonths, String frequency, double totalRepayable, double totalPaid, int paidInstallments, int totalInstallments, DateTime disbursementDate, DateTime? closedDate, LoanStatus status, List<Installment> installments
});




}
/// @nodoc
class __$LoanCopyWithImpl<$Res>
    implements _$LoanCopyWith<$Res> {
  __$LoanCopyWithImpl(this._self, this._then);

  final _Loan _self;
  final $Res Function(_Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? borrowerId = null,Object? borrowerName = null,Object? principal = null,Object? annualRate = null,Object? tenureMonths = null,Object? frequency = null,Object? totalRepayable = null,Object? totalPaid = null,Object? paidInstallments = null,Object? totalInstallments = null,Object? disbursementDate = null,Object? closedDate = freezed,Object? status = null,Object? installments = null,}) {
  return _then(_Loan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,principal: null == principal ? _self.principal : principal // ignore: cast_nullable_to_non_nullable
as double,annualRate: null == annualRate ? _self.annualRate : annualRate // ignore: cast_nullable_to_non_nullable
as double,tenureMonths: null == tenureMonths ? _self.tenureMonths : tenureMonths // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,totalRepayable: null == totalRepayable ? _self.totalRepayable : totalRepayable // ignore: cast_nullable_to_non_nullable
as double,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as double,paidInstallments: null == paidInstallments ? _self.paidInstallments : paidInstallments // ignore: cast_nullable_to_non_nullable
as int,totalInstallments: null == totalInstallments ? _self.totalInstallments : totalInstallments // ignore: cast_nullable_to_non_nullable
as int,disbursementDate: null == disbursementDate ? _self.disbursementDate : disbursementDate // ignore: cast_nullable_to_non_nullable
as DateTime,closedDate: freezed == closedDate ? _self.closedDate : closedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoanStatus,installments: null == installments ? _self._installments : installments // ignore: cast_nullable_to_non_nullable
as List<Installment>,
  ));
}


}

// dart format on
