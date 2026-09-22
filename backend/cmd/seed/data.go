package main

// The demo catalogue: a small Indonesian grocery wholesaler (toko kelontong)
// selling to warungs and kiosks. Names, prices and quantities are meant to
// look like a real shop, because the whole point of this dataset is that the
// dashboard, the forecast and the insights read convincingly in a demo.

// categorySpec is one product category.
type categorySpec struct {
	Name        string
	Description string
}

var categories = []categorySpec{
	{"Minuman", "Kopi, teh, susu dan air kemasan"},
	{"Makanan Ringan", "Keripik, biskuit, wafer dan permen"},
	{"Sembako", "Beras, minyak, gula dan kebutuhan pokok"},
	{"Perawatan Diri", "Sabun, sampo dan perlengkapan mandi"},
	{"Rumah Tangga", "Deterjen, pembersih dan kebutuhan rumah"},
}

// demand describes how a product sells over the seeded window, which is what
// makes the analytics interesting:
//
//	Popularity — how often it shows up in an order (0..1).
//	Base       — typical quantity per order line.
//	Trend      — where demand ends up on the last day, relative to the start
//	             (1.45 = +45%, 0.6 = -40%, 1.0 = flat). The change is applied
//	             over the last `trendWindowDays` days, so the "last 14 days vs
//	             the 14 before" comparison the ML service does has something
//	             clear to find.
type demand struct {
	Popularity float64
	Base       float64
	Trend      float64
}

// productSpec is one catalogue row plus the behaviour the seeder gives it.
type productSpec struct {
	SKU         string
	Name        string
	Description string
	Category    string
	Price       int64
	Demand      demand
	// Threshold overrides the default low-stock threshold when non-zero.
	Threshold int64
	// EndStock is the stock left after the history is replayed. Values at or
	// below the threshold are what fills the low-stock screen in the demo.
	EndStock int64
}

