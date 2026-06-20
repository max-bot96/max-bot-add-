import subprocess, os, sys

PYTHON = r"C:\Users\USER\AppData\Local\Python\pythoncore-3.14-64\python.exe"
MAIN = r"C:\Users\USER\Desktop\z1-pro\main.py"
DETACHED = 0x00000008

proc = subprocess.Popen(
    [PYTHON, "-u", MAIN],
    cwd=r"C:\Users\USER\Desktop\z1-pro",
    creationflags=DETACHED,
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL,
    stdin=subprocess.DEVNULL,
)
print(f"Bot started with PID {proc.pid}")
