from PIL import Image, ImageDraw, ImageFont
import os

W, H = 800, 1100
img = Image.new('RGB', (W, H), '#313338')
draw = ImageDraw.Draw(img)

try:
    font_b = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 16)
    font_m = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 16)
    font_s = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 16)
    font_xs = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 16)
    font_title = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 20)
except:
    font_b = ImageFont.load_default()
    font_m = font_b
    font_s = font_b
    font_xs = font_b
    font_title = font_b

def draw_rounded_rect(d, xy, r, fill):
    x1, y1, x2, y2 = xy
    d.rounded_rectangle(xy, radius=int(r), fill=fill)

def draw_embed(d, y_start, accent_color, title, fields, footer_text):
    margin_x = 40
    embed_w = W - margin_x * 2
    embed_h = 0
    
    for f in fields:
        lines = f['value'].count('\n') + 1
        embed_h += 28 + lines * 20
    
    embed_h += 80
    accent_x = margin_x
    body_x = margin_x + 5
    body_w = embed_w - 5
    
    draw_rounded_rect(d, (accent_x, y_start, accent_x + 5, y_start + embed_h), 3, accent_color)
    draw_rounded_rect(d, (body_x, y_start, body_x + body_w, y_start + embed_h), 8, '#2b2d31')
    
    cur_y = y_start + 12
    
    d.text((body_x + 16, cur_y), title, fill='#f2f3f5', font=font_b)
    cur_y += 32
    
    for f in fields:
        d.text((body_x + 16, cur_y), f['name'], fill='#b5bac1', font=font_xs)
        cur_y += 18
        for line in f['value'].split('\n'):
            color = '#dbdee1'
            if '`' in line:
                color = '#949ba4'
            elif '@' in line:
                color = '#c9cdfb'
            elif 'http' in line or 'صورة' in line:
                color = '#00a8fc'
            d.text((body_x + 20, cur_y), line, fill=color, font=font_s)
            cur_y += 20
        cur_y += 6
    
    cur_y += 4
    d.line([(body_x + 16, cur_y), (body_x + body_w - 16, cur_y)], fill='#3f4147', width=1)
    cur_y += 10
    
    d.text((body_x + 16, cur_y), footer_text, fill='#949ba4', font=font_xs)
    
    return y_start + embed_h + 20

cur_y = 30

d_title = "🎨 تصميم Log Embed الاحترافي — MAX BOT"
bbox = draw.textbbox((0, 0), d_title, font=font_title)
tw = bbox[2] - bbox[0]
draw.text(((W - tw) // 2, cur_y), d_title, fill='#f2f3f5', font=font_title)
cur_y += 45

d_sub = "Mockup — كيف تبدو السجلات في ديسكورد"
bbox2 = draw.textbbox((0, 0), d_sub, font=font_s)
sw = bbox2[2] - bbox2[0]
draw.text(((W - sw) // 2, cur_y), d_sub, fill='#949ba4', font=font_s)
cur_y += 40

cur_y = draw_embed(draw, cur_y, '#000000', '⚖️  حظر عضو', [
    {'name': '👤 العضو', 'value': '├─ المعرف: `123456789012345678`\n├─ الاسم: Ahmad\n├─ الرتب:\n│   🟣 @Admin\n│   🔵 @Moderator\n│   🟢 @Member\n└─ الأفاتار: [صورة](https://cdn.discordapp.com)'},
    {'name': '👨‍⚖️ المنفذ', 'value': '└── @MaxBot (`1379265753877975182`)'},
    {'name': '📋 التفاصيل', 'value': '├─ السبب: مخالفة قواعد السيرفر\n└─ الإجراء: حظر نهائي من السيرفر'},
], '🌐  MAX BOT  •  2026-06-11 00:15')

cur_y = draw_embed(draw, cur_y, '#2ECC71', '💬  رسالة جديدة', [
    {'name': '👤 العضو', 'value': '├─ المعرف: `987654321012345678`\n├─ الاسم: Sara\n└─ الأفاتار: [صورة](https://cdn.discordapp.com)'},
    {'name': '📍 الروم', 'value': '└── #general'},
    {'name': '📝 الرسالة', 'value': 'مرحبا بالجميع 👋 كيف حالكم اليوم؟'},
    {'name': '📎 المرفقات', 'value': '📎 [photo.jpg](https://cdn.discordapp.com)'},
], '🌐  MAX BOT  •  2026-06-11 00:15')

cur_y = draw_embed(draw, cur_y, '#E67E22', '👢  طرد عضو', [
    {'name': '👤 العضو', 'value': '├─ المعرف: `555666777888999000`\n├─ الاسم: TrollUser\n├─ الرتب:\n│   🟢 @Member\n└─ الأفاتار: [صورة](https://cdn.discordapp.com)'},
    {'name': '👨‍⚖️ المنفذ', 'value': '└── @Admin (`111222333444555666`)'},
    {'name': '📋 التفاصيل', 'value': '├─ السبب: سبام وإزعاج الأعضاء\n└─ الإجراء: طرد من السيرفر'},
], '🌐  MAX BOT  •  2026-06-11 00:15')

cur_y = draw_embed(draw, cur_y, '#E67E22', '🔇  كتم عضو', [
    {'name': '👤 العضو', 'value': '├─ المعرف: `777888999000111222`\n├─ الاسم: Spammer\n└─ الأفاتار: [صورة](https://cdn.discordapp.com)'},
    {'name': '👨‍⚖️ المنفذ', 'value': '└── @Moderator (`333444555666777888`)'},
    {'name': '📋 التفاصيل', 'value': '├─ السبب: سبام رسائل\n└─ الإجراء: كتم لمدة 10m'},
], '🌐  MAX BOT  •  2026-06-11 00:15')

cur_y = draw_embed(draw, cur_y, '#2ECC71', '➕  إعطاء رتبة', [
    {'name': '👤 العضو', 'value': '├─ المعرف: `111222333444555666`\n├─ الاسم: NewMember\n└─ الأفاتار: [صورة](https://cdn.discordapp.com)'},
    {'name': '👨‍⚖️ المنفذ', 'value': '└── @Admin (`999888777666555444`)'},
    {'name': '🎭 الرتب', 'value': '├─ @VIP (`1234567890`)\n└─ @Member (`0987654321`)'},
], '🌐  MAX BOT  •  2026-06-11 00:15')

if cur_y < H - 60:
    draw_rounded_rect(draw, (40, cur_y, W - 40, cur_y + 55), 8, '#1e1f22')
    cur_y += 12
    legend_items = [
        ('#000000', 'حظر'),
        ('#E67E22', 'طرد/كتم'),
        ('#2ECC71', 'إنشاء'),
        ('#E74C3C', 'حذف'),
        ('#3498DB', 'تعديل'),
        ('#7289DA', 'صوتي'),
        ('#5865F2', 'رتب'),
    ]
    lx = 60
    for color, label in legend_items:
        draw.rounded_rectangle((lx, cur_y + 15, lx + 12, cur_y + 27), radius=2, fill=color)
        draw.text((lx + 16, cur_y + 13), label, fill='#dbdee1', font=font_xs)
        lx += 90

out = r'C:\Users\USER\Desktop\z1-pro\log_embed_preview.png'
img.save(out, 'PNG')
print(f"Saved: {out}")
