<# String-Helper.ps1
*************************************************************
   This script contains functions that help with String/Match/Search
************************************************************* 
#>

# ******************************************************
# Function: getMatchingLines
# Input:   1) Text with multiple lines  
#          2) Keyword
# Output:  1) Array of lines that contain the keyword
# ******************************************************
function getMatchingLines($contents, $lookline){
    $allines = @()
    $splitted = $contents.split([Environment]::NewLine)

    for ($j = 0; $j -lt $splitted.Count; $j++) {  
        if ($splitted[$j].Length -gt 0) {  
            if ($splitted[$j] -ilike $lookline) { 
                $allines += $splitted[$j] 
            }
        }
    }
    return $allines
}


# ******************************************************
# Function: checkPassword
# Checks if the given string:
# - is at least 6 characters
# - has 1 letter, 1 number, 1 special character
# Returns $true if valid, else $false
# ******************************************************
function checkPassword($passwordString) {
    $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordString)
    )

    if ($plain.Length -lt 6) { return $false }
    if ($plain -notmatch '[A-Za-z]') { return $false }
    if ($plain -notmatch '\d') { return $false }
    if ($plain -notmatch '[^A-Za-z0-9]') { return $false }

    return $true
}
