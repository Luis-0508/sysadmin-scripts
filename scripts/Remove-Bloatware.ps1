param([switch]$Apply)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Common.ps1')

# Intentionally exact package names: no wildcards, no all-user removal, and no Store policy.
$packageNames = @(
    'Microsoft.3DBuilder',
    'Microsoft.ZuneMusic',
    'Microsoft.ZuneVideo',
    'Microsoft.BingWeather',
    'Microsoft.WindowsMaps',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.XboxApp',
    'Microsoft.GetHelp',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.Microsoft3DViewer',
    'Microsoft.MixedReality.Portal'
)
try {
    $installed = @(Get-AppxPackage -ErrorAction Stop | Where-Object { $packageNames -contains $_.Name })
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $isAdmin = [Security.Principal.WindowsPrincipal]::new($identity).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $provisioned = @()
    if ($isAdmin) {
        $provisioned = @(Get-AppxProvisionedPackage -Online -ErrorAction Stop |
            Where-Object { $packageNames -contains ($_.DisplayName -split '_')[0] })
    }
    Write-Host "Running as: $env:USERDOMAIN\$env:USERNAME. Installed packages below belong only to this user."
    foreach ($item in $installed) { Write-Host "USER PACKAGE: $($item.Name) [$($item.PackageFullName)]" }
    foreach ($item in $provisioned) { Write-Host "PROVISIONED PACKAGE: $($item.PackageName)" }
    if (-not $isAdmin) { Write-Host 'NOTICE: Run elevated to inspect or remove provisioned packages.' }
    if ($installed.Count -eq 0 -and $provisioned.Count -eq 0) { Write-Host 'SKIPPED: No matching packages were found.' }
    if (-not $Apply) {
        Write-Host 'PREVIEW ONLY: No packages were removed. This is not a permanent block on reinstalling apps.'
        exit 0
    }
    Require-Administrator
    if ($installed.Count -eq 0 -and $provisioned.Count -eq 0) { exit 0 }
    if (-not (Confirm-Token -Token 'REMOVE' -Description 'Remove exactly the listed packages for this user and deprovision them for future users?')) {
        exit 2
    }
    $failed = $false
    foreach ($item in $installed) {
        try {
            Remove-AppxPackage -Package $item.PackageFullName -ErrorAction Stop
            Write-Host "SUCCESS: Removed current-user package $($item.Name)."
        }
        catch {
            Write-Host "FAILED: $($item.Name): $($_.Exception.Message)"
            $failed = $true
        }
    }
    foreach ($item in $provisioned) {
        try {
            Remove-AppxProvisionedPackage -Online -PackageName $item.PackageName -ErrorAction Stop | Out-Null
            Write-Host "SUCCESS: Deprovisioned $($item.PackageName)."
        }
        catch {
            Write-Host "FAILED: $($item.PackageName): $($_.Exception.Message)"
            $failed = $true
        }
    }
    if ($failed) { exit 1 }
    Write-Host 'SUCCESS: Selected packages removed. The Store or future OS updates may install them again.'
    exit 0
}
catch {
    Write-Host "FAILED: $($_.Exception.Message)"
    exit 1
}
