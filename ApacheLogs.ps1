function ApacheLogs1() {
    $logPath = "C:\xampp\apache\logs\access.log"

    if (-not (Test-Path $logPath)) {
        Write-Host "Apache log not found at $logPath"
        return
    }

    $lines = Get-Content $logPath
    $tableRecords = @()   # ✅ initialize array

    foreach ($line in $lines) {
        $words = $line -split " "
        if ($words.Length -ge 11) {
            $tableRecords += [PSCustomObject]@{
                "IP"        = $words[0].Trim()
                "Time"      = ($words[3] + " " + $words[4]).Trim("[ ]")
                "Method"    = $words[5].Trim('"')
                "Page"      = $words[6]
                "Protocol"  = $words[7].Trim('"')
                "Response"  = $words[8]
                "Referrer"  = ($words[10]).Trim('"')
            }
        }
    }

    return $tableRecords | Where-Object { $_.IP -like "10.*" }
}
