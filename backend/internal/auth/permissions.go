// Package auth holds the building blocks of authentication and access
// control that do not depend on the database: the permission catalog, JWT
// issuing/parsing, password hashing, and the principal carried in a request
// context.
package auth

import "github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"

// Permission is a key of the form "<resource>.<action>". The set is fixed in
// code (see [Catalog]); roles are made of these keys, but users never create
// new ones — a key only means something if a route checks it.
type Permission string

const (
	ProductsView   Permission = "products.view"
	ProductsCreate Permission = "products.create"
	ProductsUpdate Permission = "products.update"
	ProductsDelete Permission = "products.delete"

	CategoriesView   Permission = "categories.view"
	CategoriesCreate Permission = "categories.create"
	CategoriesUpdate Permission = "categories.update"
	CategoriesDelete Permission = "categories.delete"

	InventoryView           Permission = "inventory.view"
	InventoryUpdate         Permission = "inventory.update"
	InventoryRecordMovement Permission = "inventory.record_movement"

	CustomersView   Permission = "customers.view"
	CustomersCreate Permission = "customers.create"
	CustomersUpdate Permission = "customers.update"
	CustomersDelete Permission = "customers.delete"

	SalesOrdersView    Permission = "sales_orders.view"
	SalesOrdersCreate  Permission = "sales_orders.create"
	SalesOrdersConfirm Permission = "sales_orders.confirm"
	SalesOrdersShip    Permission = "sales_orders.ship"
	SalesOrdersCancel  Permission = "sales_orders.cancel"

	AnalyticsView     Permission = "analytics.view"
	AnalyticsForecast Permission = "analytics.forecast"
	AnalyticsInsights Permission = "analytics.insights"

	UsersView   Permission = "users.view"
	UsersCreate Permission = "users.create"
	UsersUpdate Permission = "users.update"
	UsersDelete Permission = "users.delete"

	RolesView              Permission = "roles.view"
	RolesCreate            Permission = "roles.create"
	RolesUpdate            Permission = "roles.update"
	RolesDelete            Permission = "roles.delete"
	RolesAssignPermissions Permission = "roles.assign_permissions"
)

// PermissionDef describes one catalog entry. Group is what a UI groups the
// permission under; it is a stable code, not a label.
//
// The description lives in the i18n catalog (key "permission.<key>"), in
// both languages, so there is one source for it: the API translates it per
// request, and the permissions table stores the Indonesian text.
type PermissionDef struct {
	Key   Permission
	Group string
}

// Description renders the permission's description in lang.
func (d PermissionDef) Description(lang i18n.Lang) string {
	return i18n.Translate(i18n.PermissionDescription(string(d.Key)), lang)
}

// Catalog is every permission the system knows, in display order.
// cmd/migrate syncs the permissions table to exactly this list.
var Catalog = []PermissionDef{
	{ProductsView, "products"},
	{ProductsCreate, "products"},
	{ProductsUpdate, "products"},
	{ProductsDelete, "products"},

	{CategoriesView, "categories"},
	{CategoriesCreate, "categories"},
	{CategoriesUpdate, "categories"},
	{CategoriesDelete, "categories"},

	{InventoryView, "inventory"},
	{InventoryUpdate, "inventory"},
	{InventoryRecordMovement, "inventory"},

	{CustomersView, "customers"},
	{CustomersCreate, "customers"},
	{CustomersUpdate, "customers"},
	{CustomersDelete, "customers"},

	{SalesOrdersView, "sales_orders"},
	{SalesOrdersCreate, "sales_orders"},
	{SalesOrdersConfirm, "sales_orders"},
	{SalesOrdersShip, "sales_orders"},
	{SalesOrdersCancel, "sales_orders"},

	{AnalyticsView, "analytics"},
	{AnalyticsForecast, "analytics"},
	{AnalyticsInsights, "analytics"},

	{UsersView, "users"},
	{UsersCreate, "users"},
	{UsersUpdate, "users"},
	{UsersDelete, "users"},

	{RolesView, "roles"},
	{RolesCreate, "roles"},
	{RolesUpdate, "roles"},
	{RolesDelete, "roles"},
	{RolesAssignPermissions, "roles"},
}

// Known reports whether key is in the catalog.
func Known(key string) bool {
	_, ok := catalogIndex[Permission(key)]
	return ok
}

// AllKeys returns every catalog key in display order.
func AllKeys() []string {
	keys := make([]string, len(Catalog))
	for i, def := range Catalog {
		keys[i] = string(def.Key)
	}
	return keys
}

var catalogIndex = func() map[Permission]struct{} {
	index := make(map[Permission]struct{}, len(Catalog))
	for _, def := range Catalog {
		index[def.Key] = struct{}{}
	}
	return index
}()
