package handler

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
)

const testSecret = "0123456789abcdef0123456789abcdef"

// fakeAuthorizer answers with decide and records every permission asked for.
type fakeAuthorizer struct {
	mu     sync.Mutex
	asked  []auth.Permission
	decide func(p auth.Permission) error
}

func (f *fakeAuthorizer) Authorize(_ context.Context, _ uint, p auth.Permission) error {
	f.mu.Lock()
	f.asked = append(f.asked, p)
	f.mu.Unlock()
	if f.decide == nil {
		return nil
	}
	return f.decide(p)
}

func forbidden(p auth.Permission) error {
	return fmt.Errorf("%w: anda tidak punya izin %s", service.ErrForbidden, p)
}

type errorBody struct {
	Error struct {
		Code    string `json:"code"`
		Message string `json:"message"`
	} `json:"error"`
}

func decodeError(t *testing.T, w *httptest.ResponseRecorder) errorBody {
	t.Helper()
	var body errorBody
	require.NoError(t, json.Unmarshal(w.Body.Bytes(), &body), w.Body.String())
	return body
}

func testTokens(t *testing.T, now time.Time) *auth.Tokens {
	t.Helper()
	tokens, err := auth.NewTokens(testSecret, 15*time.Minute, 168*time.Hour)
	require.NoError(t, err)
	return tokens.WithClock(func() time.Time { return now })
}

func TestAuthenticate(t *testing.T) {
	gin.SetMode(gin.TestMode)
	now := time.Date(2026, 9, 26, 10, 0, 0, 0, time.UTC)
	tokens := testTokens(t, now)

	access, err := tokens.IssueAccess(7, 2)
	require.NoError(t, err)
	refresh, err := tokens.IssueRefresh(7, 2)
	require.NoError(t, err)
	other, err := auth.NewTokens(strings.Repeat("z", 32), time.Minute, time.Hour)
	require.NoError(t, err)
	forged, err := other.IssueAccess(7, 1)
	require.NoError(t, err)

	tests := []struct {
		name     string
		header   string
		verifier *auth.Tokens
		lang     string
		wantCode int
		wantErr  string // response code, "" for success
		wantMsg  string
	}{
		{name: "valid token", header: "Bearer " + access.Token, verifier: tokens, wantCode: 200},
		{name: "scheme is case-insensitive", header: "bearer " + access.Token, verifier: tokens, wantCode: 200},
		{name: "no header", header: "", verifier: tokens, wantCode: 401, wantErr: "unauthorized", wantMsg: "wajib login"},
		{name: "no header, English", header: "", verifier: tokens, lang: "en", wantCode: 401, wantErr: "unauthorized", wantMsg: "authentication required"},
		{name: "basic auth", header: "Basic dXNlcjpwYXNz", verifier: tokens, wantCode: 401, wantErr: "unauthorized", wantMsg: "tidak valid"},
		{name: "bearer without a token", header: "Bearer   ", verifier: tokens, wantCode: 401, wantErr: "unauthorized"},
		{name: "garbage token", header: "Bearer abc.def.ghi", verifier: tokens, wantCode: 401, wantErr: "unauthorized"},
		{name: "signed with another secret", header: "Bearer " + forged.Token, verifier: tokens, wantCode: 401, wantErr: "unauthorized"},
		{name: "refresh token used as access token", header: "Bearer " + refresh.Token, verifier: tokens, wantCode: 401, wantErr: "unauthorized"},
		{
			name: "expired: a distinct code so the client knows to refresh", header: "Bearer " + access.Token,
			verifier: tokens.WithClock(func() time.Time { return now.Add(16 * time.Minute) }),
			wantCode: 401, wantErr: "token_expired", wantMsg: "kedaluwarsa",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			r := gin.New()
			r.Use(func(c *gin.Context) { // what router.language() does
				c.Request = c.Request.WithContext(i18n.WithLang(c.Request.Context(), i18n.Parse(c.GetHeader("Accept-Language"))))
			})
			var seen auth.Principal
			r.GET("/x", Authenticate(tt.verifier), func(c *gin.Context) {
				seen, _ = auth.PrincipalFrom(c.Request.Context())
				c.Status(http.StatusOK)
			})

			req := httptest.NewRequest(http.MethodGet, "/x", nil)
			if tt.header != "" {
				req.Header.Set("Authorization", tt.header)
			}
			if tt.lang != "" {
				req.Header.Set("Accept-Language", tt.lang)
			}
			w := httptest.NewRecorder()
			r.ServeHTTP(w, req)

			require.Equal(t, tt.wantCode, w.Code, w.Body.String())
			if tt.wantErr == "" {
				assert.Equal(t, auth.Principal{UserID: 7, RoleID: 2}, seen, "the caller is in the context")
				return
			}
			body := decodeError(t, w)
			assert.Equal(t, tt.wantErr, body.Error.Code)
			assert.Contains(t, body.Error.Message, tt.wantMsg)
			assert.Equal(t, `Bearer realm="api"`, w.Header().Get("WWW-Authenticate"))
			assert.Zero(t, seen, "the handler never ran")
		})
	}
}

// withPrincipal stands in for Authenticate in the permission tests.
func withPrincipal(c *gin.Context) {
	c.Request = c.Request.WithContext(auth.WithPrincipal(c.Request.Context(), auth.Principal{UserID: 7, RoleID: 2}))
}

