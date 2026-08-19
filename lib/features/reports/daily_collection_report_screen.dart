import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/models/collection_entry.dart';
import '../../core/models/payment.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../collections/providers/collection_providers.dart';

/// Daily Collection Report — every payment actually collected today,
/// against today's due target, matching Stitch's report screen.
class DailyCollectionReportScreen extends ConsumerWidget {
  const DailyCollectionReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(collectionSummaryProvider);
    final paymentsAsync = ref.watch(todayPaymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Collection Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(collectionSummaryProvider);
              ref.invalidate(todayPaymentsProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppFormatters.date(DateTime.now()),
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            summaryAsync.when(
              data: (summary) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryTile(
                          label: 'Total Collected',
                          value: AppFormatters.currency(summary.totalCollected),
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _SummaryTile(
                          label: 'Target',
                          value: AppFormatters.currency(summary.totalDue),
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryTile(
                          label: 'Variance',
                          value: AppFormatters.currency(
                            summary.totalCollected - summary.totalDue,
                          ),
                          color: summary.totalCollected >= summary.totalDue
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _SummaryTile(
                          label: 'Efficiency',
                          value: '${summary.efficiency.toStringAsFixed(0)}%',
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.xl),

            AsyncValueView<List<Payment>>(
              value: paymentsAsync,
              isEmpty: (list) => list.isEmpty,
              empty: const EmptyStateWidget(
                icon: Icons.receipt_long_outlined,
                title: 'No payments recorded yet',
                description: 'Payments collected today will appear here.',
              ),
              onRetry: () => ref.invalidate(todayPaymentsProvider),
              data: (payments) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PREVIEW (${payments.length} RECORDS)',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'Sorted by: Time (Latest)',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...payments.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _PaymentRow(payment: p),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleLg.copyWith(color: color, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final Payment payment;

  const _PaymentRow({required this.payment});

  IconData get _modeIcon {
    switch (payment.mode) {
      case PaymentMode.cash:
        return Icons.money;
      case PaymentMode.upi:
        return Icons.qr_code;
      case PaymentMode.bank:
        return Icons.account_balance;
    }
  }

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
            child: Icon(_modeIcon, size: 16, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.borrowerName,
                  style: AppTypography.titleMd.copyWith(fontSize: 14),
                ),
                Text(
                  '${payment.loanId} · ${TimeOfDay.fromDateTime(payment.paidAt).format(context)}',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            AppFormatters.currency(payment.amount),
            style: AppTypography.titleMd.copyWith(
              color: AppColors.success,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
