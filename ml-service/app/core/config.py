"""Runtime configuration, read once from the environment (.env in dev)."""

from __future__ import annotations

import os
from dataclasses import dataclass
from functools import lru_cache

from dotenv import load_dotenv

load_dotenv()

SERVICE_NAME = "ml-service"
SERVICE_VERSION = "0.1.0"


def _int_env(key: str, default: int) -> int:
    raw = os.getenv(key, "").strip()
    if not raw:
        return default
    try:
        return int(raw)
    except ValueError as exc:  # fail fast on a typo rather than silently defaulting
        raise ValueError(f"{key} must be an integer, got {raw!r}") from exc


@dataclass(frozen=True)
class Settings:
    port: int = 8000
    log_level: str = "info"

    # Forecasting defaults. The window can be overridden per request; the
    # limits below are hard and produce a 422 when exceeded.
    default_window_days: int = 7
    max_window_days: int = 90
    max_horizon_days: int = 90
    min_history_points: int = 3

    # Trend analysis: compares the last N days against the N days before that.
    default_trend_window_days: int = 14
    # |change| below this is reported as "stable" rather than a direction.
    stable_threshold_percent: float = 5.0

    # Which forecaster the service uses. Swapping this (or registering another
    # one in app/services/forecasting.py) does not change the API contract.
    forecast_method: str = "moving_average"


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    return Settings(
        port=_int_env("PORT", 8000),
        log_level=os.getenv("LOG_LEVEL", "info").strip().lower() or "info",
        default_window_days=_int_env("DEFAULT_WINDOW_DAYS", 7),
        max_window_days=_int_env("MAX_WINDOW_DAYS", 90),
        max_horizon_days=_int_env("MAX_HORIZON_DAYS", 90),
        min_history_points=_int_env("MIN_HISTORY_POINTS", 3),
        default_trend_window_days=_int_env("TREND_WINDOW_DAYS", 14),
        forecast_method=os.getenv("FORECAST_METHOD", "moving_average").strip() or "moving_average",
    )
