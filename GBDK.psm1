function Install-GBDKTemplate {
	param(
		[switch]$UpdateTemplate = $false
	)
	$currentDirectory = Get-Location
	$templatePath = "$Env:GB_TOOLS_BASE_PATH/gbdk_template"
	if (Test-Path -Path $templatePath)
	{
		if($UpdateTemplate)
		{
			cd $templatePath | Out-Null
			git pull | Out-Null
			git checkout master | Out-Null
		}
	}
	else
	{
		cd $Env:GB_TOOLS_BASE_PATH | Out-Null
		git clone https://github.com/SelvinPL/gbdk_template.git | Out-Null
	}
	cd $currentDirectory | Out-Null
}

function New-GBDKProject {
	param(
		[string]$Name,
		[switch]$UpdateTemplate = $false
	)

	Install-GBDKTemplate -UpdateTemplate:$UpdateTemplate | Out-Null
	$currentDirectory = Get-Location
	$templatePath = "$Env:GB_TOOLS_BASE_PATH/gbdk_template"
	$newProjectPath = "$currentDirectory/$Name"
	mkdir $newProjectPath -Force | Out-Null
	Copy-Item -Path "$templatePath/*" -Destination $newProjectPath -Force -Recurse -Container | Out-Null
	Remove-Item -Path "$newProjectPath/.git" -Force -Recurse | Out-Null
	cd $newProjectPath
}

function Update-GBDKModule {
	$gbPath = $Env:GB_TOOLS_BASE_PATH
	$psmFilePath = "$gbPath/GBDK.psm1"
	Invoke-RestMethod "https://raw.githubusercontent.com/SelvinPL/gb_tools_installer/master/GBDK.psm1" -OutFile $psmFilePath | Out-Null
}
