import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/models/loan.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';

/// Loan Created Successfully — full-screen confirmation shown right after
/// a new loan is disbursed, matching Stitch's post-creation celebration
/// screen (mirrors PaymentSuccessScreen's structure).
class LoanCreatedScreen extends StatelessWidget {
  final Loan loan;

  const LoanCreatedScreen({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    final firstDue = loan.installments.isEmpty
        ? null
        : loan.installments.first.dueDate;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.white,
                  size: 56,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Loan Created Successfully',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${loan.borrowerName} • ${loan.id}',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Summary',
                      style: AppTypography.titleMd.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Principal Amount',
                      value: AppFormatters.currency(loan.principal),
                      isBig: true,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Total Repayable',
                      value: AppFormatters.currency(loan.totalRepayable),
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Installments',
                      value:
                          '${loan.totalInstallments} × ${AppFormatters.currency(loan.installmentAmount)}',
                    ),
                    if (firstDue != null) ...[
                      const SizedBox(height: 12),
                      _SummaryRow(
                        label: 'First Due Date',
                        value: AppFormatters.date(firstDue),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/loans/${loan.id}'),
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  label: const Text('View Loan'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Printing isn\'t available in this preview yet',
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.print_outlined, size: 20),
                  label: const Text('Print Agreement'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBig;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: isBig
              ? AppTypography.titleLg.copyWith(color: AppColors.onSurface)
              : AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
        ),
      ],
    );
  }
}
