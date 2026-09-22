package i18n

// Key identifies one message. Keys are grouped by where they surface:
// `field.*` for per-field validation, `rule.*` for business rules,
// `entity.*` for the nouns those rules talk about, `http.*` for the envelope,
// and `ml.*` for what the forecasting service's failures look like.
type Key string

const (
	// --- per-field validation (details[].message of a 422) ---------------
	KeyRequired           Key = "field.required"
	KeyMaxChars           Key = "field.max_chars"
	KeyMaxValue           Key = "field.max_value"
	KeyNotNegative        Key = "field.not_negative"
	KeyGreaterThanZero    Key = "field.greater_than_zero"
	KeyDoesNotExist       Key = "field.does_not_exist"
	KeyEmailInvalid       Key = "field.email_invalid"
	KeyPhoneInvalid       Key = "field.phone_invalid"
	KeyMovementTypeEnum   Key = "field.movement_type_enum"
	KeyOrderStatusEnum    Key = "field.order_status_enum"
	KeyGranularityEnum    Key = "field.granularity_enum"
	KeyDateFormat         Key = "field.date_format"
	KeyFromBeforeTo       Key = "field.from_before_to"
	KeyRangeMaxDays       Key = "field.range_max_days"
	KeyRangeMinDays       Key = "field.range_min_days"
	KeyItemsMin           Key = "field.items_min"
	KeyItemsMax           Key = "field.items_max"
	KeySubtotalTooLarge   Key = "field.subtotal_too_large"
	KeyOrderTotalTooLarge Key = "field.order_total_too_large"

	// --- business rules ---------------------------------------------------
	KeyProductNotExist      Key = "rule.product_not_exist"
	KeyProductUnavailable   Key = "rule.product_unavailable"
	KeyDuplicateItem        Key = "rule.duplicate_item"
	KeyInsufficientStock    Key = "rule.insufficient_stock"
	KeyInsufficientStockFor Key = "rule.insufficient_stock_for_product"
	KeyStatusFinal          Key = "rule.status_final"
	KeyStatusTransition     Key = "rule.status_transition"
	KeyCategoryInUse        Key = "rule.category_in_use"
	KeyCustomerHasOrders    Key = "rule.customer_has_orders"
	KeyEmailTaken           Key = "rule.email_taken"
	KeyNotFound             Key = "rule.not_found"
	KeyAlreadyExists        Key = "rule.already_exists"

	// --- entities, used as the subject of not_found / already_exists ------
	KeyEntityProduct           Key = "entity.product"
	KeyEntityProductSKU        Key = "entity.product_sku"
	KeyEntityCategory          Key = "entity.category"
	KeyEntityCategoryName      Key = "entity.category_name"
	KeyEntityCustomer          Key = "entity.customer"
	KeyEntityCustomerName      Key = "entity.customer_name"
	KeyEntitySalesOrderID      Key = "entity.sales_order_id"
	KeyEntitySalesOrderGeneric Key = "entity.sales_order"

	// --- HTTP envelope ----------------------------------------------------
	KeyValidationFailed Key = "http.validation_failed"
	KeyInternalError    Key = "http.internal_error"
	KeyInvalidID        Key = "http.invalid_id"
	KeyInvalidBody      Key = "http.invalid_body"

	// --- forecasting (the Python ML service) ------------------------------
	KeyMLUnavailable Key = "ml.unavailable"
	KeyMLFailed      Key = "ml.failed"
)

