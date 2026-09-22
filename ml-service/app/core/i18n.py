"""Messages this service sends back, in Indonesian or English.

The language comes from the request body (`"lang": "id" | "en"`), not from a
header: the Go backend already resolved the caller's Accept-Language and
passes the result on, so one field keeps the contract explicit and testable.
Anything unknown falls back to Indonesian, the default of the platform.

Only sentences live here. Field names, trend values ("increasing"), numbers
and product data are not translated — clients match on those.
"""

from __future__ import annotations

from typing import Literal

Lang = Literal["id", "en"]

DEFAULT_LANG: Lang = "id"
SUPPORTED: tuple[Lang, ...] = ("id", "en")


def normalize(lang: str | None) -> Lang:
    """Maps whatever arrived to a supported language."""
    if lang is None:
        return DEFAULT_LANG
    value = lang.strip().lower()
    # "en-US" and "en" are the same language here.
    base = value.split("-", 1)[0]
    return base if base in SUPPORTED else DEFAULT_LANG  # type: ignore[return-value]


# Keys are grouped like the Go catalog: `trend.*` for the insight sentences,
# `error.*` for what a rejected request says.
CATALOG: dict[str, dict[Lang, str]] = {
    # --- trend summaries --------------------------------------------------
    "trend.no_sales": {
        "id": "Belum ada penjualan dalam {period}.",
        "en": "No sales in {period}.",
    },
    "trend.first_sales": {
        "id": "Penjualan mulai muncul: {recent} unit dalam {window} hari terakhir, sebelumnya tidak ada penjualan.",
        "en": "Sales have started: {recent} units in the last {window} days, none before that.",
    },
    "trend.stable": {
        "id": "Penjualan relatif stabil dalam {period} (perubahan {percent}%).",
        "en": "Sales held steady over {period} ({percent}% change).",
    },
    "trend.increasing": {
        "id": "Penjualan naik {percent}% dalam {period} ({recent} unit vs {previous} unit periode sebelumnya).",
        "en": "Sales increased {percent}% over {period} ({recent} units vs {previous} units in the previous period).",
    },
    "trend.decreasing": {
        "id": "Penjualan turun {percent}% dalam {period} ({recent} unit vs {previous} unit periode sebelumnya).",
        "en": "Sales decreased {percent}% over {period} ({recent} units vs {previous} units in the previous period).",
    },
    # --- period labels used inside the summaries --------------------------
    "period.weeks": {
        "id": "{count} minggu terakhir",
        "en": "the last {count} weeks",
    },
    "period.days": {
        "id": "{count} hari terakhir",
        "en": "the last {count} days",
    },
    # --- validation errors ------------------------------------------------
    "error.validation_failed": {
        "id": "validasi request gagal",
        "en": "request validation failed",
    },
    "error.history_min_points": {
        "id": "history minimal berisi {minimum} data point, diterima {got}",
        "en": "history must have at least {minimum} data points, got {got}",
    },
    "error.history_min_days": {
        "id": "history minimal mencakup {minimum} hari untuk membandingkan dua periode, diterima {got}",
        "en": "history must cover at least {minimum} days to compare two periods, got {got}",
    },
    "error.horizon_max": {
        "id": "horizon_days maksimal {maximum}, diterima {got}",
        "en": "horizon_days must be at most {maximum}, got {got}",
    },
    "error.window_max": {
        "id": "window_days maksimal {maximum}, diterima {got}",
        "en": "window_days must be at most {maximum}, got {got}",
    },
}


def translate(key: str, lang: Lang | str | None = None, **params: object) -> str:
    """Renders a catalog entry; an unknown key returns itself, never empty."""
    language = normalize(lang)
    translations = CATALOG.get(key)
    if translations is None:
        return key
    template = translations.get(language) or translations[DEFAULT_LANG]
    return template.format(**params) if params else template


def period_label(window: int, lang: Lang) -> str:
    """The span both compared periods cover, in weeks when it divides evenly."""
    total_days = window * 2
    if total_days % 7 == 0:
        return translate("period.weeks", lang, count=total_days // 7)
    return translate("period.days", lang, count=total_days)


def percent(value: float, lang: Lang) -> str:
    """32.5 → "32,5" in Indonesian, "32.5" in English."""
    text = f"{abs(value):.1f}"
    return text.replace(".", ",") if lang == "id" else text
