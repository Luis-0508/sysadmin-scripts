:: =============================================
:: Disable JavaScript in Adobe Acrobat Reader DC
:: =============================================
:: This script fully disables JavaScript and trusted folders in Adobe Acrobat Reader DC
:: by setting the appropriate registry keys for FeatureLockDown policies.
:: Requires administrative privileges.
::
:: Usage: Run as administrator
::
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" /v "bDisableJavaScript" /t REG_DWORD /d "0x00000001" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" /v "bDisableTrustedFolders" /t REG_DWORD /d "0x00000001" /f