// catalog holds every sentence this API can send. Indonesian is the default
// language, so it is written first in each entry.
//
// Placeholders keep their order between languages; where a language would
// need a different order it uses explicit indexes (%[1]d).
var catalog = map[Key]map[Lang]string{
	// --- per-field validation --------------------------------------------
	KeyRequired: {
		ID: "wajib diisi",
		EN: "is required",
	},
	KeyMaxChars: {
		ID: "maksimal %d karakter",
		EN: "must be at most %d characters",
	},
	KeyMaxValue: {
		ID: "maksimal %d",
		EN: "must be at most %d",
	},
	KeyNotNegative: {
		ID: "tidak boleh negatif",
		EN: "must not be negative",
	},
	KeyGreaterThanZero: {
		ID: "harus lebih dari 0",
		EN: "must be greater than 0",
	},
	KeyDoesNotExist: {
		ID: "tidak ditemukan",
		EN: "does not exist",
	},
	KeyEmailInvalid: {
		ID: "format email tidak valid",
		EN: "must be a valid email address",
	},
	KeyPhoneInvalid: {
		ID: "harus 6-%d digit, boleh memakai +, spasi, tanda hubung atau kurung",
		EN: "must be 6-%d digits, optionally with +, spaces, dashes or parentheses",
	},
	KeyMovementTypeEnum: {
		ID: "harus salah satu dari IN, OUT, ADJUSTMENT",
		EN: "must be one of IN, OUT, ADJUSTMENT",
	},
	KeyOrderStatusEnum: {
		ID: "harus salah satu dari PENDING, CONFIRMED, SHIPPED, CANCELLED",
		EN: "must be one of PENDING, CONFIRMED, SHIPPED, CANCELLED",
	},
	KeyGranularityEnum: {
		ID: "harus daily atau weekly",
		EN: "must be daily or weekly",
	},
	KeyDateFormat: {
		ID: "harus tanggal dengan format YYYY-MM-DD",
		EN: "must be a date in YYYY-MM-DD format",
	},
	KeyFromBeforeTo: {
		ID: "harus sama dengan atau sebelum to",
		EN: "must be on or before to",
	},
	KeyRangeMaxDays: {
		ID: "rentang maksimal %d hari",
		EN: "range must be at most %d days",
	},
	KeyRangeMinDays: {
		ID: "rentang minimal %d hari untuk bisa diprediksi",
		EN: "range must cover at least %d days to forecast",
	},
	KeyItemsMin: {
		ID: "minimal berisi satu item",
		EN: "must contain at least one item",
	},
	KeyItemsMax: {
		ID: "maksimal berisi %d item",
		EN: "must contain at most %d items",
	},
	KeySubtotalTooLarge: {
		ID: "subtotal terlalu besar",
		EN: "subtotal is too large",
	},
	KeyOrderTotalTooLarge: {
		ID: "total pesanan terlalu besar",
		EN: "order total is too large",
	},

	// --- business rules ---------------------------------------------------
	KeyProductNotExist: {
		ID: "produk %d tidak ditemukan",
		EN: "product %d does not exist",
	},
	KeyProductUnavailable: {
		ID: "produk %d (%s) sudah tidak tersedia",
		EN: "product %d (%s) is no longer available",
	},
	KeyDuplicateItem: {
		ID: "produk %d sudah ada di items[%d]; gabungkan jumlahnya",
		EN: "product %d is already in items[%d]; combine the quantities",
	},
	KeyInsufficientStock: {
		ID: "stok tidak cukup: tersedia %d, diminta %d",
		EN: "insufficient stock: %d available, %d requested",
	},
	KeyInsufficientStockFor: {
		ID: "stok produk %d (%s) tidak cukup: tersedia %d, diminta %d",
		EN: "insufficient stock for product %d (%s): %d available, %d requested",
	},
	KeyStatusFinal: {
		ID: "pesanan dengan status %s tidak bisa diubah lagi",
		EN: "an order that is %s can't change status anymore",
	},
	KeyStatusTransition: {
		ID: "tidak bisa mengubah status dari %s ke %s; yang diizinkan: %s",
		EN: "can't change status from %s to %s; allowed: %s",
	},
	KeyCategoryInUse: {
		ID: "kategori %d masih dipakai oleh %d produk",
		EN: "category %d is still used by %d product(s)",
	},
	KeyCustomerHasOrders: {
		ID: "pelanggan %d masih punya %d pesanan yang belum dibatalkan",
		EN: "customer %d still has %d sales order(s) that are not cancelled",
	},
	KeyEmailTaken: {
		ID: "email sudah dipakai pelanggan lain",
		EN: "email is already used by another customer",
	},
	KeyNotFound: {
		ID: "%s tidak ditemukan",
		EN: "%s not found",
	},
	KeyAlreadyExists: {
		ID: "%s sudah ada",
		EN: "%s already exists",
	},

	// --- entities ---------------------------------------------------------
	KeyEntityProduct: {
		ID: "produk %d",
		EN: "product %d",
	},
	KeyEntityProductSKU: {
		ID: "produk dengan sku %s",
		EN: "product sku %s",
	},
	KeyEntityCategory: {
		ID: "kategori %d",
		EN: "category %d",
	},
	KeyEntityCategoryName: {
		ID: "kategori dengan nama %q",
		EN: "category name %q",
	},
	KeyEntityCustomer: {
		ID: "pelanggan %d",
		EN: "customer %d",
	},
	KeyEntityCustomerName: {
		ID: "pelanggan %q",
		EN: "customer %q",
	},
	KeyEntitySalesOrderID: {
		ID: "pesanan %d",
		EN: "sales order %d",
	},
	// The generic form takes no reference; the %s swallows the empty string
	// the caller passes so both entity keys share one call shape.
	KeyEntitySalesOrderGeneric: {
		ID: "pesanan%s",
		EN: "sales order%s",
	},

	// --- HTTP envelope ----------------------------------------------------
	KeyValidationFailed: {
		ID: "validasi request gagal",
		EN: "request validation failed",
	},
	KeyInternalError: {
		ID: "terjadi kesalahan pada server",
		EN: "internal server error",
	},
	KeyInvalidID: {
		ID: "%s harus berupa bilangan bulat positif",
		EN: "%s must be a positive integer",
	},
	KeyInvalidBody: {
		ID: "isi request bukan JSON yang valid",
		EN: "request body is not valid JSON",
	},

	// --- forecasting ------------------------------------------------------
	KeyMLUnavailable: {
		ID: "layanan forecasting sedang tidak tersedia",
		EN: "forecasting service is currently unavailable",
	},
	KeyMLFailed: {
		ID: "forecast gagal dihitung untuk produk ini",
		EN: "could not compute a forecast for this product",
	},
}
