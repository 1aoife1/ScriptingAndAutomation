# ******************************************************
# Function: getEnabledUsers
# ******************************************************
function getEnabledUsers() {
    Get-LocalUser | Where-Object { $_.Enabled -eq $true } | Select-Object Name, SID
}

# ******************************************************
# Function: getNotEnabledUsers
# ******************************************************
function getNotEnabledUsers() {
    Get-LocalUser | Where-Object { $_.Enabled -eq $false } | Select-Object Name, SID
}

# ******************************************************
# Function: createAUser
# ******************************************************
function createAUser($name, $password) {
    $params = @{
        Name     = $name
        Password = $password
    }
    $newUser = New-LocalUser @params 
    Set-LocalUser $newUser -PasswordNeverExpires $false
    Disable-LocalUser $newUser
}

# ******************************************************
# Function: removeAUser
# ******************************************************
function removeAUser($name) {
    $userToBeDeleted = Get-LocalUser | Where-Object { $_.Name -ilike $name }
    if ($userToBeDeleted) {
        Remove-LocalUser $userToBeDeleted
    } else {
        Write-Host "User not found."
    }
}

# ******************************************************
# Function: disableAUser
# ******************************************************
function disableAUser($name) {
    $u = Get-LocalUser | Where-Object { $_.Name -ilike $name }
    if ($u) { Disable-LocalUser $u } else { Write-Host "User not found." }
}

# ******************************************************
# Function: enableAUser
# ******************************************************
function enableAUser($name) {
    $u = Get-LocalUser | Where-Object { $_.Name -ilike $name }
    if ($u) { Enable-LocalUser $u } else { Write-Host "User not found." }
}

# ******************************************************
# Function: checkUser
# Checks if a given username exists
# Returns $true if exists, $false if not
# ******************************************************
function checkUser($name) {
    $exists = Get-LocalUser | Where-Object { $_.Name -ieq $name }
    if ($exists) { return $true } else { return $false }
}
