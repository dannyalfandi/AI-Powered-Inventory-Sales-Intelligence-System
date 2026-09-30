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
| Cache/Queue | Redis + queue (asynq atau Redis Streams) | Untuk job forecasting async dan cache dashboard. |
| Mobile Frontend | **Flutter** | Requirement eksplisit: mobile app, bukan web-only. Kamu sudah pakai Flutter di RAG platform, reuse skill. |
| AI/Data Service | Python: FastAPI + Pandas + Scikit-learn | Terpisah sebagai microservice, dipanggil dari Go backend via REST/gRPC. |
| Infra | Docker, GitHub Actions CI/CD | Standard, mudah didemokan di interview. |

**Arsitektur:**
```
Flutter (mobile) → Go REST API → PostgreSQL
                         ↓
                   Redis (cache/queue)
                         ↓
              Python FastAPI (ML service)
                         ↓
                 Forecasting/Insight
```

## 3. Repo Structure (target)

```
/backend        → Go (Gin, GORM, clean architecture: handler/service/repository)
/mobile         → Flutter app
/ml-service     → Python FastAPI + notebooks untuk eksperimen model
/infra          → docker-compose, github actions workflows
/docs           → ERD, API spec, architecture notes
```

## 4. Coding Conventions

- Go: gunakan struktur layered (handler → service → repository), error wrapping dengan `fmt.Errorf("...: %w", err)`, table-driven tests.
- Flutter: state management bebas dipilih di awal project (Riverpod/Bloc), tapi sekali dipilih, konsisten di seluruh app.
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
