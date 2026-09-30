package router

import (
	"context"
	"fmt"
	"net/http"
	"net/http/httptest"
	"sort"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/handler"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
)

// routePermissions is the access-control contract of the API, grouped by
// resource. backend/README.md documents the same table. A route added to the
// router without a row here fails TestEveryRouteHasAnAccessDecision.
type routeRule struct {
	method, path string
	permission   auth.Permission
}

var routePermissions = []struct {
	resource string
	routes   []routeRule
}{
	{"products", []routeRule{
		{"GET", "/api/v1/products", auth.ProductsView},
		{"GET", "/api/v1/products/1", auth.ProductsView},
		{"POST", "/api/v1/products", auth.ProductsCreate},
		{"PATCH", "/api/v1/products/1", auth.ProductsUpdate},
		{"DELETE", "/api/v1/products/1", auth.ProductsDelete},
	}},
	{"categories", []routeRule{
		{"GET", "/api/v1/categories", auth.CategoriesView},
		{"GET", "/api/v1/categories/1", auth.CategoriesView},
		{"POST", "/api/v1/categories", auth.CategoriesCreate},
		{"PATCH", "/api/v1/categories/1", auth.CategoriesUpdate},
		{"DELETE", "/api/v1/categories/1", auth.CategoriesDelete},
	}},
	{"inventory", []routeRule{
		{"GET", "/api/v1/inventory/low-stock", auth.InventoryView},
		{"GET", "/api/v1/inventory/1", auth.InventoryView},
		{"GET", "/api/v1/inventory/1/movements", auth.InventoryView},
		{"PATCH", "/api/v1/inventory/1", auth.InventoryUpdate},
		{"POST", "/api/v1/inventory/1/movements", auth.InventoryRecordMovement},
	}},
	{"customers", []routeRule{
		{"GET", "/api/v1/customers", auth.CustomersView},
		{"GET", "/api/v1/customers/1", auth.CustomersView},
		{"POST", "/api/v1/customers", auth.CustomersCreate},
		{"PATCH", "/api/v1/customers/1", auth.CustomersUpdate},
		{"DELETE", "/api/v1/customers/1", auth.CustomersDelete},
	}},
	{"sales_orders", []routeRule{
		{"GET", "/api/v1/sales-orders", auth.SalesOrdersView},
		{"GET", "/api/v1/sales-orders/1", auth.SalesOrdersView},
		{"POST", "/api/v1/sales-orders", auth.SalesOrdersCreate},
		// PATCH /sales-orders/:id/status depends on the body: see TestStatusRoute.
	}},
	{"analytics", []routeRule{
		{"GET", "/api/v1/analytics/summary", auth.AnalyticsView},
		{"GET", "/api/v1/analytics/sales-trend", auth.AnalyticsView},
		{"GET", "/api/v1/analytics/top-products", auth.AnalyticsView},
		{"GET", "/api/v1/analytics/category-breakdown", auth.AnalyticsView},
		{"GET", "/api/v1/analytics/low-stock-alert-count", auth.AnalyticsView},
		{"GET", "/api/v1/analytics/forecast", auth.AnalyticsForecast},
		{"GET", "/api/v1/analytics/insights", auth.AnalyticsInsights},
	}},
	{"users", []routeRule{
		{"GET", "/api/v1/users", auth.UsersView},
		{"GET", "/api/v1/users/1", auth.UsersView},
		{"POST", "/api/v1/users", auth.UsersCreate},
		{"PATCH", "/api/v1/users/1", auth.UsersUpdate},
		{"DELETE", "/api/v1/users/1", auth.UsersDelete},
	}},
	{"roles", []routeRule{
		{"GET", "/api/v1/roles", auth.RolesView},
		{"GET", "/api/v1/roles/1", auth.RolesView},
		{"GET", "/api/v1/permissions", auth.RolesView},
		{"POST", "/api/v1/roles", auth.RolesCreate},
		{"PATCH", "/api/v1/roles/1", auth.RolesUpdate},
		{"DELETE", "/api/v1/roles/1", auth.RolesDelete},
		{"PUT", "/api/v1/roles/1/permissions", auth.RolesAssignPermissions},
	}},
}

// Routes that deliberately need no permission.
var (
	publicRoutes = map[string]bool{
		"GET /health":               true,
		"POST /api/v1/auth/login":   true,
		"POST /api/v1/auth/refresh": true,
		"POST /api/v1/auth/logout":  true,
	}
	authenticatedOnly = map[string]bool{
		"GET /api/v1/auth/me":                   true,
		"PATCH /api/v1/sales-orders/:id/status": true, // permission chosen from the body
	}
)

// denyAll refuses everything and records what was asked. With it, a
// protected route never reaches its handler, so the handlers can be built
// with nil services.
type denyAll struct {
	mu    sync.Mutex
	asked []auth.Permission
}

func (d *denyAll) Authorize(_ context.Context, _ uint, p auth.Permission) error {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.asked = append(d.asked, p)
	return fmt.Errorf("%w: anda tidak punya izin %s", service.ErrForbidden, p)
}

func (d *denyAll) reset() []auth.Permission {
	d.mu.Lock()
	defer d.mu.Unlock()
	asked := d.asked
	d.asked = nil
	return asked
}

