import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/models/loan.dart';
import '../../core/models/payment.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../collections/providers/collection_providers.dart';
import 'providers/loan_providers.dart';

/// Loan Statement — financial summary plus full transaction history for
/// one loan, matching Stitch's "Loan Statement" screen.
class LoanStatementScreen extends ConsumerWidget {
  final String loanId;

  const LoanStatementScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanAsync = ref.watch(loanByIdProvider(loanId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Statement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sharing isn\'t available in this preview yet'),
              ),
            ),
          ),
        ],
      ),
      body: AsyncValueView<Loan>(
        value: loanAsync,
        onRetry: () => ref.invalidate(loanByIdProvider(loanId)),
        data: (loan) => _LoanStatementBody(loan: loan),
      ),
    );
  }
}

class _LoanStatementBody extends ConsumerWidget {
  final Loan loan;

  const _LoanStatementBody({required this.loan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsForLoanProvider(loan.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loan.borrowerName, style: AppTypography.titleLg),
          Text(
            loan.id,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Summary',
                  style: AppTypography.titleMd.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Outstanding Balance',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  AppFormatters.currency(loan.outstanding),
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.warning,
                  ),
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryField(
                        label: 'Principal',
                        value: AppFormatters.currency(loan.principal),
                      ),
                    ),
                    Expanded(
                      child: _SummaryField(
                        label: 'Interest',
                        value: AppFormatters.currency(
                          loan.totalRepayable - loan.principal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryField(
                        label: 'Total Repayable',
                        value: AppFormatters.currency(loan.totalRepayable),
                      ),
                    ),
                    Expanded(
                      child: _SummaryField(
                        label: 'Total Paid',
                        value: AppFormatters.currency(loan.totalPaid),
                        valueColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Text(
            'Transaction History',
            style: AppTypography.titleMd.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),

          AsyncValueView<List<Payment>>(
            value: paymentsAsync,
            isEmpty: (list) => list.isEmpty,
            empty: const EmptyStateWidget(
              icon: Icons.history_rounded,
              title: 'No transactions yet',
              description: 'Payments recorded against this loan appear here.',
            ),
            onRetry: () => ref.invalidate(paymentsForLoanProvider(loan.id)),
            data: (payments) => Column(
              children: payments
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _TransactionRow(payment: p),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryField({
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
          label,
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTypography.titleLg.copyWith(
            color: valueColor ?? AppColors.onSurface,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final Payment payment;

  const _TransactionRow({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_downward_rounded,
              size: 16,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paid: ${AppFormatters.currency(payment.amount)}',
                  style: AppTypography.titleMd.copyWith(fontSize: 14),
                ),
                Text(
                  '${AppFormatters.date(payment.paidAt)} · ${payment.mode.name.toUpperCase()} · ${payment.receiptNo}',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
