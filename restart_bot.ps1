# Restart Bot Script
Write-Host "  [1/2] Stopping bot..."
Get-Process python -ErrorAction SilentlyContinue | ForEach-Object {
    $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
    if ($cmd -match 'main\.py') {
        Stop-Process -Id $_.Id -Force
        Write-Host "  [KILL] Bot PID $($_.Id)"
    }
}
Start-Sleep -Seconds 3

Write-Host "  [2/2] Starting Bot..."
$py = "C:\Users\USER\AppData\Local\Python\pythoncore-3.14-64\python.exe"
$dir = "C:\Users\USER\Desktop\z1-pro"
Start-Process -FilePath "cmd.exe" -ArgumentList "/c set PYTHONUNBUFFERED=1 && `"$py`" -u main.py >> bot.log 2>&1" -WorkingDirectory $dir -WindowStyle Hidden
Start-Sleep -Seconds 8

$running = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
    $cmd -match 'main\.py'
}
if ($running) {
    Write-Host "  [OK] Bot is RUNNING (PID $($running.Id))"
} else {
    Write-Host "  [FAIL] Bot failed to start! Check bot.log"
}
