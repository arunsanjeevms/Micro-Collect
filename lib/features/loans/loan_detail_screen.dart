import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/models/loan.dart';
import '../../core/models/installment.dart';
import '../../core/utils/formatters.dart';
import 'providers/loan_providers.dart';

/// Loan Detail Screen — full loan overview with installment schedule
class LoanDetailScreen extends ConsumerWidget {
  final String loanId;

  const LoanDetailScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanAsync = ref.watch(loanByIdProvider(loanId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Loan ${loanAsync.value?.id ?? loanId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: AsyncValueView<Loan>(
        value: loanAsync,
        onRetry: () => ref.invalidate(loanByIdProvider(loanId)),
        data: (loan) => _LoanDetailBody(loan: loan),
      ),
    );
  }
}

class _LoanDetailBody extends StatelessWidget {
  final Loan loan;

  const _LoanDetailBody({required this.loan});

  StatusType _loanStatusType(LoanStatus status) {
    switch (status) {
      case LoanStatus.active:
        return StatusType.active;
      case LoanStatus.closed:
        return StatusType.closed;
      case LoanStatus.overdue:
        return StatusType.overdue;
      case LoanStatus.disbursed:
        return StatusType.disbursed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ─── Loan Overview Card ──────────────────────────────
              GlassCard(
                color: AppColors.primaryFixed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loan.borrowerName,
                          style: AppTypography.titleMd.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        StatusBadge(status: _loanStatusType(loan.status)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppFormatters.currency(loan.principal),
                      style: AppTypography.financialLg.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Principal Amount',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Loan terms row
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          _TermItem(
                            label: 'Rate',
                            value: '${loan.annualRate}%',
                          ),
                          _TermDivider(),
                          _TermItem(
                            label: 'Tenure',
                            value: '${loan.tenureMonths}mo',
                          ),
                          _TermDivider(),
                          _TermItem(
                            label: 'Frequency',
                            value:
                                loan.frequency[0].toUpperCase() +
                                loan.frequency.substring(1),
                          ),
                          _TermDivider(),
                          _TermItem(
                            label: 'EMI',
                            value: AppFormatters.currency(
                              loan.installmentAmount,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Repayment Progress ──────────────────────────────
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
                          'Repayment Progress',
                          style: AppTypography.titleMd.copyWith(fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${loan.progressPercent.toStringAsFixed(0)}%',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.success,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: loan.progressPercent / 100,
                        minHeight: 10,
                        backgroundColor: AppColors.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation(
                          loan.status == LoanStatus.overdue
                              ? AppColors.danger
                              : AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount details
                    Row(
                      children: [
                        Expanded(
                          child: _AmountDetail(
                            label: 'Total Repayable',
                            value: AppFormatters.currency(loan.totalRepayable),
                            color: AppColors.onSurface,
                          ),
                        ),
                        Expanded(
                          child: _AmountDetail(
                            label: 'Paid',
                            value: AppFormatters.currency(loan.totalPaid),
                            color: AppColors.success,
                          ),
                        ),
                        Expanded(
                          child: _AmountDetail(
                            label: 'Outstanding',
                            value: AppFormatters.currency(loan.outstanding),
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Key Dates ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _DateRow(
                      icon: Icons.play_circle_outline_rounded,
                      label: 'Disbursement',
                      date: AppFormatters.date(loan.disbursementDate),
                      color: AppColors.info,
                    ),
                    const Divider(height: 24),
                    _DateRow(
                      icon: Icons.flag_outlined,
                      label: 'Maturity',
                      date: AppFormatters.date(
                        DateTime(
                          loan.disbursementDate.year,
                          loan.disbursementDate.month + loan.tenureMonths,
                          loan.disbursementDate.day,
                        ),
                      ),
                      color: AppColors.warning,
                    ),
                    if (loan.closedDate != null) ...[
                      const Divider(height: 24),
                      _DateRow(
                        icon: Icons.check_circle_outline_rounded,
                        label: 'Closed',
                        date: AppFormatters.date(loan.closedDate!),
                        color: AppColors.success,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ─── Installment Schedule ────────────────────────────
              Text(
                'INSTALLMENT SCHEDULE',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              if (loan.installments.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 40,
                          color: AppColors.onSurfaceVariant.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Schedule not available',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
        ),
        // A daily loan can generate hundreds of installments - build the
        // schedule as a lazy sliver instead of eagerly inflating one Column.
        if (loan.installments.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            sliver: SliverList.separated(
              itemCount: loan.installments.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  _InstallmentRow(installment: loan.installments[index]),
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xxl)),
      ],
    );
  }
}

// ─── Term Item ───────────────────────────────────────────────────
class _TermItem extends StatelessWidget {
  final String label;
  final String value;

  const _TermItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.titleMd.copyWith(
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _TermDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: AppColors.outlineVariant);
  }
}

// ─── Amount Detail ───────────────────────────────────────────────
class _AmountDetail extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AmountDetail({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMd.copyWith(color: color, fontSize: 14),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ─── Date Row ────────────────────────────────────────────────────
class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String date;
  final Color color;

  const _DateRow({
    required this.icon,
    required this.label,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(date, style: AppTypography.titleMd.copyWith(fontSize: 14)),
      ],
    );
  }
}

// ─── Installment Row ─────────────────────────────────────────────
class _InstallmentRow extends StatelessWidget {
  final Installment installment;

  const _InstallmentRow({required this.installment});

  StatusType get _statusType {
    switch (installment.status) {
      case InstallmentStatus.paid:
        return StatusType.paid;
      case InstallmentStatus.pending:
        return StatusType.pending;
      case InstallmentStatus.overdue:
        return StatusType.overdue;
      case InstallmentStatus.partial:
        return StatusType.partial;
      case InstallmentStatus.advance:
        return StatusType.advance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = installment.status == InstallmentStatus.paid;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isPaid
            ? AppColors.successLight.withValues(alpha: 0.3)
            : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isPaid
              ? AppColors.success.withValues(alpha: 0.2)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          // Number
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isPaid
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isPaid
                  ? Icon(Icons.check, size: 14, color: AppColors.success)
                  : Text(
                      '${installment.number}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppFormatters.date(installment.dueDate),
                  style: AppTypography.titleMd.copyWith(
                    fontSize: 13,
                    color: AppColors.onSurface,
                  ),
                ),
                if (installment.paidDate != null)
                  Text(
                    'Paid ${AppFormatters.date(installment.paidDate!)}',
                    style: AppTypography.bodySm.copyWith(
                      fontSize: 11,
                      color: AppColors.success,
                    ),
                  ),
              ],
            ),
          ),

          // Amount + Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormatters.currency(installment.amount),
                style: AppTypography.titleMd.copyWith(
                  fontSize: 14,
                  color: isPaid ? AppColors.success : AppColors.onSurface,
                  decoration: isPaid ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 4),
              StatusBadge(status: _statusType, compact: true),
            ],
          ),
        ],
      ),
    );
  }
}
