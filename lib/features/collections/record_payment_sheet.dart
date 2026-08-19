import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/models/collection_entry.dart';
import '../../core/utils/avatar_color.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../data/repositories/collection_repository.dart';
import 'providers/collection_providers.dart';

/// Record Payment Bottom Sheet — amount, mode, notes, confirmation
class RecordPaymentSheet extends ConsumerStatefulWidget {
  final CollectionEntry entry;

  const RecordPaymentSheet({super.key, required this.entry});

  @override
  ConsumerState<RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends ConsumerState<RecordPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  final _notesController = TextEditingController();
  PaymentMode _paymentMode = PaymentMode.cash;
  bool _showConfirmation = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.entry.amountDue.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleRecord() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _showConfirmation = true);
    }
  }

  Future<void> _confirmPayment() async {
    final amount = double.parse(_amountController.text.replaceAll(',', ''));
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);

    final receipt = await ref
        .read(recordPaymentControllerProvider.notifier)
        .submit(
          RecordPaymentInput(
            collectionId: widget.entry.id,
            amount: amount,
            mode: _paymentMode,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          ),
        );

    if (!mounted) return;

    if (receipt == null) {
      final error = ref.read(recordPaymentControllerProvider).error;
      setState(
        () => _submitError = error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : 'Something went wrong. Please try again.',
      );
      return;
    }

    navigator.pop();
    router.push('/payments/success', extra: receipt);
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(recordPaymentControllerProvider).isLoading;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: _showConfirmation
            ? _buildConfirmation(isSubmitting)
            : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    final totalDue = widget.entry.totalDue;
    final hasArrears = widget.entry.previousDue > 0;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: avatarColorForId(widget.entry.borrowerId),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.entry.borrowerName
                        .split(' ')
                        .map((w) => w[0])
                        .take(2)
                        .join(),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.entry.borrowerName,
                      style: AppTypography.titleMd,
                    ),
                    Text(
                      hasArrears
                          ? 'Due: ${AppFormatters.currency(totalDue)} (incl. ${AppFormatters.currency(widget.entry.previousDue)} arrears) · Loan ${widget.entry.loanId}'
                          : 'Due: ${AppFormatters.currency(widget.entry.amountDue)} · Loan ${widget.entry.loanId}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Amount
          Text(
            'Enter Amount to Collect',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTypography.financialMd.copyWith(fontSize: 28),
            validator: (value) => AppValidators.amount(value, min: 1),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: AppTypography.financialMd.copyWith(
                fontSize: 28,
                color: AppColors.onSurfaceVariant,
              ),
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Quick amount chips
          Row(
            children: [
              _QuickAmountChip(
                label: 'Today\'s Due',
                onTap: () => _amountController.text = widget.entry.amountDue
                    .toStringAsFixed(0),
              ),
              if (hasArrears) ...[
                const SizedBox(width: 8),
                _QuickAmountChip(
                  label: 'Full Outstanding',
                  onTap: () =>
                      _amountController.text = totalDue.toStringAsFixed(0),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Payment Mode
          Text(
            'Payment Mode',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _PaymentModeChip(
                icon: Icons.money,
                label: 'Cash',
                isSelected: _paymentMode == PaymentMode.cash,
                onTap: () => setState(() => _paymentMode = PaymentMode.cash),
              ),
              const SizedBox(width: 10),
              _PaymentModeChip(
                icon: Icons.qr_code,
                label: 'UPI',
                isSelected: _paymentMode == PaymentMode.upi,
                onTap: () => setState(() => _paymentMode = PaymentMode.upi),
              ),
              const SizedBox(width: 10),
              _PaymentModeChip(
                icon: Icons.account_balance,
                label: 'Bank',
                isSelected: _paymentMode == PaymentMode.bank,
                onTap: () => setState(() => _paymentMode = PaymentMode.bank),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Notes
          Text(
            'Notes (optional)',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _notesController,
            maxLines: 2,
            decoration: const InputDecoration(hintText: 'Any remarks...'),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Submit
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handleRecord,
              icon: const Icon(Icons.check_rounded, size: 20),
              label: const Text('Record Payment'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation(bool isSubmitting) {
    final amount = double.parse(_amountController.text.replaceAll(',', ''));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Success icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: AppColors.success,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Confirm Payment',
          style: AppTypography.titleLg.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Receipt-style summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            children: [
              _ReceiptRow(label: 'Borrower', value: widget.entry.borrowerName),
              const Divider(height: 20),
              _ReceiptRow(label: 'Loan', value: widget.entry.loanId),
              const Divider(height: 20),
              _ReceiptRow(
                label: 'Amount',
                value: AppFormatters.currency(amount),
                isBold: true,
              ),
              const Divider(height: 20),
              _ReceiptRow(
                label: 'Mode',
                value:
                    _paymentMode.name[0].toUpperCase() +
                    _paymentMode.name.substring(1),
              ),
              if (_notesController.text.isNotEmpty) ...[
                const Divider(height: 20),
                _ReceiptRow(label: 'Notes', value: _notesController.text),
              ],
              const Divider(height: 20),
              _ReceiptRow(
                label: 'Date',
                value: AppFormatters.dateTime(DateTime.now()),
              ),
            ],
          ),
        ),

        if (_submitError != null) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.dangerLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.danger,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _submitError!,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),

        // Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isSubmitting
                    ? null
                    : () => setState(() {
                        _showConfirmation = false;
                        _submitError = null;
                      }),
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _confirmPayment,
                icon: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.white),
                        ),
                      )
                    : const Icon(Icons.check_rounded, size: 20),
                label: Text(
                  isSubmitting
                      ? (_submitError != null ? 'Retry' : 'Recording...')
                      : (_submitError != null ? 'Retry' : 'Confirm'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Quick Amount Chip ────────────────────────────────────────────
class _QuickAmountChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickAmountChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryContainer.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMd.copyWith(
            fontSize: 12,
            color: AppColors.primaryContainer,
          ),
        ),
      ),
    );
  }
}

// ─── Payment Mode Chip ───────────────────────────────────────────
class _PaymentModeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentModeChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryContainer
                  : AppColors.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.white
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Receipt Row ─────────────────────────────────────────────────
class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: isBold
                ? AppTypography.financialSm.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                  )
                : AppTypography.titleMd.copyWith(fontSize: 14),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
