Get-Process python -ErrorAction SilentlyContinue | ForEach-Object {
    $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
    if ($cmd -match 'main\.py|app\.py') {
        Stop-Process -Id $_.Id -Force
        Write-Host "  [KILL] PID $($_.Id)"
    }
}
Get-Process cloudflared -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Write-Host "  [KILL] cloudflared (if running)"

$botRunning = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
    $cmd -match 'main\.py'
}
$dashRunning = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
    $cmd -match 'app\.py'
}
$tunRunning = Get-Process cloudflared -ErrorAction SilentlyContinue

Write-Host ""
if (-not $botRunning -and -not $dashRunning -and -not $tunRunning) {
    Write-Host "  [OK] All services stopped!"
} else {
    Write-Host "  [WARN] Some processes may still be running"
}
