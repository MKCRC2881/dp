# Define the registry path
$RegistryPath = "HKLM:\SOFTWARE\Google\GCPW"
$ValueName = "domains_allowed_to_login"
$NewDomain = "galent.com"

# Check if the registry key exists
if (-Not (Test-Path $RegistryPath)) {
    Write-Output "Registry path does not exist. Creating it..."
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Get the current value of 'domains_allowed_to_login'
$currentDomains = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName

# If the current value is null, set the new domain
if (-not $currentDomains) {
    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $NewDomain
    Write-Output "Successfully set 'domains_allowed_to_login' to: $NewDomain"
} else {
    # Check if the new domain is already in the list
    if ($currentDomains -like "*$NewDomain*") {
        Write-Output "The domain '$NewDomain' is already allowed."
    } else {
        # Append the new domain to the existing ones
        $updatedDomains = "$currentDomains,$NewDomain"
        Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $updatedDomains
        Write-Output "Successfully updated 'domains_allowed_to_login' to: $updatedDomains"
    }
}
