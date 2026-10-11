// Package router wires handlers to routes.
package router

import (
	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/handler"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
)

// Handlers groups every HTTP handler the router needs. Add new resources here.
type Handlers struct {
	Health     *handler.HealthHandler
	Auth       *handler.AuthHandler
	User       *handler.UserHandler
	Role       *handler.RoleHandler
	Product    *handler.ProductHandler
	Category   *handler.CategoryHandler
	Inventory  *handler.InventoryHandler
	Customer   *handler.CustomerHandler
	SalesOrder *handler.SalesOrderHandler
	Analytics  *handler.AnalyticsHandler
}

// Guard is what the router needs to protect routes: a token verifier for
// Authenticate and an Authorizer for RequirePermission.
type Guard struct {
	Tokens     handler.TokenParser
	Authorizer service.Authorizer
}

// New builds the engine. Every /api/v1 route except login, refresh and
// logout requires an access token; every route except /auth/me also requires
// a permission. The full endpoint → permission table is in backend/README.md,
// and router_test.go fails if a route is added without a decision about it.
func New(h Handlers, g Guard) *gin.Engine {
	r := gin.New()
	r.Use(gin.Logger(), gin.Recovery(), language())

	r.GET("/health", h.Health.Check)

	can := func(p auth.Permission) gin.HandlerFunc { return handler.RequirePermission(g.Authorizer, p) }

	v1 := r.Group("/api/v1")
	{
		// Public: these are how a client obtains or gives up a token.
		public := v1.Group("/auth")
		public.POST("/login", h.Auth.Login)
		public.POST("/refresh", h.Auth.Refresh)
		public.POST("/logout", h.Auth.Logout)
	}

	api := v1.Group("", handler.Authenticate(g.Tokens))
	{
		// Any logged-in user: the client builds its UI from this.
		api.GET("/auth/me", h.Auth.Me)

		products := api.Group("/products")
		products.POST("", can(auth.ProductsCreate), h.Product.Create)
		products.GET("", can(auth.ProductsView), h.Product.List)
		products.GET("/:id", can(auth.ProductsView), h.Product.GetByID)
		products.PATCH("/:id", can(auth.ProductsUpdate), h.Product.Update)
		products.DELETE("/:id", can(auth.ProductsDelete), h.Product.Delete)

		categories := api.Group("/categories")
		categories.POST("", can(auth.CategoriesCreate), h.Category.Create)
		categories.GET("", can(auth.CategoriesView), h.Category.List)
		categories.GET("/:id", can(auth.CategoriesView), h.Category.GetByID)
		categories.PATCH("/:id", can(auth.CategoriesUpdate), h.Category.Update)
		categories.DELETE("/:id", can(auth.CategoriesDelete), h.Category.Delete)

		inventory := api.Group("/inventory")
		inventory.GET("/low-stock", can(auth.InventoryView), h.Inventory.ListLowStock) // static segment wins over :product_id
		inventory.GET("/:product_id", can(auth.InventoryView), h.Inventory.Get)
		inventory.PATCH("/:product_id", can(auth.InventoryUpdate), h.Inventory.Update)
		inventory.GET("/:product_id/movements", can(auth.InventoryView), h.Inventory.ListMovements)
		inventory.POST("/:product_id/movements", can(auth.InventoryRecordMovement), h.Inventory.CreateMovement)

		customers := api.Group("/customers")
		customers.POST("", can(auth.CustomersCreate), h.Customer.Create)
		customers.GET("", can(auth.CustomersView), h.Customer.List)
		customers.GET("/:id", can(auth.CustomersView), h.Customer.GetByID)
		customers.PATCH("/:id", can(auth.CustomersUpdate), h.Customer.Update)
		customers.DELETE("/:id", can(auth.CustomersDelete), h.Customer.Delete)

		// No endpoint edits items: a wrong order is cancelled and re-created.
		orders := api.Group("/sales-orders")
		orders.POST("", can(auth.SalesOrdersCreate), h.SalesOrder.Create)
		orders.GET("", can(auth.SalesOrdersView), h.SalesOrder.List)
		orders.GET("/:id", can(auth.SalesOrdersView), h.SalesOrder.GetByID)
		// The permission depends on the target status in the body:
		// CONFIRMED → confirm, SHIPPED → ship, CANCELLED → cancel.
		orders.PATCH("/:id/status", handler.RequireStatusPermission(g.Authorizer), h.SalesOrder.UpdateStatus)

		// Read-only aggregations over the sales tables (no analytics table).
		analytics := api.Group("/analytics")
		analytics.GET("/summary", can(auth.AnalyticsView), h.Analytics.Summary)
		analytics.GET("/sales-trend", can(auth.AnalyticsView), h.Analytics.SalesTrend)
		analytics.GET("/top-products", can(auth.AnalyticsView), h.Analytics.TopProducts)
		analytics.GET("/category-breakdown", can(auth.AnalyticsView), h.Analytics.CategoryBreakdown)
		analytics.GET("/low-stock-alert-count", can(auth.AnalyticsView), h.Analytics.LowStockAlertCount)
		// Backed by the Python ML service; degrade per product, never 5xx.
		analytics.GET("/forecast", can(auth.AnalyticsForecast), h.Analytics.Forecast)
		analytics.GET("/insights", can(auth.AnalyticsInsights), h.Analytics.Insights)

		users := api.Group("/users")
		users.POST("", can(auth.UsersCreate), h.User.Create)
		users.GET("", can(auth.UsersView), h.User.List)
		users.GET("/:id", can(auth.UsersView), h.User.GetByID)
		users.PATCH("/:id", can(auth.UsersUpdate), h.User.Update)
		users.DELETE("/:id", can(auth.UsersDelete), h.User.Delete)

		roles := api.Group("/roles")
		roles.POST("", can(auth.RolesCreate), h.Role.Create)
		// The list is also what a user manager picks a role from when creating
		// or editing a user. Which role they may actually assign is enforced
		// by the user service (only roles within their own permissions). The
		// detail route and everything else stay roles.* only.
		roles.GET("", handler.RequireAnyPermission(g.Authorizer, auth.RolesView, auth.UsersCreate, auth.UsersUpdate), h.Role.List)
		roles.GET("/:id", can(auth.RolesView), h.Role.GetByID)
		roles.PATCH("/:id", can(auth.RolesUpdate), h.Role.Update)
		roles.DELETE("/:id", can(auth.RolesDelete), h.Role.Delete)
		roles.PUT("/:id/permissions", can(auth.RolesAssignPermissions), h.Role.SetPermissions)

		// The catalog is read-only; reading it is part of managing roles.
		api.GET("/permissions", can(auth.RolesView), h.Role.ListPermissions)
	}

	return r
}
