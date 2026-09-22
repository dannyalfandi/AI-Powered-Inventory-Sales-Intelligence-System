package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type SalesOrderHandler struct {
	svc service.SalesOrderService
}

func NewSalesOrderHandler(svc service.SalesOrderService) *SalesOrderHandler {
	return &SalesOrderHandler{svc: svc}
}

// Create handles POST /api/v1/sales-orders.
func (h *SalesOrderHandler) Create(c *gin.Context) {
	var in model.CreateSalesOrderInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	o, err := h.svc.Create(c.Request.Context(), in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusCreated, o)
}

// GetByID handles GET /api/v1/sales-orders/:id (with items and customer).
func (h *SalesOrderHandler) GetByID(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	o, err := h.svc.GetByID(c.Request.Context(), id)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, o)
}

// List handles GET /api/v1/sales-orders?page=1&page_size=20&status=PENDING&customer_id=3.
func (h *SalesOrderHandler) List(c *gin.Context) {
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("page_size"))

	var customerID uint
	if raw := c.Query("customer_id"); raw != "" {
		id, err := strconv.ParseUint(raw, 10, 64)
		if err != nil || id == 0 {
			response.Error(c, http.StatusBadRequest, "invalid_query", "customer_id must be a positive integer", nil)
			return
		}
		customerID = uint(id)
	}

	orders, total, used, err := h.svc.List(c.Request.Context(), model.ListSalesOrdersParams{
		Page:       page,
		PageSize:   pageSize,
		Status:     model.OrderStatus(c.Query("status")),
		CustomerID: customerID,
	})
	if err != nil {
		writeError(c, err)
		return
	}
	response.Paginated(c, http.StatusOK, orders, response.PageMeta{
		Page: used.Page, PageSize: used.PageSize, Total: total,
	})
}

// UpdateStatus handles PATCH /api/v1/sales-orders/:id/status ({"status": "CONFIRMED"}).
func (h *SalesOrderHandler) UpdateStatus(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	var in model.UpdateOrderStatusInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	o, err := h.svc.ChangeStatus(c.Request.Context(), id, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, o)
}
