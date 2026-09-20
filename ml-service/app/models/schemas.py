"""Request/response schemas. These are the API contract — see docs/ml-service-contract.md."""

from __future__ import annotations

from datetime import date
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field

# Structural rules (types, ranges) live here; rules that depend on the data
# itself (enough history, window vs. history length) live in app/services and
# raise ValidationProblem, so both kinds come back as the same 422 envelope.


class HistoryPoint(BaseModel):
    """One day of sales for one product."""

    model_config = ConfigDict(extra="forbid")

    date: date
    quantity_sold: int = Field(ge=0)


class ForecastRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    product_id: int = Field(ge=1)
    history: list[HistoryPoint]
    horizon_days: int = Field(ge=1, description="How many days to predict, starting the day after the last history date")
    window_days: int | None = Field(
        default=None,
        ge=1,
        description="Moving-average window; defaults to DEFAULT_WINDOW_DAYS (7)",
    )


class ForecastPoint(BaseModel):
    date: date
    predicted_quantity: float


class ForecastResponse(BaseModel):
    product_id: int
    forecast: list[ForecastPoint]
    method: str
    window_days: int = Field(description="The window actually used (clamped to the days available)")


class TrendRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    product_id: int | None = Field(default=None, ge=1, description="Optional; echoed back for traceability")
    history: list[HistoryPoint]
    window_days: int | None = Field(
        default=None,
        ge=1,
        description="Length of each compared period; defaults to TREND_WINDOW_DAYS (14)",
    )


class TrendResponse(BaseModel):
    trend: Literal["increasing", "decreasing", "stable"]
    change_percent: float
    summary: str
    window_days: int = Field(description="The window actually used for each of the two periods")
    recent_total: int
    previous_total: int


class HealthResponse(BaseModel):
    status: Literal["ok"]
    service: str
    version: str
    forecast_method: str


class ErrorDetail(BaseModel):
    field: str
    message: str


class ErrorBody(BaseModel):
    code: str
    message: str
    details: list[ErrorDetail] = Field(default_factory=list)


class ErrorResponse(BaseModel):
    """Mirrors the Go backend's error envelope so the caller parses one shape."""

    error: ErrorBody
