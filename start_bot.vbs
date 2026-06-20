Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\Users\USER\Desktop\z1-pro"
WshShell.Run "python.exe -u main.py", 0, False
