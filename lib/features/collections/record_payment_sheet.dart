import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/models/mock_data.dart';
import '../../core/utils/avatar_color.dart';
import '../../core/utils/formatters.dart';

/// Record Payment Bottom Sheet — amount, mode, notes, confirmation
class RecordPaymentSheet extends StatefulWidget {
  final CollectionEntry entry;

  const RecordPaymentSheet({super.key, required this.entry});

  @override
  State<RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends State<RecordPaymentSheet> {
  late final TextEditingController _amountController;
  final _notesController = TextEditingController();
  String _paymentMode = 'cash';
  bool _showConfirmation = false;

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
    setState(() => _showConfirmation = true);
  }

  void _confirmPayment() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.successLight,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${AppFormatters.currency(double.tryParse(_amountController.text) ?? 0)} recorded for ${widget.entry.borrowerName}',
            ),
          ],
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: _showConfirmation ? _buildConfirmation() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
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
                  Text(widget.entry.borrowerName, style: AppTypography.titleMd),
                  Text(
                    'Due: ${AppFormatters.currency(widget.entry.amountDue)} · Loan ${widget.entry.loanId}',
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
          'Amount',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: AppTypography.financialMd.copyWith(fontSize: 28),
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
              isSelected: _paymentMode == 'cash',
              onTap: () => setState(() => _paymentMode = 'cash'),
            ),
            const SizedBox(width: 10),
            _PaymentModeChip(
              icon: Icons.qr_code,
              label: 'UPI',
              isSelected: _paymentMode == 'upi',
              onTap: () => setState(() => _paymentMode = 'upi'),
            ),
            const SizedBox(width: 10),
            _PaymentModeChip(
              icon: Icons.account_balance,
              label: 'Bank',
              isSelected: _paymentMode == 'bank',
              onTap: () => setState(() => _paymentMode = 'bank'),
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
    );
  }

  Widget _buildConfirmation() {
    final amount =
        double.tryParse(_amountController.text) ?? widget.entry.amountDue;

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
            border: Border.all(
              color: AppColors.outlineVariant,
              style: BorderStyle.solid,
            ),
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
                    _paymentMode[0].toUpperCase() + _paymentMode.substring(1),
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
        const SizedBox(height: AppSpacing.xl),

        // Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _showConfirmation = false),
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _confirmPayment,
                icon: const Icon(Icons.check_rounded, size: 20),
                label: const Text('Confirm'),
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
