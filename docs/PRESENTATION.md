# Narasi Presentasi — Inventory & Sales Intelligence Platform

Panduan bicara untuk interview. Semua angka di sini diukur ulang dari source dan hasil test pada 2026-10-13 (lihat [Sumber angka](#sumber-angka) di bawah). Jangan dibulatkan saat menyampaikan.

---

## 1. Elevator Pitch (±30 detik)

> Saya membangun sistem inventory untuk distributor grosir yang tidak hanya mencatat stok, tapi memakai data penjualan historis untuk memprediksi permintaan dan menjelaskan tren — misalnya "penjualan kopi naik 61,9% dalam 4 minggu terakhir." Stack-nya Go dan Postgres untuk transaksi, Python untuk forecasting, dan Flutter untuk aplikasi mobile, dengan login dan hak akses per role. Buat saya, project ini jembatan dari software engineering ke data science: datanya harus benar dulu — stok tidak boleh salah walau diakses bersamaan, dan hanya orang yang berhak yang bisa mengubahnya — baru analisisnya bisa dipercaya.

---

## 2. Narasi 1–2 Menit

**Masalahnya.** Toko grosir biasanya tahu stoknya hari ini, tapi tidak tahu stok itu cukup untuk berapa lama. Keputusan restock diambil dari feeling. Saya ingin sistem yang menjawab dua pertanyaan: *produk apa yang sedang naik atau turun*, dan *berapa kira-kira yang akan terjual minggu depan*.

**Keputusan arsitektur.** Saya pisahkan dua jenis pekerjaan yang sifatnya berbeda:

- **Transaksi** di Go + PostgreSQL. Go karena typed, cepat, dan konkurensinya eksplisit. Postgres karena analytics-nya bisa dihitung langsung di SQL, termasuk mengisi hari tanpa penjualan dengan `generate_series`, jadi tidak perlu tabel turunan yang bisa basi.
- **Komputasi** di microservice Python, karena ekosistem data science ada di sana. Service ini sengaja *stateless*: tidak menyentuh database dan menerima history penjualan dari Go di setiap request. Go tetap satu-satunya sumber kebenaran, dan service Python bisa di-restart atau diganti modelnya tanpa migrasi.
- **Akses** juga dipegang Go: login JWT dengan refresh token yang dirotasi, dan izin per resource-action yang dicek ke database di setiap request.

**Tantangan teknis yang saya selesaikan.**

1. **Race condition di stok.** Dua kasir bisa meng-confirm order untuk produk yang sama di detik yang sama. Setiap perubahan stok berjalan dalam satu transaksi dengan `SELECT … FOR UPDATE`. Row inventory di-lock urut `product_id` supaya dua order tidak saling deadlock, dan ada `CHECK quantity >= 0` di database sebagai jaring terakhir. Ini saya buktikan dengan test paralel sungguhan ke API: 5 order berebut stok yang cukup untuk 3, dan hasilnya tepat 3 sukses. 1 order di-confirm 10 kali bersamaan, dan stok berkurang sekali.
2. **Graceful degradation.** ML service bisa mati kapan saja. Kalau satu produk gagal di-forecast, hanya produk itu yang membawa error. Kalau service-nya mati total, API tetap menjawab 200 dengan `forecast_available: false`, dan aplikasi menampilkan state abu-abu yang tenang, bukan error merah, karena itu memang bukan bug. Laporan yang tidak lengkap juga sengaja tidak di-cache, supaya dashboard langsung pulih begitu service hidup lagi.
3. **Dua bahasa end-to-end.** Termasuk pesan error dan kalimat insight dari Python. Bahasa dibawa lewat request context di Go, jadi tidak ada signature fungsi yang berubah. Kode error, nama field, dan enum sengaja tidak diterjemahkan supaya klien tetap bisa mencocokkannya.
4. **Hak akses yang tidak bisa dipakai untuk naik pangkat.** Role bisa dibuat bebas dari app, jadi saya harus memastikan izin "kelola pengguna" tidak bisa dipakai untuk mendapatkan izin yang lebih besar. Ceritanya di [§3](#3-keputusan-desain-auth--rbac).

**Hasilnya.** Ada 48 endpoint di Go API dan 3 di ML service, 1.613 test otomatis yang lulus (831 Go termasuk test SQL ke Postgres asli, 80 Python, 702 Flutter), dan 317 dari 317 skenario end-to-end ke API asli dengan ML service hidup (309 dari 309 saat ML service mati). Di dalamnya ada skenario konkurensi, 13 skenario perbandingan bahasa, dan skenario eskalasi hak akses yang harus ditolak.

---

## 3. Keputusan Desain: Auth & RBAC

**"Kenapa JWT + refresh token, bukan session?"**
Klien utamanya aplikasi mobile, bukan browser, jadi tidak ada cookie yang bisa diandalkan. Access token JWT berumur pendek (15 menit) hanya dicek tanda tangan dan masa berlakunya. Refresh token (7 hari) disimpan di server sebagai hash SHA-256, jadi kebocoran database tidak membocorkan token yang bisa dipakai. Refresh token dirotasi setiap kali dipakai, di dalam satu transaksi dengan row lock. Kalau token yang sudah dirotasi dipakai lagi, berarti ada dua pihak yang memegangnya, jadi semua sesi user itu dicabut, dengan jawaban 401 yang identik dengan refresh gagal biasa. Satu hal penting: JWT di sini hanya menjawab *siapa*. Izinnya tidak saya taruh di token, jadi menonaktifkan user atau mencabut izin langsung berlaku di request berikutnya, tidak menunggu token kedaluwarsa.

**"Kenapa izin per resource-action?"**
Setiap route memetakan ke tepat satu kunci `<resource>.<action>`, misalnya `products.delete` atau `sales_orders.confirm`. Totalnya 32 kunci. Katalognya tetap di kode, karena sebuah kunci hanya bermakna kalau ada route yang mengeceknya. Ada test router yang gagal kalau ada route baru tanpa keputusan izin, jadi tidak mungkin menambah endpoint lalu lupa menjaganya. Satu route sengaja tidak satu-ke-satu: `PATCH /sales-orders/:id/status` memilih izin dari body (confirm, ship, atau cancel), karena "boleh confirm" (mengambil stok) tidak sama dengan "boleh cancel".

**"Kenapa role-nya dinamis?"**
Setiap toko membagi pekerjaan dengan cara berbeda: ada yang punya staf gudang, ada yang kasirnya juga mengurus pelanggan. Jadi role adalah data: Super Admin membuat role dan mencentang izinnya dari app. Yang tetap hanya dua role bawaan: **Super Admin** (role sistem, lolos semua cek, tidak bisa dihapus atau diganti nama) dan **Staff** (12 izin). Satu user satu role adalah penyederhanaan yang saya pilih dengan sadar; multi-role akan mengubah `role_id` jadi tabel relasi, tapi katalog dan middleware-nya tetap.

**"Kenapa izin dicek ke database di setiap request, bukan di-cache?"**
Satu query per request lewat primary key dan unique index itu murah. Dengan begitu, perubahan izin dan penonaktifan akun berlaku seketika. e2e membuktikannya: izin sebuah role diganti saat user-nya sedang login, dan token yang sama langsung mendapat akses baru serta kehilangan akses lama.

**Cerita: guard anti privilege escalation (`backend/internal/service/grant_scope.go`)**

- **Konteksnya.** Setelah layar kelola pengguna jadi, ada kebutuhan agar "user manager", yaitu orang yang boleh membuat dan mengubah pengguna tapi bukan Super Admin, bisa memilih role di form pengguna. Untuk itu daftar role (`GET /roles`) perlu dibuka untuk pemegang `users.create`/`users.update`.
- **Bagaimana celahnya ditemukan.** Sebelum membuka akses itu, saya menguji dulu di layer service apakah backend sudah mencegah user manager memberi hak yang lebih besar dari miliknya. Ternyata belum. Penjagaan yang ada hanya dua: role Super Admin hanya boleh diberikan oleh Super Admin, dan tidak ada yang boleh mengganti role akunnya sendiri. Uji itu menunjukkan user manager **bisa** membuat akun baru dengan role custom yang lebih kuat, atau memberi role itu ke orang lain. Celah yang lebih halus: ia juga bisa **me-reset password** akun yang role-nya lebih kuat, lalu login sebagai akun itu. Larangan "ganti role sendiri" jadi tidak berarti, karena ia cukup membuat atau mengambil alih akun lain.
- **Kenapa saya berhenti dulu.** Membuka daftar role justru akan membuat celah ini lebih mudah dipakai, jadi saya tidak menambalnya diam-diam. Aturan apa yang benar adalah keputusan desain, jadi saya laporkan dulu sebelum lanjut.
- **Bagaimana ditutup.** Aturannya satu: **non-Super-Admin hanya bisa memberi atau menyentuh apa yang seluruh izinnya ia pegang sendiri.** Definisi "subset izin" ada di satu tempat (`grantScope`): Super Admin mencakup semua izin, selain itu tepat izin role-nya saat request itu. Definisi yang sama dipakai di tiga tempat:
  - saat memberi izin ke role (`SetPermissions`, sudah ada sebelumnya, sekarang memakai helper yang sama);
  - saat memberi role ke user (create user dan ganti `role_id`);
  - saat mengubah apa pun pada user (termasuk password dan status aktif) atau menghapusnya, dicek terhadap role user itu saat ini. Bagian ini yang menutup skenario reset password.
  Mengedit akun sendiri tidak dibatasi aturan ini, karena role kita sendiri adalah batas kita; aturan "tidak bisa mengganti role sendiri" tetap berlaku.
- **Buktinya.** `TestUserService_PrivilegeMatrix` adalah matriks 60 kasus: Super Admin, user manager yang izinnya cukup, dan user manager yang hanya punya `users.*`, terhadap 4 role target, untuk 5 aksi (create, beri role, reset password, nonaktifkan, hapus). Setiap penolakan juga harus tidak menyimpan apa pun dan tidak mencabut sesi siapa pun. `scripts/e2e.sh` mengulang skenarionya ke API asli, termasuk memastikan password yang dicoba "dibajak" tidak bisa dipakai login. Siapa pun bisa mengeceknya: matikan salah satu bagian guard, dan sel matriks yang relevan langsung gagal.
- **Efek sampingnya, yang perlu dijelaskan saat demo.** User manager yang hanya punya `users.*` tidak bisa membuat user Staff, karena Staff punya izin pesanan dan analytics yang tidak ia pegang. User manager harus diberi izin yang mencakup role yang akan ia bagikan.

**"Kenapa jumlah user per role menghitung user yang sudah dihapus?"**
User yang dihapus (soft delete) tetap menyimpan `role_id` sebagai histori, dan foreign key-nya `ON DELETE RESTRICT`, jadi database menolak menghapus role selama baris seperti itu ada. Kalau angka di layar hanya menghitung user aktif, UI bisa menampilkan 0 tapi hapusnya tetap ditolak 409. Jadi `user_count` saya definisikan sama dengan aturan 409: semua baris user yang menunjuk role itu. Angka ini dihitung dalam query yang sama dengan daftar role, bukan satu query per role, dan app memakainya langsung: daftar role cukup satu request, dan swipe hapus hanya ditawarkan untuk role dengan `user_count` 0.

**"Bagaimana UI dan hak akses dijaga supaya tidak berbeda?"**
App punya satu tabel, `HomeTab` di `mobile/lib/core/router/home_tabs.dart`, yang memetakan setiap tab ke izin `*.view` yang dituntut endpoint-nya di backend. Tabel yang sama dipakai bottom bar (tab mana yang ditampilkan) dan guard route (ke mana deep link boleh pergi). Karena keduanya membaca satu sumber, tidak mungkin ada tab yang tampil tapi rutenya ditolak, atau sebaliknya. Section Dashboard juga mengikuti izinnya masing-masing, dan section yang tidak diizinkan tidak di-subscribe sama sekali, jadi tidak ada request yang pasti ditolak. Test widget membuktikannya dengan `verifyNever` pada endpoint yang tidak boleh dipanggil.

**"Kalau Super Admin mengubah izin, kapan app tahu?"**
Izin dibaca dari `GET /auth/me`. Supaya perubahan sampai tanpa login ulang, app membacanya lagi pada dua kesempatan. Pertama, saat app kembali ke foreground (`AppLifecycleState.resumed`), dengan throttle 60 detik supaya bolak-balik antar-app tidak membanjiri server. Kedua, setelah endpoint bisnis menjawab 403. Jalur 403 di-debounce supaya banyak 403 sekaligus (beberapa section gagal bersamaan) hanya menjadi satu panggilan, dan sengaja **tidak** ikut throttle 60 detik: 403 adalah bukti langsung bahwa izin berubah, jadi menunggu satu menit hanya membuat UI salah lebih lama. Panggilan `/auth/me` lewat client HTTP yang sama dengan request lain, jadi access token yang kedaluwarsa tetap diperbarui oleh refresher single-flight yang sudah ada, dan tidak ada jalur kedua yang bisa memicu refresh ganda. Kalau gagal karena offline atau error server, state dipertahankan. Kalau 401, sesi berakhir lewat alur yang sudah ada. Jam yang dipakai throttle bisa diinjeksi, jadi test-nya tidak perlu menunggu satu menit.

**Cerita debugging: dua bug navigasi yang muncul saat menulis test untuk fitur ini**

- **"Duplicate GlobalKey" setiap kali tab diketuk.** Test baru yang mengetuk tab langsung gagal. Ternyata bug lama: shell navigasi (yang punya GlobalKey) dibungkus `AnimatedSwitcher` untuk efek fade, jadi selama transisi widget yang sama ada di dua tempat. Sebelumnya belum ada test yang mengetuk tab, jadi tidak ketahuan. Fade-nya saya pindahkan ke container cabang navigasi milik go_router, sehingga tidak ada widget yang dipindah-pindah. Penjelasannya ada di `mobile/lib/core/router/home_shell.dart`, dan test di `home_tabs_test.dart` mengetuk tab secara nyata.
- **Guard route membaca user lama.** Test "izin dicabut saat app di background" menunjukkan state auth sudah berubah, tapi router tetap di tab yang tidak lagi diizinkan. Penyebabnya: saat router diberi tahu ada perubahan auth, guard membaca provider user turunan yang belum dihitung ulang. Guard sekarang membaca nilai yang sama dengan yang baru diterima router (komentar di `currentUser()` pada `app_router.dart`). Test `InventoryApp` di `permission_refresh_test.dart` gagal kalau perbaikan itu dikembalikan.

---

## 4. Pertanyaan yang Mungkin Muncul

**"Kenapa moving average, bukan model ML yang lebih canggih?"**
Datanya kecil: 75 hari history, 26 produk. Di volume segitu, model kompleks gampang overfit dan susah dijelaskan ke pemilik toko. Moving average cepat, deterministik, dan mudah diaudit. Arsitekturnya sudah saya siapkan untuk upgrade: ada `Forecaster` protocol dan registry, jadi regresi atau model lain cukup jadi satu class baru plus satu entry registry. Kontrak API-nya tidak berubah, hanya field `method` di response.

**"Bagaimana kamu memastikan tidak ada race condition di stok?"**
Ada tiga lapis. (1) Row lock `FOR UPDATE` dalam satu transaksi untuk setiap mutasi stok. (2) Urutan lock yang konsisten (`product_id` ascending) untuk mencegah deadlock antar-order. (3) `CHECK` constraint di DB. Tapi yang penting buktinya: `e2e.sh` menjalankan request yang benar-benar paralel ke API asli. Unit test dengan mock tidak bisa membuktikan ini, jadi saya mengujinya ke Postgres sungguhan.

**"Bagaimana dengan race condition di hak akses?"**
Aturan "minimal satu Super Admin aktif" bisa dilanggar kalau dua Super Admin saling menurunkan role di saat yang sama, karena masing-masing request sah sendirian. Saya mengunci semua baris Super Admin sebelum menghitung. Integration test ke Postgres membuktikannya secara deterministik: request kedua harus menunggu lock, lalu melihat hanya satu Super Admin, lalu ditolak.

**"Kenapa ML service dipisah, bukan langsung di Go?"**
Ada dua alasan. Ekosistem data (pandas, scikit-learn) ada di Python. Dan secara concern, transaksi dan komputasi punya karakter berbeda: yang satu harus konsisten, yang lain boleh gagal. Pemisahan ini justru yang memungkinkan graceful degradation: kalau forecasting bermasalah, pencatatan stok dan order tidak ikut jatuh.

**"Kenapa komunikasinya REST sinkron, bukan queue atau gRPC?"**
Forecast dihitung on-demand saat dashboard dibuka. Jumlah produknya dibatasi (top-N), dipanggil paralel maksimal 8 sekaligus, dengan timeout 5 detik, dan hasil lengkapnya di-cache 10 menit. Queue akan menambah kompleksitas (worker, status job, polling) untuk masalah yang belum ada. Kalau jumlah produk per request membesar, langkah berikutnya yang sudah saya catat adalah endpoint batch di ML service, bukan gRPC.

**"Kenapa analytics tidak pakai tabel agregat?"**
Tabel turunan harus disinkronkan, dan bisa basi. Semua angka dashboard dihitung Postgres dari tabel order saat request, dibantu satu index `(status, confirmed_at)`, dan query yang sering dipanggil di-cache di Redis. Aturan "hanya CONFIRMED/SHIPPED yang dihitung" hidup di SQL, jadi saya menulis test yang jalan ke Postgres asli di dalam transaksi yang di-rollback. Mock tidak bisa membuktikan query-nya benar.

**"Kenapa tidak bisa mengedit item order setelah dibuat?"**
Supaya jejak stok selalu konsisten. Item order yang sudah di-confirm harus sama persis dengan yang keluar dari gudang. Kalau salah, order dibatalkan (stok otomatis dikembalikan lewat movement IN) lalu dibuat ulang. Harga juga di-snapshot saat order dibuat, jadi perubahan harga produk nanti tidak menulis ulang histori penjualan.

**"Bagaimana i18n di-test supaya tidak ada terjemahan yang hilang?"**
Ada test di Go dan Python yang memastikan setiap key ada di kedua bahasa dengan jumlah placeholder yang sama. Di Flutter, widget test mengecek *key ARB mana* yang muncul, bukan kalimatnya, dan helper pesan error dijalankan di kedua locale. Proses ini juga menemukan bug nyata: tiga regex di app yang mencocokkan kalimat error berbahasa Inggris diam-diam berhenti bekerja begitu server menjawab dalam Bahasa Indonesia. Solusinya, app berhenti mem-parse kalimat sama sekali.

**"Data demonya dari mana?"**
Dari seeder yang membuat order lewat service layer yang sama dengan API (jadi state machine dan stock movement-nya asli), lalu memundurkan tanggalnya 75 hari. Datanya diberi ritme mingguan (Senin/Jumat ramai, Minggu sepi) dan tren per produk, supaya forecast dan insight punya sesuatu yang layak dianalisis. Seeder-nya deterministik: seed PRNG yang sama selalu menghasilkan data yang sama. Seeder yang sama membuat akun demo Super Admin dan Staff.

---

## 5. Keterbatasan yang Disadari

Moving average memproyeksikan angka datar. Ia tidak menangkap musiman, bahkan ritme mingguan yang ada di data demo sendiri (Senin/Jumat ramai) ikut rata di hasil forecast. Langkah wajar berikutnya adalah model yang sadar hari-dalam-minggu, yang bisa dipasang lewat registry tanpa mengubah API. Insight bisnis masih berupa perbandingan statistik dua periode dengan template kalimat, belum LLM. Cache dashboard sengaja tidak di-invalidate saat ada order baru, jadi ringkasan bisa tertinggal sampai 5 menit dari transaksi terakhir. Itu trade-off yang saya pilih demi kesederhanaan, tapi perlu dikomunikasikan ke user. Forecasting memanggil ML service satu kali per produk; itu aman untuk top-10, tapi tidak untuk ribuan produk tanpa endpoint batch.

Di sisi hak akses: tab dan section Dashboard sudah mengikuti izin, tapi beberapa bagian di dalam layar yang membaca resource lain belum. Picker pelanggan dan produk di form pesanan, dropdown kategori di form produk, serta stok dan riwayat di detail produk akan menampilkan pesan 403 dari server untuk role yang tidak punya izin view resource itu. Datanya tetap aman. Perubahan izin juga baru terlihat saat app kembali ke foreground atau setelah ada 403, bukan seketika, karena server tidak mengirim notifikasi. Belum ada endpoint ganti password sendiri, dan refresh token yang kedaluwarsa belum dibersihkan berkala.

Dari sisi produksi: seluruh stack (Postgres, Redis, ML service, Go API) sudah bisa dinyalakan dengan `docker compose --profile app up --build`, dan GitHub Actions menjalankan test semua service serta e2e ke stack itu. Yang belum: datanya masih sintetis, dan run e2e di CI melewati langkah cleanup (stack-nya dibuang setelah run), jadi CI menghitung 314 check, bukan 317. Semua ini sudah saya ketahui dan urutkan, bukan hal yang terlewat.

---

## Sumber angka

Semua diukur 2026-10-13. Postgres, Redis, ML service, dan API dari `docker compose --profile app` (API di port 8090), data dari `--profile seed`.

| Angka | Cara mengukur |
|---|---|
| 48 endpoint Go (47 di `/api/v1` + `/health`) | route di `backend/internal/router/router.go`; `TestEveryRouteHasAnAccessDecision` mengunci jumlahnya |
| 3 endpoint ML service | `ml-service/app/main.py` |
| 32 izin, Staff 12 izin | `backend/internal/auth/permissions.go`, `backend/cmd/seed/accounts.go` |
| 831 test Go lulus, 0 gagal, 0 skip (115 fungsi test + subtest) | `TEST_DATABASE_URL=… go test ./... -count=1 -v`, dihitung dari baris `--- PASS/FAIL/SKIP` seperti di CI; tanpa `TEST_DATABASE_URL`: 804 lulus, 15 test SQL di-skip |
| 80 test Python | `pytest` |
| 702 test Flutter | `flutter test` (tanpa emulator) |
| 1.613 test otomatis | 831 + 80 + 702 |
| 317/317 e2e (ML hidup), 309/309 (ML mati), 13 skenario id-vs-en (ML hidup) | `backend/scripts/e2e.sh` ke API di port 8090, dengan cleanup; dengan `E2E_SKIP_CLEANUP=1` (seperti di CI) 314/314 |
| 60 kasus matriks eskalasi | `TestUserService_PrivilegeMatrix` di `backend/internal/service/user_scope_test.go` |
| 5 order → tepat 3 sukses, confirm 10× → stok berkurang sekali | `backend/scripts/e2e.sh` |
| 61,9% (Kopi Bubuk Robusta, data seed) | contoh response `/analytics/insights` di `backend/README.md` |
| 75 hari, 26 produk, 425 order (~430), 380 key ARB | `backend/cmd/seed/` + hitungan di database hasil seed (order milik 10 pelanggan seed saja); `mobile/lib/l10n/app_en.arb` dan `app_id.arb`. Jumlah order bergeser sedikit menurut tanggal seed dijalankan, karena history dihitung mundur dari hari ini |
