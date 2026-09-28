param([switch]$Apply)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Common.ps1')

try {
    $policy = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive'
    $registry = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive'
    $candidates = @(
        (Join-Path $env:SystemRoot 'SysWOW64\OneDriveSetup.exe'),
        (Join-Path $env:SystemRoot 'System32\OneDriveSetup.exe'),
        (Join-Path $env:LOCALAPPDATA 'Microsoft\OneDrive\Update\OneDriveSetup.exe')
    )
    $setup = @($candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1)
    Write-Host 'OneDrive policy: DisableFileSyncNGSC=1 (machine-wide).'
    if ($setup.Count -gt 0) {
        Write-Host "OneDrive uninstaller: $($setup[0])"
    }
    else {
        Write-Host 'NOTICE: No bundled OneDriveSetup.exe found; only the policy can be applied.'
    }
    Write-Host 'The OneDrive user folder and its files will NEVER be deleted by this script.'
    if (-not $Apply) {
        Write-Host 'PREVIEW ONLY: No processes, registry values, applications or files were changed.'
        exit 0
    }
    Require-Administrator
    if (-not (Confirm-Token -Token 'DISABLE' -Description 'Confirm all OneDrive data is synced or independently backed up, and close OneDrive. This affects every user on this PC.')) {
        exit 2
    }
    if (Test-Path -LiteralPath $policy) {
        $backup = Join-Path $env:TEMP ("OneDrive-policy-{0}.reg" -f (Get-Date -Format 'yyyyMMdd-HHmmssfff'))
        & reg.exe export $registry $backup /y | Out-Null
        if ($LASTEXITCODE -ne 0) { throw 'Could not export the existing OneDrive policy; no changes were applied.' }
        Write-Host "BACKUP: $backup"
    }
    New-Item -Path $policy -Force | Out-Null
    New-ItemProperty -Path $policy -Name 'DisableFileSyncNGSC' -PropertyType DWord -Value 1 -Force | Out-Null
    Write-Host 'SUCCESS: OneDrive sync is disabled by local machine policy.'
    if ($setup.Count -gt 0) {
        $process = Start-Process -FilePath $setup[0] -ArgumentList '/uninstall' -Wait -PassThru -ErrorAction Stop
        if ($process.ExitCode -ne 0) { throw "OneDrive uninstaller exited with code $($process.ExitCode); policy remains set." }
        Write-Host 'SUCCESS: OneDrive uninstaller returned success.'
    }
    else {
        Write-Host 'SKIPPED: Uninstall step (setup executable not available).'
    }
    exit 0
}
catch {
    Write-Host "FAILED: $($_.Exception.Message)"
    exit 1
}
