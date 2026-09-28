param(
    [switch]$Apply,
    [switch]$Restore
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Common.ps1')

try {
    $path = 'Software\Microsoft\Office\16.0\Outlook\Options\General'
    $name = 'HideNewOutlookToggle'
    if (-not $Apply) {
        Write-Host ("PREVIEW: {0} HKCU:\{1}\{2} for the current account." -f $(if ($Restore) { 'Delete' } else { 'Set to DWORD 1' }), $path, $name)
        Write-Host 'This only changes the classic Outlook switch, not the installed app or an organization policy.'
        exit 0
    }
    if ($Restore) {
        if (-not (Confirm-Token -Token 'RESTORE' -Description 'Remove the per-user toggle override only if you own this setting.')) {
            exit 2
        }
        $key = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($path, $true)
        if ($null -eq $key) { Write-Host 'SKIPPED: The Outlook options key does not exist.'; exit 0 }
        try {
            if ($null -eq $key.GetValue($name)) { Write-Host 'SKIPPED: The toggle override was already absent.'; exit 0 }
            $key.DeleteValue($name, $false)
        }
        finally { $key.Close() }
        Write-Host 'SUCCESS: Removed the current-user toggle override.'
        exit 0
    }
    $key = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey($path)
    if ($null -eq $key) { throw 'Could not open the per-user Outlook options key.' }
    try { $key.SetValue($name, 1, [Microsoft.Win32.RegistryValueKind]::DWord) }
    finally { $key.Close() }
    Write-Host 'SUCCESS: The New Outlook switch is hidden for the current account.'
    exit 0
}
catch {
    Write-Host "FAILED: $($_.Exception.Message)"
    exit 1
}