func testEngine(t *testing.T) (*gin.Engine, *denyAll, string) {
	t.Helper()
	gin.SetMode(gin.TestMode)
	tokens, err := auth.NewTokens("0123456789abcdef0123456789abcdef", 15*time.Minute, time.Hour)
	require.NoError(t, err)
	access, err := tokens.IssueAccess(7, 2)
	require.NoError(t, err)

	authz := &denyAll{}
	engine := New(Handlers{
		Health:     handler.NewHealthHandler(map[string]handler.Pinger{}),
		Auth:       handler.NewAuthHandler(nil),
		User:       handler.NewUserHandler(nil),
		Role:       handler.NewRoleHandler(nil),
		Product:    handler.NewProductHandler(nil),
		Category:   handler.NewCategoryHandler(nil),
		Inventory:  handler.NewInventoryHandler(nil),
		Customer:   handler.NewCustomerHandler(nil),
		SalesOrder: handler.NewSalesOrderHandler(nil),
		Analytics:  handler.NewAnalyticsHandler(nil),
	}, Guard{Tokens: tokens, Authorizer: authz})
	return engine, authz, access.Token
}

func serve(engine *gin.Engine, method, path, token, body string) *httptest.ResponseRecorder {
	req := httptest.NewRequest(method, path, strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	if token != "" {
		req.Header.Set("Authorization", "Bearer "+token)
	}
	w := httptest.NewRecorder()
	engine.ServeHTTP(w, req)
	return w
}

func TestRoutePermissions(t *testing.T) {
	engine, authz, token := testEngine(t)

	for _, group := range routePermissions {
		t.Run(group.resource, func(t *testing.T) {
			for _, rt := range group.routes {
				name := rt.method + " " + rt.path
				t.Run(name+" without a token → 401", func(t *testing.T) {
					w := serve(engine, rt.method, rt.path, "", "{}")
					assert.Equal(t, http.StatusUnauthorized, w.Code, w.Body.String())
					assert.Empty(t, authz.reset(), "no permission lookup without a token")
				})
				t.Run(name+" checks "+string(rt.permission), func(t *testing.T) {
					w := serve(engine, rt.method, rt.path, token, "{}")
					assert.Equal(t, http.StatusForbidden, w.Code, w.Body.String())
					assert.Equal(t, []auth.Permission{rt.permission}, authz.reset())
				})
			}
		})
	}
}

func TestStatusRoute(t *testing.T) {
	engine, authz, token := testEngine(t)
	tests := []struct {
		body string
		want []auth.Permission
	}{
		{`{"status":"CONFIRMED"}`, []auth.Permission{auth.SalesOrdersConfirm}},
		{`{"status":"SHIPPED"}`, []auth.Permission{auth.SalesOrdersShip}},
		{`{"status":"CANCELLED"}`, []auth.Permission{auth.SalesOrdersCancel}},
		{`{"status":"PENDING"}`, []auth.Permission{auth.SalesOrdersConfirm, auth.SalesOrdersShip, auth.SalesOrdersCancel}},
	}
	for _, tt := range tests {
		t.Run(tt.body, func(t *testing.T) {
			assert.Equal(t, http.StatusUnauthorized, serve(engine, "PATCH", "/api/v1/sales-orders/1/status", "", tt.body).Code)
			w := serve(engine, "PATCH", "/api/v1/sales-orders/1/status", token, tt.body)
			assert.Equal(t, http.StatusForbidden, w.Code)
			assert.Equal(t, tt.want, authz.reset())
		})
	}
}

func TestPublicAndAuthenticatedOnlyRoutes(t *testing.T) {
	engine, authz, _ := testEngine(t)

	t.Run("login, refresh and logout need no token", func(t *testing.T) {
		for _, path := range []string{"/api/v1/auth/login", "/api/v1/auth/refresh", "/api/v1/auth/logout"} {
			// Bad JSON is rejected by the handler (400), which proves the
			// request got past any auth check to the handler itself.
			w := serve(engine, "POST", path, "", "{bad")
			assert.Equal(t, http.StatusBadRequest, w.Code, path)
		}
		assert.Empty(t, authz.reset())
	})

	t.Run("/auth/me needs a token but no permission", func(t *testing.T) {
		assert.Equal(t, http.StatusUnauthorized, serve(engine, "GET", "/api/v1/auth/me", "", "").Code)
	})

	t.Run("/health stays public", func(t *testing.T) {
		assert.Equal(t, http.StatusOK, serve(engine, "GET", "/health", "", "").Code)
	})
}

// TestEveryRouteHasAnAccessDecision fails when a route exists that is in
// none of the tables above — a new endpoint must be given a permission (or
// be declared public) on purpose.
func TestEveryRouteHasAnAccessDecision(t *testing.T) {
	engine, _, _ := testEngine(t)

	covered := map[string]bool{}
	for k := range publicRoutes {
		covered[k] = true
	}
	for k := range authenticatedOnly {
		covered[k] = true
	}
	for _, group := range routePermissions {
		for _, rt := range group.routes {
			covered[rt.method+" "+pattern(rt.path)] = true
		}
	}

	var missing []string
	for _, r := range engine.Routes() {
		if key := r.Method + " " + r.Path; !covered[key] {
			missing = append(missing, key)
		}
	}
	sort.Strings(missing)
	assert.Empty(t, missing, "routes without an access decision in router_test.go")
	assert.Len(t, engine.Routes(), len(covered), "every row in the tables is a real route")
}

// pattern turns a concrete test path back into the route pattern.
func pattern(path string) string {
	replacer := strings.NewReplacer(
		"/inventory/1", "/inventory/:product_id",
		"/products/1", "/products/:id", "/categories/1", "/categories/:id",
		"/customers/1", "/customers/:id", "/sales-orders/1", "/sales-orders/:id",
		"/users/1", "/users/:id", "/roles/1", "/roles/:id",
	)
	return replacer.Replace(path)
}
