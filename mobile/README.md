# mobile

Flutter app for the Inventory & Sales Intelligence Platform. It consumes the Go REST API in `../backend`.
Conventions (Riverpod, per-feature clean architecture) are in [`CLAUDE.md`](CLAUDE.md).

## Stack

| Concern | Package |
|---|---|
| State / DI | `flutter_riverpod` 3 + `riverpod_annotation` / `riverpod_generator` (codegen) |
| HTTP | `dio` |
| Models | `freezed` + `json_serializable` |
| Routing | `go_router` |
| Lints | `flutter_lints` + `riverpod_lint` (as an `analysis_options.yaml` plugin) |
| Charts | `fl_chart` (dashboard line + pie charts) |
| i18n | `flutter_localizations` + `intl`, ARB files compiled by `flutter gen-l10n` |
| Storage | `shared_preferences` (language, theme mode, accent colour) |
| Theming / motion | Material 3 `ColorScheme.fromSeed` + a `ThemeExtension` for status colours; no animation package — see [Theming & Motion](#theming--motion) |
| Tests | `flutter_test` + `mocktail` |

`riverpod_lint` 3.x is an `analysis_server_plugin`. It no longer uses `custom_lint`, which is why `custom_lint` isn't a dependency (the two versions can't be resolved together).
Its lints show up in `flutter analyze` and in the IDE.

## Layout

