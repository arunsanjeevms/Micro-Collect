import 'package:flutter/material.dart';

/// ─── Borrower Model ──────────────────────────────────────────────
class Borrower {
  final String id;
  final String name;
  final String mobile;
  final String aadhaar;
  final String village;
  final String address;
  final String pinCode;
  final String? photoUrl;
  final DateTime joinDate;
  final int activeLoans;
  final double totalOutstanding;
  final BorrowerStatus status;

  const Borrower({
    required this.id,
    required this.name,
    required this.mobile,
    required this.aadhaar,
    required this.village,
    required this.address,
    required this.pinCode,
    this.photoUrl,
    required this.joinDate,
    required this.activeLoans,
    required this.totalOutstanding,
    required this.status,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return name.substring(0, 1);
  }
}

enum BorrowerStatus { active, overdue, closed }

/// ─── Loan Model ──────────────────────────────────────────────────
class Loan {
  final String id;
  final String borrowerId;
  final String borrowerName;
  final double principal;
  final double annualRate;
  final int tenureMonths;
  final String frequency; // daily, weekly, monthly
  final double totalRepayable;
  final double totalPaid;
  final int paidInstallments;
  final int totalInstallments;
  final DateTime disbursementDate;
  final DateTime? closedDate;
  final LoanStatus status;
  final List<Installment> installments;

  const Loan({
    required this.id,
    required this.borrowerId,
    required this.borrowerName,
    required this.principal,
    required this.annualRate,
    required this.tenureMonths,
    required this.frequency,
    required this.totalRepayable,
    required this.totalPaid,
    required this.paidInstallments,
    required this.totalInstallments,
    required this.disbursementDate,
    this.closedDate,
    required this.status,
    required this.installments,
  });

  double get outstanding => totalRepayable - totalPaid;
  double get progressPercent =>
      totalInstallments > 0 ? (paidInstallments / totalInstallments) * 100 : 0;
  double get installmentAmount =>
      totalInstallments > 0 ? totalRepayable / totalInstallments : 0;
}

enum LoanStatus { active, closed, overdue, disbursed }

/// ─── Installment Model ──────────────────────────────────────────
class Installment {
  final String id;
  final int number;
  final DateTime dueDate;
  final double amount;
  final double? paidAmount;
  final DateTime? paidDate;
  final InstallmentStatus status;

  const Installment({
    required this.id,
    required this.number,
    required this.dueDate,
    required this.amount,
    this.paidAmount,
    this.paidDate,
    required this.status,
  });
}

enum InstallmentStatus { paid, pending, overdue, partial, advance }

/// ─── Collection Entry ───────────────────────────────────────────
class CollectionEntry {
  final String id;
  final String borrowerId;
  final String borrowerName;
  final String loanId;
  final double amountDue;
  final double? amountPaid;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String? paymentMode; // cash, upi, bank
  final String? notes;
  final CollectionStatus status;

  const CollectionEntry({
    required this.id,
    required this.borrowerId,
    required this.borrowerName,
    required this.loanId,
    required this.amountDue,
    this.amountPaid,
    required this.dueDate,
    this.paidDate,
    this.paymentMode,
    this.notes,
    required this.status,
  });
}

enum CollectionStatus { collected, pending, overdue, partial }

/// ─── Report Data ────────────────────────────────────────────────
class DailyCollection {
  final DateTime date;
  final double collected;
  final double due;

  const DailyCollection({
    required this.date,
    required this.collected,
    required this.due,
  });

  double get efficiency => due > 0 ? (collected / due) * 100 : 100;
}

/// ═══════════════════════════════════════════════════════════════════
/// MOCK DATA — realistic sample data for all screens
/// ═══════════════════════════════════════════════════════════════════
class MockData {
  MockData._();

  static final now = DateTime.now();

