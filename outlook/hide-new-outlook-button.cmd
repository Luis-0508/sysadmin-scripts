:: =============================================
:: Hide "Try the New Outlook" Button in Outlook 2016/2019/365
:: =============================================
:: This script hides the "Try the New Outlook" toggle button in Outlook by setting
:: the appropriate registry key. Works for Office 16.0 (Outlook 2016/2019/365).
::
:: Requires: Run as the current user
::
reg add "HKCU\Software\Microsoft\Office\16.0\Outlook\Options\General" /v HideNewOutlookToggle /t REG_DWORD /d 1 /f