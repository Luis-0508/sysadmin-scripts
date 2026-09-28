@echo off
setlocal
if not "%~2"=="" goto usage
set "apply="
set "restore="
if "%~1"=="" goto run
if /i "%~1"=="/preview" goto run
if /i "%~1"=="/apply" (
    set "apply=-Apply"
    goto run
)
if /i "%~1"=="/restore" (
    set "restore=-Restore"
    set "apply=-Apply"
    goto run
)
if /i "%~1"=="/help" goto help
goto usage
:run
set "ps=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe" set "ps=%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe"
"%ps%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\scripts\Set-OutlookToggle.ps1" %apply% %restore%
exit /b %errorlevel%
:help
echo Hide the New Outlook toggle for the CURRENT user, or restore the local override.
echo Usage: %~nx0 [/preview ^| /apply ^| /restore ^| /help]
echo Default: preview only. /restore requires confirmation.
exit /b 0
:usage
echo ERROR: Invalid arguments.
echo Usage: %~nx0 [/preview ^| /apply ^| /restore ^| /help]
exit /b 2
