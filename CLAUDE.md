# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

MicroCollect — a rural microfinance collection management app (Flutter, Material 3) with a Node.js + MySQL backend. `lib/core/utils/loan_calculator.dart`, `schedule_builder.dart`, and `payment_allocator.dart` are ported 1:1 into `backend/src/services/` — keep both copies in sync if the math changes, and don't entangle either with UI/route code.

The Flutter app can run against either backend, chosen by which `ProviderScope` overrides `lib/main.dart` installs:
- **`remoteBackendOverrides()`** (`lib/data/remote/`, the current default) — talks to the real API in `backend/`. Requires the backend running and a login (see `backend/README.md`).
- **`mockBackendOverrides()`** (`lib/data/mock/`) — an in-memory store, no server needed. This is what `flutter test` always uses (`test/support/test_app.dart` applies it explicitly, independent of `main.dart`).

Both back the same three repository interfaces (`BorrowerRepository`, `LoanRepository`, `CollectionRepository` in `lib/data/repositories/`), so feature code never knows which is active.

## Commands

### Flutter app
```bash
flutter pub get                       # install dependencies
flutter run                           # run on connected device/emulator/web
flutter run -d chrome                 # run in browser
flutter analyze                       # static analysis (uses analysis_options.yaml + flutter_lints)
flutter test                          # run all tests (always against the mock backend)
dart run build_runner build --delete-conflicting-outputs   # regenerate *.g.dart (riverpod/go_router/freezed codegen)
dart run build_runner watch --delete-conflicting-outputs   # regenerate on save
```

There is no `windows/`, `macos/`, or `linux/` platform folder — only `android/`, `ios/`, and `web/` exist. `analysis_options.yaml` excludes `build/**`, `android/**`, `ios/**`, `web/**` from analysis.

### Backend
```bash
cd backend
npm install
npx prisma migrate dev                # apply/create the MySQL schema
npm run seed                          # load demo data (same as lib/data/mock/demo_seed.dart)
npm run dev                           # start the API on http://localhost:4000
```
See `backend/README.md` for the full API reference and seeded login accounts.

## Architecture

**Entry point / composition**: `lib/main.dart` wraps `MicroCollectApp` (`lib/app.dart`) in a `ProviderScope` with either `remoteBackendOverrides()` or `mockBackendOverrides()` (the mock line is commented directly above the active one — swap by editing those two lines). `app.dart` builds a `MaterialApp.router` using `AppTheme.light` and the `goRouter` from `appRouterProvider`.

**Routing** (`lib/core/routing/app_router.dart`, generated `app_router.g.dart`): a single `@riverpod` `GoRouter` provider.
- A `ShellRoute` wraps five bottom-nav tabs (`/`, `/borrowers`, `/collections`, `/reports`, `/more`) in `_AppShell`, which renders `AppBottomNav` and keeps tab state alive via `NoTransitionPage`.
- Detail/wizard/confirmation routes (e.g. `/borrowers/:id`, `/borrowers/add`, `/loans/:id`, `/loans/create`, `/payments/success`) are registered outside the shell with `parentNavigatorKey: _rootNavigatorKey` so they push full-screen over the bottom nav instead of inside a tab. **Static paths must be declared before `:id` wildcards** in the same route list (e.g. `/loans/create` before `/loans/:id`) — go_router matches in declaration order.
- `redirect` sends unauthenticated users to `/login`, but only when `usesRemoteBackendProvider` is true (set by `remoteBackendOverrides()`); the mock backend has no login concept and is unaffected.
- When adding a new top-level tab, add it to both the `ShellRoute.routes` list and `_AppShell._paths` (index order must match). When adding a detail screen, register it at the top level with `parentNavigatorKey: _rootNavigatorKey`, not nested under the shell.

**State management**: Riverpod (`flutter_riverpod` + code-generated `riverpod_annotation`) throughout — every feature has its own `providers/` subfolder (e.g. `lib/features/borrowers/providers/borrower_providers.dart`). Follow the established `@riverpod` code-gen pattern (annotate a function/class, run `build_runner`, `part 'x.g.dart';`) rather than manually written `StateNotifierProvider`s.

**Reactivity spine**: every read provider does `ref.watch(dataRevisionProvider(EntityKind.x))`, so a write anywhere in the app propagates to every screen that depends on that entity kind with **zero explicit `ref.invalidate` calls**. Both backends feed this the same way: `ChangeFeed.changes` emits a `DataChange` (which `EntityKind`s were touched) after every write — `MockDatabase` emits it directly; `RemoteChangeFeed` is published into by each `Remote*Repository` right after a successful API call, since the backend has no push channel yet.

