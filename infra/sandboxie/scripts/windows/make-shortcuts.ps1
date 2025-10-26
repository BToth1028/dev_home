
$desktop = [Environment]::GetFolderPath("Desktop")
$startExe = "${env:ProgramFiles}\Sandboxie-Plus\Start.exe"
function New-Shortcut($name, $args) {
  $wsh = New-Object -ComObject WScript.Shell
  $lnk = $wsh.CreateShortcut((Join-Path $desktop $name))
  $lnk.TargetPath = $startExe
  $lnk.Arguments = $args
  $lnk.IconLocation = $startExe
  $lnk.Save()
}
New-Shortcut "Open-Browser-Isolated.lnk" '/box:browser-isolated "C:\Program Files\Google\Chrome\Application\chrome.exe"'
New-Shortcut "Run-Unknown-EXE.lnk" '/box:unknown-exe run_dialog'
New-Shortcut "Clean-Downloads-Box.lnk" '/box:downloads-isolated delete_sandbox_silent'
