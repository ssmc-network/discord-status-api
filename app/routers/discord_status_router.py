import discord
from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel

from settings.bot import bot

router = APIRouter()

class StatusUpdate(BaseModel):
    status: str

@router.post("/discord/status")
async def post_discord_status(status_update: StatusUpdate) -> JSONResponse:
    try:
        await bot.change_presence(activity=discord.Game(name=status_update.status))
        return JSONResponse(content={"message": f"ステータスを {status_update.status} に更新しました"}, status_code=200)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
