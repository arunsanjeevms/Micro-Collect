import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/models/mock_data.dart';
import '../../core/utils/avatar_color.dart';
import '../../core/utils/formatters.dart';

/// Borrower Detail Screen — profile, loans, and payment history
class BorrowerDetailScreen extends StatelessWidget {
  final String borrowerId;

  const BorrowerDetailScreen({super.key, required this.borrowerId});

  @override
  Widget build(BuildContext context) {
    final borrowerMatches = MockData.borrowers.where((b) => b.id == borrowerId);
    if (borrowerMatches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Borrower')),
        body: EmptyStateWidget(
          icon: Icons.person_off_outlined,
          title: 'Borrower not found',
          description:
              'This borrower may have been removed or the link is invalid.',
        ),
      );
    }
    final borrower = borrowerMatches.first;
    final borrowerLoans = MockData.loans
        .where((l) => l.borrowerId == borrowerId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(borrower.name),
        actions: [
          IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.phone_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Profile Header ──────────────────────────────────
            GlassCard(
              color: AppColors.primaryFixed,
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: avatarColorForId(borrower.id),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        borrower.initials,
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          borrower.name,
                          style: AppTypography.titleLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _InfoRow(
                          icon: Icons.phone_outlined,
                          text: AppFormatters.phone(borrower.mobile),
                        ),
                        const SizedBox(height: 2),
                        _InfoRow(
                          icon: Icons.credit_card_outlined,
                          text:
                              'Aadhaar: ${AppFormatters.maskAadhaar(borrower.aadhaar)}',
                        ),
                        const SizedBox(height: 2),
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          text: '${borrower.village}, ${borrower.pinCode}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── Quick Stats ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    label: 'Active Loans',
                    value: '${borrower.activeLoans}',
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MiniStatCard(
                    label: 'Outstanding',
                    value: AppFormatters.currency(borrower.totalOutstanding),
                    icon: Icons.account_balance_wallet_outlined,
                    color: borrower.status == BorrowerStatus.overdue
                        ? AppColors.danger
                        : AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    label: 'Member Since',
                    value: AppFormatters.date(borrower.joinDate),
                    icon: Icons.calendar_today_outlined,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MiniStatCard(
                    label: 'Status',
                    value: borrower.status.name.toUpperCase(),
                    icon: Icons.verified_outlined,
                    color: borrower.status == BorrowerStatus.active
                        ? AppColors.success
                        : borrower.status == BorrowerStatus.overdue
                        ? AppColors.danger
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ─── Loans Section ───────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LOANS',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      context.push('/loans/create?borrowerId=$borrowerId'),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('New Loan'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            if (borrowerLoans.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Center(
                  child: Text(
                    'No loans found',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...borrowerLoans.map(
                (loan) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _LoanCard(
                    loan: loan,
                    onTap: () => context.push('/loans/${loan.id}'),
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.xl),

            // ─── Recent Payments ─────────────────────────────────
            Text(
              'RECENT PAYMENTS',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...List.generate(
              3,
              (i) => _PaymentTimelineItem(
                amount: [2200.0, 2200.0, 2200.0][i],
                date: DateTime.now().subtract(Duration(days: 30 * (i + 1))),
                mode: ['Cash', 'UPI', 'Cash'][i],
                isLast: i == 2,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),

      // Quick action buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(
            top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone_rounded, size: 18),
                label: const Text('Call'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.payments_rounded, size: 18),
                label: const Text('Record Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info Row ────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─── Mini Stat Card ──────────────────────────────────────────────
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
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
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTypography.titleMd.copyWith(
              color: AppColors.onSurface,
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

// ─── Loan Card ───────────────────────────────────────────────────
class _LoanCard extends StatelessWidget {
  final Loan loan;
  final VoidCallback? onTap;

  const _LoanCard({required this.loan, this.onTap});

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
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: loan.status == LoanStatus.overdue
                    ? AppColors.danger
                    : loan.status == LoanStatus.closed
                    ? AppColors.onSurfaceVariant
                    : AppColors.primary,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    loan.id,
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  StatusBadge(status: _statusType, compact: true),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    AppFormatters.currency(loan.principal),
                    style: AppTypography.financialMd.copyWith(
                      fontSize: 20,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${loan.annualRate}% · ${loan.tenureMonths}mo · ${loan.frequency}',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${loan.paidInstallments}/${loan.totalInstallments} installments',
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
                  const SizedBox(height: 6),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Payment Timeline Item ───────────────────────────────────────
class _PaymentTimelineItem extends StatelessWidget {
  final double amount;
  final DateTime date;
  final String mode;
  final bool isLast;

  const _PaymentTimelineItem({
    required this.amount,
    required this.date,
    required this.mode,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot & line
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.successLight, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: AppColors.outlineVariant),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppFormatters.currency(amount),
                          style: AppTypography.titleMd.copyWith(
                            color: AppColors.success,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppFormatters.date(date),
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        mode,
                        style: AppTypography.labelMd.copyWith(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
