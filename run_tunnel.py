import subprocess, threading, os, sys
os.chdir(os.path.dirname(os.path.abspath(__file__)))

def run_tunnel():
    p = subprocess.Popen(
        ['ssh', '-o', 'StrictHostKeyChecking=no', '-o', 'ServerAliveInterval=30', '-R', '80:localhost:5000', 'serveo.net'],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
    )
    for line in iter(p.stdout.readline, ''):
        line = line.strip()
        for w in line.split():
            if w.startswith('https://') and '.serveo' in w or 'serveousercontent' in w:
                print(f'PUBLIC URL: {w}')
        if 'Forwarding' in line:
            print(line)
    p.wait()

t = threading.Thread(target=run_tunnel, daemon=True)
t.start()

from app import app
app.run(debug=False, port=5000, host='0.0.0.0')
