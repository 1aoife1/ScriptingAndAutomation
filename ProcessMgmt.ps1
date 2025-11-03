function StartChrome {
    $url = "https://www.champlain.edu"
    $chromePaths = @(
        "C:\Program Files\Google\Chrome\Application\chrome.exe",
        "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    )

    $chromePath = $chromePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if (-not $chromePath) {
        Write-Host "❌ Chrome executable not found. Please verify installation path." -ForegroundColor Red
        return
    }

    $chromeRunning = Get-Process -Name "chrome" -ErrorAction SilentlyContinue

    if ($chromeRunning) {
        Write-Host "🟡 Chrome is already running — opening new tab to Champlain.edu..." -ForegroundColor Yellow
        Start-Process $chromePath $url
    } else {
        Write-Host "🟢 Starting Chrome and navigating to Champlain.edu..." -ForegroundColor Green
        Start-Process $chromePath $url
    }
}
