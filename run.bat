@echo off
cd /d "%~dp0"
echo ================================
echo   Z1 BOT
echo   Auto-restart every hour
echo ================================
:loop
echo [%date% %time%] Starting bot...
"C:\Users\USER\AppData\Local\Python\pythoncore-3.14-64\python.exe" main.py
echo [%date% %time%] Bot closed. Restarting in 3 seconds...
timeout /t 3 /nobreak >nul
goto loop
