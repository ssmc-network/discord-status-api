from pydantic import Field
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    title: str = Field(default="fastapi")
    description: str = Field(default="my app description")
    version: str = Field(default="1.0.0")
    openapi_url: str = Field(default="/openapi.json")
    docs_url: str = Field(default="/docs")
    prefix_url: str = Field(default="")
    discord_token: str = Field(default="")


settings = Settings()
