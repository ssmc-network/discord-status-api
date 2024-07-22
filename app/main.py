import asyncio

from fastapi import FastAPI

from routers import discord_status_router
from settings.bot import bot
from settings.config import settings

app = FastAPI(
    title=settings.title,
    description=settings.description,
    version=settings.version,
    openapi_url=settings.openapi_url,
    docs_url=settings.docs_url,
    redoc_url=None,
)

app.include_router(discord_status_router.router, prefix=settings.prefix_url)

@app.on_event("startup")
async def startup_event():
    asyncio.create_task(bot.start(settings.discord_token))

@app.on_event("shutdown")
async def shutdown_event():
    await bot.close()