```
lib/
  main.dart                     ProviderScope → InventoryApp
  app.dart                      MaterialApp.router
  core/
    constants/api_constants.dart  API_BASE_URL (--dart-define), timeouts, paths
    error/failure.dart            sealed Failure: ServerFailure / NetworkFailure / ValidationFailure
    error/failure_mapper.dart     DioException + backend error envelope → Failure
    l10n/l10n.dart                context.l10n shorthand, re-exports AppLocalizations
    l10n/field_issue_text.dart    context.messageFor(FieldIssue) → the sentence for a form field
    locale/locale_provider.dart   AppLanguage, LanguageController, appLocaleProvider
    theme/appearance_provider.dart ThemeModeController, AccentController (both persisted)
    validation/field_issue.dart   FieldIssue/FieldIssueKind — what domain rules return instead of text
  l10n/app_en.arb, app_id.arb     every UI string, English is the template
    error/guard.dart              guardApiCall(): any exception → Failure (used by repositories)
    network/dio_client.dart       dioProvider, tokenStoreProvider, ApiErrorInterceptor
    network/auth_interceptor.dart AuthInterceptor (Bearer token, refresh on 401 token_expired, one retry)
    auth/token_store.dart         AuthTokens, TokenStore, MemoryTokenStore (tests)
    auth/secure_token_store.dart  SecureTokenStore: Keychain / Keystore, loaded in main()
    auth/token_refresher.dart     TokenRefresher: single-flight /auth/refresh
    auth/session_events.dart      sessionEndedProvider: the network layer says the server ended the session
    auth/permissions.dart         Permissions: the backend's permission keys
    network/page_meta_model.dart  {"page","page_size","total"} meta of list responses
    pagination/paged.dart         PageResult<T> (domain) + PagedState<T> (infinite-scroll lists)
    router/app_router.dart        appRouterProvider (go_router), AppRoutes
    router/home_shell.dart        bottom navigation: Dashboard · Produk · Kategori · Pelanggan · Pesanan
    utils/                        formatRupiah(), formatDateTime()
  features/auth/
    domain/      AuthUser (+ can()), AuthRole, LoginRules; usecases Login, GetCurrentUser, Logout
    data/        TokenPairModel, MeModel, RoleRefModel, requests; AuthRemoteDataSource, AuthRepositoryImpl
    presentation/
      providers/ auth_providers.dart (DI), AuthController, currentUserProvider, ref.hasPermission()
      screens/   LoginScreen, SplashScreen
  features/role_management/
    domain/      Role, CatalogPermission, PermissionGroup + groupPermissions(), RoleInput/RolePatch, RoleRules;
                 usecases GetRoles, GetRole, CreateRole, UpdateRole, DeleteRole, SetRolePermissions,
                 GetPermissionCatalog, CountRoleUsers
    data/        RoleModel, CatalogPermissionModel, request models; RoleRemoteDataSource, RoleRepositoryImpl
    presentation/
      providers/ role_providers.dart (DI), roleListProvider, roleOptionsProvider, roleUserCountProvider(id),
                 permissionCatalogProvider, roleFormProvider(id) (+ savePermissions)
      screens/   RoleListScreen, RoleFormScreen, RolePermissionEditorScreen
  features/user_management/
    domain/      ManagedUser, UserInput, UserPatch, UserRules; usecases GetUsers, GetUser, CreateUser, UpdateUser, DeleteUser
    data/        UserModel (+ embedded UserRoleModel), request models; UserRemoteDataSource, UserRepositoryImpl
    presentation/
      providers/ user_providers.dart (DI), userListProvider, userSearchQueryProvider, userFormProvider(id)
      screens/   UserListScreen, UserFormScreen
  features/product/
    domain/      entities (Product + ProductCategory, ProductPage, ProductInput, ProductPatch, ProductRules),
                 repository interface, usecases (GetProducts, GetProductById, CreateProduct, UpdateProduct, DeleteProduct)
    data/        ProductModel (+ embedded ProductCategoryModel) + request models, ProductRemoteDataSource, ProductRepositoryImpl
    presentation/
      providers/ product_providers.dart (DI graph), productListProvider, productSearchQueryProvider,
                 productFormProvider, productDetailProvider
      screens/   ProductListScreen, ProductFormScreen (with category picker)
      widgets/   ProductTile (shows the category)
  features/category/
    domain/      Category, CategoryInput, CategoryPatch, CategoryRules; usecases Get/GetById/Create/Update/DeleteCategory
    data/        CategoryModel + request models, CategoryRemoteDataSource, CategoryRepositoryImpl
    presentation/
      providers/ category_providers.dart (DI), categoryListProvider, categorySearchQueryProvider,
                 categoryFormProvider, categoryOptionsProvider (all categories, for the product form picker)
      screens/   CategoryListScreen (search, infinite scroll, swipe delete), CategoryFormScreen
  features/inventory/
    domain/      Inventory, StockMovement, MovementType, MovementInput, MovementResult, LowStockItem, MovementRules;
                 usecases GetInventory, RecordStockMovement, GetStockMovements, GetLowStockItems
    data/        InventoryModel, StockMovementModel, MovementResultModel, LowStockItemModel, CreateMovementRequest,
                 InventoryRemoteDataSource, InventoryRepositoryImpl
    presentation/
      providers/ inventory_providers.dart (DI), productInventoryProvider(productId), stockMovementListProvider(productId),
                 lowStockListProvider
      screens/   ProductStockScreen (product detail: info, stock, movement history), LowStockScreen
      widgets/   StockSummaryCard, MovementTile, MovementFormSheet (IN / OUT / ADJUSTMENT)
  features/customer/
    domain/      Customer, CustomerInput, CustomerPatch, CustomerRules; usecases Get/GetById/Create/Update/DeleteCustomer
    data/        CustomerModel + request models, CustomerRemoteDataSource, CustomerRepositoryImpl
    presentation/
      providers/ customer_providers.dart (DI), customerListProvider, customerSearchQueryProvider,
                 customerFormProvider, customerSearchProvider(query) (for pickers)
      screens/   CustomerListScreen, CustomerFormScreen
      widgets/   pickCustomer() — searchable customer picker
  features/sales_order/
    domain/      SalesOrder, SalesOrderItem, OrderCustomer, OrderStatus (+ state machine: next / canMoveTo),
                 SalesOrderInput, OrderLineInput, OrderRules; usecases GetSalesOrders, GetSalesOrderById,
                 CreateSalesOrder, ChangeOrderStatus
    data/        SalesOrderModel (+ OrderCustomerModel, SalesOrderItemModel), request models, OrderStatusCodec,
                 SalesOrderRemoteDataSource, SalesOrderRepositoryImpl
    presentation/
      providers/ sales_order_providers.dart (DI), salesOrderFiltersProvider, salesOrderListProvider,
                 salesOrderDetailProvider(id) (+ changeStatus), orderFormProvider, statusChangeErrorLines()
      screens/   SalesOrderListScreen, SalesOrderDetailScreen, SalesOrderFormScreen
      widgets/   OrderStatusBadge (+ label / icon / action text per status)
  features/dashboard/
    domain/      AnalyticsRange, DashboardSummary, SalesTrend(+Point), TopProduct, CategoryBreakdown,
                 TrendGranularity; usecases GetDashboardSummary, GetSalesTrend, GetTopProducts,
                 GetCategoryBreakdown, GetLowStockAlertCount, GetDemandForecast, GetBusinessInsights;
                 forecast.dart: ForecastReport/ProductForecast, InsightReport/ProductInsight, TrendDirection
    data/        response models + TrendGranularityCodec + TrendDirectionCodec, DashboardRemoteDataSource
                 (all 7 analytics endpoints), DashboardRepositoryImpl
    presentation/
      providers/ dashboard_providers.dart (DI), dashboardDateRangeProvider (one range for the page),
                 trendGranularityFilterProvider, dashboardSummary/SalesTrend/TopProducts/
                 CategoryBreakdown/LowStockCount/Forecast/Insights providers (one per endpoint)
      screens/   DashboardScreen
      widgets/   DashboardSection + AsyncSection (per-section loading/error), DateRangeBar, SummaryCards,
                 SalesTrendChart (fl_chart line), TopProductsSection, CategoryBreakdownChart (fl_chart pie),
                 LowStockCard, ForecastSection (sparkline per product), InsightsSection + TrendBadge,
                 UnavailableView (the calm "ML service is down" state)
  features/product/presentation/widgets/product_picker.dart   pickProduct() — searchable, disables products already added
  shared/
    widgets/state_views.dart    LoadingView / ErrorView / EmptyView
    widgets/paged_list.dart     PagedListFooter, RefreshableView, listenNearEnd()
    widgets/search_picker_sheet.dart  showSearchPicker<T>() — bottom sheet with search, used by both pickers
    theme/app_theme.dart
```

Screens and routes:

