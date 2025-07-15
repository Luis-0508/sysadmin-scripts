# 🛠️ Sysadmin Scripts

A collection of Windows **batch scripts** for system administrators to quickly **fix**, **clean**, and **configure** common issues in Microsoft Office, Teams, Adobe Acrobat, and Windows itself.

These scripts are designed to save time and reduce troubleshooting effort for **IT professionals**, **Helpdesk technicians**, and **power users**.

---

## 📄 Script Overview

### 📂 Adobe Acrobat
- [`adobe-acrobat/disable-javascript.cmd`](adobe-acrobat/disable-javascript.cmd)  
  🔒 Disables JavaScript and trusted folders in Adobe Acrobat Reader DC for enhanced security using registry keys.

---

### 💬 Microsoft Teams
- [`ms-teams/clear-teams-login.cmd`](ms-teams/clear-teams-login.cmd)  
  🧹 Clears cached login folders for Microsoft Teams to ensure credentials must be re-entered.

- [`ms-teams/full-clear-teams-cache.cmd`](ms-teams/full-clear-teams-cache.cmd)  
  🧼 Completely removes all Teams cache and login data to fix lag, crashes, or syncing issues.

---

### 📧 Outlook
- [`outlook/fix-outlook-crashes-june-2025-update.cmd`](outlook/fix-outlook-crashes-june-2025-update.cmd)  
  🛠️ Fixes crashes caused by the June 2025 Outlook Classic update by creating the missing `FORMS2` folder in `%APPDATA%`.  
  🔗 [Microsoft Support Article](https://support.microsoft.com/en-us/office/classic-outlook-crashes-opening-or-starting-a-new-email-1b413573-7dfc-4147-9c53-c2f1183b89b8)

- [`outlook/hide-new-outlook-button.cmd`](outlook/hide-new-outlook-button.cmd)  
  🙈 Hides the "Try the New Outlook" toggle in Outlook 2016/2019/365 using registry configuration.  
  🔗 [Microsoft Learn: Control Install](https://learn.microsoft.com/de-de/microsoft-365-apps/outlook/get-started/control-install)

---

### ☁️ Windows / OneDrive
- [`onedrive/disable-onedrive.cmd`](onedrive/disable-onedrive.cmd)  
  🚫 Uninstalls OneDrive, removes leftover files and disables the sync client via registry settings.

- [`windows/remove-bloatware.cmd`](windows/remove-bloatware.cmd)  
  🧽 Removes pre-installed bloatware apps (e.g. Xbox, Candy Crush, Paint 3D) and blocks their future installation using PowerShell.

---

### 🧑‍💼 Active Directory
- [`active-directory/launch-ad-console-as-user.cmd`](active-directory/launch-ad-console-as-user.cmd)  
  🔐 Prompts for domain credentials and launches the Active Directory Users and Computers console (`dsa.msc`) as another user without switching sessions.

---

> ⚠️ **Note:** Most scripts require **administrator privileges**. Always review scripts before running in production environments. Use at your own risk.

---

## 📌 Planned / To-Do

- [ ] Office license cleanup  
- [ ] Reset network stack (DNS/Winsock/IP)  
- [ ] Fix printer spooler issues  
- [ ] Systeminfo export and log collection  
- [ ] Startup entry report  
- [ ] Enable dark mode via registry  
- [ ] Reset Outlook profile  

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).
