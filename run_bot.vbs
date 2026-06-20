Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\Users\USER\Desktop\z1-pro"
WshShell.Run "cmd /c set PYTHONUNBUFFERED=1 && C:\Users\USER\AppData\Local\Python\pythoncore-3.14-64\python.exe -u main.py >> bot.log 2>&1", 0, False