**Domain models** (`lib/core/models/`): `Borrower`, `Loan`, `Installment`, `CollectionEntry`, `Payment`, `DailyCollection` — `freezed` value types with derived getters (e.g. `Loan.outstanding`, `Borrower.initials`). IDs follow `B00x` (borrowers), `L00x` (loans), `I00x`/`{loanId}-I00x` (installments), `C00x` (collection entries), `P00x` (payments) — both backends generate these the same way (`idGenerator.js` on the backend mirrors `MockDatabase._nextId`), so reuse these prefixes for any new seed/demo records.

**Data layer** (`lib/data/`):
- `repositories/` — the abstract interfaces feature code depends on, plus their shared value types (`BorrowerDraft`, `LoanDraft`, `RecordPaymentInput`, `PaymentReceipt`, `CollectionSummary`).
- `remote/` — `ApiClient` (bearer-token HTTP wrapper, translates non-2xx responses into `AppException` subtypes), `dto_mappers.dart` (hand-written JSON ↔ freezed mapping — models aren't wired to `json_serializable`), `Remote*Repository` implementations, `RemoteChangeFeed`, `remote_bindings.dart` (the override list).
- `mock/` — `mock_database.dart` (single in-memory store; a payment, loan closure, or registration mutates loan/installments/borrower/collection-entry/payment together in one `DataChange`), `mock_gateway.dart` + `dev/dev_settings.dart` (simulated latency and injectable per-op failures), `mock_bindings.dart` (the override list), `demo_seed.dart` (deterministic sample data — kept in exact sync with `backend/prisma/seed.js`).

**Auth** (`lib/core/auth/`): `AuthController` holds an in-memory JWT (issued by `POST /auth/login`) and decoded user — nothing persisted to disk, so closing the app signs out. `usesRemoteBackendProvider` (default `false`, overridden to `true` by `remoteBackendOverrides()`) is what the router's redirect and login screen key off; it's what tells the app "this instance requires a session" independent of which repositories are wired.

**Design system** (`lib/core/theme/`, `lib/core/constants/app_spacing.dart`): the "Growth & Trust" theme.
- `AppColors` defines the full Material 3 `ColorScheme` plus custom semantic colors (`success`/`warning`/`danger`/`info` + light variants), chart colors, and glassmorphism colors — consumed by `AppTheme.light` (`app_theme.dart`) which configures every widget theme (buttons, inputs, cards, bottom sheets, snackbars, etc.) in one place. Prefer adding a color/theme knob to these files over hardcoding colors in a screen.
- `AppSpacing` (4px/8px-grid tokens: `xs`/`sm`/`md`/`lg`/`xl`/`xxl`, plus `marginMobile`/`marginDesktop`) and `AppRadius` (in the same `app_spacing.dart` file) are the spacing/radius tokens used throughout instead of literal `EdgeInsets`/radius values.
- `GlassCard` (`lib/core/widgets/glass_card.dart`) is the signature glassmorphism container (semi-transparent + `BackdropFilter` blur + `AppShadows.glass`) used for hero/emphasis cards — use it instead of a plain `Card` when a screen needs the frosted-glass look shown on the dashboard.
- Other shared widgets live in `lib/core/widgets/`: `AppBottomNav`, `StatCard`, `StatusBadge`, `EmptyStateWidget`, `SkeletonLoader`, `AsyncValueView` (the standard loading/empty/error wrapper for a provider-backed screen), `ErrorStateWidget` (switches on the `AppException` hierarchy for consistent error copy).

**Formatting/validation utilities** (`lib/core/utils/`): `AppFormatters` centralizes all currency (`en_IN` locale, ₹ symbol), date, phone, and Aadhaar formatting/masking — use it rather than formatting dates/currency/Aadhaar/phone numbers inline. `validators.dart`, `loan_calculator.dart`, `schedule_builder.dart`, and `payment_allocator.dart` follow the private-constructor static-class pattern (`ClassName._()`).

**Features** (`lib/features/<feature>/`): screens grouped by feature — `dashboard/`, `borrowers/`, `loans/`, `collections/`, `reports/`, `more/`, `auth/` — each with its own `providers/` subfolder where it has write paths or derived state. Follow this grouping for new features rather than organizing by widget type.

**"More" tab content without a backing domain model**: Employees, Areas, Roles & Permissions, and Loan Schemes have no domain model or persistence on either backend yet — their screens use fixed demo content and say so in a doc comment. Don't wire them to fabricated "live" numbers; if you add real persistence for one of these, remove the doc comment and build it out on both backends the way Borrower/Loan/Collection already are.
