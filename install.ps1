$gbToolsBasePath = if ($env:GB_TOOLS_BASE_PATH) { $env:GB_TOOLS_BASE_PATH } else { "C:/GB" } 
$gbdkPath = "$gbToolsBasePath/gbdk"
$templatePath = $gbToolsBasePath + "/!template"
$tempPath = "$env:TEMP/gbdk_installer"
$emuliciousZipPath = "$tempPath/emulicious.zip"
$emuliciousPath = "$gbToolsBasePath/emulicious"
$emuliciousUrl = "https://emulicious.net/download/emulicious-with-64-bit-java-for-windows/?wpdmdl=989"
$gbdkUrl = "https://github.com/gbdk-2020/gbdk-2020/releases/latest/download/gbdk-win64.zip"
$gbdkZipPath = "$tempPath/gbdk-win64.zip"
$windowsTerminalSettingsPath = "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
$psFilePath = "$gbToolsBasePath/GBDK.ps1"
$iconFilePath = "$gbToolsBasePath/gbdk_icon.png"
$psmFilePath = "$gbToolsBasePath/GBDK.psm1"
$profileGuid = "{3e4cbead-a666-4762-baea-ace7935ba537}"
$profileName = "GBDK"

$progressPreference = 'silentlyContinue'
#################################
Write-Host "Installing WinGet..."
#################################
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
Write-Host "Done.`n`n"

##############################
Write-Host "Installing Git..."
##############################
winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements --silent
Write-Host "Done.`n`n"

#####################################
Write-Host "Installing PowerShell..."
#####################################
winget install --id Microsoft.PowerShell --source winget
###### refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
Write-Host "Done.`n`n"

###########################################
Write-Host "Installing Windows Terminal..."
###########################################
winget install -e --id Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements --silent
Write-Host "Done.`n`n"

#####################################################
Write-Host "Installing Windows Visual Studio Code..."
#####################################################
winget install -e --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements --silent
Write-Host "Done.`n`n"

################################
Write-Host "Installing MSYS2..."
################################
winget install -e --id MSYS2.MSYS2 --accept-package-agreements --accept-source-agreements --silent
Write-Host "Done.`n`n"

###########################################
Write-Host "Installing make via packman..."
###########################################
$Env:PATH += ";C:/msys64/usr/bin"
pacman -S make --noconfirm

###########################
# create required folders #
###########################
New-Item -ItemType Directory -Force $tempPath | Out-Null
New-Item -ItemType Directory -Force $gbToolsBasePath | Out-Null

#####################################
Write-Host "Installing Emulicious..."
#####################################
Invoke-RestMethod $emuliciousUrl -OutFile $emuliciousZipPath | Out-Null
Expand-Archive $emuliciousZipPath -DestinationPath $emuliciousPath -Force | Out-Null
Write-Host "Done.`n`n"


####################################
Write-Host "Installing GBDK-2020..."
####################################
Invoke-RestMethod $gbdkUrl -OutFile $gbdkZipPath | Out-Null
Expand-Archive $gbdkZipPath -DestinationPath $gbToolsBasePath -Force | Out-Null
Write-Host "Done.`n`n"

#################################################
Write-Host "Creating Windows Terminal profile..."
#################################################
## download icon ##
Invoke-WebRequest "https://avatars.githubusercontent.com/gbdk-2020" -OutFile $iconFilePath
Invoke-RestMethod "https://raw.githubusercontent.com/SelvinPL/gb_tools_installer/master/GBDK.psm1" -OutFile $psmFilePath | Out-Null
$psFile = New-Item $psFilePath -type file -Force
Set-Content $psFile @"
`$Env:GBDK_HOME = "$gbdkPath"
`$Env:EMULICIOUS_PATH = "$emuliciousPath"
`$Env:PATH += ";C:/msys64/usr/bin"
`$Env:GB_TOOLS_BASE_PATH = "$gbToolsBasePath"
`$Env:GB_PROJECTS_PATH = "`$Env:GB_TOOLS_BASE_PATH/projects"
md -Force `$Env:GB_PROJECTS_PATH | Out-Null
cd `$Env:GB_PROJECTS_PATH
Import-Module `$PSScriptRoot/GBDK.psm1 -Force | Out-Null
"@
$settingsJson = Get-Content $windowsTerminalSettingsPath | Out-String | ConvertFrom-Json
$gbdkProfile = $settingsJson.profiles.list | where { $_.guid -eq $profileGuid }
if(!$gbdkProfile)
{
	$gbdkProfile = @"
	{
		"commandline": "pwsh.exe -noexit \"$psFilePath\"",
		"guid": "$profileGuid",
		"icon": "$iconFilePath",
		"name": "$profileName"
	}
"@ | ConvertFrom-Json
	$settingsJson.profiles.list += $gbdkProfile
	Set-Content $windowsTerminalSettingsPath ($settingsJson | ConvertTo-Json -Depth 100)
}
Write-Host "Done.`n`n"
