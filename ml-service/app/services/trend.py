"""Trend analysis: last N days against the N days before them.

Pure arithmetic — no model, no LLM. The summary is a template filled with the
numbers, so the same input always produces the same sentence.
"""

from __future__ import annotations

from app.core.config import Settings, get_settings
from app.core.i18n import Lang, normalize, percent, period_label, translate
from app.models.schemas import TrendRequest, TrendResponse
from app.services.history import ValidationProblem, to_daily_series

MIN_DAYS = 4  # two periods of at least two days each


def analyze_trend(request: TrendRequest, settings: Settings | None = None) -> TrendResponse:
    settings = settings or get_settings()
    lang = normalize(request.lang)

    series = to_daily_series(request.history)
    if len(series) < MIN_DAYS:
        raise ValidationProblem(
            "history",
            translate("error.history_min_days", lang, minimum=MIN_DAYS, got=len(series)),
            lang,
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
        summary=_summary(trend, change_percent, recent_total, previous_total, window, lang),
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


def _summary(trend: str, change_percent: float, recent: int, previous: int, window: int, lang: Lang) -> str:
    """The sentence a client displays, filled with the numbers above.

    Which template is chosen is a decision about the data, not about language:
    the same case picks the same key in every language.
    """
    period = period_label(window, lang)
    if recent == 0 and previous == 0:
        return translate("trend.no_sales", lang, period=period)
    if previous == 0:
        return translate("trend.first_sales", lang, recent=recent, window=window)
    if trend == "stable":
        return translate("trend.stable", lang, period=period, percent=percent(change_percent, lang))
    return translate(
        f"trend.{trend}",
        lang,
        percent=percent(change_percent, lang),
        period=period,
        recent=recent,
        previous=previous,
    )
