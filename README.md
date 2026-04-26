# football-squad-bot

Telegram bot for forming balanced squads in amateur football games.

## What is this?

A bot that helps organise pickup football games by automatically splitting registered players into balanced teams based on skill ratings and positions.

## Local setup

### Via uv (recommended)

```bash
# Install uv if you don't have it
# https://docs.astral.sh/uv/getting-started/installation/

# Install dependencies and create venv
uv sync

# Run the dev server (healthz on :8080)
uv run python -m football_bot.main

# Run tests
uv run pytest -v

# Run all linters
uv run ruff check .
uv run ruff format --check .
uv run mypy .
uv run lint-imports
```

### Via Docker Compose

```bash
docker compose up --build
# healthz endpoint: http://localhost:8080/healthz
```

## Architecture

The codebase follows a clean-architecture layout with three physical layers:

```
football_bot/
├── domain/          # Pure business rules — no framework dependencies
├── application/     # Use cases and orchestration
│   └── ports/       # Interfaces (abstract base classes) between application and adapters
└── adapters/        # Concrete implementations: Telegram, DB, etc.
```

Port interfaces live in `football_bot.application.ports` — this is the boundary that
adapters implement and use cases depend on.

## CI

GitHub Actions runs on every push and PR:
- Ruff lint + format check
- Mypy (strict)
- Import-linter (architecture contracts)
- Pytest
