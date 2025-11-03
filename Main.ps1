. "$PSScriptRoot\ScrapeClasses.ps1"
. "$PSScriptRoot\DaysTranslator.ps1"

$FullTable = gatherClasses
$FullTable = daysTranslator $FullTable
$FullTable
