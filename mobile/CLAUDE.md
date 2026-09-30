# CLAUDE.md — /mobile (Flutter App)

Instruksi ini dibaca oleh agent (Claude Code/Codex) khusus saat bekerja di folder `/mobile`. Melengkapi CLAUDE.md di root (tech stack umum, agent workflow rules) — baca root CLAUDE.md dan `docs/architecture.md` dulu untuk konteks project secara keseluruhan.

## 1. Tujuan

Mobile app konsumen untuk Inventory & Sales Intelligence Platform. Satu-satunya frontend untuk end user (tidak ada web app terpisah di fase awal). Mengonsumsi REST API dari `/backend` (Go).

## 2. State Management: Riverpod

**Keputusan:** Riverpod (bukan Bloc). Alasan: boilerplate lebih ringan untuk banyak resource CRUD, dependency injection built-in via provider graph, `AsyncNotifierProvider`/`FutureProvider` natural untuk data fetching dari REST API, dan testability tanpa widget tree lewat `ProviderContainer`.

- Gunakan `riverpod` + `flutter_riverpod` + `riverpod_annotation` (code generation via `riverpod_generator`) — bukan versi manual tanpa codegen, supaya boilerplate provider tetap minim.
- State async (fetch dari API) selalu lewat `AsyncNotifier`/`FutureProvider`, jangan bikin state Loading/Success/Error manual — biarkan `AsyncValue` yang handle.
- Provider di-scope per fitur, didefinisikan di `presentation/providers/`, bukan di file global.

## 3. Arsitektur: Clean Architecture per Fitur (Vertical Slice)

Struktur ini paralel dengan pola handler/service/repository di `/backend`, supaya mental model konsisten antara backend dan mobile.

```
lib/
  core/
    network/           → Dio client, interceptor (auth, logging, error mapping)
    error/              → Failure classes, exception → failure mapper
    constants/           → API base URL, timeout, dll (baca dari .env via --dart-define atau flutter_dotenv)
    utils/               → formatter (currency Rupiah, tanggal), validator umum
  features/
    <nama_fitur>/            → contoh: product, inventory, sales_order, dashboard
      data/
        datasources/         → <Fitur>RemoteDataSource — panggil Dio, hit endpoint Go API
        models/               → <Fitur>Model — extends/converts ke Entity, handle JSON (via freezed + json_serializable)
        repositories/         → <Fitur>RepositoryImpl — implements domain repository, mapping Model→Entity dan error→Failure
      domain/
        entities/              → <Fitur> — pure Dart class, tanpa dependency Flutter/JSON
        repositories/           → <Fitur>Repository — abstract class/interface
        usecases/                → satu class per use case (GetProducts, CreateProduct, dll), single responsibility
      presentation/
        providers/                → <fitur>_provider.dart — AsyncNotifierProvider yang panggil usecase
        screens/                   → <Fitur>ListScreen, <Fitur>DetailScreen, <Fitur>FormScreen
        widgets/                    → widget khusus fitur ini (tidak dipakai fitur lain)
  shared/
    widgets/              → widget reusable lintas fitur (button, loading indicator, error view)
    theme/                 → ThemeData, warna, typography
  main.dart               → entrypoint, ProviderScope wrapper, routing setup
```

**Aturan arah dependency:** `presentation` → `domain` ← `data`. Domain layer tidak boleh import apapun dari `data` atau `presentation` (tidak ada dependency ke Dio, Riverpod, atau Flutter widget). Ini yang membuat business logic testable tanpa mock network/UI.

## 4. Konvensi Kode

- **Model/Entity generation:** pakai `freezed` untuk immutable classes + `json_serializable` untuk (de)serialization. Jangan tulis `fromJson`/`toJson`/`copyWith` manual.
- **Routing:** `go_router`, didefinisikan terpusat di `core/router/app_router.dart` (bukan tersebar per screen).
- **HTTP client:** `Dio`, satu instance di-share via provider (`dioProvider`), base URL dan interceptor error dikonfigurasi di sana.
- **Error handling:** exception dari datasource di-mapping ke `Failure` (sealed class: `ServerFailure`, `NetworkFailure`, `ValidationFailure`) di repository layer. UI hanya tahu `Failure`, tidak pernah lihat exception mentah dari Dio.
- **Naming:** file snake_case, class PascalCase, provider camelCase dengan suffix jelas (`productListProvider`, bukan `productProvider` yang ambigu).
- **Testing:** setiap usecase dan notifier punya unit test (mock repository via `mocktail`). Widget test untuk screen dengan logic kompleks (form validation, empty/error state).

## 5. Konfigurasi Environment

- Base URL API Go backend dibaca dari `--dart-define=API_BASE_URL=...` saat build/run, dengan default ke `http://localhost:8080` untuk dev lokal.
- **Emulator Android:** `10.0.2.2` menggantikan `localhost` untuk akses ke backend yang jalan di host machine — dokumentasikan ini di `/mobile/README.md`.
- Jangan commit base URL production ke source code — pakai `--dart-define-from-file` dengan file env yang di-gitignore untuk build release.

## 6. Agent Workflow Rules (sama seperti root CLAUDE.md)

- **Git manual oleh Danny.** Agent tidak `git commit`/`git push`.
- Kalau ada perubahan yang perlu wiring ke `/backend` (misal field baru di response API yang perlu model baru di Flutter), agent menulis instruksi/snippet untuk di-paste manual, bukan mengedit `/backend` langsung.
- Kalau Claude Code dan Codex jalan paralel: scope tugas per-fitur (`features/product/` vs `features/inventory/`) untuk hindari konflik, seperti aturan scoping per-service di root CLAUDE.md.
- Update `docs/architecture.md` bagian Status setiap fitur mobile selesai (build jalan + bisa didemokan di emulator/device).

## 7. Definition of Done per Fitur

Fitur dianggap selesai kalau: ada unit test untuk usecase/provider, UI bisa handle 3 state (loading/error/data), dan sudah dicoba jalan di emulator terhubung ke backend asli (bukan cuma mock data).
