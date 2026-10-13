# CLAUDE.md — AI-Powered Inventory & Sales Intelligence System

Instruksi ini dibaca oleh Claude Code (dan Codex, sebagai agent paralel) setiap kali bekerja di repo ini. Tujuannya: menjaga konsistensi arsitektur, coding style, dan cara kerja lintas sesi/agent.

## 1. Project Overview

**Nama:** Inventory & Sales Intelligence Platform
**Tujuan:** Mini-ERP yang tidak hanya CRUD, tetapi menganalisis data penjualan untuk demand forecasting, deteksi low-stock, dan business insight otomatis.

**Domain flow:**
```
Products → Inventory → Sales Orders → Customers → Sales Data → Analytics Engine → AI/Prediction
```

**Narasi interview (jangan hilang dari scope):**
"Sistem inventory yang menggunakan historical sales data untuk demand forecasting" — bukan sekadar "aplikasi toko online".

## 2. Tech Stack (locked — jangan diubah tanpa alasan kuat)

| Layer | Pilihan | Alasan |
|---|---|---|
| Backend | **Go** (Gin + GORM) | Kamu sudah membangun momentum Go lewat migrasi proyek klien lain (Laravel/Inertia → Go+Gin+GORM). Reuse konvensi yang sama di sini biar cepat dan konsisten. Nest.js jadi opsi B kalau mau all-TypeScript. |
| Database | **PostgreSQL** | Kamu sudah pakai Postgres (+pgvector) di RAG platform portfolio — konsisten, dan Postgres lebih kuat untuk analytical queries dibanding MySQL. |
| Cache | Redis (cache) | Cache agregasi dashboard dan laporan forecast/insight. Forecast dihitung sinkron, jadi tidak ada job queue. |
| Mobile Frontend | **Flutter** | Requirement eksplisit: mobile app, bukan web-only. Kamu sudah pakai Flutter di RAG platform, reuse skill. |
| AI/Data Service | Python: FastAPI + Pandas + Scikit-learn | Terpisah sebagai microservice, dipanggil dari Go backend via REST JSON sinkron. Model forecasting saat ini moving average (Pandas); scikit-learn sudah terpasang di `requirements.txt` untuk model regresi berikutnya, tapi belum dipakai. |
| Infra | Docker, GitHub Actions CI/CD | Standard, mudah didemokan di interview. |

**Arsitektur:**
```
Flutter (mobile)
      │  REST + Bearer JWT + Accept-Language
      ▼
Go REST API (Gin + GORM) ───────────────▶ PostgreSQL (hanya Go yang mengakses)
      │
      ├── cache ────────────────────────▶ Redis (cache saja)
      │
      └── REST JSON sinkron ────────────▶ Python FastAPI (ML service, stateless)
          (history harian di body)           forecast (moving average) + trend insight
```

Go memanggil ML service langsung; Redis hanya cache yang diakses dari Go, bukan perantara Go → Python. Detail: `docs/architecture.md` §2.

## 3. Repo Structure

```
/backend        → Go (Gin, GORM, clean architecture: handler/service/repository)
/mobile         → Flutter app
/ml-service     → Python FastAPI (forecasting + trend insight, stateless)
/infra          → docker-compose (Postgres, Redis, ML service; profile app dan seed)
/docs           → architecture.md, ml-service-contract.md, PRESENTATION.md, screenshots/
/.github/workflows → ci.yml dan e2e.yml (GitHub Actions)
```

## 4. Coding Conventions

- Go: gunakan struktur layered (handler → service → repository), error wrapping dengan `fmt.Errorf("...: %w", err)`, table-driven tests.
- Flutter: state management sudah diputuskan **Riverpod 3 dengan codegen** (`flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`, lihat `mobile/pubspec.yaml`), konsisten di seluruh app. Aturan detailnya di `mobile/CLAUDE.md` §2.
- Python: type hints wajib, Pydantic untuk schema request/response FastAPI.
- Semua service punya `README.md` sendiri dengan cara run lokal.

## 5. Agent Workflow Rules (penting — ini beda dari default)

- **Semua operasi git dilakukan manual oleh Danny.** Agent tidak melakukan `git commit`/`git push`.
- Kalau ada perubahan yang menyentuh file bersama (shared config, docker-compose, root-level schema), **agent menulis instruksi wiring untuk di-paste manual oleh Danny**, bukan langsung mengedit file itu.
- Claude Code dan Codex bisa jalan paralel di repo yang sama — hindari race condition dengan scoping tugas per-folder/per-service secara eksplisit di awal sesi (misal: satu agent fokus `/backend`, satu fokus `/ml-service`).
- Setiap sesi baru: agent membaca ulang bagian ini + `/docs/architecture.md` sebelum mulai kerja.

## 6. Definition of Done per Phase

Setiap fitur dianggap selesai kalau: ada test, ada endpoint terdokumentasi (OpenAPI/Postman), dan bisa didemokan end-to-end dari Flutter app.

## 7. Roadmap Reference

Lihat roadmap detail di percakapan/README utama — ringkasnya: CRUD core → dashboard analytics → forecasting sederhana → AI insight generation → polish untuk demo interview.

## 8. Angka Terukur (2026-10-13)

Sumber kebenaran angka adalah tabel Testing di `README.md` / `README.en.md` dan "Sumber angka" di `docs/PRESENTATION.md`. Kalau angka berubah, ukur ulang lalu perbarui semua tempat itu sekaligus.

- Test: Go 831 lulus dengan `TEST_DATABASE_URL` (0 skip; tanpa DB 804 lulus + 15 skip), Python 80, Flutter 702 → total 1.613.
- e2e (`backend/scripts/e2e.sh`): 317/317 ML hidup, 309/309 ML mati; 314 dengan `E2E_SKIP_CLEANUP=1` (seperti di CI).
- Endpoint: Go 48 (47 di `/api/v1` + `/health`), ML service 3. Izin: 32, role Staff 12. Key ARB: 380 per bahasa.
- Infra: `docker compose` (Postgres + Redis + ML), profile `app` (migrate + API), profile `seed`. CI: `.github/workflows/ci.yml` dan `e2e.yml`.