  // ─── Borrowers ──────────────────────────────────────────────────
  static final List<Borrower> borrowers = [
    Borrower(
      id: 'B001',
      name: 'Rajesh Kumar',
      mobile: '9876543210',
      aadhaar: '234567891234',
      village: 'Kothapalli',
      address: 'H.No 3-45, Main Road',
      pinCode: '507001',
      joinDate: DateTime(2024, 3, 15),
      activeLoans: 1,
      totalOutstanding: 18500,
      status: BorrowerStatus.active,
    ),
    Borrower(
      id: 'B002',
      name: 'Lakshmi Devi',
      mobile: '9988776655',
      aadhaar: '456789012345',
      village: 'Rampur',
      address: 'Ward 4, Near Temple',
      pinCode: '507002',
      joinDate: DateTime(2024, 1, 10),
      activeLoans: 2,
      totalOutstanding: 32000,
      status: BorrowerStatus.overdue,
    ),
    Borrower(
      id: 'B003',
      name: 'Suresh Reddy',
      mobile: '8877665544',
      aadhaar: '567890123456',
      village: 'Chintalapudi',
      address: 'Opp. School, Bus Stand Road',
      pinCode: '507003',
      joinDate: DateTime(2024, 6, 20),
      activeLoans: 1,
      totalOutstanding: 12000,
      status: BorrowerStatus.active,
    ),
    Borrower(
      id: 'B004',
      name: 'Padma Kumari',
      mobile: '7766554433',
      aadhaar: '678901234567',
      village: 'Kothapalli',
      address: 'H.No 7-12, Cross Road',
      pinCode: '507001',
      joinDate: DateTime(2023, 11, 5),
      activeLoans: 0,
      totalOutstanding: 0,
      status: BorrowerStatus.closed,
    ),
    Borrower(
      id: 'B005',
      name: 'Venkat Rao',
      mobile: '9654321098',
      aadhaar: '789012345678',
      village: 'Rampur',
      address: 'Ward 2, Market Area',
      pinCode: '507002',
      joinDate: DateTime(2024, 8, 1),
      activeLoans: 1,
      totalOutstanding: 25000,
      status: BorrowerStatus.active,
    ),
    Borrower(
      id: 'B006',
      name: 'Sarita Bai',
      mobile: '9543210987',
      aadhaar: '890123456789',
      village: 'Chintalapudi',
      address: 'H.No 11-3, Lake Road',
      pinCode: '507003',
      joinDate: DateTime(2024, 4, 12),
      activeLoans: 1,
      totalOutstanding: 8500,
      status: BorrowerStatus.overdue,
    ),
    Borrower(
      id: 'B007',
      name: 'Mahesh Goud',
      mobile: '9432109876',
      aadhaar: '901234567890',
      village: 'Kothapalli',
      address: 'Near Water Tank, Main Rd',
      pinCode: '507001',
      joinDate: DateTime(2024, 2, 28),
      activeLoans: 1,
      totalOutstanding: 15200,
      status: BorrowerStatus.active,
    ),
    Borrower(
      id: 'B008',
      name: 'Anitha Sharma',
      mobile: '9321098765',
      aadhaar: '012345678901',
      village: 'Rampur',
      address: 'Ward 6, Post Office Lane',
      pinCode: '507002',
      joinDate: DateTime(2024, 5, 18),
      activeLoans: 1,
      totalOutstanding: 20000,
      status: BorrowerStatus.active,
    ),
  ];

  // ─── Installments for Rajesh Kumar's loan ──────────────────────
  static List<Installment> get _rajeshInstallments => [
    Installment(
      id: 'I001',
      number: 1,
      dueDate: DateTime(2024, 4, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 4, 15),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I002',
      number: 2,
      dueDate: DateTime(2024, 5, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 5, 14),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I003',
      number: 3,
      dueDate: DateTime(2024, 6, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 6, 15),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I004',
      number: 4,
      dueDate: DateTime(2024, 7, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 7, 16),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I005',
      number: 5,
      dueDate: DateTime(2024, 8, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 8, 15),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I006',
      number: 6,
      dueDate: DateTime(2024, 9, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 9, 14),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I007',
      number: 7,
      dueDate: DateTime(2024, 10, 15),
      amount: 2200,
      paidAmount: 1000,
      paidDate: DateTime(2024, 10, 18),
      status: InstallmentStatus.partial,
    ),
    Installment(
      id: 'I008',
      number: 8,
      dueDate: DateTime(2024, 11, 15),
      amount: 2200,
      status: InstallmentStatus.pending,
    ),
    Installment(
      id: 'I009',
      number: 9,
      dueDate: DateTime(2024, 12, 15),
      amount: 2200,
      status: InstallmentStatus.pending,
    ),
    Installment(
      id: 'I010',
      number: 10,
      dueDate: DateTime(2025, 1, 15),
      amount: 2200,
      status: InstallmentStatus.pending,
    ),
  ];

