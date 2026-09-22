package i18n

import (
	"context"
	"regexp"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestParse(t *testing.T) {
	tests := []struct {
		name   string
		header string
		want   Lang
	}{
		{"empty header falls back to the default", "", ID},
		{"plain id", "id", ID},
		{"plain en", "en", EN},
		{"case insensitive", "EN", EN},
		{"regional tag", "en-US", EN},
		{"regional Indonesian", "id-ID", ID},
		{"browser list, English first", "en-US,en;q=0.9,id;q=0.8", EN},
		{"browser list, Indonesian first", "id-ID,id;q=0.9,en-US;q=0.8", ID},
		{"quality decides, not order", "id;q=0.3,en;q=0.9", EN},
		{"unsupported language", "fr-FR,de;q=0.8", ID},
		{"unsupported first, supported second", "fr,en;q=0.5", EN},
		{"wildcard only", "*", ID},
		{"zero quality is a refusal", "en;q=0", ID},
		{"whitespace and empty parts", " en ,, ", EN},
		{"nonsense", "???", ID},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			assert.Equal(t, tt.want, Parse(tt.header))
		})
	}
}

func TestContext(t *testing.T) {
	t.Run("default outside a request", func(t *testing.T) {
		assert.Equal(t, Default, FromContext(context.Background()))
	})

	t.Run("round trip", func(t *testing.T) {
		ctx := WithLang(context.Background(), EN)
		assert.Equal(t, EN, FromContext(ctx))
	})

	t.Run("an unknown language is stored as the default", func(t *testing.T) {
		ctx := WithLang(context.Background(), Lang("fr"))
		assert.Equal(t, Default, FromContext(ctx))
	})
}

func TestTranslate(t *testing.T) {
	t.Run("both languages, with interpolation", func(t *testing.T) {
		assert.Equal(t, "stok tidak cukup: tersedia 3, diminta 10",
			Translate(KeyInsufficientStock, ID, 3, 10))
		assert.Equal(t, "insufficient stock: 3 available, 10 requested",
			Translate(KeyInsufficientStock, EN, 3, 10))
	})

	t.Run("T reads the language from the context", func(t *testing.T) {
		assert.Equal(t, "wajib diisi", T(context.Background(), KeyRequired))
		assert.Equal(t, "is required", T(WithLang(context.Background(), EN), KeyRequired))
	})

	t.Run("an unknown language falls back to the default", func(t *testing.T) {
		assert.Equal(t, Translate(KeyRequired, ID), Translate(KeyRequired, Lang("fr")))
	})

	t.Run("an unknown key is returned as itself, never empty", func(t *testing.T) {
		assert.Equal(t, "field.nope", Translate(Key("field.nope"), EN))
	})
}

// The catalog is the contract: a key that exists in one language and not the
// other would ship a half-translated API, and a template whose placeholders
// disagree between languages would render "%!d(MISSING)" to a user.
func TestCatalogIsComplete(t *testing.T) {
	placeholder := regexp.MustCompile(`%(?:\[\d+\])?[a-zA-Z]`)

	for key, translations := range catalog {
		t.Run(string(key), func(t *testing.T) {
			for _, lang := range Supported {
				text, ok := translations[lang]
				require.Truef(t, ok, "missing %s translation", lang)
				assert.NotEmpty(t, strings.TrimSpace(text))
			}
			assert.Equal(t,
				len(placeholder.FindAllString(translations[ID], -1)),
				len(placeholder.FindAllString(translations[EN], -1)),
				"both languages must take the same number of arguments")
		})
	}
}
