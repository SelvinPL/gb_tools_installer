What it does?

- installs WinGet
- installs Git
- installs Power Shell
- installs Windows Terminal
- installs Visual Studio Code
- installs MSYS2
- Download and unpack Emulicious to `C:/GB/emulicious`(*)
- Download and unpack gbdk-2020 to `C:/GB/gbdk`(*)
- Download GBDK.psm1 from this repo to `C:/GB`(*)
- creates  `C:/GB/GBDK.ps1` with content:
  ```ps1
  $Env:GBDK_HOME = "C:/GB/gbdk"
  $Env:EMULICIOUS_PATH = "C:/GB/emulicious"
  $Env:PATH += ";C:/msys64/usr/bin"
  $Env:GB_TOOLS_BASE_PATH = "C:/GB"
  $Env:GB_PROJECTS_PATH = "$Env:GB_TOOLS_BASE_PATH/projects"
  md -Force $Env:GB_PROJECTS_PATH | Out-Null
  cd $Env:GB_PROJECTS_PATH
  Import-Module C:/GB/GBDK.psm1 -Force | Out-Null
  ```
- adds profile to `settings.json` of Windows Terminal
  ```json
	{
		"commandline":  "pwsh.exe -noexit \"C:/GB/GBDK.ps1\"",
		"guid":  "{3e4cbead-a666-4762-baea-ace7935ba537}",
		"icon":  "C:/GB/gbdk_icon.png",
		"name":  "GBDK"
	}
  ```
(*) you can change `C:/GB` by providing `$env:GB_TOOLS_BASE_PATH` variable before you run `iwr https:...` in powershell console fx.: `$env:GB_TOOLS_BASE_PATH="C:/custom/path"`

Then you can start Windows Termial profile "GBDK" which has 
- GBDK_HOME environment variable
- EMULICIOUS_PATH environment variable
- MSYS added to PATH
- Function from `GBDK.psm1` module which can create new project from cli:
	- `New-GbdkProject projectname [-UpdateTemplate]` - create new project using https://github.com/SelvinPL/gbdk_template as template (see: `Install-GbdkTemplate`)
	- `Install-GbdkTemplate [-UpdateTemplate]` - clone (or pull if exists and used with UpdateTemplate) https://github.com/SelvinPL/gbdk_template
	- `Update-GbdkModule` - update `GBDK.psm1` file from https://github.com/SelvinPL/gb_tools_installer/blob/master/GBDK.psm1

For installation use powershell.exe and run inside it 
(`iwr` for `Invoke-WebRequest` and `iex` stands for `Invoke-Expression` - it downloads the content of `install.ps1` from this repo and execute it as powershell's script)
```
 iwr https://raw.githubusercontent.com/SelvinPL/gb_tools_installer/master/install.ps1 | iex
```
## YOU DON'T NEED RUN POWERSHELL CONSOLE AS ADMINISTRATOR 
### and you prolly never should do this (unless you know what you are doing) for security reasons
You'll be asked with UAC popup for every program which needs administrator rights to install.

Movies bellow were made before I find out that this is a valid option.

Here is how installation should looks like on fresh windows 11:

https://github.com/user-attachments/assets/20dd73ab-e9b1-4c82-8f53-692c1b3a823b

New version:

https://github.com/user-attachments/assets/845b89d6-cd9e-4eb4-9e00-e2205abdf7b2


