
param([string]$Box="downloads-isolated",[string[]]$Paths=@("$env:USERPROFILE\Downloads"))
$iniPath = "${env:ProgramData}\Sandboxie-Plus\Sandboxie.ini"
if (!(Test-Path $iniPath)) { throw "Sandboxie.ini not found at $iniPath" }
$ini = Get-Content $iniPath -Raw
if ($ini -notmatch "^\[$Box\]"m) { throw "Box [$Box] not defined." }
foreach ($p in $Paths) {
  $line = "ForceFolder={0}" -f $p
  if ($ini -notmatch [regex]::Escape($line)) {
    $ini = $ini -replace "(\[$Box\][\s\S]*?)($)", ('$1' + "$line`r`n" + '$2')
  }
}
Set-Content -Path $iniPath -Value $ini -Encoding ASCII
Start-Process sc.exe -ArgumentList "stop","SbieSvc" -WindowStyle Hidden -Wait | Out-Null
Start-Process sc.exe -ArgumentList "start","SbieSvc" -WindowStyle Hidden -Wait | Out-Null
Write-Host "Added Forced Folders for [$Box]."
