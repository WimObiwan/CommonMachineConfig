$PROFILEDIR = Split-Path $PROFILE

$Script:IsDevMachine = $env:COMPUTERNAME -iin ('WIMDESK')
$Script:IsMyForceDevMachine = $env:COMPUTERNAME -iin ('WIMDESK')

function Set-AliasWithCheck {
	param 
	(
		[string]$Name, 
		[string]$Value
	)
	
	if (Test-Path $Value) {
		Write-Warning "$Name => $Value"
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

if ($Script:IsDevMachine) {
	Set-AliasWithCheck FxGqlC 'C:\Tools\FxGqlC\FxGqlC.exe'
}

if ($Script:IsMyForceDevMachine) {
	Set-Alias CTDesignDebug 'c:\SourceGIT\CTArchitect\CTDesign\Debug\CTDesign.exe'
	Set-Alias CTDesign 'c:\SourceGIT\CTArchitect\CTDesign\Release\CTDesign.exe'
	
	function DoProjectCopyFunc { cscript.exe C:\SourceGIT\CTArchitect\ProjectCopy\UpdateFromProject.vbs C:\SourceGIT\ContactCentre }
	Set-Alias DoProjectCopy DoProjectCopyFunc
	function DoProjectCopyFunc2 { cscript.exe C:\SourceGIT\CTArchitect2\ProjectCopy\UpdateFromProject.vbs C:\SourceGIT\ContactCentre }
	Set-Alias DoProjectCopy2 DoProjectCopyFunc2
}

if (Get-Module posh-git) {
	# 
	if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}
	. 'C:\tools\poshgit\dahlbyk-posh-git-fadc4dd\profile.example.ps1'
	$env:DebuggingTools = 'C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64'
	#. C:\Users\wim\Documents\WindowsPowerShell\sudo.ps1
	Rename-Item Function:\Prompt PoshGitPrompt -Force
	function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}
}
