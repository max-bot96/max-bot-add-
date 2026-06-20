import discord, asyncio, os, json
from dotenv import load_dotenv
load_dotenv(r'C:\Users\USER\Desktop\z1-pro\.env')
TOKEN = os.getenv("DISCORD_TOKEN")
with open(r'C:\Users\USER\Desktop\z1-pro\bot_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)
log_channels = data.get("log_channels", {})

TESTS = {
    "log_admin": ("⚖️  حظر عضو — TEST", 0x000000, [
        ("👤 العضو", "├─ المعرف: `123456`\n├─ الاسم: **Ahmad**\n└─ الرتب:\n│   🟣 @Admin\n│   🟢 @Member"),
        ("👨‍⚖️ المنفذ", "└── @MaxBot (`1379265753877975182`)"),
        ("📋 التفاصيل", "├─ السبب: مخالفة قواعد\n└─ الإجراء: حظر نهائي"),
    ]),
    "log_members": ("📥  دخول عضو — TEST", 0x00FFAA, [
        ("👤 العضو", "├─ المعرف: `789012`\n├─ الاسم: **Sara**\n└─ الحساب أنشئ: 2026-01-15"),
    ]),
    "log_chat": ("💬  رسالة جديدة — TEST", 0x2ECC71, [
        ("👤 العضو", "├─ المعرف: `345678`\n├─ الاسم: **TestUser**"),
        ("📍 الروم", "└── #general"),
        ("📝 الرسالة", "مرحبا بالجميع 👋"),
    ]),
    "log_server": ("➕  إعطاء رتبة — TEST", 0x5865F2, [
        ("👤 العضو", "├─ المعرف: `901234`\n├─ الاسم: **NewMember**"),
        ("👨‍⚖️ المنفذ", "└── @Admin (`111222`)"),
        ("🎭 الرتب", "├─ @VIP (`123`)\n└─ @Member (`456`)"),
    ]),
    "log_voice": ("🎤  تحديث صوتي — TEST", 0x7289DA, [
        ("👤 العضو", "├─ المعرف: `567890`\n├─ الاسم: **Ahmad**"),
        ("🎤 تحديث الصوت", "├─ الميك: 🔇 مكتوم ذاتياً\n└─ الانتقال: #غرفة-أ → #غرفة-ب"),
    ]),
    "log_integrations": ("🔗  ويب هوك — TEST", 0x9B59B6, [
        ("👤 العضو", "├─ المعرف: `123456`\n├─ الاسم: **Admin**"),
        ("📋 التفاصيل", "├─ النوع: إنشاء ويب هوك\n└─ الروم: #general"),
    ]),
}

async def main():
    client = discord.Client(intents=discord.Intents.default())
    @client.event
    async def on_ready():
        TARGET = "1506381047120531496"
        config = log_channels.get(TARGET, {})
        sent, failed = 0, 0
        for group, (title, color, fields) in TESTS.items():
            ch_id = config.get(group)
            if not ch_id:
                ch_id = config.get("main")
            if not ch_id:
                print(f"  {group}: no channel", flush=True)
                failed += 1
                continue
            ch = client.get_channel(int(ch_id))
            if not ch:
                print(f"  {group}: channel {ch_id} not found", flush=True)
                failed += 1
                continue
            embed = discord.Embed(title=title, color=color, description="🧪 رسالة تختبر نظام اللوق الجديد")
            for fn, fv in fields:
                embed.add_field(name=fn, value=fv, inline=False)
            embed.set_footer(text="🌐 MAX BOT • TEST")
            try:
                await ch.send(embed=embed)
                sent += 1
                print(f"  {group}: OK -> #{ch.name}", flush=True)
            except Exception as e:
                failed += 1
                print(f"  {group}: FAIL -> {type(e).__name__}", flush=True)
            await asyncio.sleep(0.5)
        print(f"\nDONE: {sent} sent, {failed} failed", flush=True)
        await client.close()
    await client.start(TOKEN)

asyncio.run(main())
