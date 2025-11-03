function gatherClasses(){

    $page = Invoke-WebRequest -TimeoutSec 5 http://localhost/Courses2025FA.html

    # All table rows
    $trs = $page.ParsedHtml.getElementsByTagName('tr')

    $FullTable = @()

    for($i = 1; $i -lt $trs.length; $i++) {   # skip header row

        $tds = $trs[$i].getElementsByTagName('td')
        if (-not $tds -or $tds.length -eq 0) { continue }

        $cols = New-Object object[] 10
        $colIndex = 0

        foreach($td in @($tds)) {
            if ($colIndex -ge $cols.Length) { break }

            $text = ($td.innerText -replace '\s+', ' ').Trim()
            $span = 1
            try { $span = [int]$td.colSpan } catch {}

            $cols[$colIndex] = $text
            $colIndex += $span
        }

        $timeStart = ""
        $timeEnd   = ""
        if ($cols[5] -and $cols[5] -notmatch '^TBA$') {
            $parts = $cols[5] -split '-'
            if ($parts.Count -ge 1) { $timeStart = $parts[0].Trim() }
            if ($parts.Count -ge 2) { $timeEnd   = $parts[1].Trim() }
        }

        $FullTable += [PSCustomObject]@{
            "Class Code" = ($cols[0] | ForEach-Object { $_ }) 
            "Title"      = ($cols[1] | ForEach-Object { $_ })
            "Days"       = ($cols[4] | ForEach-Object { $_ })
            "Time Start" = $timeStart
            "Time End"   = $timeEnd
            "Instructor" = ($cols[6] | ForEach-Object { $_ })
            "Location"   = ($cols[9] | ForEach-Object { $_ })
        }
    }

    return $FullTable
}
