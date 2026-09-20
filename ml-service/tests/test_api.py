"""HTTP layer: status codes and the exact JSON the Go backend will parse."""

from __future__ import annotations

import pytest
from fastapi.testclient import TestClient

from app.core.config import SERVICE_VERSION
from app.main import app


@pytest.fixture(scope="module")
def client() -> TestClient:
    return TestClient(app)


def test_health(client: TestClient):
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "ok",
        "service": "ml-service",
        "version": SERVICE_VERSION,
        "forecast_method": "moving_average",
    }


def test_forecast_response_shape(client: TestClient):
    response = client.post(
        "/forecast/demand",
        json={
            "product_id": 17,
            "history": [
                {"date": "2026-09-01", "quantity_sold": 4},
                {"date": "2026-09-02", "quantity_sold": 6},
                {"date": "2026-09-03", "quantity_sold": 8},
            ],
            "horizon_days": 2,
        },
    )

    assert response.status_code == 200
    assert response.json() == {
        "product_id": 17,
        "forecast": [
            {"date": "2026-09-04", "predicted_quantity": 6.0},
            {"date": "2026-09-05", "predicted_quantity": 6.0},
        ],
        "method": "moving_average",
        "window_days": 3,
    }


def test_trend_response_shape(client: TestClient):
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

    assert response.status_code == 200
    assert response.json() == {
        "trend": "increasing",
        "change_percent": 100.0,
        "summary": "Penjualan naik 100,0% dalam 4 hari terakhir (20 unit vs 10 unit periode sebelumnya).",
        "window_days": 2,
        "recent_total": 20,
        "previous_total": 10,
    }


class TestValidationEnvelope:
    valid_history = [
        {"date": "2026-09-01", "quantity_sold": 1},
        {"date": "2026-09-02", "quantity_sold": 2},
        {"date": "2026-09-03", "quantity_sold": 3},
    ]

    cases = [
        (
            "history shorter than the minimum",
            {"product_id": 1, "history": valid_history[:2], "horizon_days": 7},
            "history",
        ),
        (
            "horizon beyond the limit",
            {"product_id": 1, "history": valid_history, "horizon_days": 91},
            "horizon_days",
        ),
        (
            "horizon of zero",
            {"product_id": 1, "history": valid_history, "horizon_days": 0},
            "horizon_days",
        ),
        (
            "negative quantity",
            {
                "product_id": 1,
                "history": [{"date": "2026-09-01", "quantity_sold": -1}, *valid_history],
                "horizon_days": 7,
            },
            "history.0.quantity_sold",
        ),
        (
            "unparseable date",
            {
                "product_id": 1,
                "history": [{"date": "01-09-2026", "quantity_sold": 1}, *valid_history],
                "horizon_days": 7,
            },
            "history.0.date",
        ),
        (
            "unknown field",
            {"product_id": 1, "history": valid_history, "horizon_days": 7, "model": "arima"},
            "model",
        ),
        (
            "missing horizon",
            {"product_id": 1, "history": valid_history},
            "horizon_days",
        ),
    ]

    @pytest.mark.parametrize("name,body,field", cases, ids=[c[0] for c in cases])
    def test_422_envelope(self, client: TestClient, name, body, field):
        response = client.post("/forecast/demand", json=body)

        assert response.status_code == 422
        error = response.json()["error"]
        assert error["code"] == "validation_failed"
        assert field in [detail["field"] for detail in error["details"]]

    def test_trend_history_too_short(self, client: TestClient):
        response = client.post("/insight/trend", json={"history": self.valid_history})

        assert response.status_code == 422
        details = response.json()["error"]["details"]
        assert details[0]["field"] == "history"
        assert "at least 4 days" in details[0]["message"]

    def test_empty_history(self, client: TestClient):
        response = client.post("/forecast/demand", json={"product_id": 1, "history": [], "horizon_days": 7})

        assert response.status_code == 422
        assert response.json()["error"]["details"][0]["field"] == "history"
