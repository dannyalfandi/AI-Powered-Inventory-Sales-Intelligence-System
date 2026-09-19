package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type CategoryHandler struct {
	svc service.CategoryService
}

func NewCategoryHandler(svc service.CategoryService) *CategoryHandler {
	return &CategoryHandler{svc: svc}
}

// Create handles POST /api/v1/categories.
func (h *CategoryHandler) Create(c *gin.Context) {
	var in model.CreateCategoryInput
	if err := c.ShouldBindJSON(&in); err != nil {
		response.Error(c, http.StatusBadRequest, "invalid_body", err.Error(), nil)
		return
	}
	cat, err := h.svc.Create(c.Request.Context(), in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusCreated, cat)
}

// GetByID handles GET /api/v1/categories/:id.
func (h *CategoryHandler) GetByID(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	cat, err := h.svc.GetByID(c.Request.Context(), id)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, cat)
}

// List handles GET /api/v1/categories?page=1&page_size=20&search=minuman.
func (h *CategoryHandler) List(c *gin.Context) {
	// Invalid numbers fall back to 0 and are normalized to defaults by the service.
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("page_size"))

	categories, total, used, err := h.svc.List(c.Request.Context(), model.ListCategoriesParams{
		Page:     page,
		PageSize: pageSize,
		Search:   c.Query("search"),
	})
	if err != nil {
		writeError(c, err)
		return
	}
	response.Paginated(c, http.StatusOK, categories, response.PageMeta{
		Page: used.Page, PageSize: used.PageSize, Total: total,
	})
}

// Update handles PATCH /api/v1/categories/:id (partial update).
func (h *CategoryHandler) Update(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	var in model.UpdateCategoryInput
	if err := c.ShouldBindJSON(&in); err != nil {
		response.Error(c, http.StatusBadRequest, "invalid_body", err.Error(), nil)
		return
	}
	cat, err := h.svc.Update(c.Request.Context(), id, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, cat)
}

// Delete handles DELETE /api/v1/categories/:id. Returns 409 while products
// still use the category.
func (h *CategoryHandler) Delete(c *gin.Context) {
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
