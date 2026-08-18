import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/models/mock_data.dart';
import '../../core/utils/formatters.dart';

/// Reports Screen — collection analytics with charts
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _periodIndex = 0; // 0=Week, 1=Month, 2=Quarter

  @override
  Widget build(BuildContext context) {
    final weeklyData = MockData.weeklyCollections;
    final totalCollected = weeklyData.fold<double>(
      0,
      (sum, d) => sum + d.collected,
    );
    final totalDue = weeklyData.fold<double>(0, (sum, d) => sum + d.due);
    final avgEfficiency = totalDue > 0 ? (totalCollected / totalDue) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Period Selector ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: ['This Week', 'This Month', 'Quarter']
                    .asMap()
                    .entries
                    .map(
                      (e) => Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _periodIndex = e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _periodIndex == e.key
                                  ? AppColors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _periodIndex == e.key
                                  ? [
                                      BoxShadow(
                                        color: AppColors.black.withValues(
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                e.value,
                                style: AppTypography.labelMd.copyWith(
                                  color: _periodIndex == e.key
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── Overview Stats ──────────────────────────────────
            GlassCard(
              color: AppColors.primaryFixed,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COLLECTION OVERVIEW',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppFormatters.currency(totalCollected),
                              style: AppTypography.financialLg.copyWith(
                                color: AppColors.primary,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              'Total Collected',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${avgEfficiency.toStringAsFixed(1)}%',
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.success,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'of ${AppFormatters.currency(totalDue)} due',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── Collection Chart ────────────────────────────────
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
                        'Daily Collections',
                        style: AppTypography.titleMd.copyWith(fontSize: 15),
                      ),
                      Row(
                        children: [
                          _LegendDot(
                            color: AppColors.chartGreen,
                            label: 'Collected',
                          ),
                          const SizedBox(width: 12),
                          _LegendDot(color: AppColors.chartAmber, label: 'Due'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY:
                            weeklyData
                                .map(
                                  (d) =>
                                      d.due > d.collected ? d.due : d.collected,
                                )
                                .reduce((a, b) => a > b ? a : b) *
                            1.2,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => AppColors.inverseSurface,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final d = weeklyData[groupIndex];
                              return BarTooltipItem(
                                rodIndex == 0
                                    ? AppFormatters.currency(d.collected)
                                    : AppFormatters.currency(d.due),
                                const TextStyle(
                                  color: AppColors.inverseOnSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 46,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${(value / 1000).toStringAsFixed(0)}k',
                                  style: TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun',
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    days[value.toInt() % 7],
                                    style: TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10000,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: weeklyData.asMap().entries.map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.collected,
                                color: AppColors.chartGreen,
                                width: 12,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                              BarChartRodData(
                                toY: e.value.due,
                                color: AppColors.chartAmber.withValues(
                                  alpha: 0.4,
                                ),
                                width: 12,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── Efficiency Chart ────────────────────────────────
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
                  Text(
                    'Collection Efficiency',
                    style: AppTypography.titleMd.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 160,
                    child: LineChart(
                      LineChartData(
                        minY: 60,
                        maxY: 105,
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (_) => AppColors.inverseSurface,
                            getTooltipItems: (spots) {
                              return spots.map((spot) {
                                return LineTooltipItem(
                                  '${spot.y.toStringAsFixed(1)}%',
                                  const TextStyle(
                                    color: AppColors.inverseOnSurface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}%',
                                  style: TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun',
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    days[value.toInt() % 7],
                                    style: TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: weeklyData.asMap().entries.map((e) {
                              return FlSpot(
                                e.key.toDouble(),
                                e.value.efficiency,
                              );
                            }).toList(),
                            isCurved: true,
                            color: AppColors.chartGreen,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, bar, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.white,
                                  strokeWidth: 2.5,
                                  strokeColor: AppColors.chartGreen,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.chartGreen.withValues(
                                alpha: 0.08,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── Summary Stats ───────────────────────────────────
            Text(
              'PORTFOLIO SUMMARY',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            StatCard(
              label: 'Total Disbursed',
              value: AppFormatters.currency(108000),
              icon: Icons.account_balance_wallet_rounded,
              accentColor: AppColors.primary,
              trend: '+12% vs last month',
              isTrendPositive: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            StatCard(
              label: 'Active Loans',
              value:
                  '${MockData.loans.where((l) => l.status == LoanStatus.active).length}',
              icon: Icons.receipt_long_rounded,
              accentColor: AppColors.info,
            ),
            const SizedBox(height: AppSpacing.sm),
            StatCard(
              label: 'Total Outstanding',
              value: AppFormatters.currency(
                MockData.loans
                    .where((l) => l.status != LoanStatus.closed)
                    .fold<double>(0, (sum, l) => sum + l.outstanding),
              ),
              icon: Icons.pending_actions_rounded,
              accentColor: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.sm),
            StatCard(
              label: 'Overdue Amount',
              value: AppFormatters.currency(
                MockData.loans
                    .where((l) => l.status == LoanStatus.overdue)
                    .fold<double>(0, (sum, l) => sum + l.outstanding),
              ),
              icon: Icons.warning_rounded,
              accentColor: AppColors.danger,
              trend: 'Needs attention',
              isTrendPositive: false,
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── Borrower-wise Breakdown ─────────────────────────
            Text(
              'BORROWER BREAKDOWN',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...MockData.borrowers
                .where((b) => b.totalOutstanding > 0)
                .map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _BorrowerBreakdownItem(borrower: b),
                  ),
                ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ─── Legend Dot ───────────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11),
        ),
      ],
    );
  }
}

// ─── Borrower Breakdown Item ─────────────────────────────────────
class _BorrowerBreakdownItem extends StatelessWidget {
  final Borrower borrower;

  const _BorrowerBreakdownItem({required this.borrower});

  @override
  Widget build(BuildContext context) {
    // Find max outstanding for relative bar width
    final maxOutstanding = MockData.borrowers
        .map((b) => b.totalOutstanding)
        .reduce((a, b) => a > b ? a : b);
    final barPercent = maxOutstanding > 0
        ? borrower.totalOutstanding / maxOutstanding
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: MockData.avatarColor(borrower.id),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    borrower.initials,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      borrower.name,
                      style: AppTypography.titleMd.copyWith(fontSize: 13),
                    ),
                    Text(
                      '${borrower.activeLoans} active loan${borrower.activeLoans > 1 ? 's' : ''} · ${borrower.village}',
                      style: AppTypography.bodySm.copyWith(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                AppFormatters.currency(borrower.totalOutstanding),
                style: AppTypography.titleMd.copyWith(
                  fontSize: 14,
                  color: borrower.status == BorrowerStatus.overdue
                      ? AppColors.danger
                      : AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: barPercent,
              minHeight: 4,
              backgroundColor: AppColors.surfaceContainer,
              valueColor: AlwaysStoppedAnimation(
                borrower.status == BorrowerStatus.overdue
                    ? AppColors.danger
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
