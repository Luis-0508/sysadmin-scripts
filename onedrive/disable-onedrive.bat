:: =============================================
:: Disable and Remove OneDrive from Windows
:: =============================================
:: This script uninstalls OneDrive, deletes leftover files and folders,
:: and disables it via registry so it no longer appears or auto-starts.
::
:: Requires: Run as Administrator
::
@echo off

:: Kill running OneDrive process
taskkill /f /im OneDrive.exe >nul 2>&1

:: Uninstall OneDrive (handles both 32-bit and 64-bit)
IF EXIST "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
    "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall
) ELSE (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall
)

:: Delete leftover OneDrive folders
@RD /S /Q "%UserProfile%\OneDrive"
@RD /S /Q "%LocalAppData%\Microsoft\OneDrive"
@RD /S /Q "%ProgramData%\Microsoft OneDrive"
@RD /S /Q "C:\OneDriveTemp"

:: Disable OneDrive sync via registry
reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d 1 /f

:: Hide OneDrive from File Explorer navigation pane
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
reg add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
