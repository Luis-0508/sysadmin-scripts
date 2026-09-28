param([switch]$Apply)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Common.ps1')

try {
    $console = Join-Path $env:WINDIR 'System32\dsa.msc'
    if (-not $Apply) {
        Write-Host "PREVIEW: Open Active Directory Users and Computers using alternate credentials: $console"
        if (-not (Test-Path -LiteralPath $console)) {
            Write-Host 'NOTICE: RSAT Active Directory tools are not installed on this machine.'
        }
        exit 0
    }
    if (-not (Test-Path -LiteralPath $console)) {
        throw 'dsa.msc was not found. Install the RSAT Active Directory tools first.'
    }
    $domain = (Read-Host 'Domain (DNS or NetBIOS name)').Trim()
    $user = (Read-Host 'Account name (sAMAccountName)').Trim()
    if ($domain -cnotmatch '^[A-Za-z0-9][A-Za-z0-9.-]*$' -or
        $user -cnotmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$') {
        throw 'Invalid domain or account name. Use a DNS/NetBIOS domain and a simple sAMAccountName.'
    }
    $credential = Get-Credential -UserName ($domain + '\' + $user) -Message 'Credentials for Active Directory Users and Computers'
    if ($null -eq $credential) {
        Write-Host 'CANCELLED: No console was opened.'
        exit 2
    }
    $mmc = Join-Path $env:WINDIR 'System32\mmc.exe'
    $process = Start-Process -FilePath $mmc -ArgumentList ('"' + $console + '"') -Credential $credential -PassThru -ErrorAction Stop
    Write-Host "SUCCESS: Started Active Directory Users and Computers (PID $($process.Id))."
    exit 0
}
catch {
    Write-Host "FAILED: $($_.Exception.Message)"
    exit 1
}
