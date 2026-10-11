package router

import (
	"context"
	"net/http"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/handler"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
)

// rolePerms is a permission repository where each user id stands for a role:
// the real authorizer (service.AuthService.Authorize) decides on top of it,
// so the Super Admin case goes through the same code as production.
type rolePerms struct {
	byUser map[uint]model.Role // Permissions = the keys the role holds
}

func (r *rolePerms) SyncCatalog(context.Context, []model.Permission) error { return nil }
func (r *rolePerms) List(context.Context) ([]model.Permission, error)      { return nil, nil }
func (r *rolePerms) Authorize(_ context.Context, userID uint, permission string) (model.AuthzState, error) {
	role, ok := r.byUser[userID]
	if !ok {
		return model.AuthzState{}, nil
	}
	has := false
	for _, k := range role.Permissions {
		has = has || k == permission
	}
	return model.AuthzState{Found: true, IsSystem: role.IsSystem, HasPermission: has}, nil
}

// readOnlyRoles answers the two read routes so an allowed request is a 200.
type readOnlyRoles struct{ service.RoleService }

func (readOnlyRoles) List(_ context.Context, p model.ListRolesParams) ([]model.Role, int64, model.ListRolesParams, error) {
	return []model.Role{{ID: 2, Name: "Staff", Permissions: []string{}}}, 1, model.ListRolesParams{Page: 1, PageSize: 20}, nil
}

func (readOnlyRoles) GetByID(_ context.Context, id uint) (*model.Role, error) {
	return &model.Role{ID: id, Name: "Staff", Permissions: []string{}}, nil
}

// GET /roles opens for roles.view, users.create or users.update (a user
// manager needs the list for the role dropdown); GET /roles/:id — the detail
// with the permission list — stays roles.view only.
func TestRolesReadAccess(t *testing.T) {
	type caller struct {
		name        string
		role        model.Role
		wantList    int
		wantDetail  int
		wantListMsg string
	}
	callers := []caller{
		{name: "roles.view only", role: model.Role{Permissions: []string{"roles.view"}}, wantList: 200, wantDetail: 200},
		{name: "users.create only", role: model.Role{Permissions: []string{"users.create"}}, wantList: 200, wantDetail: 403},
		{name: "users.update only", role: model.Role{Permissions: []string{"users.update"}}, wantList: 200, wantDetail: 403},
		{name: "users.view only", role: model.Role{Permissions: []string{"users.view"}}, wantList: 403, wantDetail: 403,
			wantListMsg: "anda tidak punya izin roles.view / users.create / users.update"},
		{name: "users.delete only", role: model.Role{Permissions: []string{"users.delete"}}, wantList: 403, wantDetail: 403},
		{name: "no permission", role: model.Role{Permissions: []string{}}, wantList: 403, wantDetail: 403},
		{name: "Super Admin", role: model.Role{IsSystem: true}, wantList: 200, wantDetail: 200},
	}

	tokens, err := auth.NewTokens("0123456789abcdef0123456789abcdef", 15*time.Minute, time.Hour)
	require.NoError(t, err)
	perms := &rolePerms{byUser: map[uint]model.Role{}}
	tokenOf := map[string]string{}
	for i, c := range callers {
		userID := uint(100 + i)
		perms.byUser[userID] = c.role
		access, err := tokens.IssueAccess(userID, userID)
		require.NoError(t, err)
		tokenOf[c.name] = access.Token
	}

	engine := New(Handlers{
		Health:     handler.NewHealthHandler(map[string]handler.Pinger{}),
		Auth:       handler.NewAuthHandler(nil),
		User:       handler.NewUserHandler(nil),
		Role:       handler.NewRoleHandler(readOnlyRoles{}),
		Product:    handler.NewProductHandler(nil),
		Category:   handler.NewCategoryHandler(nil),
		Inventory:  handler.NewInventoryHandler(nil),
		Customer:   handler.NewCustomerHandler(nil),
		SalesOrder: handler.NewSalesOrderHandler(nil),
		Analytics:  handler.NewAnalyticsHandler(nil),
	}, Guard{Tokens: tokens, Authorizer: service.NewAuthService(nil, nil, perms, nil, nil)})

	for _, c := range callers {
		t.Run(c.name, func(t *testing.T) {
			w := serve(engine, "GET", "/api/v1/roles", tokenOf[c.name], "")
			assert.Equal(t, c.wantList, w.Code, "GET /roles: %s", w.Body.String())
			if c.wantList == 200 {
				assert.Contains(t, w.Body.String(), `"name":"Staff"`)
			}
			if c.wantListMsg != "" {
				assert.Contains(t, w.Body.String(), c.wantListMsg)
			}

			w = serve(engine, "GET", "/api/v1/roles/2", tokenOf[c.name], "")
			assert.Equal(t, c.wantDetail, w.Code, "GET /roles/2: %s", w.Body.String())
			if c.wantDetail == 403 {
				assert.Contains(t, w.Body.String(), "anda tidak punya izin roles.view\"", "detail asks for roles.view alone")
			}
		})
	}

	t.Run("no token", func(t *testing.T) {
		assert.Equal(t, http.StatusUnauthorized, serve(engine, "GET", "/api/v1/roles", "", "").Code)
	})
}
