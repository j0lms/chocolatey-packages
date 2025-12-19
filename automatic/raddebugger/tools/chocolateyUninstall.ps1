$ErrorActionPreference = 'Stop'

$packageName = 'raddebugger'
$installPath = Join-Path -Path (Get-ToolsLocation) -ChildPath $packageName

'raddbg', 'radbin', 'radlink' | ForEach-Object {
    Uninstall-BinFile -Name $_
}

if (Test-Path -Path $installPath) {
    Remove-Item -Path $installPath -Recurse -Force
}
