# MicroCollect

A rural microfinance collection-management app for field officers — built with Flutter and Material 3, styled after Google Stitch's "Growth & Trust" design system, backed by a Node.js + MySQL API.

## Status

- Full UI implemented for the core field-officer flow: dashboard, borrower registration and management, loan origination and servicing, daily collections, payments, and reporting.
- A real backend (`backend/` — Express + Prisma + MySQL, see `backend/README.md`) with JWT auth, a login screen, and every write path (record payment, close loan, register borrower, create loan) persisted for real.
- The Flutter app can still run against an in-memory mock backend (`lib/data/mock/`) instead — see "Backend modes" below — which is what the widget/unit test suite uses, so tests need no live server.
- Reactive state via Riverpod: every screen watches `dataRevisionProvider(EntityKind.x)`, so a write anywhere propagates automatically with no explicit `ref.invalidate` calls, whichever backend is active.
- `flutter analyze` is clean and the widget/unit test suite passes.
- No printer/Bluetooth integration — the printer/receipt screens are UI-only and say so.

## Backend modes

`lib/main.dart` picks which backend the app talks to via which `ProviderScope` overrides it installs:

- **Remote (default)** — `remoteBackendOverrides()` (`lib/data/remote/`), talking to the API in `backend/`. Requires the backend running (see `backend/README.md`) and a login.
- **Mock** — `mockBackendOverrides()` (`lib/data/mock/`), an in-memory store with no server required. Swap back to it by editing the two lines at the top of `main()` (commented in place). This is always what `flutter test` uses, regardless of which mode `main.dart` is set to.

## Getting Started

```bash
# Backend (see backend/README.md for full setup)
cd backend && npm install && npx prisma migrate dev && npm run seed && npm run dev

# Flutter app
flutter pub get                       # install dependencies
flutter run                           # run on a connected device/emulator
flutter run -d chrome                 # run in the browser
flutter run -d windows                # run as a Windows desktop app
```

Regenerate code (Riverpod providers, go_router routes, freezed models) after changing any `@riverpod` function/class, a route definition, or a `@freezed` model:

```bash
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs   # regenerate on save
```

### Quality checks

```bash
flutter analyze                       # static analysis
flutter test                          # widget + unit tests
dart format .                         # formatting
```

## Architecture

**Composition**: `lib/main.dart` wraps `MicroCollectApp` (`lib/app.dart`) in a `ProviderScope`. `app.dart` builds a `MaterialApp.router` using `AppTheme.light` and the `goRouter` from `appRouterProvider`.

**Routing** (`lib/core/routing/app_router.dart`): a single `@riverpod` `GoRouter`. A `ShellRoute` wraps five bottom-nav tabs — Dashboard, Borrowers, Collect, Reports, More — in `_AppShell`, which keeps each tab's state alive via `NoTransitionPage`. Detail, wizard, and confirmation screens are registered outside the shell so they push full-screen over the bottom nav.

**State management**: Riverpod with code-generated providers (`@riverpod` functions/classes + `part '*.g.dart'`). Every list/detail provider watches `dataRevisionProvider(EntityKind.x)`, so a write anywhere in the app propagates to every screen that reads that entity kind — no manual `ref.invalidate` calls anywhere.

**Data layer** (`lib/data/`):
- `repositories/` — abstract repository interfaces (`BorrowerRepository`, `LoanRepository`, `CollectionRepository`) the UI depends on; it never knows which backend is behind them.
- `remote/` — the real backend: `ApiClient` (bearer-token HTTP wrapper), hand-written `dto_mappers.dart` (JSON ↔ freezed models), `Remote*Repository` implementations, and `RemoteChangeFeed` (publishes the same `DataChange` a write would emit locally, since the API has no push channel yet).
- `mock/` — the in-memory alternative: `mock_database.dart` is the single store every write goes through (a payment, loan closure, or new registration mutates loan/installments/borrower/collection-entry/payment together and emits one `DataChange`); `mock_gateway.dart` + `dev/dev_settings.dart` simulate latency and injectable per-operation failures.

**Domain models** (`lib/core/models/`): `Borrower`, `Loan`, `Installment`, `CollectionEntry`, `Payment`, `DailyCollection` — all `freezed` value types with derived getters (e.g. `Loan.outstanding`, `Borrower.initials`). IDs follow `B00x` / `L00x` / `I00x` / `C00x` / `P00x` prefixes so cross-references between borrowers, loans, and collections stay resolvable.

**Design system** (`lib/core/theme/`, `lib/core/constants/app_spacing.dart`): the "Growth & Trust" green palette, Poppins type scale, 4px/8px spacing tokens, and shared widgets (`GlassCard`, `StatCard`, `StatusBadge`, `AppBottomNav`, `EmptyStateWidget`, `AsyncValueView`, `ErrorStateWidget`).

**Features** (`lib/features/<feature>/`): screens grouped by feature — `dashboard/`, `borrowers/`, `loans/`, `collections/`, `reports/`, `more/` — each with its own `providers/` subfolder.

## Screens

| Domain | Screens |
|---|---|
| Dashboard | Home dashboard with today's collection summary and quick actions |
| Borrowers | List, detail (with real payment history), 5-step registration wizard, loans overview |
| Loans | List, detail, creation (with live EMI preview), created-success, closure, statement |
| Collections | Daily collection list, record-payment sheet, payment success, receipt preview |
| Reports | Collection charts, daily collection report, analytics dashboard |
| More | Employees, Areas, Roles & Permissions, Loan Schemes, Settings, Company Profile, Printer Settings, User Security, Sync Center |

Screens under "More" that have no backing domain model yet (Employees, Areas, Roles, Loan Schemes) are clearly documented in code as illustrative content rather than live data.

## What's next

Printer/Bluetooth hardware integration and persisted device settings (currently local widget state in the "More" screens) are the main remaining gaps. `lib/core/utils/loan_calculator.dart`, `schedule_builder.dart`, and `payment_allocator.dart` are ported 1:1 into `backend/src/services/`, so both backends compute identical numbers — see `backend/README.md` for the API's architecture.
