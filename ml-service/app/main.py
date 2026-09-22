"""FastAPI entrypoint: three endpoints, one error envelope.

Run locally with:  uvicorn app.main:app --reload --port 8000
"""

from __future__ import annotations

import logging

from fastapi import FastAPI
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from starlette.requests import Request

from app.core.config import SERVICE_NAME, SERVICE_VERSION, get_settings
from app.core.i18n import DEFAULT_LANG, Lang, normalize, translate
from app.models.schemas import (
    ErrorResponse,
    ForecastRequest,
    ForecastResponse,
    HealthResponse,
    TrendRequest,
    TrendResponse,
)
from app.services.forecasting import forecast_demand
from app.services.history import ValidationProblem
from app.services.trend import analyze_trend

settings = get_settings()
logging.basicConfig(level=settings.log_level.upper(), format="%(asctime)s %(levelname)s %(name)s %(message)s")
logger = logging.getLogger(SERVICE_NAME)

app = FastAPI(
    title="Inventory & Sales Intelligence — ML Service",
    version=SERVICE_VERSION,
    description="Stateless demand forecasting and trend analysis. Callers send the history; nothing is stored here.",
)

_ERROR_RESPONSES = {422: {"model": ErrorResponse, "description": "Validation failed"}}


def _error(code: str, message: str, details: list[dict[str, str]] | None = None) -> JSONResponse:
    """The Go backend's error envelope, so callers parse one shape everywhere."""
    return JSONResponse(
        status_code=422,
        content={"error": {"code": code, "message": message, "details": details or []}},
    )


def _lang_of(body: object) -> Lang:
    """The language a rejected request asked for.

    A structurally invalid body never became a model, so the language is read
    from the raw JSON. Anything unreadable falls back to the default.
    """
    if isinstance(body, dict):
        value = body.get("lang")
        if isinstance(value, str):
            return normalize(value)
    return DEFAULT_LANG


@app.exception_handler(RequestValidationError)
async def on_request_validation_error(_: Request, exc: RequestValidationError) -> JSONResponse:
    # Pydantic writes the per-field text ("Input should be a valid integer");
    # it is not in the catalog, so only the envelope message is translated.
    details = [
        {
            # Drop the leading "body" segment: the caller cares about the field.
            "field": ".".join(str(part) for part in error["loc"][1:]) or "body",
            "message": error["msg"],
        }
        for error in jsonable_encoder(exc.errors())
    ]
    lang = _lang_of(exc.body)
    return _error("validation_failed", translate("error.validation_failed", lang), details)


@app.exception_handler(ValidationProblem)
async def on_validation_problem(_: Request, exc: ValidationProblem) -> JSONResponse:
    # exc.message is already in the caller's language: the service rendered it
    # from the `lang` of the parsed request.
    return _error(
        "validation_failed",
        translate("error.validation_failed", exc.lang),
        [{"field": exc.field, "message": exc.message}],
    )


@app.get("/health", response_model=HealthResponse, tags=["ops"])
def health() -> HealthResponse:
    return HealthResponse(
        status="ok",
        service=SERVICE_NAME,
        version=SERVICE_VERSION,
        forecast_method=settings.forecast_method,
    )


@app.post("/forecast/demand", response_model=ForecastResponse, responses=_ERROR_RESPONSES, tags=["forecast"])
def forecast(request: ForecastRequest) -> ForecastResponse:
    """Projects daily demand for one product over the next `horizon_days`."""
    response = forecast_demand(request, settings)
    logger.info(
        "forecast product_id=%s history_points=%d horizon_days=%d window_days=%d",
        request.product_id,
        len(request.history),
        request.horizon_days,
        response.window_days,
    )
    return response


@app.post("/insight/trend", response_model=TrendResponse, responses=_ERROR_RESPONSES, tags=["insight"])
def trend(request: TrendRequest) -> TrendResponse:
    """Compares the last N days with the N days before them (statistics only)."""
    response = analyze_trend(request, settings)
    logger.info(
        "trend product_id=%s history_points=%d window_days=%d trend=%s change_percent=%s",
        request.product_id,
        len(request.history),
        response.window_days,
        response.trend,
        response.change_percent,
    )
    return response
