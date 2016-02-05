
# Check Administrator
if (-not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
	Write-Error "This script must be run as administrator!"
	exit 1
}

# Run the Powershell profile
$scriptpath = Split-Path $MyInvocation.MyCommand.Path
$profile_new = Join-Path $scriptpath "WindowsPowerShell\profile.ps1"
. "$profile_new"

# Ensure chocolatey
if (-not (Test-Path (whereis choco))) {
	iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

# TODO: Install Powershell 4, ...

###############
# Set profile #
###############
$backup = "$profile-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
cp $profile $backup
". '$profile_new'" | Out-File $profile

$compare = Compare-Object (Get-Content $profile) (Get-Content $backup)
if ($compare) {
	Write-Warning "Your WindowsPowerShell profile '$profile' was changed (backup saved to '$backup').  Changes:`n$($compare | Out-String)"
} else {
	Remove-Item $backup
}
