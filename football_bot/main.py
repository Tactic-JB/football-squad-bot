"""Entry point. Currently a hello-world aiohttp server with /healthz.

Will be replaced with the Telegram bot polling/webhook setup in Chat 14 (M9 Bot Gateway).
"""

from __future__ import annotations

import asyncio

from aiohttp import web


async def healthz(_: web.Request) -> web.Response:
    return web.json_response({"status": "ok"})


def build_app() -> web.Application:
    app = web.Application()
    app.router.add_get("/healthz", healthz)
    return app


async def main() -> None:
    app = build_app()
    runner = web.AppRunner(app)
    await runner.setup()
    site = web.TCPSite(runner, host="0.0.0.0", port=8080)
    await site.start()
    # Keep the loop alive.
    await asyncio.Event().wait()


if __name__ == "__main__":
    asyncio.run(main())
