# syntax=docker/dockerfile:1.7
FROM python:3.13-slim-bookworm AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Install dependencies first (better layer caching)
COPY pyproject.toml uv.lock .python-version ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

# Now copy source and install the project itself
COPY football_bot ./football_bot
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# ----- runtime -----
FROM python:3.13-slim-bookworm AS runtime

WORKDIR /app

# Copy venv and source from builder
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/football_bot /app/football_bot

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8080

CMD ["python", "-m", "football_bot.main"]
