"""Trend analysis: direction, percentage and the Indonesian summary."""

from __future__ import annotations

import pytest

from app.core.config import Settings
from app.models.schemas import TrendRequest
from app.services.history import ValidationProblem
from app.services.trend import analyze_trend
from tests.conftest import history, points

SETTINGS = Settings()


def run(quantities: list[int], window_days: int | None = None):
    return analyze_trend(
        TrendRequest(product_id=1, history=history(quantities), window_days=window_days),
        SETTINGS,
    )


class TestDirection:
    # 4 days of history compared as 2 vs 2, so the numbers stay easy to read.
    cases = [
        # name, quantities, expected trend, expected change_percent
        ("doubled", [5, 5, 10, 10], "increasing", 100.0),
        ("halved", [10, 10, 5, 5], "decreasing", -50.0),
        ("unchanged", [7, 7, 7, 7], "stable", 0.0),
        ("4% up is still stable", [50, 50, 52, 52], "stable", 4.0),
        ("5% up crosses the threshold", [20, 20, 21, 21], "increasing", 5.0),
        ("5% down crosses the threshold", [20, 20, 19, 19], "decreasing", -5.0),
        ("from zero to something", [0, 0, 3, 4], "increasing", 100.0),
        ("down to zero", [6, 6, 0, 0], "decreasing", -100.0),
        ("no sales at all", [0, 0, 0, 0], "stable", 0.0),
    ]

    @pytest.mark.parametrize("name,quantities,trend,change", cases, ids=[c[0] for c in cases])
    def test_direction_and_percentage(self, name, quantities, trend, change):
        response = run(quantities)

        assert response.trend == trend
        assert response.change_percent == change

    def test_totals_are_reported(self):
        response = run([1, 2, 10, 20])

        assert (response.previous_total, response.recent_total) == (3, 30)
        assert response.change_percent == 900.0


class TestSummary:
    def test_increase_reads_like_the_example(self):
        # 2 weeks of 100/day against 2 weeks of 132/day → +32% over 4 weeks.
        response = run([100] * 14 + [132] * 14)

        assert response.window_days == 14
        assert response.summary == "Penjualan naik 32,0% dalam 4 minggu terakhir (1848 unit vs 1400 unit periode sebelumnya)."

    def test_decrease_says_turun(self):
        response = run([10] * 7 + [5] * 7, window_days=7)

        assert response.summary == "Penjualan turun 50,0% dalam 2 minggu terakhir (35 unit vs 70 unit periode sebelumnya)."

    def test_stable_mentions_the_change(self):
        response = run([50, 50, 51, 51])

        assert response.summary == "Penjualan relatif stabil dalam 4 hari terakhir (perubahan 2,0%)."

    def test_no_sales_at_all(self):
        assert run([0, 0, 0, 0]).summary == "Belum ada penjualan dalam 4 hari terakhir."

    def test_first_sales_after_a_dry_period(self):
        response = run([0, 0, 4, 8])

        assert response.summary == "Penjualan mulai muncul: 12 unit dalam 2 hari terakhir, sebelumnya tidak ada penjualan."

    def test_period_is_in_days_when_it_is_not_whole_weeks(self):
        assert "10 hari terakhir" in run([1] * 5 + [3] * 5).summary


class TestWindow:
    def test_window_defaults_to_two_weeks_when_the_history_allows_it(self):
        assert run([1] * 40).window_days == 14

    def test_window_is_clamped_to_half_the_history(self):
        # 9 days of history can only support a 4-vs-4 comparison.
        response = run([1] * 9)

        assert response.window_days == 4

    def test_gaps_count_as_zero_days(self):
        # 01 and 08 sold 10 each; the six missing days are zeros, so the recent
        # half (05–08) beats the earlier half (01–04).
        response = analyze_trend(
            TrendRequest(history=points([("2026-09-01", 10), ("2026-09-08", 10)])),
            SETTINGS,
        )

        assert response.window_days == 4
        assert (response.previous_total, response.recent_total) == (10, 10)
        assert response.trend == "stable"

    def test_history_shorter_than_four_days_is_rejected(self):
        with pytest.raises(ValidationProblem) as caught:
            run([1, 2, 3])

        assert caught.value.field == "history"
        assert "minimal mencakup 4 hari" in caught.value.message

    def test_a_gap_can_make_a_short_history_long_enough(self):
        response = analyze_trend(
            TrendRequest(history=points([("2026-09-01", 1), ("2026-09-06", 1)])),
            SETTINGS,
        )

        assert response.window_days == 3
