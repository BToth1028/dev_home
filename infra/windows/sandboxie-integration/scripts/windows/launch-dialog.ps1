# scripts/windows/launch-dialog.ps1
$ErrorActionPreference = "Stop"
$startExe = "$env:ProgramFiles\Sandboxie-Plus\Start.exe"
if (!(Test-Path $startExe)) { throw "Start.exe not found in $startExe" }

$boxes = @("downloads-isolated","unknown-exe","browser-isolated","repo-tooling","git-tools")
$box = Read-Host "Choose box (`n$($boxes -join ', ')`n)"
if (-not $boxes.Contains($box)) { throw "Unknown box: $box" }

$cmd = Read-Host "Command (e.g. notepad.exe)"
$args = Read-Host "Args (optional, leave blank for none)"

$argList = @("/box:$box", $cmd)
if ($args) { $argList += $args.Split(' ') }

Start-Process -FilePath $startExe -ArgumentList $argList

