// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Inventory Intelligence';

  @override
  String get commonRetry => 'Coba lagi';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonBack => 'Kembali';

  @override
  String get commonUnderstood => 'Mengerti';

  @override
  String get commonLoadMore => 'Muat lebih banyak';

  @override
  String get commonNoResults => 'Tidak ada hasil.';

  @override
  String get commonLoading => 'Memuat…';

  @override
  String get commonUnexpectedError => 'Terjadi kesalahan tak terduga.';

  @override
  String commonLoadFailed(String message) {
    return 'Gagal memuat: $message';
  }

  @override
  String get commonSaveChanges => 'Simpan perubahan';

  @override
  String get commonClearSearch => 'Hapus pencarian';

  @override
  String get commonValidationFailed => 'Perbaiki isian yang ditandai.';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navProducts => 'Produk';

  @override
  String get navCategories => 'Kategori';

  @override
  String get navCustomers => 'Pelanggan';

  @override
  String get navOrders => 'Pesanan';

  @override
  String get networkTimeout => 'Server tidak merespons. Coba lagi.';

  @override
  String get networkCancelled => 'Permintaan dibatalkan.';

  @override
  String get networkUnreachable =>
      'Tidak dapat terhubung ke server. Periksa koneksi atau API_BASE_URL.';

  @override
  String networkServerError(String status) {
    return 'Server error (HTTP $status)';
  }

  @override
  String get networkServerErrorUnknown => 'Server error';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsLanguageSection => 'Bahasa';

  @override
  String get settingsLanguageSubtitle =>
      'Berlaku untuk tampilan app dan pesan dari server.';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageIndonesian => 'Bahasa Indonesia';

  @override
  String get settingsAboutSection => 'Tentang';

  @override
  String get settingsCurrencyNote =>
      'Nominal tetap dalam Rupiah (Rp) di kedua bahasa.';

  @override
  String get productsTitle => 'Produk';

  @override
  String get productsSearchHint => 'Cari nama atau SKU';

  @override
  String get productsEmpty => 'Belum ada produk.';

  @override
  String productsEmptyForSearch(String query) {
    return 'Tidak ada produk yang cocok dengan \"$query\".';
  }

  @override
  String get productsAdd => 'Tambah produk';

  @override
  String productsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produk',
    );
    return '$_temp0';
  }

  @override
  String get productsEmptyHint =>
      'Belum ada produk.\nTambahkan produk pertama.';

  @override
  String get productSkuHint => 'contoh: KOPI-001';

  @override
  String get productFieldDescriptionOptional => 'Deskripsi (opsional)';

  @override
  String get productCreated => 'Produk ditambahkan';

  @override
  String get productUpdated => 'Produk diperbarui';

  @override
  String productDeleted(String name) {
    return '$name dihapus';
  }

  @override
  String get productCategoryLoadFailed => 'Gagal memuat daftar kategori';

  @override
  String get productCategoryReload => 'Muat ulang kategori';

  @override
  String productCategoryFallback(String id) {
    return 'Kategori #$id';
  }

  @override
  String get productNew => 'Produk baru';

  @override
  String get productEdit => 'Ubah produk';

  @override
  String get productFieldSku => 'SKU';

  @override
  String get productFieldName => 'Nama';

  @override
  String get productFieldPrice => 'Harga (Rp)';

  @override
  String get productFieldCategory => 'Kategori';

  @override
  String get productNoCategory => 'Tanpa Kategori';

  @override
  String get productDeleteConfirmTitle => 'Hapus produk?';

  @override
  String productDeleteConfirmBody(String name, String sku) {
    return '\"$name\" ($sku) akan dihapus dari daftar.';
  }

  @override
  String productDeleteFailed(String message) {
    return 'Gagal menghapus produk: $message';
  }

  @override
  String productSaveFailed(String message) {
    return 'Gagal menyimpan produk: $message';
  }

  @override
  String get productSkuTaken => 'SKU sudah dipakai produk lain';

  @override
  String get productStockTitle => 'Detail produk';

  @override
  String get productStockLow => 'Stok menipis';

  @override
  String get productStockRecordMovement => 'Catat pergerakan';

  @override
  String get productStockHistory => 'Riwayat pergerakan';

  @override
  String get validationSkuRequired => 'SKU wajib diisi';

  @override
  String validationSkuTooLong(int max) {
    return 'SKU maksimal $max karakter';
  }

  @override
  String get validationNameRequired => 'Nama wajib diisi';

  @override
  String validationNameTooLong(int max) {
    return 'Nama maksimal $max karakter';
  }

  @override
  String validationDescriptionTooLong(int max) {
    return 'Deskripsi maksimal $max karakter';
  }

  @override
  String get validationPriceRequired => 'Harga wajib diisi';

  @override
  String get validationPriceInvalid => 'Harga harus berupa bilangan bulat';

  @override
  String get validationPriceNegative => 'Harga tidak boleh negatif';

  @override
  String get validationPriceTooLarge => 'Harga terlalu besar';

  @override
  String get validationEmailInvalid => 'Format email tidak valid';

  @override
  String validationEmailTooLong(int max) {
    return 'Email maksimal $max karakter';
  }

  @override
  String validationPhoneInvalid(int max) {
    return 'Nomor telepon 6–$max digit (boleh +, spasi, tanda hubung, kurung)';
  }

  @override
  String validationAddressTooLong(int max) {
    return 'Alamat maksimal $max karakter';
  }

  @override
  String get validationQuantityRequired => 'Jumlah wajib diisi';

  @override
  String get validationQuantityInvalid => 'Jumlah harus berupa bilangan bulat';

  @override
  String get validationQuantityPositive => 'Jumlah harus lebih dari 0';

  @override
  String get validationQuantityNegative => 'Jumlah tidak boleh negatif';

  @override
  String validationQuantityTooLarge(int max) {
    return 'Jumlah maksimal $max';
  }

  @override
  String validationReasonTooLong(int max) {
    return 'Alasan maksimal $max karakter';
  }

  @override
  String get validationThresholdRequired => 'Batas wajib diisi';

  @override
  String get validationThresholdInvalid => 'Batas harus berupa bilangan bulat';

  @override
  String get validationThresholdNegative => 'Batas tidak boleh negatif';

  @override
  String get validationCustomerRequired => 'Pilih pelanggan dulu';

  @override
  String get validationItemsRequired => 'Tambahkan minimal satu produk';

  @override
  String get validationOrderTransition =>
      'Pesanan ini tidak bisa dipindahkan ke status tersebut.';

  @override
  String get validationCategoryInvalid => 'Pilih kategori yang valid';

  @override
  String validationItemsTooMany(int max) {
    return 'Maksimal $max produk per pesanan';
  }

  @override
  String validationItemsDuplicate(int line) {
    return 'Produk ini sudah ada di baris $line; gabungkan jumlahnya';
  }

  @override
  String get categoriesTitle => 'Kategori';

  @override
  String get categoriesSearchHint => 'Cari kategori';

  @override
  String categoriesEmptyForSearch(String query) {
    return 'Tidak ada kategori yang cocok dengan \"$query\".';
  }

  @override
  String get categoriesAdd => 'Tambah kategori';

  @override
  String categoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kategori',
    );
    return '$_temp0';
  }

  @override
  String get categoriesEmptyHint =>
      'Belum ada kategori.\nTambahkan kategori pertama.';

  @override
  String get categoryNameHint => 'contoh: Minuman';

  @override
  String get categoryFieldDescriptionOptional => 'Deskripsi (opsional)';

  @override
  String get categoryCreated => 'Kategori ditambahkan';

  @override
  String get categoryUpdated => 'Kategori diperbarui';

  @override
  String categoryDeleted(String name) {
    return 'Kategori $name dihapus';
  }

  @override
  String get categoryNew => 'Kategori baru';

  @override
  String get categoryEdit => 'Ubah kategori';

  @override
  String get categoryFieldName => 'Nama';

  @override
  String get categoryDeleteConfirmTitle => 'Hapus kategori?';

  @override
  String categoryDeleteConfirmBody(String name) {
    return '\"$name\" akan dihapus. Produk tetap ada, tapi kehilangan kategori ini.';
  }

  @override
  String get categoryDeleteBlockedTitle => 'Kategori masih dipakai';

  @override
  String categoryDeleteBlockedBody(String name, String reason) {
    return '\"$name\" tidak bisa dihapus selama masih dipakai produk: $reason Pindahkan produk tersebut ke kategori lain (atau hapus produknya) dulu, lalu coba lagi.';
  }

  @override
  String categoryDeleteFailed(String message) {
    return 'Gagal menghapus kategori: $message';
  }

  @override
  String categorySaveFailed(String message) {
    return 'Gagal menyimpan kategori: $message';
  }

  @override
  String get categoryNameTaken => 'Nama kategori sudah dipakai';

  @override
  String get customersTitle => 'Pelanggan';

  @override
  String get customersSearchHint => 'Cari nama, email, atau telepon';

  @override
  String customersEmptyForSearch(String query) {
    return 'Tidak ada pelanggan yang cocok dengan \"$query\".';
  }

  @override
  String get customersAdd => 'Tambah pelanggan';

  @override
  String customersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pelanggan',
    );
    return '$_temp0';
  }

  @override
  String get customersEmptyHint =>
      'Belum ada pelanggan.\nTambahkan pelanggan pertama.';

  @override
  String get customersPickerEmpty =>
      'Pelanggan tidak ditemukan.\nTambahkan dulu di tab Pelanggan.';

  @override
  String get customerFieldEmailOptional => 'Email (opsional)';

  @override
  String get customerFieldPhoneOptional => 'Telepon (opsional)';

  @override
  String get customerFieldAddressOptional => 'Alamat (opsional)';

  @override
  String get customerPhoneHint => '+62 812-3456-7890';

  @override
  String get customerNoContact => 'Tanpa kontak';

  @override
  String get customerCreated => 'Pelanggan ditambahkan';

  @override
  String get customerUpdated => 'Pelanggan diperbarui';

  @override
  String customerDeleted(String name) {
    return 'Pelanggan $name dihapus';
  }

  @override
  String get customerNew => 'Pelanggan baru';

  @override
  String get customerEdit => 'Ubah pelanggan';

  @override
  String get customerFieldName => 'Nama';

  @override
  String get customerDeleteConfirmTitle => 'Hapus pelanggan?';

  @override
  String customerDeleteConfirmBody(String name) {
    return '\"$name\" akan dihapus dari daftar.';
  }

  @override
  String get customerDeleteBlockedTitle => 'Pelanggan masih punya pesanan';

  @override
  String customerDeleteBlockedBody(String name, String reason) {
    return '\"$name\" masih punya pesanan yang belum dibatalkan: $reason Pelanggan dengan riwayat pesanan tidak bisa dihapus; batalkan dulu pesanan yang masih menunggu atau dikonfirmasi bila memang tidak jadi.';
  }

  @override
  String customerDeleteFailed(String message) {
    return 'Gagal menghapus pelanggan: $message';
  }

  @override
  String customerSaveFailed(String message) {
    return 'Gagal menyimpan pelanggan: $message';
  }

  @override
  String get customerEmailTaken => 'Email sudah dipakai pelanggan lain';

  @override
  String get customerPick => 'Pilih pelanggan';

  @override
  String get inventoryLowStockTitle => 'Stok Menipis';

  @override
  String get inventoryLowStockAllGood =>
      'Semua stok aman.\nTidak ada produk di bawah batas stok menipis.';

  @override
  String inventoryRestockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produk perlu restock',
    );
    return '$_temp0';
  }

  @override
  String get inventoryOutOfStock => 'Habis';

  @override
  String get inventoryHealthy => 'Aman';

  @override
  String get inventoryCurrentStock => 'Stok saat ini';

  @override
  String inventoryThresholdLine(int value) {
    return 'Batas stok menipis: $value';
  }

  @override
  String inventoryMovementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pergerakan',
    );
    return '$_temp0';
  }

  @override
  String get inventoryHistoryEmptyHint =>
      'Belum ada pergerakan stok.\nCatat stok masuk pertama.';

  @override
  String get inventoryEditProduct => 'Ubah produk';

  @override
  String get movementLabelIn => 'Masuk';

  @override
  String get movementLabelOut => 'Keluar';

  @override
  String get movementLabelAdjustment => 'Penyesuaian';

  @override
  String movementRecorded(String type, int before, int after) {
    return '$type dicatat: stok $before → $after';
  }

  @override
  String get movementQuantityIn => 'Jumlah masuk';

  @override
  String get movementQuantityOut => 'Jumlah keluar';

  @override
  String get movementQuantityAdjustment => 'Stok baru (hasil hitung fisik)';

  @override
  String movementCurrentStock(int value) {
    return 'Stok saat ini: $value';
  }

  @override
  String get movementFieldReasonOptional => 'Keterangan (opsional)';

  @override
  String get movementReasonHint =>
      'contoh: restock supplier, barang rusak, stock opname';

  @override
  String inventoryRemaining(int count) {
    return 'Sisa $count';
  }

  @override
  String inventoryThresholdShort(int value) {
    return 'batas $value';
  }

  @override
  String get movementFormTitle => 'Catat pergerakan stok';

  @override
  String get movementFieldQuantity => 'Jumlah';

  @override
  String get ordersTitle => 'Pesanan';

  @override
  String get ordersEmptyForFilter =>
      'Tidak ada pesanan yang cocok dengan filter ini.';

  @override
  String ordersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pesanan',
    );
    return '$_temp0';
  }

  @override
  String get ordersEmptyHint => 'Belum ada pesanan.\nBuat pesanan pertama.';

  @override
  String get ordersFilterCustomerPick => 'Filter pelanggan';

  @override
  String orderCustomerFallback(String id) {
    return 'Pelanggan #$id';
  }

  @override
  String orderStatusChanged(String number, String status) {
    return 'Pesanan $number kini $status';
  }

  @override
  String orderNoMoreActions(String status) {
    return 'Pesanan $status — tidak ada aksi lagi.';
  }

  @override
  String get orderStatusBlockedTitle => 'Status tidak bisa diubah';

  @override
  String get orderConfirmBlockedTitle => 'Pesanan tidak bisa dikonfirmasi';

  @override
  String orderDetailItemsHeading(int count) {
    return 'Produk ($count)';
  }

  @override
  String get orderDetailPriceNote =>
      'Harga adalah snapshot saat pesanan dibuat. Item tidak bisa diubah; batalkan dan buat pesanan baru bila salah.';

  @override
  String orderDialogItemsAffected(String items) {
    return 'Produk yang terpengaruh:\n$items';
  }

  @override
  String orderCreated(String number) {
    return 'Pesanan $number dibuat (menunggu konfirmasi)';
  }

  @override
  String orderFormAlreadyAdded(String name) {
    return '$name sudah ada di pesanan; ubah jumlahnya saja.';
  }

  @override
  String orderFormItemsHeading(int count) {
    return 'Produk ($count)';
  }

  @override
  String get orderFormTotalCurrent => 'Total (harga saat ini)';

  @override
  String orderFormSubtotal(String amount) {
    return 'Subtotal $amount';
  }

  @override
  String get orderFormRemoveProduct => 'Hapus produk';

  @override
  String get ordersFilterStatusAll => 'Semua';

  @override
  String get ordersFilterCustomerClear => 'Semua pelanggan';

  @override
  String get orderStatusPending => 'Menunggu';

  @override
  String get orderStatusConfirmed => 'Dikonfirmasi';

  @override
  String get orderStatusShipped => 'Dikirim';

  @override
  String get orderStatusCancelled => 'Dibatalkan';

  @override
  String get orderActionConfirm => 'Konfirmasi';

  @override
  String get orderActionShip => 'Kirim';

  @override
  String get orderActionCancel => 'Batalkan';

  @override
  String get orderActionMarkPending => 'Tandai menunggu';

  @override
  String get orderDetailTitle => 'Detail pesanan';

  @override
  String get orderDetailTotal => 'Total';

  @override
  String get orderDetailNotes => 'Catatan';

  @override
  String get orderDetailCustomer => 'Pelanggan';

  @override
  String get orderDetailCreatedAt => 'Dibuat';

  @override
  String get orderDetailConfirmedAt => 'Dikonfirmasi';

  @override
  String get orderDetailShippedAt => 'Dikirim';

  @override
  String get orderDetailCancelledAt => 'Dibatalkan';

  @override
  String orderItemLine(int quantity, String price) {
    return '$quantity × $price';
  }

  @override
  String get orderConfirmDialogTitle => 'Konfirmasi pesanan ini?';

  @override
  String get orderConfirmDialogBody =>
      'Stok setiap item pada pesanan ini akan dikurangi.';

  @override
  String get orderShipDialogTitle => 'Tandai sudah dikirim?';

  @override
  String get orderShipDialogBody =>
      'Stok sudah dikurangi saat konfirmasi; langkah ini hanya mencatat pengiriman.';

  @override
  String get orderCancelDialogTitle => 'Batalkan pesanan ini?';

  @override
  String get orderCancelDialogBodyPending =>
      'Pesanan belum menyentuh stok, jadi tidak ada stok yang dikembalikan.';

  @override
  String get orderCancelDialogBodyConfirmed =>
      'Stok yang dikurangi saat konfirmasi akan dikembalikan ke inventori.';

  @override
  String get orderChangeStatusDialogTitle => 'Ubah status?';

  @override
  String get orderStockProblemBody =>
      'Tidak ada yang berubah. Perbaiki item berikut dulu:';

  @override
  String orderStatusChangedElsewhere(String message) {
    return 'Status pesanan sudah berubah ($message). Data pesanan dimuat ulang.';
  }

  @override
  String orderItemDeleted(String label) {
    return '$label: produk sudah dihapus, tidak bisa dikonfirmasi.';
  }

  @override
  String orderItemProblem(String label, String message) {
    return '$label: $message';
  }

  @override
  String get orderFormTitle => 'Pesanan baru';

  @override
  String get orderFormCustomer => 'Pelanggan';

  @override
  String get orderFormPickCustomer => 'Pilih pelanggan';

  @override
  String get orderFormAddProduct => 'Tambah produk';

  @override
  String get orderFormPickProduct => 'Pilih produk';

  @override
  String get orderFormProductAlreadyAdded => 'sudah ditambahkan';

  @override
  String get orderFormNoItems => 'Belum ada produk yang ditambahkan.';

  @override
  String get orderFormNotesOptional => 'Catatan (opsional)';

  @override
  String get orderFormSubmit => 'Buat pesanan';

  @override
  String orderCreateFailed(String message) {
    return 'Gagal membuat pesanan: $message';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardRefresh => 'Muat ulang';

  @override
  String dashboardRangeDays(int days) {
    return '$days hari';
  }

  @override
  String get dashboardRangePick => 'Pilih tanggal';

  @override
  String get dashboardRangePickerHelp => 'Pilih rentang tanggal';

  @override
  String get dashboardRangePickerApply => 'Terapkan';

  @override
  String get dashboardSummaryTitle => 'Ringkasan';

  @override
  String get dashboardSummaryRevenue => 'Pendapatan';

  @override
  String get dashboardSummaryOrders => 'Pesanan';

  @override
  String get dashboardSummaryItemsSold => 'Item Terjual';

  @override
  String get dashboardSummaryAverageOrder => 'Rata-rata/Pesanan';

  @override
  String get dashboardTrendTitle => 'Tren Penjualan';

  @override
  String get dashboardTrendDaily => 'Harian';

  @override
  String get dashboardTrendWeekly => 'Mingguan';

  @override
  String get dashboardTrendNoPeriods => 'Tidak ada periode pada rentang ini.';

  @override
  String get dashboardTrendNoSales => 'Belum ada penjualan pada rentang ini.';

  @override
  String dashboardTrendTooltipOrders(int count) {
    return '$count pesanan';
  }

  @override
  String get dashboardTopProductsTitle => 'Produk Terlaris';

  @override
  String get dashboardTopProductsEmpty =>
      'Belum ada produk terjual pada rentang ini.';

  @override
  String dashboardTopProductSold(String sku, int count) {
    return '$sku · $count terjual';
  }

  @override
  String get dashboardCategoryTitle => 'Penjualan per Kategori';

  @override
  String get dashboardCategoryEmpty =>
      'Belum ada penjualan per kategori pada rentang ini.';

  @override
  String get dashboardLowStockTitle => 'Stok Menipis';

  @override
  String get dashboardLowStockSubtitle =>
      'Produk yang perlu segera dipesan ulang';

  @override
  String get dashboardLowStockAllGood => 'Semua stok aman';

  @override
  String get dashboardLowStockCountFailed => 'Jumlah gagal dimuat';

  @override
  String get dashboardLowStockReload => 'Muat ulang jumlah';

  @override
  String get dashboardInsightsTitle => 'Insight Bisnis';

  @override
  String get dashboardInsightsUnavailable =>
      'Insight bisnis sedang tidak tersedia';

  @override
  String get dashboardInsightsUnavailableDetail =>
      'Layanan analisis sedang mati. Angka penjualan di halaman ini tetap terbaru.';

  @override
  String get dashboardInsightsEmpty =>
      'Belum ada penjualan pada rentang ini, jadi belum ada insight.';

  @override
  String get dashboardInsightsNone => 'Tidak ada insight untuk produk ini.';

  @override
  String get dashboardForecastTitle => 'Prediksi Permintaan';

  @override
  String get dashboardForecastUnavailable =>
      'Prediksi permintaan sedang tidak tersedia';

  @override
  String get dashboardForecastUnavailableDetail =>
      'Layanan forecasting sedang mati. Data penjualan lain di halaman ini tetap terbaru.';

  @override
  String get dashboardForecastEmpty =>
      'Belum ada produk terjual pada rentang ini, jadi belum ada yang bisa diprediksi.';

  @override
  String dashboardForecastHorizon(int days) {
    return '$days hari ke depan, dari rata-rata penjualan harian';
  }

  @override
  String dashboardForecastUnits(String value) {
    return '$value unit';
  }

  @override
  String dashboardForecastPerDay(String value) {
    return '$value/hari';
  }

  @override
  String dashboardForecastSemantics(String product, String date) {
    return 'Prediksi $product sampai $date';
  }

  @override
  String get trendUp => 'Naik';

  @override
  String get trendDown => 'Turun';

  @override
  String get trendStable => 'Stabil';

  @override
  String trendUpPercent(int percent) {
    return 'Naik $percent%';
  }

  @override
  String trendDownPercent(int percent) {
    return 'Turun $percent%';
  }
}
