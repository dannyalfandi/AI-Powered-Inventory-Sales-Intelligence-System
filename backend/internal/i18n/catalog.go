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

	// --- authentication & access control ----------------------------------
	KeyMinChars          Key = "field.min_chars"
	KeyMaxBytes          Key = "field.max_bytes"
	KeyPermissionUnknown Key = "field.permission_unknown"

	KeyAuthInvalidCredentials Key = "auth.invalid_credentials"
	KeyAuthMissingToken       Key = "auth.missing_token"
	KeyAuthInvalidToken       Key = "auth.invalid_token"
	KeyAuthTokenExpired       Key = "auth.token_expired"
	KeyAuthRefreshInvalid     Key = "auth.refresh_invalid"
	KeyAuthRefreshExpired     Key = "auth.refresh_expired"
	KeyAuthAccountDisabled    Key = "auth.account_disabled"
	KeyAuthForbidden          Key = "auth.forbidden"

	KeyUserEmailTaken               Key = "rule.user_email_taken"
	KeyCannotDeactivateSelf         Key = "rule.cannot_deactivate_self"
	KeyCannotChangeOwnRole          Key = "rule.cannot_change_own_role"
	KeyLastSuperAdmin               Key = "rule.last_super_admin"
	KeySystemRoleRequiresSuperAdmin Key = "rule.system_role_requires_super_admin"
	KeySystemRoleLocked             Key = "rule.system_role_locked"
	KeyRoleInUse                    Key = "rule.role_in_use"
	KeyPermissionNotHeld            Key = "rule.permission_not_held"

	KeyEntityUser     Key = "entity.user"
	KeyEntityRole     Key = "entity.role"
	KeyEntityRoleName Key = "entity.role_name"
)

