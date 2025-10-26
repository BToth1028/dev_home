
param([Parameter(Mandatory=$true)][string]$Box,[Parameter(Mandatory=$true)][string]$Command,[string[]]$Args)
$startExe = "${env:ProgramFiles}\Sandboxie-Plus\Start.exe"
if (!(Test-Path $startExe)) { throw "Start.exe not found in $startExe" }
$allArgs = @("/box:$Box", $Command) + $Args
Start-Process -FilePath $startExe -ArgumentList $allArgs -Wait
