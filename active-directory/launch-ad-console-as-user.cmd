:: =============================================
:: Launch Active Directory Console as Domain Admin
:: =============================================
:: This script prompts for a domain and username, then launches the
:: Active Directory Users and Computers console (dsa.msc) using those credentials.
:: Useful for admins who are logged in with a non-privileged account.
::
:: Requires: Domain credentials with AD permissions
::
@echo off
setlocal

:: Prompt for domain and username
set /p domain=Enter domain name (e.g. mydomain.local): 
set /p username=Enter username (e.g. adminuser): 

:: Build full user string
set fulluser=%domain%\%username%

:: Launch MMC with dsa.msc under different credentials
echo.
echo You will now be prompted for the password of %fulluser%
runas /user:%fulluser% "mmc dsa.msc"

endlocal
