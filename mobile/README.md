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
    error/guard.dart              guardApiCall(): any exception → Failure (used by repositories)
    network/dio_client.dart       dioProvider, ApiErrorInterceptor
    network/page_meta_model.dart  {"page","page_size","total"} meta of list responses
    pagination/paged.dart         PageResult<T> (domain) + PagedState<T> (infinite-scroll lists)
    router/app_router.dart        appRouterProvider (go_router), AppRoutes
    router/home_shell.dart        bottom navigation: Produk · Kategori · Stok Menipis
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
  shared/
    widgets/state_views.dart    LoadingView / ErrorView / EmptyView
    widgets/paged_list.dart     PagedListFooter, RefreshableView, listenNearEnd()
    theme/app_theme.dart
```

Screens and routes:

| Route | Screen |
|---|---|
| `/` (tab) | Products: search, infinite scroll, swipe delete. Tapping a product opens its detail. |
| `/categories` (tab) | Categories: search, infinite scroll, swipe delete |
| `/low-stock` (tab) | Products with `quantity <= low_stock_threshold`. Refreshed whenever the tab is opened. |
| `/products/new`, `/products/:id/edit` | Product form with a category dropdown ("Tanpa Kategori" + all categories) |
| `/products/:id` | Product detail: category, current stock, low-stock status, "Catat pergerakan" and movement history |
| `/categories/new`, `/categories/:id/edit` | Category form |

Behaviour worth knowing:
- **Category delete**: the backend returns 409 while products still use the category. The row stays and a dialog explains which products block it ("masih dipakai oleh N produk…").
  Category deletes are not optimistic, unlike product deletes, because the 409 is an expected outcome.
- **Movements**: IN adds stock, OUT subtracts, ADJUSTMENT sets the stock (stock count).
  An OUT larger than the stock gets a backend 422 on `quantity` ("insufficient stock: X available, Y requested"), shown under the quantity field. The app does no local stock check, because the stock on screen can be stale.
- **Product category** (PATCH): the form sends only changed fields. "Tanpa Kategori" sends `category_id: 0`, which removes the category.

Dependency direction: `presentation → domain ← data`. `domain` imports nothing from Flutter, Dio or Riverpod.

## Prerequisites

- Flutter 3.47+ (Dart 3.13+)
- Backend running: `../infra` (`docker compose up -d`) and `../backend` (`go run ./cmd/migrate`, then `go run ./cmd/api`)

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
- `test/contract/backend_json_contract_test.dart`: parses JSON copied from real backend responses (embedded/omitted `category`, `{"movement","inventory"}`, zero-time inventory, low-stock items)
- `test/core/`: backend error envelope → `Failure`, pagination helpers

## Error handling

The backend returns `{"error": {"code", "message", "details"}}`. `ApiErrorInterceptor` maps every Dio error to a `Failure`, and `ProductRepositoryImpl` guarantees that only `Failure`s reach the UI:

| Backend | Flutter |
|---|---|
| 422 `validation_failed` + `details[]` | `ValidationFailure.messages` (`{field: message}`), shown under the form fields |
| 409 `conflict` (duplicate SKU / category name) | `ServerFailure(isConflict)`, shown on the SKU / name field |
| 409 `conflict` on category delete (still used) | dialog from `categoryDeleteErrorMessage()` |
| 404 / 400 / 500 | `ServerFailure(statusCode, code, message)` |
| timeout / no connection | `NetworkFailure` |

Riverpod 3 retries failed providers automatically. `main.dart` disables that (`retry: (_, _) => null`), so errors show immediately with a "Try again" button.

## Adding a feature

Copy `features/product/`: entity → repository interface → usecases → model/datasource/repository impl → providers → screens.
Register routes in `core/router/app_router.dart`, run `build_runner`, and add usecase and provider tests.