// PermissionDescription is the key of a permission's description, e.g.
// "permission.products.view". Every catalog permission has one; a test in
// internal/auth makes sure of it.
func PermissionDescription(permission string) Key {
	return Key("permission." + permission)
}

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

	// --- authentication & access control ----------------------------------
	KeyMinChars: {
		ID: "minimal %d karakter",
		EN: "must be at least %d characters",
	},
	KeyMaxBytes: {
		ID: "maksimal %d byte",
		EN: "must be at most %d bytes",
	},
	KeyPermissionUnknown: {
		ID: "izin %q tidak dikenal",
		EN: "unknown permission %q",
	},
	// One sentence for an unknown email, a wrong password and a disabled
	// account alike, so the login endpoint can't be used to probe accounts.
	KeyAuthInvalidCredentials: {
		ID: "email atau password salah",
		EN: "invalid email or password",
	},
	KeyAuthMissingToken: {
		ID: "wajib login: kirim header Authorization: Bearer <access_token>",
		EN: "authentication required: send an Authorization: Bearer <access_token> header",
	},
	KeyAuthInvalidToken: {
		ID: "token akses tidak valid",
		EN: "invalid access token",
	},
	KeyAuthTokenExpired: {
		ID: "token akses sudah kedaluwarsa, perbarui dengan refresh token",
		EN: "access token has expired, renew it with the refresh token",
	},
	KeyAuthRefreshInvalid: {
		ID: "refresh token tidak valid, sudah dipakai, atau sudah dicabut; silakan login ulang",
		EN: "refresh token is invalid, already used or revoked; please log in again",
	},
	KeyAuthRefreshExpired: {
		ID: "refresh token sudah kedaluwarsa, silakan login ulang",
		EN: "refresh token has expired, please log in again",
	},
	KeyAuthAccountDisabled: {
		ID: "akun ini tidak aktif atau sudah dihapus",
		EN: "this account is inactive or has been deleted",
	},
	KeyAuthForbidden: {
		ID: "anda tidak punya izin %s",
		EN: "you do not have the %s permission",
	},
	KeyUserEmailTaken: {
		ID: "email sudah dipakai pengguna lain",
		EN: "email is already used by another user",
	},
	KeyCannotDeactivateSelf: {
		ID: "tidak bisa menonaktifkan atau menghapus akun sendiri",
		EN: "you can't deactivate or delete your own account",
	},
	KeyCannotChangeOwnRole: {
		ID: "tidak bisa mengubah role akun sendiri",
		EN: "you can't change the role of your own account",
	},
	KeyLastSuperAdmin: {
		ID: "harus tetap ada minimal satu Super Admin yang aktif",
		EN: "at least one active Super Admin must remain",
	},
	KeySystemRoleRequiresSuperAdmin: {
		ID: "hanya Super Admin yang bisa memberikan role sistem atau mengubah akun Super Admin",
		EN: "only a Super Admin can grant a system role or change a Super Admin account",
	},
	KeySystemRoleLocked: {
		ID: "role sistem %q tidak bisa dihapus, diganti nama, atau diatur izinnya",
		EN: "system role %q can't be deleted, renamed or given a permission list",
	},
	KeyRoleInUse: {
		ID: "role %d masih terhubung dengan %d pengguna (termasuk yang sudah dihapus)",
		EN: "role %d is still linked to %d user(s), including deleted ones",
	},
	KeyPermissionNotHeld: {
		ID: "tidak bisa memberikan izin %q yang tidak anda miliki sendiri",
		EN: "you can't grant the %q permission because you don't hold it yourself",
	},
	KeyEntityUser: {
		ID: "pengguna %d",
		EN: "user %d",
	},
	KeyEntityRole: {
		ID: "role %d",
		EN: "role %d",
	},
	KeyEntityRoleName: {
		ID: "role dengan nama %q",
		EN: "role name %q",
	},

	// --- permission descriptions (GET /permissions, GET /auth/me) ---------
	// Keyed by PermissionDescription(key). The Indonesian text matches the
	// description stored in the permissions table.
	"permission.products.view":             {ID: "Melihat daftar dan detail produk", EN: "View the product list and details"},
	"permission.products.create":           {ID: "Membuat produk", EN: "Create products"},
	"permission.products.update":           {ID: "Mengubah produk", EN: "Edit products"},
	"permission.products.delete":           {ID: "Menghapus produk", EN: "Delete products"},
	"permission.categories.view":           {ID: "Melihat daftar dan detail kategori", EN: "View the category list and details"},
	"permission.categories.create":         {ID: "Membuat kategori", EN: "Create categories"},
	"permission.categories.update":         {ID: "Mengubah kategori", EN: "Edit categories"},
	"permission.categories.delete":         {ID: "Menghapus kategori", EN: "Delete categories"},
	"permission.inventory.view":            {ID: "Melihat stok, riwayat pergerakan, dan stok menipis", EN: "View stock, movement history and low stock"},
	"permission.inventory.update":          {ID: "Mengubah ambang stok menipis", EN: "Change low-stock thresholds"},
	"permission.inventory.record_movement": {ID: "Mencatat pergerakan stok (IN/OUT/ADJUSTMENT)", EN: "Record stock movements (IN/OUT/ADJUSTMENT)"},
	"permission.customers.view":            {ID: "Melihat daftar dan detail pelanggan", EN: "View the customer list and details"},
	"permission.customers.create":          {ID: "Membuat pelanggan", EN: "Create customers"},
	"permission.customers.update":          {ID: "Mengubah pelanggan", EN: "Edit customers"},
	"permission.customers.delete":          {ID: "Menghapus pelanggan", EN: "Delete customers"},
	"permission.sales_orders.view":         {ID: "Melihat daftar dan detail pesanan", EN: "View the sales order list and details"},
	"permission.sales_orders.create":       {ID: "Membuat pesanan", EN: "Create sales orders"},
	"permission.sales_orders.confirm":      {ID: "Mengonfirmasi pesanan (mengurangi stok)", EN: "Confirm sales orders (deducts stock)"},
	"permission.sales_orders.ship":         {ID: "Menandai pesanan dikirim", EN: "Mark sales orders as shipped"},
	"permission.sales_orders.cancel":       {ID: "Membatalkan pesanan (mengembalikan stok bila sudah dikonfirmasi)", EN: "Cancel sales orders (returns stock if confirmed)"},
	"permission.analytics.view":            {ID: "Melihat dashboard analytics", EN: "View the analytics dashboard"},
	"permission.analytics.forecast":        {ID: "Melihat prediksi permintaan", EN: "View demand forecasts"},
	"permission.analytics.insights":        {ID: "Melihat insight bisnis", EN: "View business insights"},
	"permission.users.view":                {ID: "Melihat daftar dan detail pengguna", EN: "View the user list and details"},
	"permission.users.create":              {ID: "Membuat pengguna", EN: "Create users"},
	"permission.users.update":              {ID: "Mengubah pengguna (termasuk role dan status aktif)", EN: "Edit users (including role and active status)"},
	"permission.users.delete":              {ID: "Menghapus pengguna", EN: "Delete users"},
	"permission.roles.view":                {ID: "Melihat daftar role dan katalog izin", EN: "View roles and the permission catalog"},
	"permission.roles.create":              {ID: "Membuat role", EN: "Create roles"},
	"permission.roles.update":              {ID: "Mengubah nama dan deskripsi role", EN: "Rename roles and edit their description"},
	"permission.roles.delete":              {ID: "Menghapus role", EN: "Delete roles"},
	"permission.roles.assign_permissions":  {ID: "Mengatur izin sebuah role", EN: "Set the permissions of a role"},
}
