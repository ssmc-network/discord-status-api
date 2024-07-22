import discord


class WorkStatusBot(discord.Bot):
    def __init__(self):
        intents = discord.Intents.default()
        super().__init__(intents=intents)

    async def on_ready(self):
        print(f'{self.user} としてログインしました')

bot = WorkStatusBot()
