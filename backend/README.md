# MicroCollect API

Node.js (Express) + MySQL backend for MicroCollect, using Prisma as the ORM. This is a straight port of the Flutter app's mock backend (`lib/data/mock/`) — same domain model, same IDs (`B001`, `L001`, `I001`, `C001`, `P001`), same business logic (loan calculator, installment schedule builder, payment allocator), now backed by a real MySQL database instead of an in-memory store.

## Setup

Requires Node.js 18+ and a running MySQL/MariaDB server.

```bash
cd backend
npm install
cp .env.example .env        # edit DATABASE_URL/JWT_SECRET if needed
npx prisma migrate dev      # creates the database schema
npm run seed                # loads the same demo data as the Flutter mock
npm run dev                 # starts the API on http://localhost:4000
```

`.env` (not committed):

```
DATABASE_URL="mysql://root:@localhost:3306/microcollect"
PORT=4000
JWT_SECRET="change-this-in-production"
JWT_EXPIRES_IN="12h"
CORS_ORIGIN="*"
```

Seeded accounts (from `prisma/seed.js`):

| Email | Password | Role |
|---|---|---|
| admin@microcollect.app | admin123 | ADMIN |
| officer@microcollect.app | officer123 | FIELD_OFFICER |

## API

All routes except `/auth/login` and `/health` require `Authorization: Bearer <token>`.

| Method | Route | Description |
|---|---|---|
| POST | `/auth/login` | `{ email, password }` → `{ token, user }` |
| POST | `/auth/register` | Admin-only: create a new user |
| GET | `/auth/me` | Current user from the token |
| GET | `/borrowers` | List all borrowers |
| GET | `/borrowers/:id` | One borrower |
| POST | `/borrowers` | Register a new borrower |
| GET | `/borrowers/:id/loans` | A borrower's loans |
| GET | `/borrowers/:id/payments?limit=` | A borrower's payment history |
| GET | `/loans` | List all loans (with installments) |
| GET | `/loans/:id` | One loan (with installments) |
| POST | `/loans` | Create a new loan |
| POST | `/loans/:id/close` | Settle the remaining outstanding in one payment and close the loan |
| GET | `/loans/:id/payments` | A loan's payment history |
| GET | `/collections?date=` | Collection entries due on a date (default today) |
| GET | `/collections/summary?date=` | Aggregate totals for a date |
| GET | `/collections/payments?date=` | Payments actually recorded on a date |
| POST | `/collections/:id/payments` | Record a payment against a collection entry |

## Architecture

- `prisma/schema.prisma` — the data model, mirroring `lib/core/models/` field for field.
- `src/services/loanCalculator.js`, `scheduleBuilder.js`, `paymentAllocator.js` — ported 1:1 from the matching files in `lib/core/utils/`, so both backends compute identical numbers.
- `src/services/paymentEngine.js` — the shared transaction (`applyPayment`) that both `recordPayment` (tied to a collection entry) and `closeLoan` (lump-sum payoff) build on, mirroring `MockDatabase`'s single-writer approach: one payment always updates the loan, its installments, and the borrower's derived totals together.
- `src/middleware/auth.js` — JWT verification (`requireAuth`) and role gating (`requireRole`).
- `src/utils/errors.js` — an error taxonomy mirroring `lib/core/errors/app_exception.dart`, so the Flutter client's error-state UI can eventually switch on the same shape regardless of which backend it's talking to.

## Regenerating the seed data

`npm run seed` truncates and reloads every table from `prisma/seed.js`, which reproduces the exact same borrowers/loans/installments/collections as `lib/data/mock/demo_seed.dart`. Safe to re-run at any time in development.
