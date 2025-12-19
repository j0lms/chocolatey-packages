function global:au_GetLatest {
    $apiUri = 'https://api.github.com/repos/EpicGamesExt/raddebugger/releases/latest'
    $latestRelease = Invoke-RestMethod -Uri $apiUri -UseBasicParsing

    $version = $latestRelease.tag_name.TrimStart('v')
    $tag = $latestRelease.tag_name
    $baseUrl = "https://github.com/EpicGamesExt/raddebugger/releases/download/$tag"

    return @{
        Version = $version
        URL32   = "$baseUrl/raddbg.exe"
        URLBin  = "$baseUrl/radbin.exe"
        URLLink = "$baseUrl/radlink.exe"
        ReleaseNotes = $description
    }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"            = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(^[$]urlBin\s*=\s*)('.*')"         = "`$1'$($Latest.URLBin)'"
            "(^[$]checksumBin\s*=\s*)('.*')"    = "`$1'$($Latest.ChecksumBin)'"
            "(^[$]urlLink\s*=\s*)('.*')"        = "`$1'$($Latest.URLLink)'"
            "(^[$]checksumLink\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumLink)'"
        }
    }
}

function global:au_BeforeUpdate {
    # raddbg.exe (Automatic hashing via AU)
    Get-RemoteFiles -Url $Latest.URL32 -ChecksumFor 32

    # radbin.exe (Manual hashing via standard PowerShell)
    $binPath = Join-Path $env:TEMP 'radbin.exe'
    Invoke-WebRequest -Uri $Latest.URLBin -OutFile $binPath -UseBasicParsing
    $Latest.ChecksumBin = (Get-FileHash -Path $binPath -Algorithm SHA256).Hash
    Remove-Item $binPath -Force

    # radlink.exe (Manual hashing via standard PowerShell)
    $linkPath = Join-Path $env:TEMP 'radlink.exe'
    Invoke-WebRequest -Uri $Latest.URLLink -OutFile $linkPath -UseBasicParsing
    $Latest.ChecksumLink = (Get-FileHash -Path $linkPath -Algorithm SHA256).Hash
    Remove-Item $linkPath -Force
}

Update-Package -ChecksumFor 32
