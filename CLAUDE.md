# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

MicroCollect — a rural microfinance collection management app (Flutter, Material 3). Currently a frontend-only prototype: all data comes from `lib/core/models/mock_data.dart` (`MockData` class), there is no backend/API/persistence layer yet. `lib/core/utils/loan_calculator.dart` is explicitly commented as isolated so a future backend can become the source of truth for those calculations — don't entangle it with UI code.

## Commands

```bash
flutter pub get                       # install dependencies
flutter run                           # run on connected device/emulator/web
flutter run -d chrome                 # run in browser
flutter analyze                       # static analysis (uses analysis_options.yaml + flutter_lints)
flutter test                          # run all tests
flutter test test/widget_test.dart    # run a single test file
dart run build_runner build --delete-conflicting-outputs   # regenerate *.g.dart (riverpod/go_router codegen)
dart run build_runner watch --delete-conflicting-outputs   # regenerate on save
```

There is no `windows/`, `macos/`, or `linux/` platform folder — only `android/`, `ios/`, and `web/` exist. `analysis_options.yaml` excludes `build/**`, `android/**`, `ios/**`, `web/**` from analysis.

`test/widget_test.dart` is still the default Flutter counter-app smoke test left over from scaffolding — it does not test `MicroCollectApp`'s actual UI and will fail if run as-is. Treat it as needing replacement rather than as a real regression signal.

## Architecture

**Entry point / composition**: `lib/main.dart` wraps `MicroCollectApp` (`lib/app.dart`) in a `ProviderScope` (Riverpod). `app.dart` builds a `MaterialApp.router` using `AppTheme.light` and the `goRouter` from `appRouterProvider`.

**Routing** (`lib/core/routing/app_router.dart`, generated `app_router.g.dart` via `riverpod_annotation`/`build_runner`): a single `@riverpod` `GoRouter` provider.
- A `ShellRoute` wraps the four bottom-nav tabs (`/`, `/borrowers`, `/collections`, `/reports`) in `_AppShell`, which renders `AppBottomNav` and keeps tab state alive via `NoTransitionPage`.
- Detail/creation routes (`/borrowers/:id`, `/borrowers/add`, `/loans/:id`, `/loans/create`) are registered outside the shell with `parentNavigatorKey: _rootNavigatorKey` so they push full-screen over the bottom nav instead of inside a tab.
- When adding a new top-level tab, add it to both the `ShellRoute.routes` list and `_AppShell._paths` (index order must match). When adding a detail screen, register it at the top level with `parentNavigatorKey: _rootNavigatorKey`, not nested under the shell.

**State management**: Riverpod (`flutter_riverpod` + code-generated `riverpod_annotation`) is wired up at the app/router level, but feature screens are currently plain `StatelessWidget`s reading directly from `MockData` — there are no feature-level providers yet. When introducing real data flow, follow the `@riverpod` code-gen pattern already used in `app_router.dart` (annotate a function/class, run `build_runner`, `part 'x.g.dart';`) rather than manually written `StateNotifierProvider`s, for consistency.

**Domain models & mock data** (`lib/core/models/mock_data.dart`): `Borrower`, `Loan`, `Installment`, `CollectionEntry`, `DailyCollection` plus their status enums (`BorrowerStatus`, `LoanStatus`, `InstallmentStatus`, `CollectionStatus`) are defined in this one file alongside the static `MockData` class that supplies sample records for every screen. IDs follow `B00x` (borrowers), `L00x` (loans), `I00x` (installments), `C00x` (collection entries) — reuse these prefixes for any new mock records so cross-references between borrowers/loans/collections stay resolvable by ID.

**Design system** (`lib/core/theme/`, `lib/core/constants/app_spacing.dart`): the "Growth & Trust" theme.
- `AppColors` defines the full Material 3 `ColorScheme` plus custom semantic colors (`success`/`warning`/`danger`/`info` + light variants), chart colors, and glassmorphism colors — consumed by `AppTheme.light` (`app_theme.dart`) which configures every widget theme (buttons, inputs, cards, bottom sheets, snackbars, etc.) in one place. Prefer adding a color/theme knob to these files over hardcoding colors in a screen.
- `AppSpacing` (4px/8px-grid tokens: `xs`/`sm`/`md`/`lg`/`xl`/`xxl`, plus `marginMobile`/`marginDesktop`) and `AppRadius` (in the same `app_spacing.dart` file) are the spacing/radius tokens used throughout instead of literal `EdgeInsets`/radius values.
- `GlassCard` (`lib/core/widgets/glass_card.dart`) is the signature glassmorphism container (semi-transparent + `BackdropFilter` blur + `AppShadows.glass`) used for hero/emphasis cards — use it instead of a plain `Card` when a screen needs the frosted-glass look shown on the dashboard.
- Other shared widgets live in `lib/core/widgets/`: `AppBottomNav`, `StatCard`, `StatusBadge`, `EmptyStateWidget`, `SkeletonLoader`.

**Formatting/validation utilities** (`lib/core/utils/`): `AppFormatters` centralizes all currency (`en_IN` locale, ₹ symbol), date, phone, and Aadhaar formatting/masking — use it rather than formatting dates/currency/Aadhaar/phone numbers inline. `validators.dart` and `loan_calculator.dart` follow the same private-constructor static-class pattern (`ClassName._()`), matched by `AppFormatters` and `MockData`.

**Features** (`lib/features/<feature>/`): screens are grouped by feature — `dashboard/`, `borrowers/`, `loans/`, `collections/`, `reports/` — each a flat folder of screen/sheet widgets (no further nesting). Follow this grouping for new features rather than organizing by widget type.
