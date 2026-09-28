@echo off
setlocal
if not "%~2"=="" goto usage
if "%~1"=="" goto preview
if /i "%~1"=="/preview" goto preview
if /i "%~1"=="/apply" goto apply
if /i "%~1"=="/help" goto help
goto usage
:preview
if not defined LOCALAPPDATA (
    echo FAILED: LOCALAPPDATA is not available for the current account.
    exit /b 1
)
echo PREVIEW: Create "%LOCALAPPDATA%\Microsoft\FORMS2" for this account if missing.
echo This was a workaround for a specific 2025 Outlook crash; install Office updates first.
exit /b 0
:apply
if not defined LOCALAPPDATA (
    echo FAILED: LOCALAPPDATA is not available for the current account.
    exit /b 1
)
tasklist /FI "IMAGENAME eq OUTLOOK.EXE" 2>nul | findstr /I /C:"OUTLOOK.EXE" >nul
if not errorlevel 1 (
    echo FAILED: Close Outlook and other Office apps before running this workaround.
    exit /b 1
)
if exist "%LOCALAPPDATA%\Microsoft\FORMS2\." (
    echo SKIPPED: FORMS2 already exists.
    exit /b 0
)
mkdir "%LOCALAPPDATA%\Microsoft\FORMS2" 2>nul
if errorlevel 1 (
    echo FAILED: Could not create FORMS2 for the current account.
    exit /b 1
)
echo SUCCESS: Created FORMS2 for the current account.
exit /b 0
:help
echo Create the current user's FORMS2 folder for the historical June 2025 Outlook crash.
echo Usage: %~nx0 [/preview ^| /apply ^| /help]
echo Default: preview only. Update Outlook before using this workaround.
exit /b 0
:usage
echo ERROR: Invalid arguments.
echo Usage: %~nx0 [/preview ^| /apply ^| /help]
exit /b 2
