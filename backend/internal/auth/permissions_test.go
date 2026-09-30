package auth

import (
	"context"
	"regexp"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
)

func TestCatalog(t *testing.T) {
	keyFormat := regexp.MustCompile(`^[a-z_]+\.[a-z_]+$`)
	seen := map[Permission]bool{}

	for _, def := range Catalog {
		t.Run(string(def.Key), func(t *testing.T) {
			assert.False(t, seen[def.Key], "duplicate key")
			seen[def.Key] = true

			assert.Regexp(t, keyFormat, string(def.Key), "keys are <resource>.<action>")
			assert.True(t, strings.HasPrefix(string(def.Key), def.Group+"."),
				"the group is the resource part of the key")

			// A missing translation would come back as the key itself.
			for _, lang := range i18n.Supported {
				desc := def.Description(lang)
				assert.NotEqual(t, string(i18n.PermissionDescription(string(def.Key))), desc,
					"missing %s description", lang)
				assert.NotEmpty(t, desc)
			}
		})
	}
}

func TestKnownAndAllKeys(t *testing.T) {
	assert.True(t, Known("products.view"))
	assert.True(t, Known("roles.assign_permissions"))
	assert.False(t, Known("products.explode"))
	assert.False(t, Known(""))

	keys := AllKeys()
	assert.Len(t, keys, len(Catalog))
	assert.Equal(t, "products.view", keys[0], "display order is kept")
}

func TestPrincipalContext(t *testing.T) {
	_, ok := PrincipalFrom(context.Background())
	assert.False(t, ok, "no principal outside an authenticated request")

	ctx := WithPrincipal(context.Background(), Principal{UserID: 3, RoleID: 2})
	p, ok := PrincipalFrom(ctx)
	assert.True(t, ok)
	assert.Equal(t, Principal{UserID: 3, RoleID: 2}, p)

	_, ok = PrincipalFrom(WithPrincipal(context.Background(), Principal{}))
	assert.False(t, ok, "a zero user id is not a principal")
}