| Route | Screen |
|---|---|
| `/login` | Login: email + password. Every other route redirects here while nobody is logged in |
| `/splash` | Shown at start-up only, while a stored session is checked (`GET /auth/me`) |
| `/admin/roles`, `/admin/roles/new`, `/admin/roles/:id`, `/admin/roles/:id/permissions` | Role management: list, form/detail, permission editor (see [Administration](#administration-roles--users)) |
| `/admin/users`, `/admin/users/new`, `/admin/users/:id` | User management: list, form |
| `/` (tab) | Dashboard: summary cards, date range (7/30/90 hari or custom), sales trend (daily/weekly), business insights, demand forecast, top 10 products, revenue per category, low-stock badge |
| `/products` (tab) | Products: search, infinite scroll, swipe delete. Tapping a product opens its detail. |
| `/categories` (tab) | Categories: search, infinite scroll, swipe delete |
| `/low-stock` | Products with `quantity <= low_stock_threshold`, opened from the dashboard card. |
| `/products/new`, `/products/:id/edit` | Product form with a category dropdown ("Tanpa Kategori" + all categories) |
| `/products/:id` | Product detail: category, current stock, low-stock status, "Catat pergerakan" and movement history |
| `/categories/new`, `/categories/:id/edit` | Category form |
| `/customers` (tab) | Customers: search by name, email or phone, infinite scroll, swipe delete |
| `/customers/new`, `/customers/:id/edit` | Customer form |
| `/sales-orders` (tab) | Orders: filter by status (chips) and customer (picker), infinite scroll, colored status badge |
| `/sales-orders/new` | Order form: customer picker, product picker, quantities, running total |
| `/sales-orders/:id` | Order detail: status + timeline, customer, items with snapshot prices, total, action buttons |

Bottom navigation (5 tabs): Dashboard · Produk · Kategori · Pelanggan · Pesanan.
Stok Menipis is no longer a tab: it is opened from the low-stock card on the dashboard (`context.pushNamed(AppRoutes.lowStock)`), which keeps the dashboard as the home screen without a sixth tab.

Behaviour worth knowing:
- **Category delete**: the backend returns 409 while products still use the category. The row stays and a dialog explains which products block it ("masih dipakai oleh N produk…").
  Category deletes are not optimistic, unlike product deletes, because the 409 is an expected outcome.
- **Movements**: IN adds stock, OUT subtracts, ADJUSTMENT sets the stock (stock count).
  An OUT larger than the stock gets a backend 422 on `quantity` ("insufficient stock: X available, Y requested"), shown under the quantity field. The app does no local stock check, because the stock on screen can be stale.
- **Product category** (PATCH): the form sends only changed fields. "Tanpa Kategori" sends `category_id: 0`, which removes the category.
- **Customer delete**: 409 while the customer has orders that are not cancelled (including SHIPPED). A dialog shows the count; nothing is deleted.
  Not optimistic, like category deletes.
- **Order status**: the buttons come from `OrderStatus.next`, which mirrors the backend state machine:

  | Status | Buttons |
  |---|---|
  | PENDING | Konfirmasi, Batalkan |
  | CONFIRMED | Kirim, Batalkan |
  | SHIPPED / CANCELLED | none |

  - Every transition asks for confirmation first. The dialog says what happens to stock: deducted on confirm, returned when cancelling a confirmed order, unchanged otherwise.
  - While a request runs, **all** action buttons are disabled and the tapped one shows a spinner, so a double tap can't send a second request.
  - If confirm fails on stock, a dialog lists every problem item by name ("Teh Melati (TEH-1): stok tersedia 3, dibutuhkan 5.") and states that no stock changed.
    A 422 on `status` (the order was changed on another device) reloads the order.
  - After a stock-changing transition, the stock screens (product stock, movement history, low stock) are refreshed.
- **Order form**: products already in the order are disabled in the picker ("sudah ditambahkan").
  Quantity must be 1–1,000,000, and the customer and at least one product are required.
  These rules mirror the backend, and local and backend (422) errors appear under the same line/field.
  The running total uses current product prices. The backend snapshots prices when the order is created, and the order detail shows those snapshots.
  Items can't be edited after creation; cancel the order and create a new one.

- **Dashboard**: five endpoints load in parallel, each in its own provider and its own section. A section that fails shows only its own message and "Coba lagi"; the others keep their data. While a section reloads (after a date change) its previous data stays on screen under a thin progress bar.
  The date range is one provider that the four range-based sections watch, so changing it reloads them together; the granularity toggle is a separate provider, so daily↔weekly costs exactly one request.
  The low-stock count is not range-bound (it is current stock), so it does not reload on a date change, and its card stays tappable even when the count fails.
  `DashboardScreen` keeps all five providers subscribed with `ref.listen`, so scrolling a card out of the `ListView` does not dispose it and refetch on scroll back.
  Money is formatted with `formatRupiah`; chart axes use `formatRupiahCompact` ("Rp 928rb"). Products without a category arrive as `category_id: null` and are shown as an italic grey "Tanpa Kategori" slice.
- **Forecast and insights** (`Prediksi Permintaan`, `Insight Bisnis`) come from the Go API endpoints backed by the Python ML service, so they have a state the other sections do not: **unavailable**. Three "nothing to show" cases are deliberately different:
  - `forecast_available` / `insights_available` false (the ML service is down) → `UnavailableView`: grey panel, muted icon, no red, and a low-emphasis "Coba lagi". It is not a bug and not the user's fault, so it must not look like `ErrorView`.
  - the report is available but one product carries an `error` → that row alone is dimmed to 60% and shows the message instead of numbers; the other products keep theirs.
  - no products at all → an empty state ("belum ada penjualan … jadi belum ada yang bisa diprediksi"), which reads differently from both of the above.
  `AsyncError` stays reserved for failures reaching our own API; an unavailable ML service is *data*, so the section never shows the generic red retry for it. Each section retries on its own — bringing the forecast back does not touch the insights.

Dependency direction: `presentation → domain ← data`. `domain` imports nothing from Flutter, Dio or Riverpod.

## Language (English / Bahasa Indonesia)

The app ships in both languages and **starts in English**. The choice is in **Settings**, reached from the
Dashboard app bar — five destinations already fill the bottom bar on a phone, and settings are somewhere
you visit now and then rather than a place you navigate between. Switching applies immediately, with no
restart, and is remembered in `shared_preferences` under `app_language`.

One switch covers both halves of the app:

- **the app's own labels** come from `lib/l10n/app_en.arb` / `app_id.arb` (377 keys), read as `context.l10n.<key>`.
  `app_en.arb` is the template, so a key must exist there first; `flutter gen-l10n` then writes
  `lib/l10n/app_localizations*.dart` (committed, like the other generated files).
- **the sentences the backend writes** come back already translated: `AcceptLanguageInterceptor` puts
  `Accept-Language: en|id` on *every* Dio request, read per request from `languageControllerProvider`, so a
  language change reaches the very next call without rebuilding the client.

Because of that split there are exactly two kinds of error text, and the UI never re-parses a sentence:

- a failure the **app** produced carries a `FailureIssue` (timeout, unreachable, malformed response, local
  validation) and `errorMessage(context, error)` writes it from the ARB files;
- a failure the **backend** produced carries its message and is shown as it is.

The same rule applies per field: domain rules in `domain/` return a typed `FieldIssue` instead of a sentence
(that is how `domain` stays free of Flutter), and `context.messageFor(issue)` renders it. Backend 422
`details[]` messages are shown verbatim under the same field names.

This replaced three regexes that matched the API's *English* wording (`used by (\d+) product`,
`has (\d+) sales order`, `(\d+) available, (\d+) requested`). They quietly stopped matching the moment the
server answered in Indonesian. Field *names* (`items[1].quantity`) are still parsed — those are part of the
API contract and are never translated — but the sentence beside them is only ever quoted.

### Formats

- **Money stays Rupiah in both languages**: `Rp 45.000`, formatted with `id_ID` grouping. The amount is
  Rupiah whichever language the labels are in, and a dot thousands separator is how Rupiah is written.
- **Dates are numeric in both**: `20/09/2026`, `20/09/2026 14:05`. Unambiguous next to a Rupiah amount, and
  it needs no per-locale date data at startup.
- **Plain numbers follow the language**: a forecast of one and a half units reads `1.5` in English and
  `1,5` in Indonesian (`formatDecimal`).

### Adding or changing a string

1. Add the key to `lib/l10n/app_en.arb` **and** `lib/l10n/app_id.arb` (same placeholders in both).
2. `flutter gen-l10n`
3. Use it as `context.l10n.<key>`, and commit the regenerated `app_localizations*.dart`.

## Theming & Motion

Everything visual comes from `lib/shared/theme/`. A screen should never write a
colour, a radius, a font size or a duration of its own — if it needs one that
does not exist yet, the token belongs in the theme.

| File | What it owns |
|---|---|
| `app_spacing.dart` | `AppSpacing` (4/8/12/16/24/32) and `AppRadius` (8 badge, 12 card, 20 sheet) |
| `app_typography.dart` | The type scale, plus `textTheme.metric` / `.metricLabel` |
| `app_status_colors.dart` | The five semantic status colours, as a `ThemeExtension` |
| `app_accent.dart` | The six accent presets a user can choose between |
| `app_motion.dart` | Durations, curves, and the single reduce-motion check |
| `app_theme.dart` | Assembles all of the above into the light and dark `ThemeData` |

### Design tokens

**Spacing** is a 4pt grid that doubles. A value that fits none of the six steps
usually means the layout needs rethinking, not a seventh step.

**Radius** has three steps and they carry meaning: the bigger the surface, the
softer the corner, so size reads as hierarchy instead of everything sharing one
rounded look.

**Type** stays on the platform UI font. A display face was considered and
rejected: this app is read in a warehouse on a cheap phone, where a bundled
font costs startup and a network-loaded one risks a flash of unstyled text. The
personality comes from the scale instead — a wider spread between levels,
tracking that tightens as text grows, and only two weights (600 and 400) doing
the work so "bold" always means one thing. The rule that shapes screens: **a
number outranks its label.** A figure is `textTheme.metric`; the word beside it
is a quiet `metricLabel`. Flutter's defaults give both nearly the same weight.

**Status colours** are five roles — `positive`, `negative`, `warning`, `info`,
`neutral` — and each is a triple: a `container` fill, the `onContainer` text
that sits on it, and an `accent` for the same status drawn straight onto the
page (a chart line, an arrow). They are shared by everything that reports a
state, so a rising trend, a shipped order, a healthy stock level and a stock-in
row are all the same green.

They are deliberately **not** derived from the accent colour. The accent is the
user's choice; "sales are down" has to read as down whichever of the six they
picked.

`test/shared/theme/status_contrast_test.dart` computes WCAG 2.1 contrast over
every pairing in both modes and fails the build if an edit drops one below AA
(4.5:1). It also checks that each accent preset produces a readable
`ColorScheme`. Editing a colour by eye is therefore safe: the test will say so.

### Dark mode and accent

`ThemeModeController` (System/Light/Dark) and `AccentController` live in
`lib/core/theme/appearance_provider.dart`, built the same way as
`LanguageController`: state is read straight out of `SharedPreferences` in
`build`, so the first frame is already right, and `main.dart` loads preferences
before `runApp`.

Both controls are in **Settings**, under the language picker, and apply
instantly. There is no "Apply" button on purpose — nothing here is destructive
or costly to undo, so a confirmation step would only put a tap between the user
and the thing they are trying to look at. The preview card above the controls
shows a metric, a filled button and a status badge together, which also makes
the point that the green badge is *not* part of the accent.

**To add an accent preset:** add a value to `AppAccent` with a stable `code`
(that string lands in storage) and a mid-tone `seed`, add a
`settingsAccent<Name>` key to both ARB files, and extend the `switch` in
`SettingsScreen._accentLabel`. The contrast test picks it up automatically —
if the seed produces an unreadable button, it fails. Keep new hues away from
the greens and reds the status palette uses.

The set is fixed rather than a free colour picker so that guarantee can hold:
an open picker lets someone land on a yellow that makes white-on-primary
buttons unreadable, and no amount of runtime clamping makes that pleasant.

### Motion

Two rules, both enforced in code:

1. **Nothing animates for longer than it takes to read it.** Durations run
   120–600ms (`AppMotion.fast` / `normal` / `page` / `counter`), and no
   animation gates content: data is laid out at its final value on frame one
   and the motion plays over the top.
2. **Reduce motion is honoured everywhere.** Widgets never read `MediaQuery`
   themselves; they ask `AppMotion.durationOf(context, …)`, which returns
   `Duration.zero` when the platform setting is on. Zero rather than "shorter",
   because a 60ms slide is a flicker — exactly the sensation the setting exists
   to prevent.

What moves, and why:

| Where | Motion | Why it earns its place |
|---|---|---|
| Route pushes | Fade + 16px drift, 280ms | The stock Android slide makes every push feel like a journey on a five-tab app |
| Tab switches | 120ms cross-fade | Marks that the page changed without re-animating a whole screen |
| Dashboard figures | Count up, 520ms | Changing the date range silently rewrites four numbers at once; this says which ones moved |
| Charts | fl_chart tween, 520ms | Same reason — a swapped series is otherwise indistinguishable from a redraw |
| Loading | Shimmer skeletons | See below |
| List rows | 0.985 scale while pressed | The ink splash is easy to miss outdoors; scale reads at a glance |
| Empty states | Icon eases in, 240ms | An empty screen arriving as a hard cut reads as a failed load |

The count-up starts at **72% of the target**, not zero. "Rp 0" racing upward
reads for a moment as *no sales today*, which is a different and alarming fact;
starting partway keeps every frame the right order of magnitude while still
clearly moving. Its semantics label is the finished number throughout, so a
screen reader is never handed a half-counted value.

Haptics (`HapticFeedback.lightImpact`) fire at four decision points only:
confirming/shipping/cancelling an order, deleting a record, a successful form
submit, and a recorded stock movement. They are fire-and-forget, never awaited
— awaiting a platform channel just delays the navigation that follows.

### Skeletons

`lib/shared/widgets/skeleton.dart` replaces every full-screen spinner.
`SkeletonList`, `SkeletonSummaryGrid`, `SkeletonChart`, `SkeletonLines`,
`SkeletonForm` and `SkeletonDetail` each mirror the real layout's box sizes, so
nothing shifts when the data lands — which is the whole point. One `Skeleton`
wrapper sweeps a single highlight across all the boxes below it, so a loading
area reads as one object rather than a dozen blinking rectangles, and the
subtree is wrapped in `ExcludeSemantics` so a screen reader hears the loading
announcement instead of a description of grey boxes.

On the dashboard, `AsyncSection` takes a `skeleton:` shaped like that section's
own content. A section that is *refreshing* keeps its old data on screen under
a hairline progress bar; only a first load shows a skeleton.

Under reduce motion the shimmer stops and the boxes stay flat — the shape still
says what is loading, which is most of the benefit.

## Prerequisites

- Flutter 3.47+ (Dart 3.13+)
- Backend running: `../infra` (`docker compose up -d`) and `../backend` (`go run ./cmd/migrate`, then `go run ./cmd/api`)
- For the two ML-backed dashboard sections (Prediksi Permintaan, Insight Bisnis) also start the Python service: `cd ../ml-service && uvicorn app.main:app --port 8000`. Without it those two sections show their "sedang tidak tersedia" state and everything else works normally.

## Setup

```bash
cd mobile
flutter pub get
flutter run
```

Generated files (`*.g.dart`, `*.freezed.dart`) are committed to the repo on purpose, so a fresh clone runs without codegen.
Don't add them to `.gitignore`.

### Regenerating code

You don't need `build_runner` for first-time setup. Re-run it only after changing a model or entity, for example adding a field to a `@freezed`, `@JsonSerializable` or `@riverpod` class:

```bash
dart run build_runner build      # regenerates *.g.dart / *.freezed.dart
dart run build_runner watch      # or keep it running while developing
```

Commit the regenerated files together with the change that caused them.

> **Note:** build_runner 2.16+ removed `--delete-conflicting-outputs`; conflicting outputs are overwritten automatically.
> The old command `dart run build_runner build --delete-conflicting-outputs` still works, but it prints a warning that the flag is ignored.

## Run

The API base URL comes from `--dart-define=API_BASE_URL=...`. The default is `http://localhost:8080`.

| Target | `API_BASE_URL` |
|---|---|
| **Android emulator** | `http://10.0.2.2:8080`: inside the emulator, `localhost` is the emulator itself; `10.0.2.2` is the host machine |
| iOS simulator / desktop | `http://localhost:8080` (default) |
| Physical device (same Wi-Fi) | `http://<host-LAN-IP>:8080`; the host firewall must allow port 8080 |

```bash
# Android emulator
flutter emulators --launch Pixel_9_Pro_XL
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080

# or from a (git-ignored) env file
cp env/dev.example.json env/dev.json
flutter run --dart-define-from-file=env/dev.json
```

> **Windows: the `&` in the repo folder name breaks Android builds.**
> `gradlew.bat` builds its classpath from unquoted `cmd` variables, so a path like
> `...\AI-Powered Inventory & Sales Intelligence System\mobile` is cut at `&`. The build then fails with
> `Could not find or load main class org.gradle.wrapper.GradleWrapperMain`.
> Fix it with one of these:
> - rename the repo folder without `&` (recommended, e.g. `AI-Powered-Inventory-Sales-Intelligence-System`), or
> - build through a short path alias:
>   `subst X: "C:\Kerjaan\Go\AI-Powered Inventory & Sales Intelligence System"`, then `cd X:\mobile; flutter run ...`
>   (a directory junction also works). Keep the alias path short; very long paths hit Windows' 260-character limit during shader compilation.
>
> `flutter test` / `flutter analyze` are unaffected.

For release builds, keep the real URL in a git-ignored `env/<name>.json` and pass it with `--dart-define-from-file`.
Never hardcode a non-dev URL in source.

Debug builds log every request and response through Dio's `LogInterceptor`.

## Test

```bash
flutter test                 # all tests
flutter test test/features/product
flutter analyze              # lints incl. riverpod_lint
```

- `test/features/<feature>/domain/usecases/`: every usecase, with a `mocktail` mock repository (table-driven where there are several cases)
- `test/features/<feature>/presentation/providers/`: list providers (search, pagination, delete incl. category 409), form providers (create, PATCH diff incl. `category_id`), `productInventoryProvider.recordMovement` (updates stock and reloads history + low-stock list)
  These tests use `ProviderContainer.test` with the feature's repository provider overridden.
- `test/features/<feature>/presentation/screens|widgets/`:
  - product list/form: category label, category picker, 422 on `category_id`
  - category list/form: 409 dialog, duplicate name
  - `MovementFormSheet`: local rules, insufficient-stock 422 under the field, success
  - `LowStockScreen`: data/empty/error/load more
- `test/contract/backend_json_contract_test.dart`: parses JSON copied from real backend responses:
  - embedded/omitted `category`
  - `{"movement","inventory"}`
  - zero-time inventory and low-stock items
  - customers with/without email
  - orders with nested `customer` + `items`, and list orders without `items`
  - the 422/409 error shapes
  - analytics: summary, daily/weekly trend, top products and category breakdown (incl. `"products": null` / `"categories": null` on an empty range, and `category_id: null`), low-stock count
  - forecast and insights: a product with a forecast, the ML service down (`forecast_available: false` + per-product `error`), partial failure, an empty range, and a real 0% change
- `test/features/sales_order/`:
  - the 4×4 state machine and `OrderRules`
  - usecases and providers (filters, `changeStatus` refreshes, per-item error lines, form state)
  - widget tests: detail buttons per status, confirm dialog, disabled while in flight, short-stock dialog; form duplicate product / quantity 0 / 422 per line / running total; list badges and filter
- `test/features/dashboard/`: providers (default 30-day range, date change reloads all range-based sections, granularity reloads only the trend, one failing endpoint leaves the others with data) and widget tests (per-section spinner, data, per-section retry, low-stock navigation, preset chip).
  `forecast_presentation_test.dart` covers the two ML-backed sections: providers (both follow the date range, an unavailable report is data rather than an AsyncError, partial failure stays available, a transport failure is still an error) and widgets (data, unavailable, partial failure, empty, and the two sections degrading independently)
- `test/core/`: backend error envelope → `Failure`, pagination helpers, `AppLanguage`/`LanguageController`
  (default English, a stored choice, an unsupported stored code, persistence across a restart), the
  `Accept-Language` header on every request, and `ThemeModeController`/`AccentController` (defaults,
  switching, persistence across a restart, an accent the app no longer ships)
- `test/core/network/auth_interceptor_test.dart` and `test/core/auth/token_refresher_test.dart`: the
  token refresh (see [Authentication](#authentication-token-refresh)). They run the real Dio stack over
  a fake backend that, like the real one, accepts each refresh token **once** and counts every reuse.
  Every scenario asserts that count stays 0: 5 requests expiring together → one refresh; a late 401 →
  no second refresh; rejected / offline / lost-answer refreshes; 401 `unauthorized`; 403. Making the
  refresh non-shared, or dropping the late-401 check, makes these tests fail.
- `test/features/auth/`: `AuthController` (start-up with and without stored tokens, 401 and offline at
  start-up, login success and 401, logout, session ended by the server and ended twice),
  `AuthRepositoryImpl` (tokens stored only on a full login, dropped if `/auth/me` fails, logout offline),
  the login screen (validation, 401 banner, 422 under the fields, offline, loading state), and
  `permission_ui_test.dart`: every gated action on screen per role (Staff, Super Admin, single-permission
  users). Ungating the category delete or the order actions makes it fail.
- `test/contract/admin_json_contract_test.dart`: the roles, permissions and users endpoints, from responses
  captured from the running API (including 409 in-use / system role, 422 per field and per permission index, 403).
- `test/features/role_management/`, `test/features/user_management/`: usecases and notifiers (create/edit/
  delete role, assign permissions as a full list, create/edit/deactivate user, 422/403/409), and the screens:
  loading/error/empty/data, add/delete shown per permission, the 409 dialog with the server's sentence, the
  permission editor (grouping from the API, toggles, full-list save, locked boxes for non-Super-Admins), form
  validation, and self-protection. `test/features/admin_navigation_test.dart`: the Settings entries for Staff,
  Super Admin and partial custom roles, and admin deep links bounced without the permission (real router).
  Turning off the role-list delete gate, the Settings entry gate or the route guard makes these fail.
- `test/core/router/auth_guard_test.dart`: `authRedirect` as a table, and the real router: splash at
  start-up, login from any page, a session ended from a deep screen lands on `/login` **once**, login lands on
  the Dashboard, logout from Settings. `test/core/auth/secure_token_store_test.dart`: `current` changes
  before storage is written.
- `test/features/settings/`: the Settings page — every option offered, the page retitles and re-themes
  itself immediately on switching, and each choice is written to storage
- `test/shared/theme/`: WCAG 2.1 contrast over every status pairing and every accent preset in both
  light and dark mode, and reduce-motion behaviour for each animated widget
- `test/shared/widgets/`: skeletons appear while loading, vanish when data lands, hold still under
  reduce motion, and stay out of the semantics tree
- `test/helpers/l10n_harness.dart`: `localizedApp()` for widget tests, `l10nOf(tester)` and `withL10n()`.
  Tests assert *which ARB key* a screen shows, not one language's wording, so neither language can drift:
  the delete-conflict and order-error helpers run over both locales.

## Authentication: token refresh

The backend issues a 15-minute access token and a 7-day refresh token that works **exactly once**: each
refresh rotates it, and sending a used one again counts as theft (reuse detection). The backend then
revokes every session of the user, on every device, and answers like any other failed refresh. So the
client must never send the same refresh token twice. That is what the HTTP client is built around.

`AuthInterceptor` puts `Authorization: Bearer <access>` on every request (except those with
`Options(extra: {AuthInterceptor.skipAuth: true})`, i.e. login). On a **401 `token_expired`** it asks
`TokenRefresher` for a usable token and retries the request **once**:

- **Single-flight.** When the token expires, every request in flight gets its 401 at about the same time.
  The first starts `POST /auth/refresh`; all others `await` the same future and retry with the token it
  brings. No request refreshes on its own. There is no lock: the check ("is the token my request failed
  with still the current one?") and claiming the in-flight refresh happen in one synchronous step, and Dart
  runs one isolate. For the same reason `TokenStore.current` is synchronous.
- **Late 401s.** A request sent with the old token whose 401 arrives *after* the refresh finished retries
  with the new token without refreshing again. Refreshing again would spend the fresh refresh token for
  nothing.
- **Never loops.** A retried request that fails again is not refreshed a second time. The refresh itself
  goes through a separate Dio without `AuthInterceptor`.

When the refresh itself fails, what is safe depends on whether the server could have rotated the token:

| Refresh outcome | What the app does |
|---|---|
| 401 (expired, revoked, reused) | ends the local session once (`onSessionEnded`); waiting requests fail with that 401 |
| never reached the server (no connection, connect timeout) | keeps the session; waiting requests fail as `NetworkFailure`; the next 401 may refresh again with the same, still valid, token |
| sent but no usable answer (receive timeout, 5xx, unreadable 200) | ends the local session and does **not** retry. The server may already have rotated the token, and a retry would be a reuse that logs the user out on every device. Re-login costs this device one login instead |

Other answers: a **401 with another code** (`unauthorized`: account deactivated or deleted) ends the local
session without refreshing, but only if it was sent with the current token. A **403 `forbidden`** is a
permission answer and leaves the session alone.

## Authentication: login, session and permissions

**Token storage.** `SecureTokenStore` (`core/auth/`) keeps the pair in platform secure storage via
`flutter_secure_storage`: the iOS Keychain (`first_unlock_this_device`: readable after the first unlock for
background refreshes, never synced or backed up), and on Android AES-GCM with the key in the Android Keystore.
`main()` loads it before `runApp`, like `SharedPreferences`, and overrides `tokenStoreProvider` with it.
`current` stays synchronous: it reads an in-memory copy that every save/clear updates **before** writing to
storage, which the single-flight refresh above depends on. Unreadable storage (Keystore reset, restored
backup) counts as "no session", not as a crash. Tests get `MemoryTokenStore`, the provider's default.

**Who is logged in.** `features/auth/` is a normal slice (entities, usecases, data, providers).
`AuthController` holds `AsyncData(user)`, `AsyncData(null)` when logged out, and `AsyncLoading` only while
the stored session is checked at start-up. `currentUserProvider` exposes the user. `AuthUser` carries the
name, the one role and the permission keys from `GET /auth/me`.

- **Start-up:** stored tokens → `GET /auth/me`, which also refreshes an expired access token on the way.
  Success → the user. Any failure → logged out, and the login screen. An auth failure has already removed
  the tokens; after a network failure they stay, and the next start tries them again.
- **Login:** `POST /auth/login` → tokens saved → `GET /auth/me`. The login response has the role but not the
  permissions. If `/auth/me` fails the tokens are dropped again, so there is never half a session.
- **Logout** (Settings): forgets the tokens first, then `POST /auth/logout` best effort, so it works offline.
- **Session ended by the server:** the network layer calls `onSessionEnded`, which signals
  `sessionEndedProvider` in `core/` (so `core/` doesn't import the feature). `AuthController` listens to it and
  drops the user, whichever request noticed, from whichever screen.

**Routing guard.** `appRouter` re-runs `authRedirect` (a pure function, tested as a table) whenever the auth
state changes. Checking the session → `/splash`. Nobody logged in → `/login`, from any route. Logged in on
`/login` or `/splash` → the Dashboard. Already on `/login` → no redirect, so a burst of 401s never loops. No
screen navigates on login or logout itself; the guard follows the state.

**Permission-based UI.** `ref.hasPermission(Permissions.productsDelete)` (`auth_controller.dart`) checks the
current user. A system role (Super Admin) passes everything. The rule is to **hide** what the user can't
do, never show it disabled without a reason; the backend enforces every permission regardless (403).

| Where | Action | Permission |
|---|---|---|
| Products list | "add" button · swipe to delete | `products.create` · `products.delete` |
| Product detail | edit button · "record movement" | `products.update` · `inventory.record_movement` |
| Categories list | "add" · swipe to delete · tap to edit | `categories.create` · `.delete` · `.update` |
| Customers list | "add" · swipe to delete · tap to edit | `customers.create` · `.delete` · `.update` |
| Orders list | "new order" | `sales_orders.create` |
| Order detail | Confirm · Ship · Cancel (per the state machine) | `sales_orders.confirm` · `.ship` · `.cancel` |

An order whose next steps the user may not perform shows no action bar at all. "No more actions" stays
reserved for final orders. There is no user or role management screen yet, so there is no entry point to hide.
Settings shows the logged-in user's name, role and email, and the Sign out button.

## Administration: roles & users

Settings has an **Administration** section with two entries. Each shows on its own, for users who hold at
least one permission of its area (`Permissions.roleManagement` = any `roles.*`, `Permissions.userManagement` =
any `users.*`), through the same `ref.hasAnyPermission()` as the rest of the app. With neither, the section
isn't there. Every admin route also checks the permission itself (`requireAny` in `app_router.dart`), so a
deep link can't open a screen whose entry is hidden: it lands back on `/settings`.

**Role management** (`features/role_management/`):

- **Role list** (`/admin/roles`): name, permission count ("All permissions" for the system role, with a
  *System* badge), and the number of users. The roles endpoint doesn't report the user count, so each row
  reads it from `GET /users?role_id=…&page_size=1`. That needs `users.view`; without it the count is left out.
- **Role form** (`/admin/roles/new`, `/admin/roles/:id`): name and description. It doubles as the detail page:
  what the role grants, and "Edit permissions". A new role continues on its own page after saving, since
  permissions are assigned there. The system role is explained, its name is locked, and it has no permission
  editor, because the backend never lets it be renamed, deleted or given a list.
- **Permission editor** (`/admin/roles/:id/permissions`): the catalog from `GET /permissions`, grouped by the
  API's own `resource_group` (only the group *names* are translated; an unknown group shows under its code).
  One checkbox per permission, plus a tri-state box per group. Saving sends the **complete desired list**
  of keys, in catalog order, to `PUT /roles/:id/permissions`, which replaces rather than merges. A
  non-Super-Admin can only grant what they hold (the backend answers 403 otherwise), so those boxes are
  shown but locked, with a note.
- **Delete**: swipe on the list. Never offered for the system role. A 409 ("still linked to N users, including
  deleted ones") is shown exactly as the backend wrote it, already in the app's language.

**User management** (`features/user_management/`):

- **User list** (`/admin/users`): name, email, role, an Active/Inactive chip, and a "(You)" mark on your own
  row. Search by name or email, infinite scroll, swipe to delete.
- **User form** (`/admin/users/new`, `/admin/users/:id`): name, email, password (a new, optional one when
  editing; `PATCH /users/:id` accepts it, and it signs the user out everywhere), role (from `GET /roles`),
  and the active switch. On edit only the changed fields are sent.
- **Self-protection, before the request:** on your own account the role picker and the active switch are
  locked with the reason shown, and swiping your own row says you can't delete yourself. The backend
  refuses all three too (409). A non-Super-Admin isn't offered the Super Admin role (backend 403). Other
  refusals (403/409, e.g. a duplicate email) appear in the form as the backend's sentence.

| Where | Action | Permission |
|---|---|---|
| Settings | "Roles & permissions" entry | any `roles.*` |
| Settings | "Users" entry | any `users.*` |
| Role list | add · swipe to delete (not the system role) · user count | `roles.create` · `roles.delete` · `users.view` |
| Role form | save changes · "Edit permissions" (not the system role) | `roles.update` · `roles.assign_permissions` |
| Permission editor | open · a checkbox (non-Super-Admin) | `roles.assign_permissions` · holding that permission |
| User list | add · swipe to delete | `users.create` · `users.delete` |
| User form | save changes (role, active, password…) | `users.update` (create: `users.create`) |

Reading a list needs its `*.view` permission on the backend. A user with only, say, `roles.create` sees
the entry, but the list shows the server's 403 message; the form still works.

## Error handling

The backend returns `{"error": {"code", "message", "details"}}`. `ApiErrorInterceptor` maps every Dio error to a `Failure`, and `ProductRepositoryImpl` guarantees that only `Failure`s reach the UI:

| Backend | Flutter |
|---|---|
| 422 `validation_failed` + `details[]` | `ValidationFailure.messages` (`{field: message}`), shown under the form fields as they arrive — already translated |
| rejected locally, before any request | `ValidationFailure.issues` (`{field: FieldIssue}`), rendered by `context.messageFor()` |
| 409 `conflict` (duplicate SKU / category name) | `ServerFailure(isConflict)`, shown on the SKU / name field |
| 409 `conflict` on category delete (still used) | dialog from `categoryDeleteErrorMessage()` |
| 409 `conflict` on customer delete (active orders) / duplicate email | dialog from `customerDeleteErrorMessage()` / error on the email field |
| 422 `items[i].quantity` on order confirm (short stock) | dialog with one line per item from `statusChangeErrorLines()` |
| 404 / 400 / 500 | `ServerFailure(statusCode, code, message)` |
| timeout / no connection | `NetworkFailure` |

Riverpod 3 retries failed providers automatically. `main.dart` disables that (`retry: (_, _) => null`), so errors show immediately with a "Try again" button.

`main.dart` also loads `SharedPreferences` before `runApp` and overrides `sharedPreferencesProvider` with it,
so the first frame is already in the right language instead of flashing English first.

## Adding a feature

Copy `features/product/`: entity → repository interface → usecases → model/datasource/repository impl → providers → screens.
Register routes in `core/router/app_router.dart`, run `build_runner`, and add usecase and provider tests.
Put every user-visible string in both ARB files (no literals in widgets) and let domain rules return a
`FieldIssue` rather than a sentence.
