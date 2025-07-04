# Sysadmin Scripts

A collection of Windows batch scripts for system administrators to quickly fix, clean, and configure common issues in Microsoft Office, Teams, and Adobe Acrobat. These scripts are designed to save time and reduce troubleshooting effort for IT professionals and power users.

---

## Scripts Overview

### Adobe Acrobat
- **[adobe-acrobat/disable-javascript.bat](adobe-acrobat/disable-javascript.bat)**  
  Disables JavaScript and trusted folders in Adobe Acrobat Reader DC for enhanced security by setting registry keys.

### Microsoft Teams
- **[ms-teams/clear-teams-login.bat](ms-teams/clear-teams-login.bat)**  
  Clears all cached login folders for Microsoft Teams to ensure no one can access your account without a password.
- **[ms-teams/full-clear-teams-cache.bat](ms-teams/full-clear-teams-cache.bat)**  
  Completely removes all Teams cache and login data to fix lag, crashes, and persistent issues.

### Outlook
- **[outlook/fix-outlook-crashes-june-2025-update.bat](outlook/fix-outlook-crashes-june-2025-update.bat)**  
  Creates the required FORMS2 folder in AppData to prevent lags and crashes caused by the June 2025 update of Outlook Classic.  
  [Microsoft Support Article](https://support.microsoft.com/en-us/office/classic-outlook-crashes-opening-or-starting-a-new-email-1b413573-7dfc-4147-9c53-c2f1183b89b8)

- **[outlook/hide-new-outlook-button.bat](outlook/hide-new-outlook-button.bat)**  
  Hides the "Try the New Outlook" toggle button in Outlook 2016/2019/365 by setting the appropriate registry key.  
  [Microsoft Learn: Control Install](https://learn.microsoft.com/de-de/microsoft-365-apps/outlook/get-started/control-install)

---

> **Note:** Most scripts require administrative privileges. Always review scripts before running in production environments.
