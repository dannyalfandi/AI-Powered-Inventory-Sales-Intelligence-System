"""Both languages of everything this service says.

The rest of the suite asserts the numbers and the shapes in the default
language; the wording lives here, so a catalog change fails one file.
"""

from __future__ import annotations

import pytest
from fastapi.testclient import TestClient

from app.core.i18n import CATALOG, SUPPORTED, normalize, percent, period_label, translate
from app.main import app
from app.models.schemas import ForecastRequest, TrendRequest
from app.services.forecasting import forecast_demand
from app.services.history import ValidationProblem
from app.services.trend import analyze_trend
from tests.conftest import history


@pytest.fixture(scope="module")
def client() -> TestClient:
    return TestClient(app)


class TestNormalize:
    cases = [
        ("id", "id"),
        ("en", "en"),
        ("EN", "en"),
        ("en-US", "en"),
        ("id-ID", "id"),
        (None, "id"),
        ("", "id"),
        ("fr", "id"),
    ]

    @pytest.mark.parametrize("value,expected", cases, ids=[str(c[0]) for c in cases])
    def test_normalize(self, value, expected):
        assert normalize(value) == expected


class TestCatalogIsComplete:
    def test_every_key_has_every_language(self):
        for key, translations in CATALOG.items():
            for lang in SUPPORTED:
                assert translations.get(lang), f"{key} is missing {lang}"

    def test_placeholders_match_between_languages(self):
        import re

        placeholder = re.compile(r"\{(\w+)\}")
        for key, translations in CATALOG.items():
            names = {lang: set(placeholder.findall(text)) for lang, text in translations.items()}
            assert names["id"] == names["en"], f"{key} takes different parameters per language"


class TestFormatting:
    def test_percent_uses_the_local_decimal_mark(self):
        assert percent(32.5, "id") == "32,5"
        assert percent(32.5, "en") == "32.5"

    def test_period_label(self):
        assert period_label(14, "id") == "4 minggu terakhir"
        assert period_label(14, "en") == "the last 4 weeks"
        assert period_label(5, "id") == "10 hari terakhir"
        assert period_label(5, "en") == "the last 10 days"

    def test_unknown_key_returns_itself(self):
        assert translate("trend.nope", "en") == "trend.nope"


class TestTrendSummaries:
    """The same data in both languages: only the sentence changes."""

    def run(self, quantities: list[int], lang: str, window_days: int | None = None):
        return analyze_trend(TrendRequest(product_id=1, lang=lang, history=history(quantities), window_days=window_days))

    def test_increase(self):
        indonesian = self.run([100] * 14 + [132] * 14, "id")
        english = self.run([100] * 14 + [132] * 14, "en")

        assert indonesian.summary == (
            "Penjualan naik 32,0% dalam 4 minggu terakhir (1848 unit vs 1400 unit periode sebelumnya)."
        )
        assert english.summary == (
            "Sales increased 32.0% over the last 4 weeks (1848 units vs 1400 units in the previous period)."
        )
        # The machine-readable parts are identical in both languages.
        assert indonesian.trend == english.trend == "increasing"
        assert indonesian.change_percent == english.change_percent == 32.0
        assert indonesian.recent_total == english.recent_total == 1848

    def test_decrease(self):
        assert self.run([10] * 7 + [5] * 7, "en", window_days=7).summary == (
            "Sales decreased 50.0% over the last 2 weeks (35 units vs 70 units in the previous period)."
        )

    def test_stable(self):
        assert self.run([50, 50, 51, 51], "en").summary == (
            "Sales held steady over the last 4 days (2.0% change)."
        )

    def test_no_sales(self):
        assert self.run([0, 0, 0, 0], "en").summary == "No sales in the last 4 days."

    def test_first_sales(self):
        assert self.run([0, 0, 4, 8], "en").summary == (
            "Sales have started: 12 units in the last 2 days, none before that."
        )

    def test_unknown_language_falls_back_to_indonesian(self):
        # Pydantic rejects an unsupported value outright, so the fallback is
        # about what reaches the renderer, not about accepting bad input.
        assert translate("trend.no_sales", "fr", period="4 hari terakhir") == "Belum ada penjualan dalam 4 hari terakhir."


