@echo off
setlocal
if not "%~2"=="" goto usage
set "apply="
if "%~1"=="" goto run
if /i "%~1"=="/preview" goto run
if /i "%~1"=="/apply" (
    set "apply=-Apply"
    goto run
)
if /i "%~1"=="/help" goto help
goto usage
:run
set "ps=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe" set "ps=%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe"
"%ps%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\scripts\Disable-OneDrive.ps1" %apply%
exit /b %errorlevel%
:help
echo Apply the OneDrive sync policy and run its uninstaller without deleting any user files.
echo Usage: %~nx0 [/preview ^| /apply ^| /help]
echo Default: preview only; /apply may require interactive confirmation.
exit /b 0
:usage
echo ERROR: Invalid arguments.
echo Usage: %~nx0 [/preview ^| /apply ^| /help]
exit /b 2
