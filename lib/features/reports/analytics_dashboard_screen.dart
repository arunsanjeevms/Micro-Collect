import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/models/loan.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/glass_card.dart';
import '../collections/providers/collection_providers.dart';
import '../loans/providers/loan_providers.dart';

/// Analytics Dashboard — a portfolio-wide view built entirely from real
/// provider data, matching Stitch's "Analytics Overview" screen. Sections
/// Stitch renders that have no backing domain model yet (area-wise and
/// employee-performance breakdowns - there's no Area/Employee concept in
/// this app) are intentionally left out rather than filled with invented
/// numbers.
class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(collectionSummaryProvider);
    final loansAsync = ref.watch(loansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Overview')),
      body: AsyncValueView<List<Loan>>(
        value: loansAsync,
        onRetry: () => ref.invalidate(loansProvider),
        data: (loans) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              summaryAsync.when(
                data: (summary) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            label: "Today's Collection",
                            value: AppFormatters.currency(
                              summary.totalCollected,
                            ),
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _StatTile(
                            label: "Today's Due",
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
                          child: _StatTile(
                            label: 'Efficiency',
                            value: '${summary.efficiency.toStringAsFixed(0)}%',
                            color: AppColors.info,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _StatTile(
                            label: 'Overdue',
                            value: '${summary.overdueCount}',
                            color: AppColors.danger,
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

              _PortfolioSection(loans: loans),
              const SizedBox(height: AppSpacing.xl),

              Text(
                'LOAN STATUS DISTRIBUTION',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _DistributionCard(
                total: loans.length,
                segments: [
                  _Segment(
                    label: 'Active',
                    count: loans
                        .where((l) => l.status == LoanStatus.active)
                        .length,
                    color: AppColors.success,
                  ),
                  _Segment(
                    label: 'Overdue',
                    count: loans
                        .where((l) => l.status == LoanStatus.overdue)
                        .length,
                    color: AppColors.danger,
                  ),
                  _Segment(
                    label: 'Disbursed',
                    count: loans
                        .where((l) => l.status == LoanStatus.disbursed)
                        .length,
                    color: AppColors.info,
                  ),
                  _Segment(
                    label: 'Closed',
                    count: loans
                        .where((l) => l.status == LoanStatus.closed)
                        .length,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              Text(
                'REPAYMENT FREQUENCY MIX',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _DistributionCard(
                total: loans.length,
                segments: [
                  _Segment(
                    label: 'Daily',
                    count: loans.where((l) => l.frequency == 'daily').length,
                    color: AppColors.chartGreen,
                  ),
                  _Segment(
                    label: 'Weekly',
                    count: loans.where((l) => l.frequency == 'weekly').length,
                    color: AppColors.chartAmber,
                  ),
                  _Segment(
                    label: 'Monthly',
                    count: loans.where((l) => l.frequency == 'monthly').length,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatTile({
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
            label,
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
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

class _PortfolioSection extends StatelessWidget {
  final List<Loan> loans;

  const _PortfolioSection({required this.loans});

  @override
  Widget build(BuildContext context) {
    final activeLoans = loans.where((l) => l.status != LoanStatus.closed);
    final outstandingPrincipal = activeLoans.fold<double>(
      0,
      (sum, l) => sum + l.principal,
    );
    final outstandingInterest = activeLoans.fold<double>(
      0,
      (sum, l) => sum + (l.totalRepayable - l.principal),
    );
    final now = DateTime.now();
    final disbursedToday = loans
        .where(
          (l) =>
              l.disbursementDate.year == now.year &&
              l.disbursementDate.month == now.month &&
              l.disbursementDate.day == now.day,
        )
        .fold<double>(0, (sum, l) => sum + l.principal);

    return GlassCard(
      color: AppColors.primaryFixed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PORTFOLIO',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.primary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _PortfolioRow(
            label: 'Outstanding Principal',
            value: AppFormatters.currency(outstandingPrincipal),
          ),
          const SizedBox(height: 8),
          _PortfolioRow(
            label: 'Outstanding Interest',
            value: AppFormatters.currency(outstandingInterest),
          ),
          const SizedBox(height: 8),
          _PortfolioRow(
            label: 'Disbursed Today',
            value: AppFormatters.currency(disbursedToday),
          ),
        ],
      ),
    );
  }
}

class _PortfolioRow extends StatelessWidget {
  final String label;
  final String value;

  const _PortfolioRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTypography.titleMd.copyWith(
            color: AppColors.primary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _Segment {
  final String label;
  final int count;
  final Color color;

  const _Segment({
    required this.label,
    required this.count,
    required this.color,
  });
}

class _DistributionCard extends StatelessWidget {
  final int total;
  final List<_Segment> segments;

  const _DistributionCard({required this.total, required this.segments});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          if (total > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: segments
                      .where((s) => s.count > 0)
                      .map(
                        (s) => Expanded(
                          flex: s.count,
                          child: Container(color: s.color),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          const SizedBox(height: 14),
          ...segments.map(
            (s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: s.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s.label,
                      style: AppTypography.bodyMd.copyWith(fontSize: 13),
                    ),
                  ),
                  Text(
                    '${s.count}',
                    style: AppTypography.titleMd.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
