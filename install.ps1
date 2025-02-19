$gbToolsBasePath = if ($env:GB_TOOLS_BASE_PATH) { $env:GB_TOOLS_BASE_PATH } else { "C:/GB" } 
$tempPath = "$env:TEMP/gbdk_installer"

$emuliciousPath = "$gbToolsBasePath/emulicious"
$emuliciousUrl = "https://emulicious.net/download/emulicious-with-64-bit-java-for-windows/?wpdmdl=989"
$emuliciousZipPath = "$tempPath/emulicious.zip"

$gbdkPath = "$gbToolsBasePath/gbdk"
$gbdkUrl = "https://github.com/gbdk-2020/gbdk-2020/releases/latest/download/gbdk-win64.zip"
$gbdkZipPath = "$tempPath/gbdk-win64.zip"

$windowsTerminalSettingsPath = "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
$profileName = "GBDK"
$profileGuid = "{3e4cbead-a666-4762-baea-ace7935ba537}"
$profileScriptPath = "$gbToolsBasePath/GBDK.ps1"
$profileIconPath = "$gbToolsBasePath/gbdk_icon.png"
$moduleFilePath = "$gbToolsBasePath/GBDK.psm1"

$progressPreference = 'silentlyContinue'

###################
# Installing WinGet
###################
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe

$packagesToInstall = 
	"Git.Git", 
	"Microsoft.PowerShell", 
	"Microsoft.WindowsTerminal", 
	"Microsoft.VisualStudioCode", 
	"MSYS2.MSYS2"

#####################
# Installing packages
#####################
winget install -e $packagesToInstall --accept-package-agreements --accept-source-agreements --silent

#############################
# Installing make via packman
#############################
$Env:PATH += ";C:/msys64/usr/bin"
pacman -S make --noconfirm

##########################
# create required folders 
##########################
New-Item -ItemType Directory -Force $tempPath | Out-Null
New-Item -ItemType Directory -Force $gbToolsBasePath | Out-Null

#####################################
Write-Host "Installing Emulicious..."
#####################################
# download
Invoke-RestMethod $emuliciousUrl -OutFile $emuliciousZipPath | Out-Null
# unzip
Expand-Archive $emuliciousZipPath -DestinationPath $emuliciousPath -Force | Out-Null

####################################
Write-Host "Installing GBDK-2020..."
####################################
# download
Invoke-RestMethod $gbdkUrl -OutFile $gbdkZipPath | Out-Null
# unzip
Expand-Archive $gbdkZipPath -DestinationPath $gbToolsBasePath -Force | Out-Null

#################################################
Write-Host "Creating Windows Terminal profile..."
#################################################
# download icon
Invoke-WebRequest "https://avatars.githubusercontent.com/gbdk-2020" -OutFile $profileIconPath
# download gbdk module
Invoke-RestMethod "https://raw.githubusercontent.com/SelvinPL/gb_tools_installer/master/GBDK.psm1" -OutFile $moduleFilePath | Out-Null
# create script file
$profileScriptFile = New-Item $profileScriptPath -type file -Force
# set script file's content
Set-Content $profileScriptFile @"
`$Env:GBDK_HOME = "$gbdkPath"
`$Env:EMULICIOUS_PATH = "$emuliciousPath"
`$Env:PATH += ";C:/msys64/usr/bin"
`$Env:GB_TOOLS_BASE_PATH = "$gbToolsBasePath"
`$Env:GB_PROJECTS_PATH = "`$Env:GB_TOOLS_BASE_PATH/projects"
md -Force `$Env:GB_PROJECTS_PATH | Out-Null
cd `$Env:GB_PROJECTS_PATH
Import-Module $moduleFilePath -Force | Out-Null
"@
# load Windows Terminal profile
$settingsJson = Get-Content $windowsTerminalSettingsPath | Out-String | ConvertFrom-Json
# find GBDK profile
$gbdkProfile = $settingsJson.profiles.list | where { $_.guid -eq $profileGuid }
# create or modify GBDK profile
if(!$gbdkProfile)
{
	$gbdkProfile = @{
		commandline = "pwsh.exe -noexit `"$profileScriptPath`""
		guid = "$profileGuid"
		icon = "$profileIconPath"
		name = "$profileName"
	}
	$settingsJson.profiles.list += $gbdkProfile
}
else
{
	$gbdkProfile.commandline = "pwsh.exe -noexit `"$profileScriptPath`""
	$gbdkProfile.guid = "$profileGuid"
	$gbdkProfile.icon = "$profileIconPath"
	$gbdkProfile.name = "$profileName"
}
# write Windows Terminal profile back
Set-Content $windowsTerminalSettingsPath ($settingsJson | ConvertTo-Json -Depth 100)
Write-Host "Done.`n`n"
