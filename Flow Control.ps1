clear # Pulls login/logoff records from Windows Events
$logrecords = Get-EventLog System -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-14)


$logsrecordsTable = @()

for($i=0; $i -lt $logrecords.Count; $i++){

$event = ""
if($logrecords[$i].InstanceID -eq 7001) {$event="Logon"}
if($logrecords[$i].InstanceID -eq 7002) {$event="Logoff"}
$user = $logrecords[$i].ReplacementStrings[1]


$logsrecordsTable += [pscustomobject]@{"Time" = $logrecords[$i].TimeWritten; `
                                     "ID" = $logrecords[$i].InstanceID; `
                                     "Event" = $event; `
                                     "User" = $user;
                                     }
}

$logsrecordsTable