var products = []productSpec{
	// --- Minuman -----------------------------------------------------------
	{
		SKU: "MNM-001", Name: "Kopi Bubuk Robusta 200g", Category: "Minuman", Price: 24000,
		Description: "Kopi bubuk robusta lokal, kemasan 200 gram",
		// The star of the demo: clearly rising, and nearly out of stock.
		Demand: demand{Popularity: 0.55, Base: 6, Trend: 2.6}, EndStock: 6,
	},
	{
		SKU: "MNM-002", Name: "Teh Celup Melati 25s", Category: "Minuman", Price: 9500,
		Description: "Teh celup aroma melati isi 25 kantong",
		Demand:      demand{Popularity: 0.4, Base: 5, Trend: 1.05}, EndStock: 80,
	},
	{
		SKU: "MNM-003", Name: "Susu UHT Cokelat 1L", Category: "Minuman", Price: 19500,
		Description: "Susu UHT rasa cokelat, 1 liter",
		Demand:      demand{Popularity: 0.35, Base: 4, Trend: 1.4}, EndStock: 54,
	},
	{
		SKU: "MNM-004", Name: "Air Mineral 600ml (dus isi 24)", Category: "Minuman", Price: 42000,
		Description: "Air mineral kemasan 600ml, satu dus isi 24 botol",
		Demand:      demand{Popularity: 0.45, Base: 3, Trend: 1.1}, EndStock: 38,
	},
	{
		SKU: "MNM-005", Name: "Kopi Susu Instan 10s", Category: "Minuman", Price: 15000,
		Description: "Kopi susu instan sachet isi 10",
		Demand:      demand{Popularity: 0.3, Base: 5, Trend: 1.9}, EndStock: 9, Threshold: 12,
	},
	{
		SKU: "MNM-006", Name: "Sirup Cocopandan 500ml", Category: "Minuman", Price: 28000,
		Description: "Sirup rasa cocopandan botol 500ml",
		// Post-Ramadan slump: the clearest falling line in the demo.
		Demand: demand{Popularity: 0.25, Base: 3, Trend: 0.3}, EndStock: 62,
	},

	// --- Makanan Ringan ----------------------------------------------------
	{
		SKU: "SNK-001", Name: "Keripik Singkong Balado 150g", Category: "Makanan Ringan", Price: 12000,
		Description: "Keripik singkong rasa balado, 150 gram",
		Demand:      demand{Popularity: 0.5, Base: 8, Trend: 1.9}, EndStock: 44,
	},
	{
		SKU: "SNK-002", Name: "Biskuit Kelapa 300g", Category: "Makanan Ringan", Price: 17500,
		Description: "Biskuit kelapa kaleng 300 gram",
		Demand:      demand{Popularity: 0.3, Base: 4, Trend: 0.95}, EndStock: 47,
	},
	{
		SKU: "SNK-003", Name: "Kacang Atom 100g", Category: "Makanan Ringan", Price: 8000,
		Description: "Kacang atom gurih kemasan 100 gram",
		Demand:      demand{Popularity: 0.35, Base: 6, Trend: 1.0}, EndStock: 73,
	},
	{
		SKU: "SNK-004", Name: "Wafer Cokelat 120g", Category: "Makanan Ringan", Price: 11000,
		Description: "Wafer lapis cokelat 120 gram",
		Demand:      demand{Popularity: 0.3, Base: 5, Trend: 1.15}, EndStock: 58,
	},
	{
		SKU: "SNK-005", Name: "Permen Mint 50s", Category: "Makanan Ringan", Price: 7500,
		Description: "Permen mint toples isi 50",
		Demand:      demand{Popularity: 0.2, Base: 4, Trend: 0.7}, EndStock: 66,
	},

	// --- Sembako -----------------------------------------------------------
	{
		SKU: "SMB-001", Name: "Beras Pandan Wangi 5kg", Category: "Sembako", Price: 78000,
		Description: "Beras pandan wangi karung 5 kilogram",
		// Big-ticket item: its own, higher threshold.
		Demand: demand{Popularity: 0.5, Base: 4, Trend: 1.5}, Threshold: 20, EndStock: 15,
	},
	{
		SKU: "SMB-002", Name: "Minyak Goreng 2L", Category: "Sembako", Price: 36000,
		Description: "Minyak goreng kemasan pouch 2 liter",
		Demand:      demand{Popularity: 0.55, Base: 5, Trend: 1.1}, EndStock: 41,
	},
	{
		SKU: "SMB-003", Name: "Gula Pasir 1kg", Category: "Sembako", Price: 17000,
		Description: "Gula pasir kemasan 1 kilogram",
		// A high-volume staple that is falling, so the insight list shows a
		// "Turun" badge among the best sellers instead of only good news.
		Demand: demand{Popularity: 0.6, Base: 9, Trend: 0.5}, EndStock: 52,
	},
	{
		SKU: "SMB-004", Name: "Tepung Terigu Serbaguna 1kg", Category: "Sembako", Price: 13000,
		Description: "Tepung terigu protein sedang 1 kilogram",
		Demand:      demand{Popularity: 0.3, Base: 5, Trend: 0.9}, EndStock: 49,
	},
	{
		SKU: "SMB-005", Name: "Telur Ayam 1kg", Category: "Sembako", Price: 29000,
		Description: "Telur ayam negeri, berat 1 kilogram",
		Demand:      demand{Popularity: 0.45, Base: 6, Trend: 1.6}, EndStock: 7, Threshold: 15,
	},
	{
		SKU: "SMB-006", Name: "Mie Instan Goreng (dus isi 40)", Category: "Sembako", Price: 120000,
		Description: "Mie instan goreng satu dus isi 40 bungkus",
		Demand:      demand{Popularity: 0.35, Base: 2, Trend: 0.45}, EndStock: 33,
	},
	{
		SKU: "SMB-007", Name: "Garam Halus 500g", Category: "Sembako", Price: 4000,
		Description: "Garam halus beryodium 500 gram",
		Demand:      demand{Popularity: 0.25, Base: 6, Trend: 1.0}, EndStock: 88,
	},

	// --- Perawatan Diri ----------------------------------------------------
	{
		SKU: "PRW-001", Name: "Sabun Mandi Cair 450ml", Category: "Perawatan Diri", Price: 26000,
		Description: "Sabun mandi cair refill 450ml",
		Demand:      demand{Popularity: 0.35, Base: 4, Trend: 1.15}, EndStock: 45,
	},
	{
		SKU: "PRW-002", Name: "Sampo Anti Ketombe 340ml", Category: "Perawatan Diri", Price: 42000,
		Description: "Sampo anti ketombe botol 340ml",
		Demand:      demand{Popularity: 0.25, Base: 3, Trend: 0.45}, EndStock: 57,
	},
	{
		SKU: "PRW-003", Name: "Pasta Gigi Herbal 190g", Category: "Perawatan Diri", Price: 18500,
		Description: "Pasta gigi herbal 190 gram",
		Demand:      demand{Popularity: 0.3, Base: 4, Trend: 1.0}, EndStock: 51,
	},
	{
		SKU: "PRW-004", Name: "Sikat Gigi Medium (isi 2)", Category: "Perawatan Diri", Price: 9000,
		Description: "Sikat gigi bulu medium, kemasan isi 2",
		Demand:      demand{Popularity: 0.2, Base: 4, Trend: 1.05}, EndStock: 64,
	},

	// --- Rumah Tangga ------------------------------------------------------
	{
		SKU: "RTG-001", Name: "Deterjen Bubuk 800g", Category: "Rumah Tangga", Price: 22000,
		Description: "Deterjen bubuk kemasan 800 gram",
		Demand:      demand{Popularity: 0.4, Base: 5, Trend: 1.4}, EndStock: 43,
	},
	{
		SKU: "RTG-002", Name: "Pembersih Lantai 800ml", Category: "Rumah Tangga", Price: 17000,
		Description: "Cairan pembersih lantai wangi lemon 800ml",
		Demand:      demand{Popularity: 0.3, Base: 4, Trend: 0.95}, EndStock: 50,
	},
	{
		SKU: "RTG-003", Name: "Tisu Wajah 250s", Category: "Rumah Tangga", Price: 14500,
		Description: "Tisu wajah lembut isi 250 lembar",
		Demand:      demand{Popularity: 0.25, Base: 5, Trend: 1.1}, EndStock: 59,
	},
	{
		SKU: "RTG-004", Name: "Sabun Cuci Piring 780ml", Category: "Rumah Tangga", Price: 16500,
		Description: "Sabun cuci piring refill 780ml",
		Demand:      demand{Popularity: 0.35, Base: 5, Trend: 1.05}, EndStock: 8, Threshold: 10,
	},
}

