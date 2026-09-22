// Package client holds outbound HTTP clients for the services this API talks
// to. Today that is only the Python ML service in /ml-service.
package client

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// ErrUnavailable means the ML service could not be reached or did not answer
// in time, or answered 5xx. Callers treat it as "no forecast this time" and
// keep serving the rest of the response — never as a failure of their own.
var ErrUnavailable = errors.New("ml service unavailable")

// ErrInvalidRequest means the ML service rejected what we sent (HTTP 422).
// That is a bug on this side, not a transient outage, so it is logged loudly
// but still degrades gracefully for the caller.
var ErrInvalidRequest = errors.New("ml service rejected the request")

// MLService is the forecasting service as this API uses it. The service layer
// depends on this interface so tests can supply a fake.
type MLService interface {
	ForecastDemand(ctx context.Context, req ForecastRequest) (ForecastResponse, error)
	TrendInsight(ctx context.Context, req TrendRequest) (TrendResponse, error)
}

// --- wire types, mirroring docs/ml-service-contract.md --------------------

type ForecastRequest struct {
	ProductID uint `json:"product_id"`
	// Lang is the language of the messages the ML service sends back, taken
	// from the Accept-Language of the request that triggered this call.
	Lang        string             `json:"lang,omitempty"`
	History     []model.DailySales `json:"history"`
	HorizonDays int                `json:"horizon_days"`
	// WindowDays is omitted to use the service's own default (7 days).
	WindowDays int `json:"window_days,omitempty"`
}

type ForecastResponse struct {
	ProductID  uint                  `json:"product_id"`
	Forecast   []model.ForecastPoint `json:"forecast"`
	Method     string                `json:"method"`
	WindowDays int                   `json:"window_days"`
}

type TrendRequest struct {
	ProductID uint `json:"product_id"`
	// Lang decides the language of `summary`; see ForecastRequest.Lang.
	Lang    string             `json:"lang,omitempty"`
	History []model.DailySales `json:"history"`
	// WindowDays is omitted to use the service's own default (14 days).
	WindowDays int `json:"window_days,omitempty"`
}

type TrendResponse struct {
	Trend         string  `json:"trend"`
	ChangePercent float64 `json:"change_percent"`
	Summary       string  `json:"summary"`
	WindowDays    int     `json:"window_days"`
	RecentTotal   int64   `json:"recent_total"`
	PreviousTotal int64   `json:"previous_total"`
}

// errorEnvelope is the ML service's 422 body. It is deliberately the same
// shape this API returns, so the fields map one to one.
type errorEnvelope struct {
	Error struct {
		Code    string `json:"code"`
		Message string `json:"message"`
		Details []struct {
			Field   string `json:"field"`
			Message string `json:"message"`
		} `json:"details"`
	} `json:"error"`
}

// --- client ---------------------------------------------------------------

type mlServiceClient struct {
	baseURL string
	http    *http.Client
}

// NewMLService returns a client for the service at baseURL. The timeout
// covers the whole call: this is a synchronous hop inside a user request, so
// it must fail fast rather than hold the dashboard open.
func NewMLService(baseURL string, timeout time.Duration) MLService {
	return &mlServiceClient{
		baseURL: strings.TrimRight(baseURL, "/"),
		http:    &http.Client{Timeout: timeout},
	}
}

func (c *mlServiceClient) ForecastDemand(ctx context.Context, req ForecastRequest) (ForecastResponse, error) {
	return post[ForecastRequest, ForecastResponse](ctx, c, "/forecast/demand", req)
}

func (c *mlServiceClient) TrendInsight(ctx context.Context, req TrendRequest) (TrendResponse, error) {
	return post[TrendRequest, TrendResponse](ctx, c, "/insight/trend", req)
}

func post[Req any, Res any](ctx context.Context, c *mlServiceClient, path string, payload Req) (Res, error) {
	var out Res

	body, err := json.Marshal(payload)
	if err != nil {
		return out, fmt.Errorf("encode %s request: %w", path, err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+path, bytes.NewReader(body))
	if err != nil {
		return out, fmt.Errorf("build %s request: %w", path, err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	res, err := c.http.Do(httpReq)
	if err != nil {
		// Connection refused, DNS failure, timeout, cancelled context — from
		// the caller's point of view they are all "the service isn't there".
		return out, fmt.Errorf("%w: POST %s: %w", ErrUnavailable, path, err)
	}
	defer res.Body.Close()

	// Cap the read: a wrong URL could point at something that streams forever.
	raw, err := io.ReadAll(io.LimitReader(res.Body, 1<<20))
	if err != nil {
		return out, fmt.Errorf("%w: read %s response: %w", ErrUnavailable, path, err)
	}

	switch {
	case res.StatusCode == http.StatusOK:
		if err := json.Unmarshal(raw, &out); err != nil {
			return out, fmt.Errorf("decode %s response: %w", path, err)
		}
		return out, nil
	case res.StatusCode == http.StatusUnprocessableEntity:
		return out, fmt.Errorf("%w: POST %s: %s", ErrInvalidRequest, path, describe(raw))
	case res.StatusCode >= 500:
		return out, fmt.Errorf("%w: POST %s returned %d", ErrUnavailable, path, res.StatusCode)
	default:
		return out, fmt.Errorf("POST %s returned unexpected status %d: %s", path, res.StatusCode, describe(raw))
	}
}

// describe turns an error body into one readable line for the log.
func describe(raw []byte) string {
	var envelope errorEnvelope
	if err := json.Unmarshal(raw, &envelope); err == nil && envelope.Error.Message != "" {
		parts := make([]string, 0, len(envelope.Error.Details))
		for _, d := range envelope.Error.Details {
			parts = append(parts, d.Field+": "+d.Message)
		}
		if len(parts) == 0 {
			return envelope.Error.Message
		}
		return envelope.Error.Message + " (" + strings.Join(parts, "; ") + ")"
	}
	return strings.TrimSpace(string(raw))
}
