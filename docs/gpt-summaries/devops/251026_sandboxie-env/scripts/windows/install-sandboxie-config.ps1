
$ErrorActionPreference = "Stop"
$sbieDir = "${env:ProgramFiles}\Sandboxie-Plus"
$iniPath = "${env:ProgramData}\Sandboxie-Plus\Sandboxie.ini"
$kitRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
$boxesPath = Join-Path $kitRoot "sandboxie\boxes"

if (!(Test-Path $sbieDir)) { throw "Sandboxie-Plus not found in $sbieDir" }
if (!(Test-Path $iniPath)) { throw "Sandboxie.ini not found in $iniPath" }

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
Copy-Item $iniPath "$iniPath.bak.$stamp"

$ini = Get-Content $iniPath -Raw
if ($ini -notmatch "^\[GlobalSettings\]"m) {
    $ini = "[GlobalSettings]`r`n" + $ini
}

$importLines = @()
Get-ChildItem -Path $boxesPath -Filter *.ini | ForEach-Object {
    $importLines += "ImportBox=$($_.FullName)"
}

$ini = ($ini -split "`r`n") | Where-Object { $_ -notmatch "^ImportBox=.*sandboxie\\boxes\\.*\.ini$" } | Out-String
$ini = $ini -replace "(\[GlobalSettings\]\s*)", ("`$1" + ($importLines -join "`r`n") + "`r`n")

Set-Content -Path $iniPath -Value $ini -Encoding ASCII

Start-Process sc.exe -ArgumentList "stop","SbieSvc" -WindowStyle Hidden -Wait | Out-Null
Start-Process sc.exe -ArgumentList "start","SbieSvc" -WindowStyle Hidden -Wait | Out-Null
Write-Host "Imported boxes and restarted service."
