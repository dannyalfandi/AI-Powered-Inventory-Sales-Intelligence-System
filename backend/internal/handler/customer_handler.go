package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type CustomerHandler struct {
	svc service.CustomerService
}

func NewCustomerHandler(svc service.CustomerService) *CustomerHandler {
	return &CustomerHandler{svc: svc}
}

// Create handles POST /api/v1/customers.
func (h *CustomerHandler) Create(c *gin.Context) {
	var in model.CreateCustomerInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	cust, err := h.svc.Create(c.Request.Context(), in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusCreated, cust)
}

// GetByID handles GET /api/v1/customers/:id.
func (h *CustomerHandler) GetByID(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	cust, err := h.svc.GetByID(c.Request.Context(), id)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, cust)
}

// List handles GET /api/v1/customers?page=1&page_size=20&search=budi.
func (h *CustomerHandler) List(c *gin.Context) {
	// Invalid numbers fall back to 0 and are normalized to defaults by the service.
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("page_size"))

	customers, total, used, err := h.svc.List(c.Request.Context(), model.ListCustomersParams{
		Page:     page,
		PageSize: pageSize,
		Search:   c.Query("search"),
	})
	if err != nil {
		writeError(c, err)
		return
	}
	response.Paginated(c, http.StatusOK, customers, response.PageMeta{
		Page: used.Page, PageSize: used.PageSize, Total: total,
	})
}

// Update handles PATCH /api/v1/customers/:id (partial update).
func (h *CustomerHandler) Update(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	var in model.UpdateCustomerInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	cust, err := h.svc.Update(c.Request.Context(), id, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, cust)
}

// Delete handles DELETE /api/v1/customers/:id. Returns 409 while the
// customer has orders that are not cancelled.
func (h *CustomerHandler) Delete(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	if err := h.svc.Delete(c.Request.Context(), id); err != nil {
		writeError(c, err)
		return
	}
	c.Status(http.StatusNoContent)
}
