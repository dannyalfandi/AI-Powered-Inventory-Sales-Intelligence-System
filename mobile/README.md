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
| Storage | `shared_preferences` (the language choice) |
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
    validation/field_issue.dart   FieldIssue/FieldIssueKind — what domain rules return instead of text
  l10n/app_en.arb, app_id.arb     every UI string, English is the template
    error/guard.dart              guardApiCall(): any exception → Failure (used by repositories)
    network/dio_client.dart       dioProvider, ApiErrorInterceptor
    network/page_meta_model.dart  {"page","page_size","total"} meta of list responses
    pagination/paged.dart         PageResult<T> (domain) + PagedState<T> (infinite-scroll lists)
    router/app_router.dart        appRouterProvider (go_router), AppRoutes
    router/home_shell.dart        bottom navigation: Dashboard · Produk · Kategori · Pelanggan · Pesanan
    utils/                        formatRupiah(), formatDateTime()
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

- **the app's own labels** come from `lib/l10n/app_en.arb` / `app_id.arb` (267 keys), read as `context.l10n.<key>`.
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
  (default English, a stored choice, an unsupported stored code, persistence across a restart) and the
  `Accept-Language` header on every request
- `test/features/settings/`: the Settings page — both options offered, the page retitles itself immediately
  on switching, and the choice is written to storage
- `test/helpers/l10n_harness.dart`: `localizedApp()` for widget tests, `l10nOf(tester)` and `withL10n()`.
  Tests assert *which ARB key* a screen shows, not one language's wording, so neither language can drift:
  the delete-conflict and order-error helpers run over both locales.

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
