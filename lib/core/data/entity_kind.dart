/// The kinds of data a write can touch, used to scope change notifications
/// so a provider only re-reads when something it actually depends on moved.
enum EntityKind {
  borrower,
  loan,
  installment,
  collection,
  payment,
  report,
  sync,
  area,
  employee,
  role,
  loanScheme,
}

/// Describes which entity kinds a single write affected. A payment, for
/// example, touches loan + installment + borrower + collection + payment +
/// report all at once, and is published as one DataChange rather than five.
class DataChange {
  const DataChange(this.kinds);

  const DataChange.all()
    : kinds = const {
        EntityKind.borrower,
        EntityKind.loan,
        EntityKind.installment,
        EntityKind.collection,
        EntityKind.payment,
        EntityKind.report,
        EntityKind.sync,
        EntityKind.area,
        EntityKind.employee,
        EntityKind.role,
        EntityKind.loanScheme,
      };

  final Set<EntityKind> kinds;

  bool touches(EntityKind kind) => kinds.contains(kind);
}
