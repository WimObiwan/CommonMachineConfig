
# e.g.
#iex ((new-object net.webclient).DownloadString('...'))

# Check Administrator
if (-not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
	Write-Error "This script must be run as administrator!"
	exit 1
}

# Ensure chocolatey
if (-not (Test-Path (whereis choco))) {
	iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco install git

$targetdir = Join-Path $env:USERPROFILE CommonMachineConfig

git clone https://github.com/WimObiwan/CommonMachineConfig.git "$targetdir"

cd Join-Path ($targetdir "windows\PowerShell")
.\Install.ps1
