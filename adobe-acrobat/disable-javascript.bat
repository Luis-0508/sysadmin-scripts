:: disables javascript fully in adobe acrobat
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" /v "bDisableJavaScript" /t REG_DWORD /d "0x00000001" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" /v "bDisableTrustedFolders" /t REG_DWORD /d "0x00000001" /f