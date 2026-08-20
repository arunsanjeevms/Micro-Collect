/**
 * Generates the next sequential prefixed id for an entity (B001, L001,
 * I001, C001, P001, ...), matching MockDatabase._nextId on the Flutter
 * side so ids stay in the same shape whichever backend is active.
 *
 * Takes a Prisma delegate (e.g. tx.borrower) and finds the current max by
 * reading every id with that prefix - fine at this data scale, and it
 * keeps the same "look at what already exists" semantics as the mock
 * implementation rather than introducing a separate counter table.
 */
async function nextId(delegate, prefix, { where } = {}) {
  const rows = await delegate.findMany({
    where: { ...(where || {}), id: { startsWith: prefix } },
    select: { id: true },
  });

  let max = 0;
  for (const row of rows) {
    const suffix = row.id.slice(prefix.length);
    const n = parseInt(suffix, 10);
    if (Number.isFinite(n) && n > max) max = n;
  }

  return `${prefix}${String(max + 1).padStart(3, '0')}`;
}

module.exports = { nextId };
