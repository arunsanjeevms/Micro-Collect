import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/repositories/collection_repository.dart';

/// Payment Receipt Preview — a thermal-receipt-styled view of a completed
/// payment, with Share/Print actions. No printer/share integration exists
/// yet in this mock-data-only build, so those actions surface a SnackBar
/// rather than pretending to succeed.
class PaymentReceiptScreen extends StatelessWidget {
  final PaymentReceipt receipt;

  const PaymentReceiptScreen({super.key, required this.receipt});

  void _notAvailable(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action isn\'t available in this preview yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payment = receipt.payment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _notAvailable(context, 'Sharing'),
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () => _notAvailable(context, 'Printing'),
          ),
        ],
      ),
      backgroundColor: AppColors.surfaceContainerLow,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.account_balance_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'MICROCOLLECT',
                        style: AppTypography.titleLg.copyWith(letterSpacing: 1),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rural Collection Services',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _DashedDivider(),
                  const SizedBox(height: 12),
                  _ReceiptRow(label: 'Receipt #', value: payment.receiptNo),
                  _ReceiptRow(
                    label: 'Date',
                    value: AppFormatters.date(payment.paidAt),
                  ),
                  _ReceiptRow(
                    label: 'Time',
                    value: TimeOfDay.fromDateTime(payment.paidAt)
                        .format(context),
                  ),
                  const SizedBox(height: 12),
                  const _DashedDivider(),
                  const SizedBox(height: 12),
                  Text(
                    'CUSTOMER DETAILS',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _ReceiptRow(label: 'Name', value: payment.borrowerName),
                  _ReceiptRow(label: 'Loan No.', value: payment.loanId),
                  _ReceiptRow(
                    label: 'Installments',
                    value: receipt.touchedInstallmentNumbers
                        .map((n) => '#$n')
                        .join(', '),
                  ),
                  const SizedBox(height: 12),
                  const _DashedDivider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL PAID', style: AppTypography.titleMd),
                      Text(
                        AppFormatters.currency(payment.amount),
                        style: AppTypography.titleLg.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _ReceiptRow(
                    label: 'Payment Method',
                    value: payment.mode.name.toUpperCase(),
                  ),
                  _ReceiptRow(
                    label: 'Remaining Bal.',
                    value: AppFormatters.currency(receipt.newLoanOutstanding),
                  ),
                  const SizedBox(height: 12),
                  const _DashedDivider(),
                  const SizedBox(height: 12),
                  Text(
                    'Thank you for your payment!',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodySm.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / 6).floor();
          return Row(
            children: List.generate(
              dashCount,
              (_) => Expanded(
                child: Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  color: AppColors.outlineVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
