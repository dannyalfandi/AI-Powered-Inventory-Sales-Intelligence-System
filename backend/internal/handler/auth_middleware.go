package handler

import (
	"errors"
	"fmt"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
)

// TokenParser verifies a signed token. *auth.Tokens implements it.
type TokenParser interface {
	Parse(token string, want auth.TokenType) (*auth.Claims, error)
}

// Authenticate requires a valid access token in "Authorization: Bearer
// <token>" and puts the caller (user id + role id) in the request context.
//
// It checks the signature and the expiry only — no database. Whether the
// user may still act, and with which permissions, is decided per route by
// RequirePermission, against the database.
//
//	no header                    → 401 unauthorized
//	not "Bearer <token>", forged → 401 unauthorized
//	expired                      → 401 token_expired (the client should refresh)
func Authenticate(tokens TokenParser) gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx := c.Request.Context()
		header := strings.TrimSpace(c.GetHeader("Authorization"))
		if header == "" {
			writeError(c, authFailure(c, service.ErrUnauthorized, i18n.KeyAuthMissingToken))
			return
		}
		scheme, token, ok := strings.Cut(header, " ")
		token = strings.TrimSpace(token)
		if !ok || !strings.EqualFold(scheme, "Bearer") || token == "" {
			writeError(c, authFailure(c, service.ErrUnauthorized, i18n.KeyAuthInvalidToken))
			return
		}

		claims, err := tokens.Parse(token, auth.AccessToken)
		switch {
		case errors.Is(err, auth.ErrTokenExpired):
			writeError(c, authFailure(c, service.ErrTokenExpired, i18n.KeyAuthTokenExpired))
			return
		case err != nil:
			writeError(c, authFailure(c, service.ErrUnauthorized, i18n.KeyAuthInvalidToken))
			return
		}

		c.Request = c.Request.WithContext(auth.WithPrincipal(ctx,
			auth.Principal{UserID: claims.UserID, RoleID: claims.RoleID}))
		c.Next()
	}
}

// RequirePermission lets the request through only if the caller's current
// role grants permission (a Super Admin always passes). It must run after
// Authenticate. The check goes to the database on every request — see
// service.Authorizer for why it is not cached.
//
//	role lacks the permission          → 403 forbidden
//	user deactivated/deleted since login → 401 unauthorized
func RequirePermission(authz service.Authorizer, permission auth.Permission) gin.HandlerFunc {
	return func(c *gin.Context) {
		p, ok := auth.PrincipalFrom(c.Request.Context())
		if !ok {
			// Only reachable if a route is wired without Authenticate.
			writeError(c, authFailure(c, service.ErrUnauthorized, i18n.KeyAuthMissingToken))
			return
		}
		if err := authz.Authorize(c.Request.Context(), p.UserID, permission); err != nil {
			writeError(c, err)
			return
		}
		c.Next()
	}
}

// statusPermissions maps a sales order's target status to the permission the
// transition needs. PATCH /sales-orders/:id/status is one route for three
// different actions, and "may confirm" (takes stock) is not "may cancel".
var statusPermissions = map[model.OrderStatus]auth.Permission{
	model.OrderConfirmed: auth.SalesOrdersConfirm,
	model.OrderShipped:   auth.SalesOrdersShip,
	model.OrderCancelled: auth.SalesOrdersCancel,
}

// RequireStatusPermission is RequirePermission for the status route: it reads
// "status" from the body to pick the permission. A body that names no valid
// target (missing, PENDING, a typo, bad JSON) needs any one of the three —
// enough to be told by the handler what is wrong with the request, and never
// enough to change anything, because the handler rejects it.
func RequireStatusPermission(authz service.Authorizer) gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx := c.Request.Context()
		p, ok := auth.PrincipalFrom(ctx)
		if !ok {
			writeError(c, authFailure(c, service.ErrUnauthorized, i18n.KeyAuthMissingToken))
			return
		}

		var body model.UpdateOrderStatusInput
		// The body is cached in the context, so the handler can bind it again.
		_ = c.ShouldBindBodyWith(&body, binding.JSON)
		target := model.OrderStatus(strings.ToUpper(strings.TrimSpace(body.Status)))

		if permission, ok := statusPermissions[target]; ok {
			if err := authz.Authorize(ctx, p.UserID, permission); err != nil {
				writeError(c, err)
				return
			}
			c.Next()
			return
		}

		for _, permission := range []auth.Permission{auth.SalesOrdersConfirm, auth.SalesOrdersShip, auth.SalesOrdersCancel} {
			err := authz.Authorize(ctx, p.UserID, permission)
			if err == nil {
				c.Next()
				return
			}
			if !errors.Is(err, service.ErrForbidden) {
				writeError(c, err) // 401 or a database error: no point trying the others
				return
			}
		}
		writeError(c, fmt.Errorf("%w: %s", service.ErrForbidden, i18n.T(ctx, i18n.KeyAuthForbidden,
			"sales_orders.confirm / sales_orders.ship / sales_orders.cancel")))
	}
}

// authFailure builds a service-style error ("<sentinel>: <message>") in the
// request's language, for writeError to map.
func authFailure(c *gin.Context, sentinel error, key i18n.Key) error {
	return fmt.Errorf("%w: %s", sentinel, i18n.T(c.Request.Context(), key))
}
