:: =============================================
:: Remove & Block Default Windows Bloatware
:: =============================================
:: This script removes common pre-installed apps from Windows
:: and blocks them from being reinstalled automatically via the Store.
::
:: Requires: Run as administrator
::
@echo off
title Windows Bloatware Removal Script
setlocal EnableDelayedExpansion

:: Check for admin rights
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo This script must be run as administrator.
    pause
    exit /b
)

echo Removing removable apps...
set apps=3DBuilder ZuneMusic ZuneVideo BingWeather WindowsMaps SolitaireCollection CandyCrush Xbox GetHelp FeedbackHub Paint3D MixedReality

for %%A in (%apps%) do (
    echo Trying to remove: %%A
    powershell -Command "Get-AppxPackage *%%A* | Remove-AppxPackage -ErrorAction SilentlyContinue"
)

echo.
echo Blocking future installations...
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match '3DBuilder|ZuneMusic|ZuneVideo|BingWeather|WindowsMaps|SolitaireCollection|CandyCrush|Xbox|GetHelp|FeedbackHub|Paint3D|MixedReality' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"

echo.
echo Bloatware removal and blocking complete.
pause
