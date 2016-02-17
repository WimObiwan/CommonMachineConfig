$ProfileDir = Split-Path $PROFILE
$CommonProfile = $MyInvocation.MyCommand.Path
$CommonProfileDir = Split-Path $CommonProfile
$CommonMachineConfigDir = Split-Path $CommonProfileDir

#Fixed HOMEDRIVE/HOMEPATH after domain changes
$env:HOMEDRIVE = ($env:USERPROFILE -replace '(.*\:).*', '$1')
$env:HOMEPATH = ($env:USERPROFILE -replace '.*\:(.*)', '$1')

Write-Host "Executing Common Profile '$CommonProfile'"

$Script:IsCompilerMachine = $env:COMPUTERNAME -iin ('WIMDESK')
$Script:IsMyForceDevMachine = $env:COMPUTERNAME -iin ('WIMDESK')

function Set-AliasWithCheck {
	param 
	(
		[string]$Name, 
		[string]$Value
	)
	
	if (Test-Path $Value) {
		Write-Host "Adding alias: $Name => $Value"
		
		Set-Alias -Scope Global $Name $Value
	}
}

Set-Alias whereis (where.exe where.exe)
#Set-Alias git 'C:\Program Files\Git\bin\git.exe'
#Set-Alias gitk 'C:\Program Files\Git\cmd\gitk.cmd'
Set-AliasWithCheck ssh-agent 'C:\Program Files\Git\usr\bin\ssh-agent.exe'
Set-AliasWithCheck ssh 'C:\Program Files\Git\usr\bin\ssh.exe'
Set-AliasWithCheck edit 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Set-AliasWithCheck nano 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Set-AliasWithCheck 7z 'C:\Program Files\7-Zip\7z.exe'
Set-Alias Gui (whereis powershell_ise.exe)
Set-AliasWithCheck FxGqlC 'C:\Tools\FxGqlC\FxGqlC.exe'

$DefaultDir = $env:SystemDrive

if ($Script:IsMyForceDevMachine) {
	Set-Alias CTDesignDebug 'c:\SourceGIT\CTArchitect\CTDesign\Debug\CTDesign.exe'
	Set-Alias CTDesign 'c:\SourceGIT\CTArchitect\CTDesign\Release\CTDesign.exe'
	
	function DoProjectCopyFunc { cscript.exe C:\SourceGIT\CTArchitect\ProjectCopy\UpdateFromProject.vbs C:\SourceGIT\ContactCentre }
	Set-Alias DoProjectCopy DoProjectCopyFunc
	function DoProjectCopyFunc2 { cscript.exe C:\SourceGIT\CTArchitect2\ProjectCopy\UpdateFromProject.vbs C:\SourceGIT\ContactCentre }
	Set-Alias DoProjectCopy2 DoProjectCopyFunc2
	
	$DefaultDir = 'c:\SourceGIT'
}

Install-Module posh-git
if (Get-Module posh-git) {
    # Taken from PoshGit example profile
	
	# Load posh-git module from current directory
	Import-Module posh-git

	# If module is installed in a default location ($env:PSModulePath),
	# use this instead (see about_Modules for more information):
	# Import-Module posh-git


	# Set up a simple prompt, adding the git prompt parts inside git repos
	function global:prompt {
		$realLASTEXITCODE = $LASTEXITCODE

		Write-Host($pwd.ProviderPath) -nonewline

		Write-VcsStatus

		$global:LASTEXITCODE = $realLASTEXITCODE
		return "> "
	}

	Start-SshAgent -Quiet
}

cd $DefaultDir

Write-Host
