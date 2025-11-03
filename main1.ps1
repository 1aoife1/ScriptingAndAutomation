# ==============================================
# Reuses previous lab functions via dot notation
# ==============================================

. (Join-Path $PSScriptRoot ApacheLogs.ps1)
. (Join-Path $PSScriptRoot Event-Log.ps1)
. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot String-Helper.ps1)
. (Join-Path $PSScriptRoot ProcessMgmt.ps1)

Clear-Host

do {
    Write-Host ""
    Write-Host "===== Main Operations Menu ====="
    Write-Host "1. Display last 10 Apache logs"
    Write-Host "2. Display last 10 failed logins for all users"
    Write-Host "3. Display at-risk users"
    Write-Host "4. Start Chrome and open champlain.edu"
    Write-Host "5. Exit"
    Write-Host "================================"
    $choice = Read-Host "Enter your choice (1-5)"

    switch ($choice) {

        1 {
            Write-Host "`n--- Last 10 Apache Logs ---`n"
            try {
                $logs = ApacheLogs1
                if ($logs) {
                    $logs | Select-Object -Last 10 | Format-Table -AutoSize -Wrap
                } else {
                    Write-Host "No logs found or file empty."
                }
            } catch {
                Write-Host "Error reading Apache logs."
            }
            Pause
        }

        2 {
            Write-Host "`n--- Last 10 Failed Logins ---`n"
            try {
                $failed = getFailedLogins 90
                $failed | Select-Object -Last 10 | Format-Table Time, User
            } catch {
                Write-Host "Error retrieving failed logins."
            }
            Pause
        }

        3 {
            Write-Host "`n--- At-Risk Users (More than 10 failed logins in past 90 days) ---`n"
            try {
                $failed = getFailedLogins 90
                $grouped = $failed | Group-Object User | Where-Object { $_.Count -gt 10 }
                if ($grouped) {
                    $grouped | Select-Object Name, Count | Format-Table -AutoSize
                } else {
                    Write-Host "No at-risk users found."
                }
            } catch {
                Write-Host "Error processing at-risk users."
            }
            Pause
        }

        4 {
            Write-Host "`n--- Checking Chrome status ---`n"
            try {
                StartChrome
            } catch {
                Write-Host "Error starting Chrome."
            }
            Pause
        }

        5 {
            Write-Host "Goodbye."
        }

        Default {
            Write-Host "Invalid selection. Please enter a number between 1 and 5."
            Pause
        }
    }

} until ($choice -eq 5)
