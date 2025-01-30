What it does?

- installs WinGet
- installs Git
- installs Power Shell
- installs Windows Terminal
- installs Visual Studio Code
- installs MSYS2
- Download and unpack Emulicious to `C:\GB\emulicious`
- Download and unpack gbdk-2020 to `C:\GB\gbdk`
- creates  `C:\GB\GBDK.ps1` with content:
  ```ps1
  $Env:GBDK_HOME = "C:/GB/gbdk"
  $Env:EMULICIOUS_PATH = "C:/GB/emulicious"
  $Env:PATH += ";C:/msys64/usr/bin"
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

for installation use in cmd.exe runned as admin:
```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SelvinPL/gb_tools_installer/master/install.ps1'))"
```

Here is how installation should looks like on fresh windows 11:
https://github.com/SelvinPL/gb_tools_installer/raw/master/assets/installation.mov