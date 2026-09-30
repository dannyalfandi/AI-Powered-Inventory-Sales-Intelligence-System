package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type RoleHandler struct {
	svc service.RoleService
}

func NewRoleHandler(svc service.RoleService) *RoleHandler {
	return &RoleHandler{svc: svc}
}

// Create handles POST /api/v1/roles.
func (h *RoleHandler) Create(c *gin.Context) {
	var in model.CreateRoleInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	r, err := h.svc.Create(c.Request.Context(), in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusCreated, r)
}

// GetByID handles GET /api/v1/roles/:id (with its permission keys).
func (h *RoleHandler) GetByID(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	r, err := h.svc.GetByID(c.Request.Context(), id)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, r)
}

// List handles GET /api/v1/roles?page=1&page_size=20&search=staff.
func (h *RoleHandler) List(c *gin.Context) {
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("page_size"))
	roles, total, used, err := h.svc.List(c.Request.Context(), model.ListRolesParams{
		Page: page, PageSize: pageSize, Search: c.Query("search"),
	})
	if err != nil {
		writeError(c, err)
		return
	}
	response.Paginated(c, http.StatusOK, roles, response.PageMeta{
		Page: used.Page, PageSize: used.PageSize, Total: total,
	})
}

// Update handles PATCH /api/v1/roles/:id (name, description).
func (h *RoleHandler) Update(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	var in model.UpdateRoleInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	r, err := h.svc.Update(c.Request.Context(), id, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, r)
}

// Delete handles DELETE /api/v1/roles/:id. 409 for the system role and for a
// role users still have.
func (h *RoleHandler) Delete(c *gin.Context) {
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

// SetPermissions handles PUT /api/v1/roles/:id/permissions
// ({"permission_keys": [...]}) — replaces the list, never appends.
func (h *RoleHandler) SetPermissions(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	var in model.SetRolePermissionsInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	r, err := h.svc.SetPermissions(c.Request.Context(), id, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, r)
}

// ListPermissions handles GET /api/v1/permissions: the fixed catalog.
func (h *RoleHandler) ListPermissions(c *gin.Context) {
	perms, err := h.svc.ListPermissions(c.Request.Context())
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, perms)
}
