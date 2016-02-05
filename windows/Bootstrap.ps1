
# e.g.
#iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/WimObiwan/CommonMachineConfig/master/windows/Bootstrap.ps1'))

# Check Administrator
if (-not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
	Write-Error "This script must be run as administrator!"
	exit 1
}

# Ensure chocolatey
if (-not (Test-Path (where.exe choco))) {
	Write-Host "Installing chocolatey"
	iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host "Installing GIT"
choco install git --yes

$targetdir = Join-Path $env:USERPROFILE CommonMachineConfig

Set-Alias git (Join-Path $env:ProgramFiles 'git\cmd\git.exe')

if (Test-Path $targetdir) {
	Remove-Item -Recurse -Force $targetdir
}

Write-Host "Cloning CommonMachineConfig"
git clone https://github.com/WimObiwan/CommonMachineConfig.git "$targetdir"

$install = Join-Path $targetdir "windows\Install.ps1"
Write-Host "Bootstrap done.  Launching Install at '$install'."
. $install