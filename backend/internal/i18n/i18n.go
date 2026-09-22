// Package i18n renders the messages this API sends to clients in Indonesian
// or English, chosen per request from the Accept-Language header.
//
// How it fits together:
//
//	router      → Middleware() reads Accept-Language and puts the language in
//	              the request context.
//	service     → builds messages with T(ctx, key, args...); it never writes a
//	              user-facing sentence as a literal.
//	handler     → same, for the envelope ("request validation failed", …).
//
// The language travels in the context rather than in every service signature:
// it is request-scoped data, every service method already takes a ctx, and
// that keeps the business logic free of a parameter it would only pass on.
//
// Only sentences are translated. Field names (`category_id`, `items[0].quantity`),
// codes (`validation_failed`), SKUs, product names and numbers are data and
// stay exactly as they are, so clients can keep matching on them.
package i18n

import (
	"context"
	"fmt"
	"sort"
	"strconv"
	"strings"
)

// Lang is a supported language tag.
type Lang string

const (
	ID Lang = "id"
	EN Lang = "en"
	// Default is what an unknown or missing Accept-Language gets. Indonesian,
	// because that is what existing clients (the Flutter app) expect.
	Default = ID
)

// Supported lists the languages the catalog covers.
var Supported = []Lang{ID, EN}

func (l Lang) valid() bool {
	return l == ID || l == EN
}

// Parse picks a language from an Accept-Language header value.
//
// It understands the usual forms — "en", "en-US", "id-ID,id;q=0.9,en;q=0.8",
// "*" — and falls back to [Default] for anything it does not recognise, so a
// client that sends no header (or a language we do not have) keeps working.
func Parse(header string) Lang {
	type candidate struct {
		lang    Lang
		quality float64
		order   int
	}

	var candidates []candidate
	for i, part := range strings.Split(header, ",") {
		tag, quality := parseTag(part)
		if tag == "" {
			continue
		}
		// "en-US" and "en" are the same language to us.
		base := Lang(strings.ToLower(strings.SplitN(tag, "-", 2)[0]))
		if !base.valid() {
			continue
		}
		candidates = append(candidates, candidate{lang: base, quality: quality, order: i})
	}
	if len(candidates) == 0 {
		return Default
	}
	// Highest q wins; ties keep the order the client wrote them in.
	sort.SliceStable(candidates, func(i, j int) bool {
		if candidates[i].quality != candidates[j].quality {
			return candidates[i].quality > candidates[j].quality
		}
		return candidates[i].order < candidates[j].order
	})
	if candidates[0].quality <= 0 { // "en;q=0" means "not English"
		return Default
	}
	return candidates[0].lang
}

// parseTag splits one Accept-Language entry into its tag and quality.
func parseTag(part string) (string, float64) {
	fields := strings.Split(strings.TrimSpace(part), ";")
	tag := strings.TrimSpace(fields[0])
	if tag == "" || tag == "*" {
		return "", 0
	}
	quality := 1.0
	for _, field := range fields[1:] {
		field = strings.TrimSpace(field)
		if value, ok := strings.CutPrefix(field, "q="); ok {
			if parsed, err := strconv.ParseFloat(strings.TrimSpace(value), 64); err == nil {
				quality = parsed
			}
		}
	}
	return tag, quality
}

// --- request context -------------------------------------------------------

type contextKey struct{}

// WithLang returns a context carrying lang. Unknown languages become [Default].
func WithLang(ctx context.Context, lang Lang) context.Context {
	if !lang.valid() {
		lang = Default
	}
	return context.WithValue(ctx, contextKey{}, lang)
}

// FromContext is the language of the current request, or [Default] outside one.
func FromContext(ctx context.Context) Lang {
	if lang, ok := ctx.Value(contextKey{}).(Lang); ok && lang.valid() {
		return lang
	}
	return Default
}

// --- rendering -------------------------------------------------------------

// T renders key in the language of ctx. It is the form service and handler
// code uses; see [Translate] when the language is already known.
func T(ctx context.Context, key Key, args ...any) string {
	return Translate(key, FromContext(ctx), args...)
}

// Translate renders key in lang, interpolating args into the template.
//
// A key that is missing entirely returns the key itself: a visible, greppable
// string rather than an empty message, and the catalog test makes sure that
// cannot happen for keys that exist in code.
func Translate(key Key, lang Lang, args ...any) string {
	if !lang.valid() {
		lang = Default
	}
	translations, ok := catalog[key]
	if !ok {
		return string(key)
	}
	template, ok := translations[lang]
	if !ok {
		// A half-translated catalog should still say something useful.
		if fallback, ok := translations[Default]; ok {
			template = fallback
		} else {
			return string(key)
		}
	}
	if len(args) == 0 {
		return template
	}
	return fmt.Sprintf(template, args...)
}
