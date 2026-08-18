import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/models/collection_entry.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/avatar_color.dart';
import '../../core/utils/formatters.dart';
import 'providers/collection_providers.dart';
import 'record_payment_sheet.dart';

/// Collections Screen — today's due collections with summary
class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(collectionSummaryProvider).value;
    final allEntries = ref.watch(todayCollectionsProvider).value ?? const [];
    final filtered = ref.watch(filteredCollectionsProvider);
    final filter = ref.watch(collectionStatusFilterProvider);
    final filterNotifier = ref.read(collectionStatusFilterProvider.notifier);

    final totalDue = summary?.totalDue ?? 0;
    final totalCollected = summary?.totalCollected ?? 0;

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
                          value: '${summary?.collectedCount ?? 0}',
                          color: AppColors.success,
                        ),
                        _MiniStat(
                          label: 'Pending',
                          value: '${summary?.pendingCount ?? 0}',
                          color: AppColors.warning,
                        ),
                        _MiniStat(
                          label: 'Overdue',
                          value: '${summary?.overdueCount ?? 0}',
                          color: AppColors.danger,
                        ),
                        _MiniStat(
                          label: 'Partial',
                          value: '${summary?.partialCount ?? 0}',
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
                  isSelected: filter == null,
                  onTap: () => filterNotifier.set(null),
                ),
                _StatusTab(
                  label: 'Pending',
                  isSelected: filter == CollectionStatus.pending,
                  onTap: () => filterNotifier.set(CollectionStatus.pending),
                  color: AppColors.warning,
                ),
                _StatusTab(
                  label: 'Collected',
                  isSelected: filter == CollectionStatus.collected,
                  onTap: () => filterNotifier.set(CollectionStatus.collected),
                  color: AppColors.success,
                ),
                _StatusTab(
                  label: 'Overdue',
                  isSelected: filter == CollectionStatus.overdue,
                  onTap: () => filterNotifier.set(CollectionStatus.overdue),
                  color: AppColors.danger,
                ),
                _StatusTab(
                  label: 'Partial',
                  isSelected: filter == CollectionStatus.partial,
                  onTap: () => filterNotifier.set(CollectionStatus.partial),
                  color: AppColors.info,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ─── Collection List ───────────────────────────────────
          Expanded(
            child: AsyncValueView<List<CollectionEntry>>(
              value: filtered,
              isEmpty: (list) => list.isEmpty,
              empty: EmptyStateWidget(
                icon: Icons.payments_outlined,
                title: allEntries.isEmpty ? 'Nothing due today' : 'No matches',
                description: allEntries.isEmpty
                    ? 'Collections for today will show up here.'
                    : 'Try a different filter.',
              ),
              onRetry: () => ref.invalidate(todayCollectionsProvider),
              data: (list) => ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                  vertical: AppSpacing.xs,
                ),
                itemCount: list.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final entry = list[index];
                  return _CollectionListItem(
                    entry: entry,
                    onRecordPayment: () => _showPaymentSheet(context, entry),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet(BuildContext context, CollectionEntry entry) {
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
    final hasArrears = entry.previousDue > 0;

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

                StatusBadge(status: _statusType, compact: true),
              ],
            ),
            const SizedBox(height: 10),

            // Prev Due / Today's Due / Total Due breakdown
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _AmountColumn(
                      label: 'Prev Due',
                      value: hasArrears
                          ? AppFormatters.currency(entry.previousDue)
                          : '—',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: AppColors.outlineVariant,
                  ),
                  Expanded(
                    child: _AmountColumn(
                      label: 'Today\'s Due',
                      value: AppFormatters.currency(entry.amountDue),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: AppColors.outlineVariant,
                  ),
                  Expanded(
                    child: _AmountColumn(
                      label: 'Total Due',
                      value: AppFormatters.currency(entry.totalDue),
                      emphasize: true,
                    ),
                  ),
                ],
              ),
            ),

            // Action row for pending/overdue/partial
            if (!isCollected) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (entry.notes != null)
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
                    )
                  else
                    const Spacer(),
                  ElevatedButton.icon(
                    onPressed: onRecordPayment,
                    icon: const Icon(Icons.payments_rounded, size: 16),
                    label: const Text('Collect Now'),
                    style: ElevatedButton.styleFrom(
                      // The theme's default minimumSize is
                      // Size(double.infinity, 48), which this Row (with no
                      // Expanded around the button) can't satisfy - it
                      // forces an infinite-width layout constraint.
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ] else ...[
              if (entry.paymentMode != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
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
                            entry.paymentMode == PaymentMode.cash
                                ? Icons.money
                                : entry.paymentMode == PaymentMode.upi
                                ? Icons.qr_code
                                : Icons.account_balance,
                            size: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entry.paymentMode!.name.toUpperCase(),
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

// ─── Amount Column (Prev/Today/Total Due breakdown) ──────────────
class _AmountColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _AmountColumn({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            fontSize: 10,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMd.copyWith(
            fontSize: emphasize ? 15 : 13,
            color: emphasize ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ],
    );
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
