import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/models/mock_data.dart';
import '../../core/utils/avatar_color.dart';

/// Borrowers List Screen — searchable, filterable borrower directory
class BorrowersScreen extends StatefulWidget {
  final void Function(String borrowerId)? onBorrowerTap;

  const BorrowersScreen({super.key, this.onBorrowerTap});

  @override
  State<BorrowersScreen> createState() => _BorrowersScreenState();
}

class _BorrowersScreenState extends State<BorrowersScreen> {
  String _searchQuery = '';
  BorrowerStatus? _filterStatus;

  List<Borrower> get _filteredBorrowers {
    var list = MockData.borrowers;
    if (_filterStatus != null) {
      list = list.where((b) => b.status == _filterStatus).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (b) =>
                b.name.toLowerCase().contains(q) ||
                b.village.toLowerCase().contains(q) ||
                b.mobile.contains(q),
          )
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredBorrowers;

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
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by name, village, or phone...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _searchQuery = ''),
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
                  count: MockData.borrowers.length,
                  isSelected: _filterStatus == null,
                  onTap: () => setState(() => _filterStatus = null),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Active',
                  count: MockData.borrowers
                      .where((b) => b.status == BorrowerStatus.active)
                      .length,
                  isSelected: _filterStatus == BorrowerStatus.active,
                  onTap: () =>
                      setState(() => _filterStatus = BorrowerStatus.active),
                  color: AppColors.success,
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Overdue',
                  count: MockData.borrowers
                      .where((b) => b.status == BorrowerStatus.overdue)
                      .length,
                  isSelected: _filterStatus == BorrowerStatus.overdue,
                  onTap: () =>
                      setState(() => _filterStatus = BorrowerStatus.overdue),
                  color: AppColors.danger,
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Closed',
                  count: MockData.borrowers
                      .where((b) => b.status == BorrowerStatus.closed)
                      .length,
                  isSelected: _filterStatus == BorrowerStatus.closed,
                  onTap: () =>
                      setState(() => _filterStatus = BorrowerStatus.closed),
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
                  '${filtered.length} borrower${filtered.length != 1 ? 's' : ''}',
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
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_search_rounded,
                          size: 64,
                          color: AppColors.onSurfaceVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No borrowers found',
                          style: AppTypography.titleMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.marginMobile,
                      vertical: AppSpacing.xs,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return _BorrowerListItem(
                        borrower: filtered[index],
                        onTap: () =>
                            widget.onBorrowerTap?.call(filtered[index].id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const _AddBorrowerPlaceholder()),
          );
        },
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

/// Placeholder used for navigation — will be replaced by actual AddBorrowerScreen
class _AddBorrowerPlaceholder extends StatelessWidget {
  const _AddBorrowerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Add Borrower')));
  }
}