  // ─── Loans ─────────────────────────────────────────────────────
  static List<Loan> get loans => [
    Loan(
      id: 'L001',
      borrowerId: 'B001',
      borrowerName: 'Rajesh Kumar',
      principal: 20000,
      annualRate: 24,
      tenureMonths: 10,
      frequency: 'monthly',
      totalRepayable: 24000,
      totalPaid: 14200,
      paidInstallments: 6,
      totalInstallments: 10,
      disbursementDate: DateTime(2024, 3, 15),
      status: LoanStatus.active,
      installments: _rajeshInstallments,
    ),
    Loan(
      id: 'L002',
      borrowerId: 'B002',
      borrowerName: 'Lakshmi Devi',
      principal: 15000,
      annualRate: 22,
      tenureMonths: 6,
      frequency: 'weekly',
      totalRepayable: 16650,
      totalPaid: 8300,
      paidInstallments: 12,
      totalInstallments: 26,
      disbursementDate: DateTime(2024, 5, 1),
      status: LoanStatus.overdue,
      installments: [],
    ),
    Loan(
      id: 'L003',
      borrowerId: 'B002',
      borrowerName: 'Lakshmi Devi',
      principal: 25000,
      annualRate: 20,
      tenureMonths: 12,
      frequency: 'monthly',
      totalRepayable: 30000,
      totalPaid: 7500,
      paidInstallments: 3,
      totalInstallments: 12,
      disbursementDate: DateTime(2024, 7, 10),
      status: LoanStatus.active,
      installments: [],
    ),
    Loan(
      id: 'L004',
      borrowerId: 'B003',
      borrowerName: 'Suresh Reddy',
      principal: 10000,
      annualRate: 24,
      tenureMonths: 6,
      frequency: 'daily',
      totalRepayable: 11200,
      totalPaid: 5600,
      paidInstallments: 90,
      totalInstallments: 180,
      disbursementDate: DateTime(2024, 6, 20),
      status: LoanStatus.active,
      installments: [],
    ),
    Loan(
      id: 'L005',
      borrowerId: 'B004',
      borrowerName: 'Padma Kumari',
      principal: 8000,
      annualRate: 20,
      tenureMonths: 6,
      frequency: 'monthly',
      totalRepayable: 8800,
      totalPaid: 8800,
      paidInstallments: 6,
      totalInstallments: 6,
      disbursementDate: DateTime(2023, 11, 5),
      closedDate: DateTime(2024, 5, 5),
      status: LoanStatus.closed,
      installments: [],
    ),
    Loan(
      id: 'L006',
      borrowerId: 'B005',
      borrowerName: 'Venkat Rao',
      principal: 30000,
      annualRate: 22,
      tenureMonths: 12,
      frequency: 'monthly',
      totalRepayable: 36600,
      totalPaid: 6100,
      paidInstallments: 2,
      totalInstallments: 12,
      disbursementDate: DateTime(2024, 8, 1),
      status: LoanStatus.active,
      installments: [],
    ),
  ];

  // ─── Today's Collections ───────────────────────────────────────
  static List<CollectionEntry> get todayCollections => [
    CollectionEntry(
      id: 'C001',
      borrowerId: 'B001',
      borrowerName: 'Rajesh Kumar',
      loanId: 'L001',
      amountDue: 2200,
      amountPaid: 2200,
      dueDate: now,
      paidDate: now,
      paymentMode: 'cash',
      status: CollectionStatus.collected,
    ),
    CollectionEntry(
      id: 'C002',
      borrowerId: 'B003',
      borrowerName: 'Suresh Reddy',
      loanId: 'L004',
      amountDue: 62,
      amountPaid: 62,
      dueDate: now,
      paidDate: now,
      paymentMode: 'upi',
      status: CollectionStatus.collected,
    ),
    CollectionEntry(
      id: 'C003',
      borrowerId: 'B005',
      borrowerName: 'Venkat Rao',
      loanId: 'L006',
      amountDue: 3050,
      dueDate: now,
      status: CollectionStatus.pending,
    ),
    CollectionEntry(
      id: 'C004',
      borrowerId: 'B002',
      borrowerName: 'Lakshmi Devi',
      loanId: 'L002',
      amountDue: 640,
      dueDate: now,
      status: CollectionStatus.overdue,
    ),
    CollectionEntry(
      id: 'C005',
      borrowerId: 'B006',
      borrowerName: 'Sarita Bai',
      loanId: 'L002',
      amountDue: 850,
      amountPaid: 500,
      dueDate: now,
      paidDate: now,
      paymentMode: 'cash',
      notes: 'Will pay remaining tomorrow',
      status: CollectionStatus.partial,
    ),
    CollectionEntry(
      id: 'C006',
      borrowerId: 'B007',
      borrowerName: 'Mahesh Goud',
      loanId: 'L001',
      amountDue: 1520,
      dueDate: now,
      status: CollectionStatus.pending,
    ),
    CollectionEntry(
      id: 'C007',
      borrowerId: 'B008',
      borrowerName: 'Anitha Sharma',
      loanId: 'L006',
      amountDue: 2000,
      amountPaid: 2000,
      dueDate: now,
      paidDate: now,
      paymentMode: 'bank',
      status: CollectionStatus.collected,
    ),
  ];

  // ─── Weekly Collection Data (for charts) ───────────────────────
  static List<DailyCollection> get weeklyCollections => List.generate(7, (i) {
    final date = now.subtract(Duration(days: 6 - i));
    final dues = [
      28500.0,
      31200.0,
      24800.0,
      35000.0,
      29600.0,
      32500.0,
      30000.0,
    ];
    final collected = [
      24850.0,
      28400.0,
      22100.0,
      30500.0,
      25200.0,
      31800.0,
      24850.0,
    ];
    return DailyCollection(date: date, collected: collected[i], due: dues[i]);
  });

  // ─── Color for borrower avatars ────────────────────────────────
  static Color avatarColor(String id) {
    final colors = [
      const Color(0xFF065F46),
      const Color(0xFF855300),
      const Color(0xFF393768),
      const Color(0xFF059669),
      const Color(0xFF2563EB),
      const Color(0xFFD97706),
      const Color(0xFF0D9488),
      const Color(0xFF6366F1),
    ];
    final index = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return colors[index % colors.length];
  }
}
