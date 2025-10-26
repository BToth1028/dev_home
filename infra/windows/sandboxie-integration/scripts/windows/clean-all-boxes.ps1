# scripts/windows/clean-all-boxes.ps1
$ErrorActionPreference = "Stop"
$start = "$env:ProgramFiles\Sandboxie-Plus\Start.exe"
if (!(Test-Path $start)) { throw "Start.exe not found in $start" }

$boxes = @("downloads-isolated","unknown-exe","browser-isolated","repo-tooling","git-tools")
foreach ($b in $boxes) {
  & $start /box:$b delete_sandbox_silent
  Write-Host "Cleaned $b"
}

