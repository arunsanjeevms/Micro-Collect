import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/models/borrower.dart';
import '../../core/models/installment.dart';
import '../../core/models/loan.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/avatar_color.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/status_badge.dart';
import '../borrowers/providers/borrower_providers.dart';
import 'providers/loan_providers.dart';

enum _LoanFilter { all, active, closed, overdue }

/// Customer Loans Overview — every loan for one borrower, filterable by status.
class BorrowerLoansScreen extends ConsumerStatefulWidget {
  final String borrowerId;

  const BorrowerLoansScreen({super.key, required this.borrowerId});

  @override
  ConsumerState<BorrowerLoansScreen> createState() =>
      _BorrowerLoansScreenState();
}

class _BorrowerLoansScreenState extends ConsumerState<BorrowerLoansScreen> {
  _LoanFilter _filter = _LoanFilter.all;

  @override
  Widget build(BuildContext context) {
    final borrowerAsync = ref.watch(borrowerByIdProvider(widget.borrowerId));
    final loansAsync = ref.watch(loansForBorrowerProvider(widget.borrowerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Loans'), titleSpacing: 0),
      body: AsyncValueView<List<Loan>>(
        value: loansAsync,
        onRetry: () =>
            ref.invalidate(loansForBorrowerProvider(widget.borrowerId)),
        isEmpty: (list) => list.isEmpty,
        empty: const EmptyStateWidget(
          icon: Icons.receipt_long_outlined,
          title: 'No loans yet',
          description: 'Loans for this borrower will appear here.',
        ),
        data: (loans) {
          final borrower = borrowerAsync.value;
          final activeLoans = loans
              .where((l) => l.status == LoanStatus.active)
              .toList();
          final closedLoans = loans
              .where((l) => l.status == LoanStatus.closed)
              .toList();
          final overdueLoans = loans
              .where((l) => l.status == LoanStatus.overdue)
              .toList();
          final totalOutstanding = loans.fold<double>(
            0,
            (sum, l) => sum + l.outstanding,
          );
          final totalPaid = loans.fold<double>(
            0,
            (sum, l) => sum + l.totalPaid,
          );
          final nextDue = _earliestPendingInstallment(loans);

          final visibleLoans = switch (_filter) {
            _LoanFilter.all => loans,
            _LoanFilter.active => activeLoans,
            _LoanFilter.closed => closedLoans,
            _LoanFilter.overdue => overdueLoans,
          };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (borrower != null) _BorrowerHeader(borrower: borrower),
                if (borrower != null) const SizedBox(height: AppSpacing.lg),

                // Summary bento
                Row(
                  children: [
                    Expanded(
                      child: _SummaryStat(
                        label: 'Active Loans',
                        value: '${activeLoans.length}',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _SummaryStat(
                        label: 'Outstanding',
                        value: AppFormatters.currency(totalOutstanding),
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryStat(
                        label: 'Total Paid',
                        value: AppFormatters.currency(totalPaid),
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _SummaryStat(
                        label: 'Next Due',
                        value: nextDue == null
                            ? '—'
                            : AppFormatters.currency(nextDue.amount),
                        subValue: nextDue == null
                            ? null
                            : AppFormatters.date(nextDue.dueDate),
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Status filter tabs
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterTab(
                        label: 'All (${loans.length})',
                        selected: _filter == _LoanFilter.all,
                        onTap: () => setState(() => _filter = _LoanFilter.all),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: 'Active (${activeLoans.length})',
                        selected: _filter == _LoanFilter.active,
                        onTap: () =>
                            setState(() => _filter = _LoanFilter.active),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: 'Closed (${closedLoans.length})',
                        selected: _filter == _LoanFilter.closed,
                        onTap: () =>
                            setState(() => _filter = _LoanFilter.closed),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: 'Overdue (${overdueLoans.length})',
                        selected: _filter == _LoanFilter.overdue,
                        onTap: () =>
                            setState(() => _filter = _LoanFilter.overdue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (visibleLoans.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: EmptyStateWidget(
                      icon: Icons.filter_alt_off_outlined,
                      title: 'No loans in this filter',
                      description: 'Try a different status filter.',
                    ),
                  )
                else
                  ...visibleLoans.map(
                    (loan) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _LoanOverviewCard(
                        loan: loan,
                        onView: () => context.push('/loans/${loan.id}'),
                        onCollect: () => context.push('/collections'),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Installment? _earliestPendingInstallment(List<Loan> loans) {
    Installment? next;
    for (final loan in loans) {
      for (final inst in loan.installments) {
        if (inst.status != InstallmentStatus.pending &&
            inst.status != InstallmentStatus.overdue &&
            inst.status != InstallmentStatus.partial) {
          continue;
        }
        if (next == null || inst.dueDate.isBefore(next.dueDate)) {
          next = inst;
        }
      }
    }
    return next;
  }
}

class _BorrowerHeader extends StatelessWidget {
  final Borrower borrower;

  const _BorrowerHeader({required this.borrower});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: avatarColorForId(borrower.id),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              borrower.initials,
              style: AppTypography.labelMd.copyWith(color: AppColors.white),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                borrower.name,
                style: AppTypography.titleMd.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                borrower.id,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final Color color;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
    this.subValue,
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
              letterSpacing: 0.8,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.titleMd.copyWith(color: color, fontSize: 16),
          ),
          if (subValue != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subValue!,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.danger,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : AppColors.outlineVariant,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: selected
                ? AppColors.onPrimaryContainer
                : AppColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _LoanOverviewCard extends StatelessWidget {
  final Loan loan;
  final VoidCallback onView;
  final VoidCallback onCollect;

  const _LoanOverviewCard({
    required this.loan,
    required this.onView,
    required this.onCollect,
  });

  StatusType get _statusType {
    switch (loan.status) {
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(status: _statusType, compact: true),
              const SizedBox(width: 8),
              Text(
                loan.id,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${loan.frequency[0].toUpperCase()}${loan.frequency.substring(1)} Loan',
            style: AppTypography.titleMd.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 12),
          _AmountRow(label: 'Principal', value: loan.principal),
          const SizedBox(height: 6),
          _AmountRow(
            label: 'Paid',
            value: loan.totalPaid,
            color: AppColors.success,
          ),
          const SizedBox(height: 6),
          _AmountRow(
            label: 'Outstanding',
            value: loan.outstanding,
            color: AppColors.warning,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              Text(
                '${loan.progressPercent.toStringAsFixed(0)}%',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: loan.progressPercent / 100,
              minHeight: 6,
              backgroundColor: AppColors.surfaceContainer,
              valueColor: AlwaysStoppedAnimation(
                loan.status == LoanStatus.overdue
                    ? AppColors.danger
                    : AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onView,
                  child: const Text('View'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCollect,
                  child: const Text('Collect'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? color;

  const _AmountRow({required this.label, required this.value, this.color});

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
        Text(
          AppFormatters.currency(value),
          style: AppTypography.labelMd.copyWith(
            color: color ?? AppColors.onSurface,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
