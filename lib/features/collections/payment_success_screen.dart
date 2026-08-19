import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/repositories/collection_repository.dart';

/// Payment Successful — full-screen confirmation shown right after a
/// payment is recorded, matching Stitch's post-payment celebration screen.
class PaymentSuccessScreen extends StatelessWidget {
  final PaymentReceipt receipt;

  const PaymentSuccessScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final payment = receipt.payment;

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
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 56,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Payment Successful',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your transaction has been securely processed.',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
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
                  children: [
                    Text(
                      'AMOUNT PAID',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppFormatters.currency(payment.amount),
                      style: AppTypography.financialLg.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _ReceiptField(
                            label: 'Receipt Number',
                            value: payment.receiptNo,
                          ),
                        ),
                        Expanded(
                          child: _ReceiptField(
                            label: 'Payment Method',
                            value: payment.mode.name.toUpperCase(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _ReceiptField(
                            label: 'Customer',
                            value: payment.borrowerName,
                          ),
                        ),
                        Expanded(
                          child: _ReceiptField(
                            label: 'Loan Number',
                            value: payment.loanId,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _ReceiptField(
                            label: 'Remaining Balance',
                            value: AppFormatters.currency(
                              receipt.newLoanOutstanding,
                            ),
                            valueColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/collections'),
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: const Text('Done'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.push('/payments/receipt', extra: receipt),
                  icon: const Icon(Icons.print_outlined, size: 20),
                  label: const Text('View Receipt'),
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

class _ReceiptField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ReceiptField({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSm.copyWith(
            color: AppColors.outline,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMd.copyWith(
            color: valueColor ?? AppColors.onSurface,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
