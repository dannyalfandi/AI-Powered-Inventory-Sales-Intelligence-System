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
- [x] Core CRUD: Products, Category, Inventory, Stock Movement — **selesai di backend** (Category CRUD + tolak delete 409 selama masih dipakai produk; `products.category_id` nullable FK; Inventory 1-1 per produk + `stock_movements` immutable IN/OUT/ADJUSTMENT dalam satu transaction dengan row lock, stok tidak bisa negatif (CHECK + validasi service); endpoint low-stock; unit test service; dicoba end-to-end: `go run ./cmd/migrate` ke Postgres asli + 48 skenario HTTP ke API asli termasuk 20 OUT paralel). Layar Flutter: lihat item "Flutter: Category & Inventory".
- [x] Sales Order & Customer — **selesai di backend** (Customer CRUD + tolak delete 409 selama ada order yang belum CANCELLED; Sales Order dengan snapshot harga, nomor `SO-YYYYMMDD-NNNN` dari counter per hari dalam transaksi yang sama, state machine PENDING→CONFIRMED→SHIPPED / →CANCELLED; stok dikurangi saat CONFIRMED dan dikembalikan saat CONFIRMED→CANCELLED, semua item dalam satu transaksi dengan row lock (order + inventory urut `product_id`), gagal satu item = rollback semua + 422 per item; `stock_movements.sales_order_id` untuk jejak. Unit test service (state machine lengkap 4×4, rollback, stok cukup/kurang, cancel mengembalikan stok). Dicoba end-to-end: migrate ke Postgres asli + `scripts/e2e.sh` 105/105 dua kali, termasuk 5 order berebut stok yang sama secara paralel (tepat 3 sukses), 1 order di-confirm 10× paralel (stok berkurang sekali), 20 create paralel (nomor unik tanpa celah); invariant DB dicek via SQL: saldo stok = replay movement, tidak ada stok negatif.) Layar Flutter: lihat item "Flutter: Customer & Sales Order".
- [x] Dashboard & analytics dasar (SQL aggregation) — **selesai di backend** (endpoint read-only `/api/v1/analytics`: summary, sales-trend (daily/weekly), top-products, category-breakdown, low-stock-alert-count. Semua angka diagregasi Postgres langsung dari `sales_orders` + `sales_order_items` (+ products/categories), tanpa tabel turunan; hanya order CONFIRMED/SHIPPED yang dihitung sebagai penjualan, tanggal penjualan dari `confirmed_at` dalam `APP_TIMEZONE`. Trend mengisi periode kosong dengan nol lewat `generate_series`. Validasi rentang tanggal (from <= to, maksimal 366 hari, default 30 hari terakhir). Cache Redis untuk summary + sales-trend, TTL `ANALYTICS_CACHE_TTL` (default 5 menit, 0 mematikan cache). Index baru `idx_sales_orders_status_confirmed_at`. Test: unit test service (validasi, default, pembulatan AOV, cache hit/miss) + test SQL ke Postgres asli (di-skip tanpa `TEST_DATABASE_URL`, jalan dalam transaksi yang di-rollback) yang membuktikan order PENDING/CANCELLED tidak ikut terhitung. Dicoba end-to-end: `scripts/e2e.sh` 136/136 dengan `ANALYTICS_CACHE_TTL=0` (angka summary/top/kategori dicek persis) dan 133/133 dengan cache aktif; cache diverifikasi langsung ke Redis: key dengan TTL 299 detik, nilai lama bertahan setelah ada penjualan baru, dan angka baru muncul setelah key dihapus.) Layar Flutter: lihat item "Flutter: Dashboard & Analytics".
- [x] Flutter app: halaman core — **selesai** (scaffold Riverpod + clean architecture per fitur, slice `product`: list + search + pagination + pull-to-refresh, form create/edit, swipe delete; 57 unit/widget test; dicoba di emulator Android `Pixel_9_Pro_XL` terhubung ke backend asli via `10.0.2.2:8080`: list, search, create, 409 SKU duplikat, PATCH, delete, error state + retry)
- [x] Flutter: Category & Inventory — **selesai** (fitur `category` CRUD + search + dialog jelas saat delete ditolak 409; `product` dapat dropdown kategori + label kategori di list/detail; fitur `inventory`: halaman detail produk (stok, status low-stock, catat IN/OUT/ADJUSTMENT, riwayat infinite scroll), 422 stok tidak cukup tampil di bawah field quantity; bottom nav Produk/Kategori/Stok Menipis; 161 unit/widget test; dicoba di emulator Android `Pixel_9_Pro_XL` ke backend asli via `10.0.2.2:8080`: create kategori, create produk + pilih kategori, IN/ADJUSTMENT/OUT, OUT melebihi stok → 422 di field, status berubah ke "Stok menipis", tab Stok Menipis, delete kategori terpakai → dialog 409, delete kategori kosong)
- [x] Flutter: Customer & Sales Order — **selesai** (fitur `customer` CRUD + search nama/email/telepon + dialog jelas saat delete ditolak 409 (masih ada pesanan belum dibatalkan); fitur `sales_order`: list dengan filter status (chip) + pelanggan (picker) + badge warna+ikon per status, form buat pesanan (picker pelanggan & produk dengan search, produk yang sudah ditambah di-disable, validasi jumlah 1–1.000.000, running total), detail pesanan dengan tombol aksi dari state machine (PENDING: Konfirmasi/Batalkan, CONFIRMED: Kirim/Batalkan, SHIPPED/CANCELLED: tanpa aksi), dialog konfirmasi yang menjelaskan efek ke stok, semua tombol disable selama request, 422 stok kurang ditampilkan per item. Test kontrak JSON dari respons API asli + 253 unit/widget test. Dicoba di emulator `Pixel_9_Pro_XL` ke backend asli: buat pelanggan, buat pesanan 2 produk (total Rp 140.000), confirm ditolak 422 per item (stok Kopi tetap 5), batalkan PENDING, confirm → kirim (SHIPPED, tanpa aksi), confirm → batalkan (stok Kopi 2 → 3 via movement IN), filter pesanan per pelanggan, hapus pelanggan dengan pesanan → dialog 409.)
- [x] Flutter: Dashboard & Analytics — **selesai** (fitur `dashboard` sebagai tab home `/`, memakai kelima endpoint `/api/v1/analytics`: kartu ringkasan (pendapatan, pesanan, item terjual, rata-rata per pesanan, semua format Rupiah), pemilih rentang tanggal (chip 7/30/90 hari + date range picker, default 30 hari terakhir sama seperti backend), grafik tren penjualan `fl_chart` dengan toggle harian/mingguan, daftar 10 produk terlaris dengan bar proporsional, donut penjualan per kategori (`category_id: null` tampil sebagai "Tanpa Kategori" abu-abu), dan kartu badge stok menipis yang membuka halaman Stok Menipis. Tab "Stok Menipis" dihapus dari bottom nav (tetap 5 tab: Dashboard, Produk, Kategori, Pelanggan, Pesanan) dan `/low-stock` jadi route full-screen. Satu provider rentang tanggal diikuti empat provider data (granularity provider terpisah supaya toggle harian/mingguan cuma memicu 1 request), tiap section punya loading/error/retry sendiri. Test kontrak JSON kelima endpoint (termasuk `"products": null` saat rentang kosong) + unit test provider + widget test; total 274 test lulus. Dicoba di emulator `Pixel_9_Pro_XL` ke backend asli via `10.0.2.2:8080`: ganti rentang 30→7 hari memicu tepat 4 request dengan rentang baru (low-stock count tidak ikut), toggle Mingguan tepat 1 request, custom range 01–20/09 lewat picker, scroll tidak memicu request ulang, matikan network → semua section menampilkan error+retry sendiri, nyalakan lagi lalu retry hanya section Ringkasan → hanya 1 request dan section lain tetap error.)
- [x] Low-stock detection (threshold-based) — **selesai** (backend `GET /api/v1/inventory/low-stock`, threshold per produk + default `LOW_STOCK_DEFAULT_THRESHOLD`; di Flutter dibuka dari kartu badge di Dashboard, dicoba di emulator)
- [ ] ML service: forecasting sederhana — **belum mulai**
- [ ] AI-generated insight — **belum mulai**
- [ ] Polish untuk demo interview — **belum mulai**

## 7. Open Decisions (belum final, diputuskan nanti)

- State management Flutter: Riverpod vs Bloc — belum dipilih.
- Queue library Go: `asynq` vs Redis Streams manual — belum dipilih.
- Format komunikasi Go ↔ ML service: REST JSON vs gRPC — asumsi REST JSON dulu untuk kesederhanaan, bisa direvisi.
