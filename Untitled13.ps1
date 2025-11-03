Write-Host "`Instructor Class Counts"
$FullTable |
    Group-Object Instructor |
    Sort-Object Count -Descending |
    Select-Object @{Name="Name"; Expression={$_.Name}}, @{Name="Count"; Expression={$_.Count}} |
    Format-Table "Name", "Count" -AutoSize
