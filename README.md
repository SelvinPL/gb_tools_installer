What it does?

- installs WinGet
- installs Git
- installs Power Shell
- installs Windows Terminal
- installs Visual Studio Code
- installs MSYS2
- Download and unpack Emulicious to `C:\GB\emulicious`
- Download and unpack gbdk-2020 to `C:\GB\gbdk`
- Download GBDK.psm1 from this repo to `C:\GB\gbdk`
- creates  `C:\GB\GBDK.ps1` with content:
  ```ps1
  $Env:GBDK_HOME = "C:/GB/gbdk"
  $Env:EMULICIOUS_PATH = "C:/GB/emulicious"
  $Env:PATH += ";C:/msys64/usr/bin"
  $Env:GBDK_TEMPLATE_BASE = "C:/GB/"
  Import-Module $PSScriptRoot/GBDK.psm1 -Force | Out-Null
  ```
- adds profile to `settings.json` of Windows Terminal
  ```json
      {
        "commandline": "pwsh.exe  -noexit \"C:/GB/GBDK.ps1\"",
        "guid": "{3e4cbead-a666-4762-baea-ace7935ba537}",
        "icon": "C:/msys64/msys2.ico",
        "name": "GBDK"
      }
  ```

Then you can start Windows Termial profile "GBDK" which has 
- GBDK_HOME environment variable
- EMULICIOUS_PATH environment variable
- MSYS added to PATH
- Function from GBDK.psm1 module which can create new project from cli `New-GBDKProject projectname`

for installation use in cmd.exe runned as admin:
```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SelvinPL/gb_tools_installer/master/install.ps1'))"
```
*if you have problem with Antivirus you may just download https://raw.githubusercontent.com/SelvinPL/gb_tools_installer/master/install.ps1
and run in admin cmd*
```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command path_to/install.ps1
```

Here is how installation should looks like on fresh windows 11:

https://github.com/user-attachments/assets/20dd73ab-e9b1-4c82-8f53-692c1b3a823b

New version:

https://github.com/user-attachments/assets/845b89d6-cd9e-4eb4-9e00-e2205abdf7b2


