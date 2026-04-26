# Contributing

## Branch naming

```
<type>/<short-slug>
```

Types follow [Conventional Commits](https://www.conventionalcommits.org/):
`feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `build`, `ci`, `perf`

Examples: `feat/squad-balancer`, `fix/registration-crash`, `chore/bump-deps`

## Commit message format

```
<type>(<scope>): <description>
```

Scopes:
- `m1`…`m12` — for numbered feature modules
- `infra` — infrastructure, tooling, CI config
- `ci` — CI/CD workflows only
- `docs` — documentation
- `deps` — dependency updates

Examples:
```
feat(m1): add player registration command
fix(m3): handle duplicate squad entries
chore(infra): update ruff to 0.7
```

PR titles must follow the same convention — validated automatically by the `PR Title` CI job.

Inside a branch, individual commit messages can be informal; they are squash-merged into one
Conventional Commit when the PR lands.

## Pre-commit hooks

Hooks are configured in `.pre-commit-config.yaml` and run automatically on `git commit`:

- **ruff** — lint + auto-fix
- **ruff-format** — code formatting
- **import-linter** — architecture contract checks
- **detect-secrets** — no credentials in source

Install once after cloning:

```bash
uv run pre-commit install
```

## Local checks before pushing

Run these before opening a PR:

- [ ] `uv run ruff check .` — no lint errors
- [ ] `uv run ruff format --check .` — formatting clean
- [ ] `uv run mypy .` — no type errors
- [ ] `uv run lint-imports` — architecture contracts intact
- [ ] `uv run pytest -v` — all tests pass

> **Note on mypy**: mypy is intentionally **not** in pre-commit hooks because the standard
> `mirrors-mypy` hook runs in an isolated venv and cannot see project dependencies. Always
> run `uv run mypy .` manually before pushing.

## Architecture rules

The import-linter enforces these contracts (see `pyproject.toml`):

1. `domain` must not import from `application` or `adapters`
2. `application` must not import from `adapters`

Port interfaces (`football_bot.application.ports`) are the only coupling point between
`application` and `adapters` — adapters implement ports, use cases depend on port abstractions.