// customerSpec is one buyer: the warungs and kiosks this shop supplies.
type customerSpec struct {
	Name    string
	Email   string
	Phone   string
	Address string
	// Weight is how often this customer orders, relative to the others.
	Weight int
}

var customers = []customerSpec{
	{"Warung Bu Siti", "bu.siti@example.com", "081234567801", "Jl. Melati No. 12, Bandung", 5},
	{"Toko Berkah Jaya", "berkahjaya@example.com", "081234567802", "Jl. Ahmad Yani No. 45, Bandung", 5},
	{"Kios Pak Hendra", "hendra.kios@example.com", "081234567803", "Jl. Cihampelas No. 7, Bandung", 4},
	{"Minimarket Amanah", "amanah.mart@example.com", "081234567804", "Jl. Soekarno Hatta No. 210, Bandung", 4},
	{"Warung Kopi Cak Ali", "cakali@example.com", "081234567805", "Jl. Dipatiukur No. 3, Bandung", 3},
	{"Toko Sinar Abadi", "sinarabadi@example.com", "081234567806", "Jl. Pasirkaliki No. 88, Bandung", 3},
	{"Katering Dapur Ibu Rina", "dapuribur@example.com", "081234567807", "Jl. Setiabudi No. 30, Bandung", 3},
	{"Kantin Sekolah Nusantara", "kantin.nusantara@example.com", "081234567808", "Jl. Merdeka No. 5, Bandung", 2},
	{"Toko Sembako Makmur", "sembakomakmur@example.com", "081234567809", "Jl. Kopo No. 150, Bandung", 2},
	{"Kedai Kopi Senja", "kedaisenja@example.com", "081234567810", "Jl. Riau No. 21, Bandung", 2},
}

// testDataPatterns are the SQL LIKE patterns of rows left behind by the test
// scripts and by manual poking during development. `--clean` removes exactly
// these (see cleanTestData), which is why they are listed rather than
// guessed: E2E-*/SMOKE-* come from scripts/e2e.sh, SHAPE-*/SHP-*/CACHE-* from
// one-off probes, and the plain ones from manual emulator testing.
var (
	testProductSKUs = []string{"E2E-%", "SMOKE-%", "SHAPE-%", "SHP-%", "CACHE-%", "KOPI-001", "TEH-001"}
	testNames       = []string{"E2E %", "E2E-%", "Shape %", "Cache probe%", "SMOKE%"}
	// Categories and customers created by hand while testing the app.
	manualCategoryNames = []string{"Minuman", "Makanan"}
	manualCustomerNames = []string{"Toko Maju Jaya"}
)
