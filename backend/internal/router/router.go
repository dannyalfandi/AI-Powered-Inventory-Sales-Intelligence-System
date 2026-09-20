// Package router wires handlers to routes.
package router

import (
	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/handler"
)

// Handlers groups every HTTP handler the router needs. Add new resources here.
type Handlers struct {
	Health     *handler.HealthHandler
	Product    *handler.ProductHandler
	Category   *handler.CategoryHandler
	Inventory  *handler.InventoryHandler
	Customer   *handler.CustomerHandler
	SalesOrder *handler.SalesOrderHandler
	Analytics  *handler.AnalyticsHandler
}

func New(h Handlers) *gin.Engine {
	r := gin.New()
	r.Use(gin.Logger(), gin.Recovery())

	r.GET("/health", h.Health.Check)

	v1 := r.Group("/api/v1")
	{
		products := v1.Group("/products")
		products.POST("", h.Product.Create)
		products.GET("", h.Product.List)
		products.GET("/:id", h.Product.GetByID)
		products.PATCH("/:id", h.Product.Update)
		products.DELETE("/:id", h.Product.Delete)

		categories := v1.Group("/categories")
		categories.POST("", h.Category.Create)
		categories.GET("", h.Category.List)
		categories.GET("/:id", h.Category.GetByID)
		categories.PATCH("/:id", h.Category.Update)
		categories.DELETE("/:id", h.Category.Delete)

		inventory := v1.Group("/inventory")
		inventory.GET("/low-stock", h.Inventory.ListLowStock) // static segment wins over :product_id
		inventory.GET("/:product_id", h.Inventory.Get)
		inventory.PATCH("/:product_id", h.Inventory.Update)
		inventory.GET("/:product_id/movements", h.Inventory.ListMovements)
		inventory.POST("/:product_id/movements", h.Inventory.CreateMovement)

		customers := v1.Group("/customers")
		customers.POST("", h.Customer.Create)
		customers.GET("", h.Customer.List)
		customers.GET("/:id", h.Customer.GetByID)
		customers.PATCH("/:id", h.Customer.Update)
		customers.DELETE("/:id", h.Customer.Delete)

		// No endpoint edits items: a wrong order is cancelled and re-created.
		orders := v1.Group("/sales-orders")
		orders.POST("", h.SalesOrder.Create)
		orders.GET("", h.SalesOrder.List)
		orders.GET("/:id", h.SalesOrder.GetByID)
		orders.PATCH("/:id/status", h.SalesOrder.UpdateStatus)

		// Read-only aggregations over the sales tables (no analytics table).
		analytics := v1.Group("/analytics")
		analytics.GET("/summary", h.Analytics.Summary)
		analytics.GET("/sales-trend", h.Analytics.SalesTrend)
		analytics.GET("/top-products", h.Analytics.TopProducts)
		analytics.GET("/category-breakdown", h.Analytics.CategoryBreakdown)
		analytics.GET("/low-stock-alert-count", h.Analytics.LowStockAlertCount)
	}

	return r
}
