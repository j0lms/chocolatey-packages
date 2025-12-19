$ErrorActionPreference = 'Stop'

$packageName    = 'raddebugger'
$toolsDir       = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$installPath    = Join-Path -Path (Get-ToolsLocation) -ChildPath $packageName
$binPath        = Join-Path -Path $installPath -ChildPath 'bin'

$url          = 'https://github.com/EpicGamesExt/raddebugger/releases/download/v0.9.24-alpha/raddbg.exe'
$checksum     = '2C825C58C008AD109A60F95665182E013A489435FD807D8F9B54F649790F02BB'
$urlBin       = 'https://github.com/EpicGamesExt/raddebugger/releases/download/v0.9.24-alpha/radbin.exe'
$checksumBin  = '336FC019FC5B19FC0F11A662FDA543C7DD74E81291D345E9AEF14D7A3853E340'
$urlLink      = 'https://github.com/EpicGamesExt/raddebugger/releases/download/v0.9.24-alpha/radlink.exe'
$checksumLink = '44657105E531FA513D7142F47DB0CC861F2D898CA688351F96578ADC00E54D49'

if (!(Test-Path $binPath)) {
    New-Item -Path $binPath -ItemType Directory -Force | Out-Null
}

$files = @(
    @{ n='raddbg.exe';  u=$url;      c=$checksum },
    @{ n='radbin.exe';  u=$urlBin;   c=$checksumBin },
    @{ n='radlink.exe'; u=$urlLink;  c=$checksumLink }
)

foreach ($file in $files) {
    Get-ChocolateyWebFile -PackageName $packageName `
                          -FileFullPath (Join-Path $binPath $file.n) `
                          -Url $file.u `
                          -Checksum $file.c `
                          -ChecksumType 'sha256'
}

'raddbg', 'radbin', 'radlink' | ForEach-Object {
    Install-BinFile -Name $_ -Path (Join-Path $binPath "$($_).exe")
}
