param(
    [Parameter(Mandatory)][ValidateSet('Login', 'Full')][string]$Mode,
    [switch]$Apply
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Common.ps1')

try {
    if (-not $env:LOCALAPPDATA -or -not $env:APPDATA) {
        throw 'The current user profile is missing LOCALAPPDATA or APPDATA.'
    }
    $newTeams = Join-Path $env:LOCALAPPDATA 'Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams'
    $targets = @([pscustomobject]@{ Name = 'New Teams local cache'; Path = $newTeams; Root = $env:LOCALAPPDATA })
    if ($Mode -eq 'Full') {
        foreach ($folder in @('Cache', 'application cache\cache', 'blob_storage', 'databases', 'GPUcache', 'IndexedDB', 'Local Storage', 'tmp')) {
            $targets += [pscustomobject]@{
                Name = "Classic Teams $folder"
                Path = (Join-Path (Join-Path $env:APPDATA 'Microsoft\Teams') $folder)
                Root = $env:APPDATA
            }
        }
    }
    foreach ($target in $targets) {
        Assert-SafeDeleteTarget -Path $target.Path -Root $target.Root
        if (Test-Path -LiteralPath $target.Path) {
            Write-Host ("{0}: {1}" -f $(if ($Apply) { 'TARGET' } else { 'PREVIEW' }), $target.Path)
        }
        else {
            Write-Host "SKIPPED (not present): $($target.Path)"
        }
    }
    if (-not $Apply) {
        Write-Host 'PREVIEW ONLY: No files or Microsoft identity broker data were changed.'
        Write-Host 'Cache removal cannot guarantee sign-out when Windows single sign-on is enabled.'
        exit 0
    }
    $running = @(Get-Process -Name 'ms-teams', 'Teams' -ErrorAction SilentlyContinue)
    if ($running.Count -gt 0) {
        throw 'Quit Teams completely (including the tray icon) before resetting its cache.'
    }
    if (-not (Confirm-Token -Token 'RESET' -Description 'This deletes Teams-only local caches. Personalization may be reset; do not use it to fix missing chats or channels.')) {
        exit 2
    }
    $failed = $false
    foreach ($target in $targets) {
        if (-not (Test-Path -LiteralPath $target.Path)) { continue }
        try {
            Remove-Item -LiteralPath $target.Path -Recurse -Force -ErrorAction Stop
            Write-Host "SUCCESS: Removed $($target.Name)."
        }
        catch {
            Write-Host "FAILED: $($target.Name): $($_.Exception.Message)"
            $failed = $true
        }
    }
    if ($failed) { exit 1 }
    Write-Host 'SUCCESS: Teams cache reset completed. Restart Teams.'
    exit 0
}
catch {
    Write-Host "FAILED: $($_.Exception.Message)"
    exit 1
}
