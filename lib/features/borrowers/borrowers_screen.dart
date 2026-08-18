import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/models/borrower.dart';
import '../../core/widgets/async_value_view.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/avatar_color.dart';
import 'providers/borrower_providers.dart';

/// Borrowers List Screen — searchable, filterable borrower directory
class BorrowersScreen extends ConsumerStatefulWidget {
  const BorrowersScreen({super.key});

  @override
  ConsumerState<BorrowersScreen> createState() => _BorrowersScreenState();
}

class _BorrowersScreenState extends ConsumerState<BorrowersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(borrowerQueryProvider.notifier).setSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = ref.watch(filteredBorrowersProvider);
    final counts = ref.watch(borrowerStatusCountsProvider).value;
    final query = ref.watch(borrowerQueryProvider);
    final queryNotifier = ref.read(borrowerQueryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowers'),
        actions: [
          IconButton(icon: const Icon(Icons.sort_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.sm,
              AppSpacing.marginMobile,
              AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: queryNotifier.setSearch,
              decoration: InputDecoration(
                hintText: 'Search by name, village, or phone...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: query.search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: _clearSearch,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
              ),
              children: [
                _FilterChip(
                  label: 'All',
                  count: counts?.values.fold<int>(0, (a, b) => a + b) ?? 0,
                  isSelected: query.status == null,
                  onTap: () => queryNotifier.setStatus(null),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Active',
                  count: counts?[BorrowerStatus.active] ?? 0,
                  isSelected: query.status == BorrowerStatus.active,
                  onTap: () => queryNotifier.setStatus(BorrowerStatus.active),
                  color: AppColors.success,
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Overdue',
                  count: counts?[BorrowerStatus.overdue] ?? 0,
                  isSelected: query.status == BorrowerStatus.overdue,
                  onTap: () => queryNotifier.setStatus(BorrowerStatus.overdue),
                  color: AppColors.danger,
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Closed',
                  count: counts?[BorrowerStatus.closed] ?? 0,
                  isSelected: query.status == BorrowerStatus.closed,
                  onTap: () => queryNotifier.setStatus(BorrowerStatus.closed),
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            child: Row(
              children: [
                Text(
                  filtered.maybeWhen(
                    data: (list) =>
                        '${list.length} borrower${list.length != 1 ? 's' : ''}',
                    orElse: () => ' ',
                  ),
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Borrower list
          Expanded(
            child: AsyncValueView<List<Borrower>>(
              value: filtered,
              isEmpty: (list) => list.isEmpty,
              empty: EmptyStateWidget(
                icon: Icons.person_search_rounded,
                title: query.isDefault ? 'No borrowers yet' : 'No matches',
                description: query.isDefault
                    ? 'Register your first borrower to get started.'
                    : 'Try a different name, village, or phone number.',
                actionLabel: query.isDefault ? 'Add borrower' : null,
                onAction: query.isDefault
                    ? () => context.push('/borrowers/add')
                    : null,
              ),
              onRetry: () => ref.invalidate(borrowersProvider),
              data: (list) => ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                  vertical: AppSpacing.xs,
                ),
                itemCount: list.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final borrower = list[index];
                  return _BorrowerListItem(
                    borrower: borrower,
                    onTap: () => context.push('/borrowers/${borrower.id}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/borrowers/add'),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add'),
      ),
    );
  }
}

// ─── Borrower List Item ──────────────────────────────────────────
class _BorrowerListItem extends StatelessWidget {
  final Borrower borrower;
  final VoidCallback? onTap;

  const _BorrowerListItem({required this.borrower, this.onTap});

  StatusType get _statusType {
    switch (borrower.status) {
      case BorrowerStatus.active:
        return StatusType.active;
      case BorrowerStatus.overdue:
        return StatusType.overdue;
      case BorrowerStatus.closed:
        return StatusType.closed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: avatarColorForId(borrower.id),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  borrower.initials,
                  style: AppTypography.titleMd.copyWith(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          borrower.name,
                          style: AppTypography.titleMd.copyWith(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(status: _statusType, compact: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        borrower.village,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (borrower.activeLoans > 0) ...[
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${borrower.activeLoans} loan${borrower.activeLoans > 1 ? 's' : ''}',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (borrower.totalOutstanding > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '₹${borrower.totalOutstanding.toStringAsFixed(0)} outstanding',
                      style: AppTypography.labelMd.copyWith(
                        color: borrower.status == BorrowerStatus.overdue
                            ? AppColors.danger
                            : AppColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Filter Chip ─────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor.withValues(alpha: 0.12)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.labelMd.copyWith(
                color: isSelected ? chipColor : AppColors.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? chipColor.withValues(alpha: 0.2)
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? chipColor : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
