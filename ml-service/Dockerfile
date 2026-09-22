# Multi-stage: wheels are built once, the runtime image keeps no build tools.
FROM python:3.12-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

FROM python:3.12-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

WORKDIR /app

COPY --from=builder /wheels /wheels
COPY requirements.txt .
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r requirements.txt \
    && rm -rf /wheels

# Non-root: the service needs no write access anywhere.
RUN useradd --create-home --uid 1001 mlservice
COPY app ./app
USER mlservice

EXPOSE 8000
# Shell form so $PORT from the environment is honoured.
CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT}
