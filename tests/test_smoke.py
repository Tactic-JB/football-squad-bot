"""Smoke test to ensure CI has at least one passing test."""

from football_bot.main import build_app


def test_app_builds() -> None:
    app = build_app()
    assert app is not None
