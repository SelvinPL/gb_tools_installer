function Install-GBDKTemplate() {
    $currentDirectory = Get-Location
    $templatePath = "$Env:GBDK_TEMPLATE_BASE/gbdk_template"
    if (Test-Path -Path $templatePath)
    {
        cd $templatePath | Out-Null
        git pull | Out-Null
        git checkout master | Out-Null
    }
    else
    {
        git clone https://github.com/SelvinPL/gbdk_template.git | Out-Null
    }
    cd $currentDirectory | Out-Null
}

function New-GBDKProject {
    param(
        [string]$Name
    )

    Install-GBDKTemplate | Out-Null
    $currentDirectory = Get-Location
    $templatePath = "$Env:GBDK_TEMPLATE_BASE/gbdk_template"
    $newProjectPath = "$currentDirectory/$Name"
    mkdir $newProjectPath -Force | Out-Null
    Copy-Item -Path "$templatePath/*" -Destination $newProjectPath  -Force -Recurse -Container | Out-Null
    Remove-Item -Path "$newProjectPath/.git" -Force -Recurse | Out-Null
    cd $newProjectPath
}
