package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type ProductHandler struct {
	svc service.ProductService
}

func NewProductHandler(svc service.ProductService) *ProductHandler {
	return &ProductHandler{svc: svc}
}

// Create handles POST /api/v1/products.
func (h *ProductHandler) Create(c *gin.Context) {
	var in model.CreateProductInput
	if err := c.ShouldBindJSON(&in); err != nil {
		response.Error(c, http.StatusBadRequest, "invalid_body", err.Error(), nil)
		return
	}
	p, err := h.svc.Create(c.Request.Context(), in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusCreated, p)
}

// GetByID handles GET /api/v1/products/:id.
func (h *ProductHandler) GetByID(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	p, err := h.svc.GetByID(c.Request.Context(), id)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, p)
}

// List handles GET /api/v1/products?page=1&page_size=20&search=kopi.
func (h *ProductHandler) List(c *gin.Context) {
	// Invalid numbers fall back to 0 and are normalized to defaults by the service.
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("page_size"))

	products, total, used, err := h.svc.List(c.Request.Context(), model.ListProductsParams{
		Page:     page,
		PageSize: pageSize,
		Search:   c.Query("search"),
	})
	if err != nil {
		writeError(c, err)
		return
	}
	response.Paginated(c, http.StatusOK, products, response.PageMeta{
		Page: used.Page, PageSize: used.PageSize, Total: total,
	})
}

// Update handles PATCH /api/v1/products/:id (partial update).
func (h *ProductHandler) Update(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	var in model.UpdateProductInput
	if err := c.ShouldBindJSON(&in); err != nil {
		response.Error(c, http.StatusBadRequest, "invalid_body", err.Error(), nil)
		return
	}
	p, err := h.svc.Update(c.Request.Context(), id, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, p)
}

// Delete handles DELETE /api/v1/products/:id.
func (h *ProductHandler) Delete(c *gin.Context) {
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
