Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\Users\USER\Desktop\z1-pro"
WshShell.Run "cmd /c cloudflared tunnel --url http://127.0.0.1:5001 >> tunnel.log 2>&1", 0, False
