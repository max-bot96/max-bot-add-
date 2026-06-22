import json, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
d = json.load(open('commands_data.json','r',encoding='utf-8'))
cmds = [c for c in d if c.get('prefix','!') == '!']
cats = {}
for c in cmds:
    cat = c.get('category','غير محدد')
    if cat not in cats: cats[cat] = []
    cats[cat].append(c)
for cat in sorted(cats.keys()):
    print(f'\n=== {cat} ({len(cats[cat])}) ===')
    for c in cats[cat]:
        name = c.get('name','')
        desc = c.get('description','')
        aliases = c.get('aliases', [])
        alias_str = ''
        if aliases:
            alias_str = ' | '.join(aliases)
        print(f"  !{name} - {desc} {alias_str}")
