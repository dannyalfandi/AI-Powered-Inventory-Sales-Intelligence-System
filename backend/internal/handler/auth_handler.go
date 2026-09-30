package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type AuthHandler struct {
	svc service.AuthService
}

func NewAuthHandler(svc service.AuthService) *AuthHandler {
	return &AuthHandler{svc: svc}
}

// Login handles POST /api/v1/auth/login (public).
func (h *AuthHandler) Login(c *gin.Context) {
	var in model.LoginInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	pair, err := h.svc.Login(c.Request.Context(), in)
	if err != nil {
		writeError(c, err)
		return
	}
	noStore(c)
	response.OK(c, http.StatusOK, pair)
}

// Refresh handles POST /api/v1/auth/refresh (public; the refresh token is
// the credential).
func (h *AuthHandler) Refresh(c *gin.Context) {
	var in model.RefreshInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	pair, err := h.svc.Refresh(c.Request.Context(), in)
	if err != nil {
		writeError(c, err)
		return
	}
	noStore(c)
	response.OK(c, http.StatusOK, pair)
}

// Logout handles POST /api/v1/auth/logout (public; revokes the refresh token
// in the body).
func (h *AuthHandler) Logout(c *gin.Context) {
	var in model.RefreshInput
	if err := c.ShouldBindJSON(&in); err != nil {
		writeInvalidBody(c, err)
		return
	}
	if err := h.svc.Logout(c.Request.Context(), in); err != nil {
		writeError(c, err)
		return
	}
	c.Status(http.StatusNoContent)
}

// Me handles GET /api/v1/auth/me (any authenticated user).
func (h *AuthHandler) Me(c *gin.Context) {
	me, err := h.svc.Me(c.Request.Context())
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, me)
}

// noStore keeps tokens out of shared and browser caches (RFC 6749 §5.1).
func noStore(c *gin.Context) {
	c.Header("Cache-Control", "no-store")
	c.Header("Pragma", "no-cache")
}
