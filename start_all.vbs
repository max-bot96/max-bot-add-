Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\Users\USER\Desktop\z1-pro"

' Start Bot
WshShell.Run "cmd /c set PYTHONUNBUFFERED=1 && C:\Users\USER\AppData\Local\Python\pythoncore-3.14-64\python.exe -u main.py >> bot.log 2>&1", 0, False
WScript.Sleep 3000

' Start Dashboard
WshShell.Run "cmd /c C:\Users\USER\AppData\Local\Python\pythoncore-3.14-64\python.exe -u app.py >> dashboard.log 2>&1", 0, False
WScript.Sleep 3000

' Start Tunnel
WshShell.Run "cmd /c cloudflared tunnel --url http://127.0.0.1:5001 >> tunnel.log 2>&1", 0, False
WScript.Sleep 5000

' Start Watchdog
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Users\USER\Desktop\z1-pro\watchdog.ps1", 0, False
