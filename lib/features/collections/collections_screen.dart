import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/models/mock_data.dart';
import '../../core/utils/avatar_color.dart';
import '../../core/utils/formatters.dart';
import 'record_payment_sheet.dart';

/// Collections Screen — today's due collections with summary
class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  CollectionStatus? _filter;

  List<CollectionEntry> get _filteredEntries {
    final entries = MockData.todayCollections;
    if (_filter == null) return entries;
    return entries.where((e) => e.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allEntries = MockData.todayCollections;
    final totalDue = allEntries.fold<double>(0, (sum, e) => sum + e.amountDue);
    final totalCollected = allEntries.fold<double>(
      0,
      (sum, e) => sum + (e.amountPaid ?? 0),
    );
    final collectedCount = allEntries
        .where((e) => e.status == CollectionStatus.collected)
        .length;
    final filtered = _filteredEntries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Summary Card ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.sm,
              AppSpacing.marginMobile,
              0,
            ),
            child: GlassCard(
              color: AppColors.primaryFixed,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TODAY\'S COLLECTION',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppFormatters.currency(totalCollected),
                              style: AppTypography.financialLg.copyWith(
                                color: AppColors.primary,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'of ${AppFormatters.currency(totalDue)} due',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Circular progress
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 72,
                              height: 72,
                              child: CircularProgressIndicator(
                                value: totalDue > 0
                                    ? totalCollected / totalDue
                                    : 0,
                                strokeWidth: 6,
                                backgroundColor: AppColors.surfaceContainer,
                                valueColor: const AlwaysStoppedAnimation(
                                  AppColors.success,
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  totalDue > 0
                                      ? '${((totalCollected / totalDue) * 100).toStringAsFixed(0)}%'
                                      : '0%',
                                  style: AppTypography.titleMd.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Mini stats row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _MiniStat(
                          label: 'Collected',
                          value: '$collectedCount',
                          color: AppColors.success,
                        ),
                        _MiniStat(
                          label: 'Pending',
                          value:
                              '${allEntries.where((e) => e.status == CollectionStatus.pending).length}',
                          color: AppColors.warning,
                        ),
                        _MiniStat(
                          label: 'Overdue',
                          value:
                              '${allEntries.where((e) => e.status == CollectionStatus.overdue).length}',
                          color: AppColors.danger,
                        ),
                        _MiniStat(
                          label: 'Partial',
                          value:
                              '${allEntries.where((e) => e.status == CollectionStatus.partial).length}',
                          color: AppColors.info,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ─── Filter Tabs ───────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
              ),
              children: [
                _StatusTab(
                  label: 'All',
                  isSelected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                _StatusTab(
                  label: 'Pending',
                  isSelected: _filter == CollectionStatus.pending,
                  onTap: () =>
                      setState(() => _filter = CollectionStatus.pending),
                  color: AppColors.warning,
                ),
                _StatusTab(
                  label: 'Collected',
                  isSelected: _filter == CollectionStatus.collected,
                  onTap: () =>
                      setState(() => _filter = CollectionStatus.collected),
                  color: AppColors.success,
                ),
                _StatusTab(
                  label: 'Overdue',
                  isSelected: _filter == CollectionStatus.overdue,
                  onTap: () =>
                      setState(() => _filter = CollectionStatus.overdue),
                  color: AppColors.danger,
                ),
                _StatusTab(
                  label: 'Partial',
                  isSelected: _filter == CollectionStatus.partial,
                  onTap: () =>
                      setState(() => _filter = CollectionStatus.partial),
                  color: AppColors.info,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ─── Collection List ───────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
                vertical: AppSpacing.xs,
              ),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                return _CollectionListItem(
                  entry: filtered[index],
                  onRecordPayment: () => _showPaymentSheet(filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet(CollectionEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecordPaymentSheet(entry: entry),
    );
  }
}

// ─── Collection List Item ────────────────────────────────────────
class _CollectionListItem extends StatelessWidget {
  final CollectionEntry entry;
  final VoidCallback onRecordPayment;

  const _CollectionListItem({
    required this.entry,
    required this.onRecordPayment,
  });

  StatusType get _statusType {
    switch (entry.status) {
      case CollectionStatus.collected:
        return StatusType.paid;
      case CollectionStatus.pending:
        return StatusType.pending;
      case CollectionStatus.overdue:
        return StatusType.overdue;
      case CollectionStatus.partial:
        return StatusType.partial;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCollected = entry.status == CollectionStatus.collected;

    return Container(
      decoration: BoxDecoration(
        color: isCollected
            ? AppColors.successLight.withValues(alpha: 0.2)
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCollected
              ? AppColors.success.withValues(alpha: 0.2)
              : AppColors.cardBorder,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: _statusColor, width: 4)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: avatarColorForId(entry.borrowerId),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      entry.borrowerName
                          .split(' ')
                          .map((w) => w[0])
                          .take(2)
                          .join(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & loan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.borrowerName,
                        style: AppTypography.titleMd.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Loan ${entry.loanId}',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
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
                      AppFormatters.currency(entry.amountDue),
                      style: AppTypography.financialSm.copyWith(
                        fontSize: 16,
                        color: isCollected
                            ? AppColors.success
                            : AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(status: _statusType, compact: true),
                  ],
                ),
              ],
            ),

            // Action row for pending/overdue
            if (!isCollected) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (entry.paymentMode != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.paymentMode!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  if (entry.notes != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.notes!,
                        style: AppTypography.bodySm.copyWith(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ] else
                    const Spacer(),
                  SizedBox(
                    height: 30,
                    child: TextButton.icon(
                      onPressed: onRecordPayment,
                      icon: const Icon(Icons.payments_rounded, size: 14),
                      label: const Text('Record'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              if (entry.paymentMode != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 52),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            entry.paymentMode == 'cash'
                                ? Icons.money
                                : entry.paymentMode == 'upi'
                                ? Icons.qr_code
                                : Icons.account_balance,
                            size: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entry.paymentMode!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (entry.paidDate != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        AppFormatters.time(entry.paidDate!),
                        style: AppTypography.bodySm.copyWith(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (entry.status) {
      case CollectionStatus.collected:
        return AppColors.success;
      case CollectionStatus.pending:
        return AppColors.warning;
      case CollectionStatus.overdue:
        return AppColors.danger;
      case CollectionStatus.partial:
        return AppColors.info;
    }
  }
}

// ─── Mini Stat ───────────────────────────────────────────────────
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.titleMd.copyWith(color: color, fontSize: 18),
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

// ─── Status Tab ──────────────────────────────────────────────────
class _StatusTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _StatusTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tabColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? tabColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? tabColor : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: isSelected ? tabColor : AppColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
