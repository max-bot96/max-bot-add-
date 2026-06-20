@echo off
echo =============================================
echo   MAX BOT - 24/7 Service Installer
echo =============================================
echo.
echo This will install 4 services:
echo   1. MaxBotBot (Discord Bot)
echo   2. MaxBotDashboard (Web Dashboard)
echo   3. MaxBotTunnel247 (Cloudflare Tunnel)
echo   4. MaxBotWatchdog (Auto-restart monitor)
echo.
echo All services will start on boot and restart
echo automatically if they crash.
echo.
echo Press any key to continue...
pause > nul

echo.
echo Deleting old tasks...
schtasks /delete /tn MaxBotRun /f >nul 2>&1
schtasks /delete /tn MaxBotWeb /f >nul 2>&1
schtasks /delete /tn MaxBotTunnel /f >nul 2>&1
schtasks /delete /tn MaxBotBot /f >nul 2>&1
schtasks /delete /tn MaxBotDashboard /f >nul 2>&1
schtasks /delete /tn MaxBotTunnel247 /f >nul 2>&1
schtasks /delete /tn MaxBotWatchdog /f >nul 2>&1
echo Old tasks deleted.

echo.
echo Creating new 24/7 tasks...
schtasks /create /tn "MaxBotBot" /xml "C:\Users\USER\Desktop\z1-pro\task_bot_247.xml" /f
schtasks /create /tn "MaxBotDashboard" /xml "C:\Users\USER\Desktop\z1-pro\task_dashboard_247.xml" /f
schtasks /create /tn "MaxBotTunnel247" /xml "C:\Users\USER\Desktop\z1-pro\task_tunnel_247.xml" /f
schtasks /create /tn "MaxBotWatchdog" /xml "C:\Users\USER\Desktop\z1-pro\task_watchdog_247.xml" /f

echo.
echo Starting all services...
schtasks /run /tn MaxBotBot
schtasks /run /tn MaxBotDashboard
schtasks /run /tn MaxBotTunnel247
schtasks /run /tn MaxBotWatchdog

echo.
echo =============================================
echo   ALL SERVICES INSTALLED AND STARTED!
echo =============================================
echo.
echo Services:
echo   - MaxBotBot: runs at boot + logon
echo   - MaxBotDashboard: runs at boot + logon
echo   - MaxBotTunnel247: runs at boot + logon
echo   - MaxBotWatchdog: monitors and restarts all
echo.
echo Auto-restart: ON (retries 999 times, 1 min interval)
echo Boot start: ON (starts automatically on boot)
echo Time limit: NONE (runs forever)
echo.
echo Press any key to exit...
pause > nul
