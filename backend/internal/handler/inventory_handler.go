package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type InventoryHandler struct {
	svc service.InventoryService
}

func NewInventoryHandler(svc service.InventoryService) *InventoryHandler {
	return &InventoryHandler{svc: svc}
}

// Get handles GET /api/v1/inventory/:product_id.
func (h *InventoryHandler) Get(c *gin.Context) {
	productID, ok := parseID(c, "product_id")
	if !ok {
		return
	}
	inv, err := h.svc.Get(c.Request.Context(), productID)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, inv)
}

// Update handles PATCH /api/v1/inventory/:product_id ({"low_stock_threshold": n}).
func (h *InventoryHandler) Update(c *gin.Context) {
	productID, ok := parseID(c, "product_id")
	if !ok {
		return
	}
	var in model.UpdateInventoryInput
	if err := c.ShouldBindJSON(&in); err != nil {
		response.Error(c, http.StatusBadRequest, "invalid_body", err.Error(), nil)
		return
	}
	inv, err := h.svc.Update(c.Request.Context(), productID, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, inv)
}

// CreateMovement handles POST /api/v1/inventory/:product_id/movements.
func (h *InventoryHandler) CreateMovement(c *gin.Context) {
	productID, ok := parseID(c, "product_id")
	if !ok {
		return
	}
	var in model.CreateStockMovementInput
	if err := c.ShouldBindJSON(&in); err != nil {
		response.Error(c, http.StatusBadRequest, "invalid_body", err.Error(), nil)
		return
	}
	mv, inv, err := h.svc.RecordMovement(c.Request.Context(), productID, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusCreated, gin.H{"movement": mv, "inventory": inv})
}

// ListMovements handles GET /api/v1/inventory/:product_id/movements?page=1&page_size=20.
func (h *InventoryHandler) ListMovements(c *gin.Context) {
	productID, ok := parseID(c, "product_id")
	if !ok {
		return
	}
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("page_size"))

	movements, total, used, err := h.svc.ListMovements(c.Request.Context(), productID, model.ListMovementsParams{
		Page: page, PageSize: pageSize,
	})
	if err != nil {
		writeError(c, err)
		return
	}
	response.Paginated(c, http.StatusOK, movements, response.PageMeta{
		Page: used.Page, PageSize: used.PageSize, Total: total,
	})
}

// ListLowStock handles GET /api/v1/inventory/low-stock?page=1&page_size=20.
func (h *InventoryHandler) ListLowStock(c *gin.Context) {
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("page_size"))

	items, total, used, err := h.svc.ListLowStock(c.Request.Context(), model.ListLowStockParams{
		Page: page, PageSize: pageSize,
	})
	if err != nil {
		writeError(c, err)
		return
	}
	response.Paginated(c, http.StatusOK, items, response.PageMeta{
		Page: used.Page, PageSize: used.PageSize, Total: total,
	})
}
