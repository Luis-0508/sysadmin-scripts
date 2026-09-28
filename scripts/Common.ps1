# Shared safety checks for interactive Windows support tasks.
Set-StrictMode -Version Latest

function Require-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'Run this command from an elevated terminal using the intended account.'
    }
}

function Confirm-Token {
    param(
        [Parameter(Mandatory)][string]$Token,
        [Parameter(Mandatory)][string]$Description
    )
    Write-Host $Description
    $answer = Read-Host ("Type {0} to proceed" -f $Token)
    if ($answer -cne $Token) {
        Write-Host 'CANCELLED: No changes were made by this confirmation step.'
        return $false
    }
    return $true
}

function Assert-SafeDeleteTarget {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Root
    )
    $fullRoot = [IO.Path]::GetFullPath($Root).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    $fullPath = [IO.Path]::GetFullPath($Path)
    if (-not $fullPath.StartsWith($fullRoot, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to remove a path outside its expected profile root: $fullPath"
    }
    $relative = $fullPath.Substring($fullRoot.Length)
    $parts = @($relative -split '[\\/]')
    if ($parts.Count -lt 2) {
        throw "Refusing to remove a profile root or direct child: $fullPath"
    }
    $current = $fullRoot.TrimEnd('\', '/')
    foreach ($part in $parts) {
        if (-not $part) { continue }
        $current = Join-Path $current $part
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Refusing to follow a reparse point during deletion: $current"
            }
        }
    }
}
