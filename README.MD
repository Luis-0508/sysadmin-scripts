# 🛠️ Sysadmin Scripts

A collection of Windows **batch scripts** for system administrators to quickly **fix**, **clean**, and **configure** common issues in Microsoft Office, Teams, Adobe Acrobat, and Windows itself.

These scripts are designed to save time and reduce troubleshooting effort for **IT professionals**, **Helpdesk technicians**, and **power users**.

---

## 📄 Script Overview

### 📂 Adobe Acrobat
- [`adobe-acrobat/disable-javascript.bat`](adobe-acrobat/disable-javascript.bat)  
  🔒 Disables JavaScript and trusted folders in Adobe Acrobat Reader DC for enhanced security using registry keys.

---

### 💬 Microsoft Teams
- [`ms-teams/clear-teams-login.bat`](ms-teams/clear-teams-login.bat)  
  🧹 Clears cached login folders for Microsoft Teams to ensure credentials must be re-entered.

- [`ms-teams/full-clear-teams-cache.bat`](ms-teams/full-clear-teams-cache.bat)  
  🧼 Completely removes all Teams cache and login data to fix lag, crashes, or syncing issues.

---

### 📧 Outlook
- [`outlook/fix-outlook-crashes-june-2025-update.bat`](outlook/fix-outlook-crashes-june-2025-update.bat)  
  🛠️ Fixes crashes caused by the June 2025 Outlook Classic update by creating the missing `FORMS2` folder in `%APPDATA%`.  
  🔗 [Microsoft Support Article](https://support.microsoft.com/en-us/office/classic-outlook-crashes-opening-or-starting-a-new-email-1b413573-7dfc-4147-9c53-c2f1183b89b8)

- [`outlook/hide-new-outlook-button.bat`](outlook/hide-new-outlook-button.bat)  
  🙈 Hides the "Try the New Outlook" toggle in Outlook 2016/2019/365 using registry configuration.  
  🔗 [Microsoft Learn: Control Install](https://learn.microsoft.com/de-de/microsoft-365-apps/outlook/get-started/control-install)

---

### ☁️ Windows / OneDrive
- [`onedrive/disable-onedrive.bat`](onedrive/disable-onedrive.bat)  
  🚫 Uninstalls OneDrive, removes leftover files and disables the sync client via registry settings.

---

> ⚠️ **Note:** Most scripts require **administrator privileges**. Always review scripts before running in production environments. Use at your own risk.

---

## 📌 Planned / To-Do

- [ ] Office license cleanup
- [ ] Reset network stack (DNS/Winsock/IP)
- [ ] Fix printer spooler issues
- [ ] Remove Windows bloatware (e.g. Xbox, Candy Crush)
- [ ] Systeminfo export and log collection
- [ ] Startup entry report
- [ ] Enable dark mode via registry
- [ ] Reset Outlook profile

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).
