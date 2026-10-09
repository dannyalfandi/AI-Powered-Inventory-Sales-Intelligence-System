package handler

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
)

// fakeRoleService returns fixed roles; only the read methods are used.
type fakeRoleService struct {
	service.RoleService // nil: any other method panics, which a test would show
	roles               []model.Role
}

func (f *fakeRoleService) GetByID(_ context.Context, id uint) (*model.Role, error) {
	for i := range f.roles {
		if f.roles[i].ID == id {
			r := f.roles[i]
			return &r, nil
		}
	}
	return nil, fmt.Errorf("%w: role %d tidak ditemukan", service.ErrNotFound, id)
}

func (f *fakeRoleService) List(_ context.Context, p model.ListRolesParams) ([]model.Role, int64, model.ListRolesParams, error) {
	p.Page, p.PageSize = 1, 20
	return f.roles, int64(len(f.roles)), p, nil
}

func count(n int64) *int64 { return &n }

var handlerRoles = []model.Role{
	{ID: 1, Name: "Super Admin", IsSystem: true, UserCount: count(1), Permissions: []string{"products.view"}},
	{ID: 2, Name: "Staff", UserCount: count(3), Permissions: []string{"products.view"}},
	{ID: 7, Name: "Kosong", UserCount: count(0), Permissions: []string{}},
}

// The contract Flutter reads: user_count is a snake_case integer on every
// role, in the same envelope as before ({"data": ...} / {"data", "meta"}),
// and present even when it is 0.
func TestRoleHandler_UserCountInJSON(t *testing.T) {
	gin.SetMode(gin.TestMode)
	h := NewRoleHandler(&fakeRoleService{roles: handlerRoles})
	r := gin.New()
	r.GET("/roles", h.List)
	r.GET("/roles/:id", h.GetByID)

	tests := []struct {
		name      string
		path      string
		wantCount []float64 // user_count of each role in data, in order
	}{
		{"list", "/roles", []float64{1, 3, 0}},
		{"detail", "/roles/2", []float64{3}},
		{"detail with 0 users still has the field", "/roles/7", []float64{0}},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			w := httptest.NewRecorder()
			r.ServeHTTP(w, httptest.NewRequest(http.MethodGet, tt.path, nil))
			require.Equal(t, http.StatusOK, w.Code, w.Body.String())

			var env map[string]json.RawMessage
			require.NoError(t, json.Unmarshal(w.Body.Bytes(), &env))
			var items []map[string]any
			if strings.HasPrefix(string(env["data"]), "[") {
				require.NoError(t, json.Unmarshal(env["data"], &items))
				assert.JSONEq(t, `{"page":1,"page_size":20,"total":3}`, string(env["meta"]), "same pagination envelope")
			} else {
				var one map[string]any
				require.NoError(t, json.Unmarshal(env["data"], &one))
				items = []map[string]any{one}
				assert.NotContains(t, env, "meta")
			}

			got := make([]float64, len(items))
			for i, item := range items {
				require.Contains(t, item, "user_count", "snake_case, never omitted")
				got[i] = item["user_count"].(float64)
				assert.NotContains(t, item, "UserCount")
				assert.Contains(t, item, "permissions", "the list still carries permissions")
			}
			assert.Equal(t, tt.wantCount, got)
		})
	}
}

// A role inside a user (GET /users, PATCH /users/:id) is loaded without
// the count; it must not show a false "user_count": 0.
func TestUserJSON_EmbeddedRoleHasNoUserCount(t *testing.T) {
	u := model.User{ID: 7, Email: "staff@example.com", RoleID: 2, Role: &model.Role{ID: 2, Name: "Staff"}}
	b, err := json.Marshal(u)
	require.NoError(t, err)
	var got struct {
		Role map[string]any `json:"role"`
	}
	require.NoError(t, json.Unmarshal(b, &got))
	assert.Equal(t, "Staff", got.Role["name"])
	assert.NotContains(t, got.Role, "user_count")
}

// fakeUserService answers Update and Delete with a fixed error.
type fakeUserService struct {
	service.UserService
	err error
}

func (f *fakeUserService) Create(context.Context, model.CreateUserInput) (*model.User, error) {
	return nil, f.err
}

func (f *fakeUserService) Update(context.Context, uint, model.UpdateUserInput) (*model.User, error) {
	return nil, f.err
}

func (f *fakeUserService) Delete(context.Context, uint) error { return f.err }

// The scope refusals reach the client as an ordinary 403: code "forbidden"
// and the translated sentence. The i18n key itself is not in the envelope.
func TestUserHandler_ScopeRefusalsAre403(t *testing.T) {
	gin.SetMode(gin.TestMode)
	tests := []struct {
		name, method, path, body, lang string
		key                            i18n.Key
		args                           []any
		wantMsg                        string
	}{
		{"create with a stronger role", "POST", "/users", `{}`, "id",
			i18n.KeyRoleExceedsOwnPermissions, []any{"Power", "products.delete"},
			`tidak bisa memberikan role "Power" karena role itu punya izin "products.delete" yang tidak anda miliki sendiri`},
		{"reset password of a stronger user", "PATCH", "/users/12", `{"password":"x"}`, "en",
			i18n.KeyUserRoleExceedsOwnPermissions, []any{"Power", "products.delete"},
			`you can't change or delete a user with the "Power" role because it has the "products.delete" permission, which you don't hold yourself`},
		{"delete a stronger user", "DELETE", "/users/12", ``, "id",
			i18n.KeyUserRoleExceedsOwnPermissions, []any{"Power", "products.delete"},
			`tidak bisa mengubah atau menghapus pengguna dengan role "Power" karena role itu punya izin "products.delete" yang tidak anda miliki sendiri`},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			lang := i18n.Parse(tt.lang)
			err := fmt.Errorf("%w: %s", service.ErrForbidden, i18n.Translate(tt.key, lang, tt.args...))
			h := NewUserHandler(&fakeUserService{err: err})
			r := gin.New()
			r.POST("/users", h.Create)
			r.PATCH("/users/:id", h.Update)
			r.DELETE("/users/:id", h.Delete)

			req := httptest.NewRequest(tt.method, tt.path, strings.NewReader(tt.body))
			req.Header.Set("Content-Type", "application/json")
			w := httptest.NewRecorder()
			r.ServeHTTP(w, req)

			assert.Equal(t, http.StatusForbidden, w.Code, w.Body.String())
			body := decodeError(t, w)
			assert.Equal(t, "forbidden", body.Error.Code)
			assert.Equal(t, tt.wantMsg, body.Error.Message)
		})
	}
}
