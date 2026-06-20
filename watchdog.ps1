# MAX BOT - 24/7 Watchdog Script
# Monitors bot, dashboard, and tunnel — restarts if crashed

$PYTHON = "C:\Users\USER\AppData\Local\Python\pythoncore-3.14-64\python.exe"
$DIR = "C:\Users\USER\Desktop\z1-pro"
$CLOUDFLARED = "$DIR\cloudflared.exe"

$BOT_CHECK_INTERVAL = 30
$WEB_CHECK_INTERVAL = 30
$TUNNEL_CHECK_INTERVAL = 30

function Write-Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts - $msg" | Out-File -FilePath "$DIR\watchdog.log" -Append -Encoding utf8
}

function Is-ProcessRunning($name) {
    $procs = Get-Process -Name $name -ErrorAction SilentlyContinue
    return ($null -ne $procs -and $procs.Count -gt 0)
}

function Is-BotRunning() {
    $procs = Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
        $_.CommandLine -like "*main.py*" -and $_.CommandLine -like "*python*"
    }
    return ($null -ne $procs -and @($procs).Count -gt 0)
}

function Is-DashboardRunning() {
    $procs = Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
        $_.CommandLine -like "*app.py*" -and $_.CommandLine -like "*python*" -and $_.CommandLine -notlike "*main.py*"
    }
    return ($null -ne $procs -and @($procs).Count -gt 0)
}

function Start-Bot() {
    Write-Log "Starting bot..."
    $proc = Start-Process -FilePath $PYTHON -ArgumentList "-u main.py" -WorkingDirectory $DIR -WindowStyle Hidden -RedirectStandardOutput "$DIR\bot.log" -RedirectStandardError "$DIR\bot_err.log" -PassThru
    Write-Log "Bot started with PID: $($proc.Id)"
}

function Start-Dashboard() {
    Write-Log "Starting dashboard..."
    $proc = Start-Process -FilePath $PYTHON -ArgumentList "-u app.py" -WorkingDirectory $DIR -WindowStyle Hidden -RedirectStandardOutput "$DIR\dashboard.log" -RedirectStandardError "$DIR\dashboard_err.log" -PassThru
    Write-Log "Dashboard started with PID: $($proc.Id)"
}

function Start-Tunnel() {
    Write-Log "Starting cloudflared tunnel..."
    $proc = Start-Process -FilePath $CLOUDFLARED -ArgumentList "tunnel --url http://127.0.0.1:5001" -WorkingDirectory $DIR -WindowStyle Hidden -RedirectStandardOutput "$DIR\tunnel.log" -RedirectStandardError "$DIR\tunnel_err.log" -PassThru
    Write-Log "Tunnel started with PID: $($proc.Id)"
}

Write-Log "=== Watchdog started ==="

while ($true) {
    # Check Bot
    if (-not (Is-BotRunning)) {
        Write-Log "Bot is DOWN! Restarting..."
        Start-Bot
    }

    # Check Dashboard
    if (-not (Is-DashboardRunning)) {
        Write-Log "Dashboard is DOWN! Restarting..."
        Start-Dashboard
    }

    # Check Tunnel
    if (-not (Is-ProcessRunning "cloudflared")) {
        Write-Log "Tunnel is DOWN! Restarting..."
        Start-Tunnel
    }

    Start-Sleep -Seconds $BOT_CHECK_INTERVAL
}
