package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type UserHandler struct {
	svc service.UserService
}

func NewUserHandler(svc service.UserService) *UserHandler {
	return &UserHandler{svc: svc}
}

// Create handles POST /api/v1/users.
func (h *UserHandler) Create(c *gin.Context) {
	var in model.CreateUserInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	u, err := h.svc.Create(c.Request.Context(), in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusCreated, u)
}

// GetByID handles GET /api/v1/users/:id.
func (h *UserHandler) GetByID(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	u, err := h.svc.GetByID(c.Request.Context(), id)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, u)
}

// List handles GET /api/v1/users?page=1&page_size=20&search=budi&role_id=2.
func (h *UserHandler) List(c *gin.Context) {
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("page_size"))

	var roleID uint
	if raw := c.Query("role_id"); raw != "" {
		id, err := strconv.ParseUint(raw, 10, 64)
		if err != nil || id == 0 {
			response.Error(c, http.StatusBadRequest, "invalid_query",
				i18n.T(c.Request.Context(), i18n.KeyInvalidID, "role_id"), nil)
			return
		}
		roleID = uint(id)
	}

	users, total, used, err := h.svc.List(c.Request.Context(), model.ListUsersParams{
		Page: page, PageSize: pageSize, Search: c.Query("search"), RoleID: roleID,
	})
	if err != nil {
		writeError(c, err)
		return
	}
	response.Paginated(c, http.StatusOK, users, response.PageMeta{
		Page: used.Page, PageSize: used.PageSize, Total: total,
	})
}

// Update handles PATCH /api/v1/users/:id (partial update).
func (h *UserHandler) Update(c *gin.Context) {
	id, ok := parseID(c, "id")
	if !ok {
		return
	}
	var in model.UpdateUserInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	u, err := h.svc.Update(c.Request.Context(), id, in)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, u)
}

// Delete handles DELETE /api/v1/users/:id: soft delete + deactivate + revoke
// sessions. A user can't delete their own account (409).
func (h *UserHandler) Delete(c *gin.Context) {
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
