# Multi-stage: wheels are built once, the runtime image keeps no build tools.
# Base pinned to the patch release and the Debian release.
FROM python:3.12.15-slim-trixie AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

FROM python:3.12.15-slim-trixie AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

WORKDIR /app

# Bind-mount the wheels instead of COPY + rm: a COPY layer would keep every
# wheel in the image even after a later `rm`.
COPY requirements.txt .
RUN --mount=type=bind,from=builder,source=/wheels,target=/wheels \
    pip install --no-cache-dir --no-index --find-links=/wheels -r requirements.txt

# Non-root: the service needs no write access anywhere.
RUN useradd --create-home --uid 1001 mlservice
COPY app ./app
USER mlservice

EXPOSE 8000
# sh expands $PORT, then `exec` replaces it with uvicorn, so uvicorn is PID 1
# and receives SIGTERM directly: `docker stop` shuts down gracefully instead
# of waiting 10s and killing it (exit 137).
CMD ["sh", "-c", "exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT}"]
