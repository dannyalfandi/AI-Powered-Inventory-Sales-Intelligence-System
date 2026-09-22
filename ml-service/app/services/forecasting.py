"""Demand forecasting.

Only a moving average for now. Everything above the `Forecaster` protocol is
model-agnostic: adding linear regression later means writing one more class,
registering it, and pointing `FORECAST_METHOD` at it — the request and
response shapes do not change, only the `method` field in the response.
"""

from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass
from datetime import date
from typing import Protocol

import pandas as pd

from app.core.config import Settings, get_settings
from app.core.i18n import normalize, translate
from app.models.schemas import ForecastPoint, ForecastRequest, ForecastResponse
from app.services.history import ValidationProblem, future_dates, to_daily_series


@dataclass(frozen=True)
class Prediction:
    """What a forecaster returns: one value per future day, plus what it used."""

    values: list[float]
    window_days: int


class Forecaster(Protocol):
    name: str

    def predict(self, series: pd.Series, horizon_days: int, window_days: int) -> Prediction: ...


class MovingAverageForecaster:
    """Average of the last `window_days` days, held flat over the horizon.

    A flat projection is deliberate: with a simple moving average, feeding the
    predictions back in only drags the curve towards the same mean, so the flat
    line is both the honest answer and the easy one to explain.
    """

    name = "moving_average"

    def predict(self, series: pd.Series, horizon_days: int, window_days: int) -> Prediction:
        # Short history is usable: average what is there instead of failing.
        effective_window = min(window_days, len(series))
        average = float(series.tail(effective_window).mean())
        value = round(max(average, 0.0), 2)
        return Prediction(values=[value] * horizon_days, window_days=effective_window)


_FORECASTERS: dict[str, Forecaster] = {
    MovingAverageForecaster.name: MovingAverageForecaster(),
}


def get_forecaster(method: str) -> Forecaster:
    try:
        return _FORECASTERS[method]
    except KeyError as exc:
        known = ", ".join(sorted(_FORECASTERS))
        raise ValueError(f"unknown forecast method {method!r}; known methods: {known}") from exc


def forecast_demand(request: ForecastRequest, settings: Settings | None = None) -> ForecastResponse:
    """Validates the data-dependent rules, then runs the configured forecaster."""
    settings = settings or get_settings()
    lang = normalize(request.lang)

    if len(request.history) < settings.min_history_points:
        raise ValidationProblem(
            "history",
            translate(
                "error.history_min_points",
                lang,
                minimum=settings.min_history_points,
                got=len(request.history),
            ),
            lang,
        )
    if request.horizon_days > settings.max_horizon_days:
        raise ValidationProblem(
            "horizon_days",
            translate("error.horizon_max", lang, maximum=settings.max_horizon_days, got=request.horizon_days),
            lang,
        )
    window_days = request.window_days or settings.default_window_days
    if window_days > settings.max_window_days:
        raise ValidationProblem(
            "window_days",
            translate("error.window_max", lang, maximum=settings.max_window_days, got=window_days),
            lang,
        )

    series = to_daily_series(request.history)
    forecaster = get_forecaster(settings.forecast_method)
    prediction = forecaster.predict(series, request.horizon_days, window_days)
    dates = future_dates(series, request.horizon_days)

    return ForecastResponse(
        product_id=request.product_id,
        forecast=_points(dates, prediction.values),
        method=forecaster.name,
        window_days=prediction.window_days,
    )


def _points(dates: Sequence[date], values: Sequence[float]) -> list[ForecastPoint]:
    return [ForecastPoint(date=day, predicted_quantity=value) for day, value in zip(dates, values, strict=True)]
