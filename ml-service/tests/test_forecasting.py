"""Forecasting logic: the moving average, the gap filling and the 422 rules."""

from __future__ import annotations

from datetime import date

import pytest

from app.core.config import Settings
from app.models.schemas import ForecastRequest
from app.services.forecasting import forecast_demand
from app.services.history import ValidationProblem, to_daily_series
from tests.conftest import history, points

SETTINGS = Settings()


def run(**kwargs) -> object:
    body = {"product_id": 1, "horizon_days": 3}
    body.update(kwargs)
    return forecast_demand(ForecastRequest(**body), SETTINGS)


class TestMovingAverage:
    cases = [
        # name, quantities, window_days, expected value, expected effective window
        ("full window of 7 days", [10, 10, 10, 10, 10, 10, 10], None, 10.0, 7),
        ("only the last 7 days count", [100, 100, 1, 1, 1, 1, 1, 1, 1], None, 1.0, 7),
        ("averages to a fraction, rounded to 2 decimals", [1, 2, 2, 2, 2, 2, 2], None, 1.86, 7),
        ("history shorter than the window uses what exists", [4, 6, 8], None, 6.0, 3),
        ("explicit smaller window", [10, 10, 10, 2, 2], 2, 2.0, 2),
        ("window of 1 repeats the last day", [5, 5, 42], 1, 42.0, 1),
        ("all zeros forecast zero", [0, 0, 0, 0, 0], None, 0.0, 5),
    ]

    @pytest.mark.parametrize("name,quantities,window,expected,expected_window", cases, ids=[c[0] for c in cases])
    def test_average(self, name, quantities, window, expected, expected_window):
        response = run(history=history(quantities), window_days=window)

        assert [p.predicted_quantity for p in response.forecast] == [expected] * 3
        assert response.window_days == expected_window
        assert response.method == "moving_average"

    def test_missing_days_count_as_zero(self):
        # Three selling days of 10, but 03 and 04 are missing: the mean over the
        # five-day span is 6, not the 10 a naive average of the rows would give.
        response = run(
            history=points([("2026-09-01", 10), ("2026-09-02", 10), ("2026-09-05", 10)]),
            window_days=5,
        )

        assert response.forecast[0].predicted_quantity == 6.0
        assert response.window_days == 5

    def test_rows_with_the_same_date_are_summed(self):
        response = run(
            history=points([("2026-09-01", 2), ("2026-09-01", 3), ("2026-09-02", 5)]),
            window_days=2,
        )

        assert response.forecast[0].predicted_quantity == 5.0

    def test_out_of_order_history_is_sorted(self):
        ordered = run(history=points([("2026-09-01", 1), ("2026-09-02", 2), ("2026-09-03", 9)]), window_days=1)
        shuffled = run(history=points([("2026-09-03", 9), ("2026-09-01", 1), ("2026-09-02", 2)]), window_days=1)

        assert shuffled.forecast[0].predicted_quantity == ordered.forecast[0].predicted_quantity == 9.0
        assert shuffled.forecast[0].date == ordered.forecast[0].date == date(2026, 9, 4)


class TestForecastShape:
    def test_dates_continue_the_day_after_the_last_history_day(self):
        response = run(history=history([1, 2, 3]), horizon_days=4)

        assert [p.date for p in response.forecast] == [
            date(2026, 9, 4),
            date(2026, 9, 5),
            date(2026, 9, 6),
            date(2026, 9, 7),
        ]

    def test_gaps_do_not_shift_the_first_forecast_date(self):
        response = run(
            history=points([("2026-09-01", 5), ("2026-09-02", 5), ("2026-09-10", 5)]),
            horizon_days=1,
        )

        assert response.forecast[0].date == date(2026, 9, 11)

    def test_horizon_length_matches_the_request(self):
        assert len(run(history=history([1, 2, 3]), horizon_days=90).forecast) == 90

    def test_product_id_is_echoed(self):
        assert run(product_id=17, history=history([1, 2, 3])).product_id == 17


class TestValidation:
    cases = [
        # The default language is Indonesian; TestMessageLanguage covers English.
        ("too few history points", {"history": history([1, 2])}, "history", "minimal berisi 3 data point"),
        ("horizon beyond the limit", {"history": history([1, 2, 3]), "horizon_days": 91}, "horizon_days", "maksimal 90"),
        ("window beyond the limit", {"history": history([1, 2, 3]), "window_days": 91}, "window_days", "maksimal 90"),
    ]

    @pytest.mark.parametrize("name,kwargs,field,message", cases, ids=[c[0] for c in cases])
    def test_rejects(self, name, kwargs, field, message):
        with pytest.raises(ValidationProblem) as caught:
            run(**kwargs)

        assert caught.value.field == field
        assert message in caught.value.message

    def test_accepts_the_limits_themselves(self):
        assert run(history=history([1, 2, 3]), horizon_days=90, window_days=90).window_days == 3


class TestDailySeries:
    def test_empty_history_gives_an_empty_series(self):
        assert to_daily_series([]).empty

    def test_index_is_continuous(self):
        series = to_daily_series(points([("2026-09-01", 1), ("2026-09-05", 1)]))

        assert len(series) == 5
        assert list(series) == [1, 0, 0, 0, 1]
