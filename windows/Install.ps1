
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

$Script:IsCompilerMachine = $env:COMPUTERNAME -iin ('WIMDESK')
$Script:IsMyForceDevMachine = $env:COMPUTERNAME -iin ('WIMDESK')
$Script:IsDesktop = $env:COMPUTERNAME -iin ('WIMDESK')

# Runtimes
choco install vcredist2013 --yes
choco install vcredist2012 --yes
choco install vcredist2010 --yes
choco install vcredist2008 --yes
choco install vcredist2005 --yes
choco install DotNet4.5 --yes

# Sysadmin tools
choco install chocolateygui --yes
choco install notepadplusplus --yes
choco install LinkShellExtension --yes
choco install pscx --yes
choco install poshgit --yes
choco install putty --yes
choco install gitextensions --yes
#choco install tortoisesvn --yes
#choco install tortoisegit --yes
choco install kdiff3 --yes
choco install wincdemu --yes
choco install fxgqlc --yes

#choco cygwin
#choco cyg-get
#cyg-get git,git-svn

if (-$Script:IsCompilerMachine) {
	#choco install VisualStudio2013Professional -InstallArguments "/Features:'WebTools Win8SDK'"
}

if (-$Script:IsDesktop) {
	choco install greenshot --yes
	choco install terminals --yes
	choco install vmwarevsphereclient --yes
	choco install keepass-classic --yes
}

###############
# Set profile #
###############
if (Test-Path $profile) {
	$backup = "$profile-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
	cp $profile $backup
} else {
	$backup = $null
}
mkdir -force $profiledir | Out-Null
". '$profile_new'" | Out-File $profile

if ($backup) {
	$compare = Compare-Object (Get-Content $profile) (Get-Content $backup)
	if ($compare) {
		Write-Warning "Your WindowsPowerShell profile '$profile' was changed (backup saved to '$backup').  Changes:`n$($compare | Out-String)"
	} else {
		Remove-Item $backup
	}
}

Write-Host "Running profile again."
. "$profile"

Write-Host "Install.ps1 finished."