func TestRequirePermission(t *testing.T) {
	gin.SetMode(gin.TestMode)
	tests := []struct {
		name     string
		decision error
		wantCode int
		wantErr  string
	}{
		{name: "allowed", decision: nil, wantCode: 200},
		{name: "role lacks the permission", decision: forbidden(auth.ProductsDelete), wantCode: 403, wantErr: "forbidden"},
		{name: "user deactivated since login", decision: fmt.Errorf("%w: akun ini tidak aktif", service.ErrUnauthorized), wantCode: 401, wantErr: "unauthorized"},
		{name: "database down", decision: errors.New("connection refused"), wantCode: 500, wantErr: "internal_error"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			authz := &fakeAuthorizer{decide: func(auth.Permission) error { return tt.decision }}
			handlerRan := false
			r := gin.New()
			r.DELETE("/x", withPrincipal, RequirePermission(authz, auth.ProductsDelete), func(c *gin.Context) {
				handlerRan = true
				c.Status(http.StatusOK)
			})

			w := httptest.NewRecorder()
			r.ServeHTTP(w, httptest.NewRequest(http.MethodDelete, "/x", nil))

			assert.Equal(t, tt.wantCode, w.Code, w.Body.String())
			assert.Equal(t, []auth.Permission{auth.ProductsDelete}, authz.asked)
			assert.Equal(t, tt.wantErr == "", handlerRan, "the handler runs only when allowed")
			if tt.wantErr != "" {
				assert.Equal(t, tt.wantErr, decodeError(t, w).Error.Code)
			}
		})
	}

	t.Run("without Authenticate in front it refuses instead of allowing", func(t *testing.T) {
		authz := &fakeAuthorizer{}
		r := gin.New()
		r.GET("/x", RequirePermission(authz, auth.ProductsView), func(c *gin.Context) { c.Status(http.StatusOK) })
		w := httptest.NewRecorder()
		r.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/x", nil))
		assert.Equal(t, http.StatusUnauthorized, w.Code)
		assert.Empty(t, authz.asked)
	})
}

func TestRequireStatusPermission(t *testing.T) {
	gin.SetMode(gin.TestMode)
	anyOfThree := []auth.Permission{auth.SalesOrdersConfirm, auth.SalesOrdersShip, auth.SalesOrdersCancel}

	tests := []struct {
		name      string
		body      string
		holds     []auth.Permission
		wantAsked []auth.Permission
		wantCode  int
	}{
		{"confirm needs sales_orders.confirm", `{"status":"CONFIRMED"}`, []auth.Permission{auth.SalesOrdersConfirm}, []auth.Permission{auth.SalesOrdersConfirm}, 200},
		{"status is case-insensitive", `{"status":" shipped "}`, []auth.Permission{auth.SalesOrdersShip}, []auth.Permission{auth.SalesOrdersShip}, 200},
		{"cancel needs sales_orders.cancel", `{"status":"CANCELLED"}`, []auth.Permission{auth.SalesOrdersCancel}, []auth.Permission{auth.SalesOrdersCancel}, 200},
		{"may ship but not confirm", `{"status":"CONFIRMED"}`, []auth.Permission{auth.SalesOrdersShip}, []auth.Permission{auth.SalesOrdersConfirm}, 403},
		{"an invalid target needs any one of the three", `{"status":"PENDING"}`, []auth.Permission{auth.SalesOrdersCancel}, anyOfThree, 200},
		{"bad JSON with none of them", `{bad`, nil, anyOfThree, 403},
		{"no body with only confirm", ``, []auth.Permission{auth.SalesOrdersConfirm}, []auth.Permission{auth.SalesOrdersConfirm}, 200},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			authz := &fakeAuthorizer{decide: func(p auth.Permission) error {
				for _, held := range tt.holds {
					if held == p {
						return nil
					}
				}
				return forbidden(p)
			}}
			var bound model.UpdateOrderStatusInput
			r := gin.New()
			r.PATCH("/orders/:id/status", withPrincipal, RequireStatusPermission(authz), func(c *gin.Context) {
				// The handler binds the body again, as SalesOrderHandler does.
				_ = c.ShouldBindBodyWith(&bound, binding.JSON)
				c.Status(http.StatusOK)
			})

			w := httptest.NewRecorder()
			req := httptest.NewRequest(http.MethodPatch, "/orders/1/status", strings.NewReader(tt.body))
			req.Header.Set("Content-Type", "application/json")
			r.ServeHTTP(w, req)

			assert.Equal(t, tt.wantCode, w.Code, w.Body.String())
			assert.Equal(t, tt.wantAsked, authz.asked)
			if w.Code == http.StatusOK && strings.Contains(tt.body, "status") {
				assert.NotEmpty(t, bound.Status, "the handler still reads the body the middleware consumed")
			}
		})
	}

	t.Run("a 401 stops the any-of search", func(t *testing.T) {
		authz := &fakeAuthorizer{decide: func(auth.Permission) error {
			return fmt.Errorf("%w: akun ini tidak aktif", service.ErrUnauthorized)
		}}
		r := gin.New()
		r.PATCH("/orders/:id/status", withPrincipal, RequireStatusPermission(authz), func(c *gin.Context) { c.Status(200) })
		w := httptest.NewRecorder()
		r.ServeHTTP(w, httptest.NewRequest(http.MethodPatch, "/orders/1/status", strings.NewReader(`{}`)))
		assert.Equal(t, http.StatusUnauthorized, w.Code)
		assert.Len(t, authz.asked, 1)
	})
}
