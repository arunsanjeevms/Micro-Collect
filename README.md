# MicroCollect

A rural microfinance collection-management app for field officers — built with Flutter and Material 3, styled after Google Stitch's "Growth & Trust" design system.

This is currently a **frontend-only prototype**: every screen is fully built and navigable, but all data lives in an in-memory mock backend (`lib/data/mock/`). There is no real API or persistence layer yet — restarting the app resets all data to the seeded demo state.

## Status

- Full UI implemented for the core field-officer flow: dashboard, borrower registration and management, loan origination and servicing, daily collections, payments, and reporting.
- Reactive state via Riverpod, backed by a single in-memory `MockDatabase` with simulated network latency and injectable failures.
- `flutter analyze` is clean and the widget/unit test suite passes.
- No backend, no auth, no real persistence, no printer/Bluetooth integration — these are explicitly out of scope for this phase.

## Getting Started

```bash
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

**Mock backend** (`lib/data/`):
- `mock/mock_database.dart` — the single in-memory store every write goes through. A payment, loan closure, or new registration mutates the loan/installments/borrower/collection-entry/payment records together and emits one `DataChange`.
- `mock/mock_gateway.dart` + `dev/dev_settings.dart` — simulated latency and injectable per-operation failures, so loading and error states are real rather than decorative.
- `repositories/` — abstract repository interfaces the UI depends on; `mock/mock_*_repository.dart` are the only implementations today.

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

A real backend (API + persistence) is the next major phase. `lib/core/utils/loan_calculator.dart` is deliberately kept isolated from UI code so it can become backend-authoritative later without UI rework.
