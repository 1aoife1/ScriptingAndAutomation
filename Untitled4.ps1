
$files = Get-ChildItem -Recurse -File -Exclude "outfolder"
$files | Where-Object { $_.Extension -eq '.csv' } | ForEach-Object {
    Rename-Item $_.FullName -NewName ($_.BaseName + '.log')
}

Get-ChildItem -Recurse -File
