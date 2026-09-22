"""Turning the caller's history list into a dense daily series.

The Go backend already gap-fills its analytics output with `generate_series`,
but this service does not rely on that: any missing day between the first and
the last date is treated as **0 sold**. A gap in sales data means "nothing was
sold that day", and dropping those days would silently inflate every average.
"""

from __future__ import annotations

from collections.abc import Sequence
from datetime import date

import pandas as pd

from app.core.i18n import DEFAULT_LANG, Lang
from app.models.schemas import HistoryPoint


class ValidationProblem(Exception):
    """A rule that depends on the data, reported to the caller as 422.

    It carries the language it was rendered in so the handler can put the
    envelope around it in the same one.
    """

    def __init__(self, field: str, message: str, lang: Lang = DEFAULT_LANG) -> None:
        super().__init__(message)
        self.field = field
        self.message = message
        self.lang = lang


def to_daily_series(history: Sequence[HistoryPoint]) -> pd.Series:
    """Sorted, gap-filled daily quantities indexed by date.

    Several rows with the same date are summed, so a caller that sends one row
    per order for a day gets the same answer as one that pre-aggregates.
    """
    if not history:
        return pd.Series(dtype="int64", index=pd.DatetimeIndex([], name="date"), name="quantity_sold")

    frame = pd.DataFrame(
        {
            "date": pd.to_datetime([point.date for point in history]),
            "quantity_sold": [point.quantity_sold for point in history],
        }
    )
    daily = frame.groupby("date", as_index=True)["quantity_sold"].sum().sort_index()

    full_range = pd.date_range(start=daily.index.min(), end=daily.index.max(), freq="D", name="date")
    return daily.reindex(full_range, fill_value=0).astype("int64").rename("quantity_sold")


def last_date(series: pd.Series) -> date:
    return series.index[-1].date()


def future_dates(series: pd.Series, horizon_days: int) -> list[date]:
    """The `horizon_days` days right after the last day of history."""
    start = series.index[-1] + pd.Timedelta(days=1)
    return [stamp.date() for stamp in pd.date_range(start=start, periods=horizon_days, freq="D")]
