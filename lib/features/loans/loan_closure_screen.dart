import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/models/collection_entry.dart';
import '../../core/models/loan.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_value_view.dart';
import 'providers/loan_providers.dart';

/// Loan Closure — settles a loan's full remaining outstanding in one lump
/// sum, matching Stitch's "Loan Closure" screen. On success, reuses
/// PaymentSuccessScreen since closing a loan returns the same
/// PaymentReceipt shape a regular payment does.
class LoanClosureScreen extends ConsumerWidget {
  final String loanId;

  const LoanClosureScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanAsync = ref.watch(loanByIdProvider(loanId));

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Closure')),
      body: AsyncValueView<Loan>(
        value: loanAsync,
        onRetry: () => ref.invalidate(loanByIdProvider(loanId)),
        data: (loan) => _LoanClosureBody(loan: loan),
      ),
    );
  }
}

class _LoanClosureBody extends ConsumerStatefulWidget {
  final Loan loan;

  const _LoanClosureBody({required this.loan});

  @override
  ConsumerState<_LoanClosureBody> createState() => _LoanClosureBodyState();
}

class _LoanClosureBodyState extends ConsumerState<_LoanClosureBody> {
  PaymentMode _mode = PaymentMode.cash;

  Future<void> _handleClose() async {
    final loan = widget.loan;
    final receipt = await ref
        .read(closeLoanControllerProvider.notifier)
        .submit(loan.id, mode: _mode);
    if (!mounted) return;

    final error = ref.read(closeLoanControllerProvider).error;
    if (error != null || receipt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not close loan: ${error ?? 'unknown error'}'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    context.pushReplacement('/payments/success', extra: receipt);
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;
    final isSubmitting = ref.watch(
      closeLoanControllerProvider.select((s) => s.isLoading),
    );
    final alreadyClosed = loan.status == LoanStatus.closed;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
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
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: alreadyClosed
                      ? AppColors.surfaceContainer
                      : AppColors.warningLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  alreadyClosed ? 'CLOSED' : 'PENDING CLOSURE',
                  style: AppTypography.labelSm.copyWith(
                    color: alreadyClosed
                        ? AppColors.onSurfaceVariant
                        : AppColors.warning,
                  ),
                ),
              ),
            ],
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
              children: [
                _AmountRow(
                  label: 'Total Repayable',
                  value: AppFormatters.currency(loan.totalRepayable),
                ),
                const Divider(height: 20),
                _AmountRow(
                  label: 'Total Paid',
                  value: AppFormatters.currency(loan.totalPaid),
                  color: AppColors.success,
                ),
                const Divider(height: 20),
                _AmountRow(
                  label: 'Outstanding',
                  value: AppFormatters.currency(loan.outstanding),
                  color: AppColors.warning,
                ),
                const Divider(height: 20),
                _AmountRow(
                  label: 'Final Closure Amount',
                  value: AppFormatters.currency(loan.outstanding),
                  isBig: true,
                ),
              ],
            ),
          ),

          if (!alreadyClosed) ...[
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Payment Mode',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _ModeChip(
                  icon: Icons.money,
                  label: 'Cash',
                  isSelected: _mode == PaymentMode.cash,
                  onTap: () => setState(() => _mode = PaymentMode.cash),
                ),
                const SizedBox(width: 10),
                _ModeChip(
                  icon: Icons.qr_code,
                  label: 'UPI',
                  isSelected: _mode == PaymentMode.upi,
                  onTap: () => setState(() => _mode = PaymentMode.upi),
                ),
                const SizedBox(width: 10),
                _ModeChip(
                  icon: Icons.account_balance,
                  label: 'Bank',
                  isSelected: _mode == PaymentMode.bank,
                  onTap: () => setState(() => _mode = PaymentMode.bank),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dangerLight.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.danger),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This settles every remaining installment in one payment and closes the loan. This cannot be undone.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _handleClose,
                icon: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(isSubmitting ? 'Closing...' : 'Close Loan'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBig;

  const _AmountRow({
    required this.label,
    required this.value,
    this.color,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBig
              ? AppTypography.titleLg.copyWith(color: AppColors.primary)
              : AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
        ),
        Text(
          value,
          style: isBig
              ? AppTypography.headlineMd.copyWith(color: AppColors.primary)
              : AppTypography.titleMd.copyWith(
                  color: color ?? AppColors.onSurface,
                  fontSize: 15,
                ),
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryContainer.withValues(alpha: 0.15)
                : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelMd.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
