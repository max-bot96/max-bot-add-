@echo off
chcp 65001 >nul
title MAX BOT - Control Panel
cd /d "%~dp0"
set "PY=C:\Users\USER\AppData\Local\Python\pythoncore-3.14-64\python.exe"

:menu
cls
echo.
echo  ==========================================
echo     MAX BOT - Control Panel
echo  ==========================================
echo.
echo  [1]  Start ALL (Hidden)
echo  [2]  Start Bot Only (Hidden)
echo  [3]  Start Dashboard Only (Hidden)
echo  [4]  Stop All
echo  [5]  Restart Bot
echo  [6]  Bot Status
echo  [7]  View Logs
echo  [8]  Open Dashboard Link
echo  [9]  Exit
echo.
set /p choice="Choose: "

if "%choice%"=="1" goto all
if "%choice%"=="2" goto bot
if "%choice%"=="3" goto web
if "%choice%"=="4" goto stop
if "%choice%"=="5" goto restart
if "%choice%"=="6" goto status
if "%choice%"=="7" goto logs
if "%choice%"=="8" goto link
if "%choice%"=="9" goto exit_app
echo Invalid choice!
timeout /t 2 >nul
goto menu

:all
cls
echo.
echo  [*] Starting ALL (Hidden)...
echo  [*] Starting Bot...
cscript //nologo "%~dp0run_bot.vbs"
timeout /t 3 >nul
echo  [+] Bot started!
echo  [*] Starting Dashboard...
cscript //nologo "%~dp0run_dashboard.vbs"
timeout /t 3 >nul
echo  [+] Dashboard started!
echo  [*] Starting Tunnel...
cscript //nologo "%~dp0run_tunnel.vbs"
echo  [+] Waiting for tunnel URL...
timeout /t 12 >nul
echo  [+] Extracting tunnel URL...
"%PY%" -c "import re; f=open('tunnel.log','r',errors='ignore'); t=f.read(); f.close(); matches=re.findall(r'https://[a-z0-9-]+\.trycloudflare\.com',t); url=matches[-1] if matches else ''; open('server_url2.txt','w',encoding='utf-8').write(url) if url else None; print('  [+] URL: '+url) if url else print('  [!] URL not found')"
echo.
echo  ==========================================
echo     ALL STARTED (Hidden)!
echo  ==========================================
echo.
if exist "%~dp0server_url2.txt" (
    echo  Link:
    type "%~dp0server_url2.txt"
) else (
    echo  Dashboard: http://127.0.0.1:5001
)
echo.
echo  ==========================================
echo.
pause
goto menu

:bot
cls
echo.
echo  [*] Starting Bot (Hidden)...
cscript //nologo "%~dp0run_bot.vbs"
echo  [+] Bot started!
echo.
pause
goto menu

:web
cls
echo.
echo  [*] Starting Dashboard (Hidden)...
cscript //nologo "%~dp0run_dashboard.vbs"
timeout /t 3 >nul
echo  [+] Dashboard started!
echo  [*] Starting Tunnel (Hidden)...
cscript //nologo "%~dp0run_tunnel.vbs"
echo  [+] Waiting for tunnel URL...
timeout /t 12 >nul
echo  [+] Extracting tunnel URL...
"%PY%" -c "import re; f=open('tunnel.log','r',errors='ignore'); t=f.read(); f.close(); matches=re.findall(r'https://[a-z0-9-]+\.trycloudflare\.com',t); url=matches[-1] if matches else ''; open('server_url2.txt','w',encoding='utf-8').write(url) if url else None; print('  [+] URL: '+url) if url else print('  [!] URL not found')"
echo  [+] Done!
echo.
pause
goto menu

:stop
cls
echo.
echo  [*] Stopping all services...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0stop_all.ps1"
timeout /t 2 >nul
echo.
pause
goto menu

:restart
cls
echo.
echo  [*] Restarting Bot...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0restart_bot.ps1"
echo.
pause
goto menu

:status
cls
echo.
echo  ==========================================
echo     Bot Status
echo  ==========================================
echo.
tasklist /FI "IMAGENAME eq python.exe" 2>nul | find /I "python.exe" >nul && echo  [RUNNING] Bot running || echo  [STOPPED] Bot not running
tasklist /FI "IMAGENAME eq cloudflared.exe" 2>nul | find /I "cloudflared.exe" >nul && echo  [RUNNING] Tunnel running || echo  [STOPPED] Tunnel not running
echo.
if exist "%~dp0server_url2.txt" (
    echo  Link:
    type "%~dp0server_url2.txt"
) else (
    echo  Link: Not available
)
echo.
echo  ==========================================
echo.
pause
goto menu

:logs
cls
echo.
if exist "%~dp0bot.log" (
    start notepad "%~dp0bot.log"
) else (
    echo  No bot.log found!
    timeout /t 2 >nul
)
goto menu

:link
cls
echo.
if exist "%~dp0server_url2.txt" (
    set /p TUNNEL_URL=<"%~dp0server_url2.txt"
    start "" "!TUNNEL_URL!"
) else (
    start "" "http://127.0.0.1:5001"
)
goto menu

:exit_app
cls
echo.
echo  Goodbye!
timeout /t 1 >nul
exit
