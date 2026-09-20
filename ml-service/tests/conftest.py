from __future__ import annotations

from datetime import date, timedelta

from app.models.schemas import HistoryPoint

START = date(2026, 9, 1)


def history(quantities: list[int], start: date = START) -> list[HistoryPoint]:
    """One point per day from [start], in order — the common, gap-free shape."""
    return [HistoryPoint(date=start + timedelta(days=i), quantity_sold=q) for i, q in enumerate(quantities)]


def points(pairs: list[tuple[str, int]]) -> list[HistoryPoint]:
    """Explicit dates, for gaps, duplicates and out-of-order input."""
    return [HistoryPoint(date=date.fromisoformat(day), quantity_sold=q) for day, q in pairs]
