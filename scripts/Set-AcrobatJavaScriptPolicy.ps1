param([switch]$Apply)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Common.ps1')

$products = @(
    @{ Name = 'Acrobat Reader 64-bit'; Install = 'HKLM:\SOFTWARE\Adobe\Acrobat Reader\DC'; Policy = 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'; Registry = 'HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown' },
    @{ Name = 'Acrobat Reader 32-bit'; Install = 'HKLM:\SOFTWARE\WOW6432Node\Adobe\Acrobat Reader\DC'; Policy = 'HKLM:\SOFTWARE\WOW6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'; Registry = 'HKLM\SOFTWARE\WOW6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown' },
    @{ Name = 'Adobe Acrobat 64-bit'; Install = 'HKLM:\SOFTWARE\Adobe\Adobe Acrobat\DC'; Policy = 'HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'; Registry = 'HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' },
    @{ Name = 'Adobe Acrobat 32-bit'; Install = 'HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC'; Policy = 'HKLM:\SOFTWARE\WOW6432Node\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'; Registry = 'HKLM\SOFTWARE\WOW6432Node\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' }
)
try {
    $targets = @($products | Where-Object { Test-Path -LiteralPath $_.Install })
    if ($targets.Count -eq 0) {
        Write-Host 'SKIPPED: No supported Acrobat/Reader DC installation was detected.'
        if ($Apply) { exit 2 }
        exit 0
    }
    foreach ($target in $targets) {
        Write-Host ("{0}: {1} -> bDisableJavaScript=1, bDisableTrustedFolders=1" -f $(if ($Apply) { 'TARGET' } else { 'PREVIEW' }), $target.Registry)
    }
    if (-not $Apply) { exit 0 }
    Require-Administrator
    if (-not (Confirm-Token -Token 'HARDEN' -Description 'This changes machine-wide Adobe security policies. Close Adobe applications first.')) {
        exit 2
    }
    foreach ($target in $targets) {
        if (Test-Path -LiteralPath $target.Policy) {
            $backup = Join-Path $env:TEMP ("Adobe-policy-{0}-{1}.reg" -f ($target.Name -replace '[^A-Za-z0-9]', '-'), (Get-Date -Format 'yyyyMMdd-HHmmssfff'))
            & reg.exe export $target.Registry $backup /y | Out-Null
            if ($LASTEXITCODE -ne 0) { throw "Could not back up $($target.Registry)." }
            Write-Host "BACKUP: $backup"
        }
        New-Item -Path $target.Policy -Force | Out-Null
        New-ItemProperty -Path $target.Policy -Name 'bDisableJavaScript' -Value 1 -PropertyType DWord -Force | Out-Null
        New-ItemProperty -Path $target.Policy -Name 'bDisableTrustedFolders' -Value 1 -PropertyType DWord -Force | Out-Null
        Write-Host "SUCCESS: Updated $($target.Name)."
    }
    exit 0
}
catch {
    Write-Host "FAILED: $($_.Exception.Message)"
    exit 1
}
