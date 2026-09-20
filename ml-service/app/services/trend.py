"""Trend analysis: last N days against the N days before them.

Pure arithmetic — no model, no LLM. The summary is a template filled with the
numbers, so the same input always produces the same sentence.
"""

from __future__ import annotations

from app.core.config import Settings, get_settings
from app.models.schemas import TrendRequest, TrendResponse
from app.services.history import ValidationProblem, to_daily_series

MIN_DAYS = 4  # two periods of at least two days each


def analyze_trend(request: TrendRequest, settings: Settings | None = None) -> TrendResponse:
    settings = settings or get_settings()

    series = to_daily_series(request.history)
    if len(series) < MIN_DAYS:
        raise ValidationProblem(
            "history",
            f"history must cover at least {MIN_DAYS} days to compare two periods, got {len(series)}",
        )

    requested = request.window_days or settings.default_trend_window_days
    # Both periods must fit in the history, so the window can never exceed half
    # of it; a caller with 10 days of data still gets a 5-vs-5 comparison.
    window = min(requested, len(series) // 2)

    recent_total = int(series.tail(window).sum())
    previous_total = int(series.tail(window * 2).head(window).sum())
    change_percent = _change_percent(recent_total, previous_total)
    trend = _direction(change_percent, recent_total, previous_total, settings.stable_threshold_percent)

    return TrendResponse(
        trend=trend,
        change_percent=change_percent,
        summary=_summary(trend, change_percent, recent_total, previous_total, window),
        window_days=window,
        recent_total=recent_total,
        previous_total=previous_total,
    )


def _change_percent(recent: int, previous: int) -> float:
    if previous > 0:
        return round((recent - previous) / previous * 100, 1)
    # No baseline to divide by: going from nothing to something is reported as
    # +100%, and nothing to nothing as 0%.
    return 100.0 if recent > 0 else 0.0


def _direction(change_percent: float, recent: int, previous: int, threshold: float) -> str:
    if recent == 0 and previous == 0:
        return "stable"
    if abs(change_percent) < threshold:
        return "stable"
    return "increasing" if change_percent > 0 else "decreasing"


def _period_label(window: int) -> str:
    """The span both periods cover together, in weeks when it divides evenly."""
    total_days = window * 2
    if total_days % 7 == 0:
        return f"{total_days // 7} minggu terakhir"
    return f"{total_days} hari terakhir"


def _percent_id(value: float) -> str:
    """Indonesian decimal notation: 32.5 → "32,5"."""
    return f"{abs(value):.1f}".replace(".", ",")


def _summary(trend: str, change_percent: float, recent: int, previous: int, window: int) -> str:
    period = _period_label(window)
    if recent == 0 and previous == 0:
        return f"Belum ada penjualan dalam {period}."
    if previous == 0:
        return f"Penjualan mulai muncul: {recent} unit dalam {window} hari terakhir, sebelumnya tidak ada penjualan."
    if trend == "stable":
        return f"Penjualan relatif stabil dalam {period} (perubahan {_percent_id(change_percent)}%)."
    arah = "naik" if trend == "increasing" else "turun"
    return (
        f"Penjualan {arah} {_percent_id(change_percent)}% dalam {period} "
        f"({recent} unit vs {previous} unit periode sebelumnya)."
    )
