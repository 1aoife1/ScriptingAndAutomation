cd $PSScriptRoot
$files = Get-ChildItem
$folderPath = "$PSScriptRoot/outfolder/"
$filePath = Join-Path $folderPath "out.csv"


$files | Where-Object { $_.Extension -eq ".ps1" } | Export-Csv -Path $filePath
