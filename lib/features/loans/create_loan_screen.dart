import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/models/borrower.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/loan_calculator.dart';
import '../borrowers/providers/borrower_providers.dart';
import '../../data/repositories/loan_repository.dart';
import 'providers/loan_providers.dart';

/// Create Loan Screen — form with live EMI preview
class CreateLoanScreen extends ConsumerWidget {
  final String borrowerId;

  const CreateLoanScreen({super.key, required this.borrowerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borrowerAsync = ref.watch(borrowerByIdProvider(borrowerId));

    return Scaffold(
      appBar: borrowerAsync.value == null
          ? AppBar(title: const Text('New Loan'))
          : null,
      body: AsyncValueView<Borrower>(
        value: borrowerAsync,
        onRetry: () => ref.invalidate(borrowerByIdProvider(borrowerId)),
        data: (borrower) => _CreateLoanForm(borrower: borrower),
      ),
    );
  }
}

class _CreateLoanForm extends ConsumerStatefulWidget {
  final Borrower borrower;

  const _CreateLoanForm({required this.borrower});

  @override
  ConsumerState<_CreateLoanForm> createState() => _CreateLoanFormState();
}

class _CreateLoanFormState extends ConsumerState<_CreateLoanForm> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController(text: '20000');
  final _rateController = TextEditingController(text: '24');
  final _tenureController = TextEditingController(text: '12');
  String _frequency = 'monthly';
  int _advanceInstallments = 0;

  double get _principal =>
      double.tryParse(_principalController.text.replaceAll(',', '')) ?? 0;
  double get _rate => double.tryParse(_rateController.text) ?? 0;
  int get _tenure => int.tryParse(_tenureController.text) ?? 0;

  double get _totalRepayable => LoanCalculator.totalRepayable(
    principal: _principal,
    annualRate: _rate,
    tenureMonths: _tenure,
  );

  int get _installmentCount => LoanCalculator.installmentCount(
    tenureMonths: _tenure,
    frequency: _frequency,
  );

  double get _emiAmount => LoanCalculator.installmentAmount(
    totalRepayable: _totalRepayable,
    numberOfInstallments: _installmentCount,
  );

  double get _advanceDeduction => LoanCalculator.advanceDeduction(
    totalRepayable: _totalRepayable,
    advanceInstallments: _advanceInstallments,
    totalInstallments: _installmentCount,
  );

  double get _disbursement => LoanCalculator.disbursementAmount(
    principal: _principal,
    advanceDeduction: _advanceDeduction,
  );

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final loan = await ref
        .read(createLoanControllerProvider.notifier)
        .submit(
          LoanDraft(
            borrowerId: widget.borrower.id,
            principal: _principal,
            annualRate: _rate,
            tenureMonths: _tenure,
            frequency: _frequency,
            advanceInstallments: _advanceInstallments,
          ),
        );
    if (!mounted) return;

    final error = ref.read(createLoanControllerProvider).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not create loan: $error'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }
    if (loan == null) return;

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
            Text('Loan of ${AppFormatters.currency(_principal)} created'),
          ],
        ),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final borrower = widget.borrower;
    final isSubmitting = ref.watch(
      createLoanControllerProvider.select((s) => s.isLoading),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Loan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'for ${borrower.name}',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Live Preview Card ─────────────────────────────
              GlassCard(
                color: AppColors.primaryFixed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calculate_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'LOAN PREVIEW',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _PreviewItem(
                            label: 'EMI / Installment',
                            value: AppFormatters.currency(_emiAmount),
                            isBig: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _PreviewItem(
                              label: 'Total Repayable',
                              value: AppFormatters.currency(_totalRepayable),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 28,
                            color: AppColors.outlineVariant,
                          ),
                          Expanded(
                            child: _PreviewItem(
                              label: 'Interest',
                              value: AppFormatters.currency(
                                _totalRepayable - _principal,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 28,
                            color: AppColors.outlineVariant,
                          ),
                          Expanded(
                            child: _PreviewItem(
                              label: 'Installments',
                              value: '$_installmentCount',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_advanceInstallments > 0) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.warningLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Advance deduction: ${AppFormatters.currency(_advanceDeduction)} · Disbursement: ${AppFormatters.currency(_disbursement)}',
                                style: AppTypography.bodySm.copyWith(
                                  fontSize: 12,
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ─── Loan Details ──────────────────────────────────
              _SectionHeader(
                icon: Icons.account_balance_outlined,
                title: 'Loan Details',
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _principalController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  final amount = double.tryParse(v?.replaceAll(',', '') ?? '');
                  if (amount == null || amount < 1000) {
                    return 'Minimum ₹1,000';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Principal Amount *',
                  hintText: '20000',
                  prefixText: '₹ ',
                  prefixIcon: Icon(Icons.currency_rupee, size: 20),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rateController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        final rate = double.tryParse(v ?? '');
                        if (rate == null || rate <= 0 || rate > 50) {
                          return 'Invalid rate';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Annual Rate *',
                        hintText: '24',
                        suffixText: '%',
                        prefixIcon: Icon(Icons.percent, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _tenureController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        final months = int.tryParse(v ?? '');
                        if (months == null || months < 1 || months > 60) {
                          return 'Invalid tenure';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tenure *',
                        hintText: '12',
                        suffixText: 'months',
                        prefixIcon: Icon(Icons.calendar_month, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Frequency ─────────────────────────────────────
              Text(
                'Repayment Frequency',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: ['daily', 'weekly', 'monthly'].map((freq) {
                  final isSelected = _frequency == freq;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _frequency = freq),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: freq != 'monthly' ? 8 : 0,
                        ),
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
                        child: Center(
                          child: Text(
                            freq[0].toUpperCase() + freq.substring(1),
                            style: AppTypography.labelMd.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Advance Deduction ─────────────────────────────
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Advance Deduction',
                          style: AppTypography.titleMd.copyWith(fontSize: 14),
                        ),
                        Text(
                          '$_advanceInstallments installments',
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryContainer,
                        inactiveTrackColor: AppColors.surfaceContainer,
                        thumbColor: AppColors.primaryContainer,
                        overlayColor: AppColors.primaryContainer.withValues(
                          alpha: 0.2,
                        ),
                      ),
                      child: Slider(
                        value: _advanceInstallments.toDouble(),
                        min: 0,
                        max: 5,
                        divisions: 5,
                        onChanged: (v) =>
                            setState(() => _advanceInstallments = v.round()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isSubmitting ? null : _handleSubmit,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded, size: 20),
                  label: Text(isSubmitting ? 'Creating...' : 'Create Loan'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Preview Item ────────────────────────────────────────────────
class _PreviewItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isBig;

  const _PreviewItem({
    required this.label,
    required this.value,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: isBig
              ? AppTypography.financialMd.copyWith(color: AppColors.primary)
              : AppTypography.titleMd.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Section Header ──────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.titleMd.copyWith(
            color: AppColors.primary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
