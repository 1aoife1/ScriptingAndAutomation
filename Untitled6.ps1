# Challenge 1

function IOC {
    param (
        [string]$Url = "http://10.0.17.47/IOC.html"
    )


    $html = Invoke-WebRequest -Uri $Url
    $content = $html.Content

  
    $cells = [regex]::Matches($content, '<td>(.*?)</td>') | ForEach-Object {
        $_.Groups[1].Value.Trim()
    }

 
    $iocs = for ($i = 0; $i -lt $cells.Count; $i += 2) {
        [PSCustomObject]@{
            Pattern     = $cells[$i]
            Description = $cells[$i + 1]
        }
    }


    $iocs
}


IOC
