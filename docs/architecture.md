# Architecture — Inventory & Sales Intelligence Platform

Dokumen ini dibaca oleh setiap agent (Claude Code/Codex) di awal sesi, sesuai CLAUDE.md. Isinya: keputusan arsitektur + status project saat ini. Update bagian "Status" setiap kali ada milestone yang selesai.

## 1. Domain Flow

```
Products → Inventory → Sales Orders → Customers → Sales Data → Analytics Engine → AI/Prediction
```

## 2. System Architecture

```
Flutter (mobile) → Go REST API (Gin) → PostgreSQL
                          ↓
                    Redis (cache/queue)
                          ↓
               Python FastAPI (ML service)
                          ↓
                  Forecasting / Insight
```

- **Backend (Go/Gin/GORM):** REST API, satu-satunya service yang bicara langsung ke Postgres.
- **Redis:** cache (dashboard aggregates) + queue (job forecasting async, misal `asynq`).
- **ML Service (Python/FastAPI):** stateless, tidak akses DB langsung — menerima data historis dari Go backend via request, mengembalikan hasil forecast/insight. Alasan: memisahkan concern (Go = source of truth, Python = komputasi), dan mudah dijelaskan saat interview.
- **Mobile (Flutter):** satu-satunya consumer API untuk end user, tidak ada web frontend terpisah di fase awal.

## 3. Tech Stack Decisions & Alasan

| Keputusan | Alasan |
|---|---|
| Go dipilih daripada Nest.js | Konsisten dengan migrasi proyek klien lain (Laravel/Inertia → Go+Gin+GORM), reuse momentum belajar |
| PostgreSQL dipilih daripada MySQL | Analytical query lebih kuat; konsisten dengan portfolio RAG platform yang sudah pakai Postgres |
| Flutter dipilih daripada React/Next.js | Requirement mobile app native-feel eksplisit; reuse skill dari RAG platform |
| ML service dipisah sebagai microservice, bukan library dalam Go | Python punya ekosistem ML matang (Pandas/Scikit-learn); memisahkan concern computational vs transactional |

## 4. Data Flow — Forecasting Pipeline

1. Go backend mengumpulkan sales history per product (aggregated daily/weekly) dari Postgres.
2. Go backend mengirim data historis ke FastAPI ML service (REST call).
3. ML service menjalankan model (moving average → linear regression, upgrade path ke model lain nanti) dan mengembalikan hasil prediksi.
4. Go backend menyimpan hasil (atau cache di Redis) dan mengekspos ke Flutter via endpoint insight/forecast.
5. Insight text ("Product A naik 32% dalam 4 minggu") di-generate dari hasil ini — rule-based dulu, upgrade ke LLM call di fase lanjut kalau diperlukan.

## 5. Repo Structure

```
/backend        → Go (Gin, GORM, clean architecture: handler/service/repository)
/mobile         → Flutter app
/ml-service     → Python FastAPI + notebooks eksperimen model
/infra          → docker-compose, GitHub Actions workflows
/docs           → dokumen ini, ERD, API spec
```

## 6. Status

> Update bagian ini setiap milestone selesai.

- [x] Infra: docker-compose Postgres + Redis + healthcheck, `/infra/.env.example`, `/infra/README.md` — **selesai**
- [x] Backend: scaffold Go (handler/service/repository) + koneksi Postgres/Redis — **selesai** (`/health` 200, Product CRUD sebagai template slice, migration via `go run ./cmd/migrate`, unit test service/config/health)
- [x] Core CRUD: Products, Category, Inventory, Stock Movement — **selesai di backend** (Category CRUD + tolak delete 409 selama masih dipakai produk; `products.category_id` nullable FK; Inventory 1-1 per produk + `stock_movements` immutable IN/OUT/ADJUSTMENT dalam satu transaction dengan row lock, stok tidak bisa negatif (CHECK + validasi service); endpoint low-stock; unit test service; dicoba end-to-end: `go run ./cmd/migrate` ke Postgres asli + 48 skenario HTTP ke API asli termasuk 20 OUT paralel). Belum ada layar Flutter untuk Category/Inventory.
- [ ] Sales Order & Customer — **belum mulai**
- [ ] Dashboard & analytics dasar (SQL aggregation) — **belum mulai**
- [x] Flutter app: halaman core — **selesai** (scaffold Riverpod + clean architecture per fitur, slice `product`: list + search + pagination + pull-to-refresh, form create/edit, swipe delete; 57 unit/widget test; dicoba di emulator Android `Pixel_9_Pro_XL` terhubung ke backend asli via `10.0.2.2:8080`: list, search, create, 409 SKU duplikat, PATCH, delete, error state + retry)
- [x] Flutter: Category & Inventory — **selesai** (fitur `category` CRUD + search + dialog jelas saat delete ditolak 409; `product` dapat dropdown kategori + label kategori di list/detail; fitur `inventory`: halaman detail produk (stok, status low-stock, catat IN/OUT/ADJUSTMENT, riwayat infinite scroll), 422 stok tidak cukup tampil di bawah field quantity; bottom nav Produk/Kategori/Stok Menipis; 161 unit/widget test; dicoba di emulator Android `Pixel_9_Pro_XL` ke backend asli via `10.0.2.2:8080`: create kategori, create produk + pilih kategori, IN/ADJUSTMENT/OUT, OUT melebihi stok → 422 di field, status berubah ke "Stok menipis", tab Stok Menipis, delete kategori terpakai → dialog 409, delete kategori kosong)
- [x] Low-stock detection (threshold-based) — **selesai** (backend `GET /api/v1/inventory/low-stock`, threshold per produk + default `LOW_STOCK_DEFAULT_THRESHOLD`; tab "Stok Menipis" di Flutter, dicoba di emulator)
- [ ] ML service: forecasting sederhana — **belum mulai**
- [ ] AI-generated insight — **belum mulai**
- [ ] Polish untuk demo interview — **belum mulai**

## 7. Open Decisions (belum final, diputuskan nanti)

- State management Flutter: Riverpod vs Bloc — belum dipilih.
- Queue library Go: `asynq` vs Redis Streams manual — belum dipilih.
- Format komunikasi Go ↔ ML service: REST JSON vs gRPC — asumsi REST JSON dulu untuk kesederhanaan, bisa direvisi.