class TestValidationMessages:
    def test_forecast_history_too_short(self):
        for lang, expected in [
            ("id", "history minimal berisi 3 data point, diterima 2"),
            ("en", "history must have at least 3 data points, got 2"),
        ]:
            with pytest.raises(ValidationProblem) as caught:
                forecast_demand(ForecastRequest(product_id=1, lang=lang, history=history([1, 2]), horizon_days=7))

            assert caught.value.field == "history"
            assert caught.value.message == expected
            assert caught.value.lang == lang

    def test_trend_history_too_short(self):
        for lang, expected in [
            ("id", "history minimal mencakup 4 hari untuk membandingkan dua periode, diterima 3"),
            ("en", "history must cover at least 4 days to compare two periods, got 3"),
        ]:
            with pytest.raises(ValidationProblem) as caught:
                analyze_trend(TrendRequest(product_id=1, lang=lang, history=history([1, 2, 3])))

            assert caught.value.message == expected


class TestOverHTTP:
    """What the Go backend actually receives."""

    valid_history = [
        {"date": "2026-09-01", "quantity_sold": 4},
        {"date": "2026-09-02", "quantity_sold": 6},
        {"date": "2026-09-03", "quantity_sold": 8},
    ]

    def test_trend_summary_in_english(self, client: TestClient):
        response = client.post(
            "/insight/trend",
            json={
                "product_id": 17,
                "lang": "en",
                "history": [
                    {"date": "2026-09-01", "quantity_sold": 5},
                    {"date": "2026-09-02", "quantity_sold": 5},
                    {"date": "2026-09-03", "quantity_sold": 10},
                    {"date": "2026-09-04", "quantity_sold": 10},
                ],
            },
        )

        assert response.status_code == 200
        body = response.json()
        assert body["summary"] == (
            "Sales increased 100.0% over the last 4 days (20 units vs 10 units in the previous period)."
        )
        assert body["trend"] == "increasing"

    def test_omitting_lang_keeps_indonesian(self, client: TestClient):
        response = client.post(
            "/insight/trend",
            json={
                "product_id": 17,
                "history": [
                    {"date": "2026-09-01", "quantity_sold": 5},
                    {"date": "2026-09-02", "quantity_sold": 5},
                    {"date": "2026-09-03", "quantity_sold": 10},
                    {"date": "2026-09-04", "quantity_sold": 10},
                ],
            },
        )

        assert response.json()["summary"].startswith("Penjualan naik")

    def test_422_envelope_in_english(self, client: TestClient):
        response = client.post(
            "/forecast/demand",
            json={"product_id": 1, "lang": "en", "history": self.valid_history[:2], "horizon_days": 7},
        )

        assert response.status_code == 422
        error = response.json()["error"]
        assert error["code"] == "validation_failed"  # codes never translate
        assert error["message"] == "request validation failed"
        assert error["details"][0] == {
            "field": "history",
            "message": "history must have at least 3 data points, got 2",
        }

    def test_422_envelope_in_indonesian(self, client: TestClient):
        response = client.post(
            "/forecast/demand",
            json={"product_id": 1, "history": self.valid_history[:2], "horizon_days": 7},
        )

        error = response.json()["error"]
        assert error["message"] == "validasi request gagal"
        assert error["details"][0]["message"] == "history minimal berisi 3 data point, diterima 2"

    def test_structural_error_still_uses_the_requested_language(self, client: TestClient):
        # Pydantic writes the per-field text; the envelope is ours.
        response = client.post(
            "/forecast/demand",
            json={"product_id": 1, "lang": "en", "history": self.valid_history},
        )

        assert response.status_code == 422
        assert response.json()["error"]["message"] == "request validation failed"

    def test_an_unsupported_language_is_rejected_as_a_field(self, client: TestClient):
        response = client.post(
            "/forecast/demand",
            json={"product_id": 1, "lang": "fr", "history": self.valid_history, "horizon_days": 7},
        )

        assert response.status_code == 422
        assert "lang" in [detail["field"] for detail in response.json()["error"]["details"]]
