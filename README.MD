# Sysadmin Scripts

A small collection of **Windows** support scripts for Active Directory, Acrobat/Reader, Microsoft Teams, OneDrive, classic Outlook and optional Windows apps. All eight CMD entry points default to **preview only**. No script downloads or executes remote code.

> **Read this before using the scripts on a user's PC.** `/apply` changes the current machine or account, sometimes irreversibly. Test in an isolated VM, review the proposed targets, keep backups and verify the affected account. The repository is MIT-licensed and provided without warranty.

## Quick start

Open a terminal in the repository and run a script without arguments, or explicitly pass `/preview`:

```cmd
ms-teams\full-clear-teams-cache.cmd /preview
```

Review its output. To carry out the operation, use `/apply`:

```cmd
ms-teams\full-clear-teams-cache.cmd /apply
```

Destructive or machine-wide helpers also require a typed confirmation. `/help` prints usage. A successful preview does **not** establish that applying the change will succeed. Scripts return exit code `0` for success or a safe skip, `1` for an operational failure and `2` for invalid usage or a cancelled operation.

**Account context matters:** Run Teams, Outlook and per-user Appx tasks as the **affected user**. Starting them through an alternate administrator account changes the administrator's own profile/HKCU instead. Use an elevated terminal for machine-wide Adobe/OneDrive policy changes and Appx deprovisioning, preferably by elevating the intended account rather than switching accounts.

The PowerShell helpers use Windows PowerShell 5.1 and the built-in Windows utilities. CMD launchers set the execution policy only for their own PowerShell process; organization-enforced policies still apply. Inspect the local, trusted scripts before execution.

## Scripts

| Entry point | Preview / apply behavior | Scope and recovery |
| --- | --- | --- |
| [Launch AD console](active-directory/launch-ad-console-as-user.cmd) | `/apply` securely prompts for a domain, account and password, then starts `dsa.msc` with alternate credentials. | Requires RSAT Active Directory tools and a simple DNS/NetBIOS domain and sAMAccountName. No password is stored. Closing the console undoes the action. |
| [Disable Adobe JavaScript](adobe-acrobat/disable-javascript.cmd) | Detects supported Reader/Acrobat DC installations before setting `bDisableJavaScript=1` and `bDisableTrustedFolders=1`. | Machine-wide Adobe policy. Existing target keys are exported to a timestamped REG backup in `%TEMP%` before modification. Review managed policies before restoring a backup. |
| [Reset Teams login cache](ms-teams/clear-teams-login.cmd) | Only clears the **new Teams-specific cache** after Teams is closed and you type `RESET`. | Does **not** delete OneAuth, TokenBroker, IdentityCache or AAD BrokerPlugin. It cannot guarantee sign-out with Windows SSO; use Teams' own Sign out if account separation is required. |
| [Reset full Teams caches](ms-teams/full-clear-teams-cache.cmd) | Clears new Teams' cache and known classic Teams cache subfolders after confirmation. | Preserves shared M365 identity stores and classic diagnostic logs outside the listed caches. Some personalization may be lost; restart Teams. |
| [Disable/remove OneDrive](onedrive/disable-onedrive.cmd) | After confirmation, sets the documented `DisableFileSyncNGSC=1` machine policy and invokes an available OneDrive uninstaller. | **Never deletes `%UserProfile%\OneDrive` or its contents.** Verify sync and backup status manually before applying. An existing policy key is exported to `%TEMP%`. Reverting requires changing the policy, and reinstalling OneDrive if removed. |
| [Classic Outlook FORMS2 workaround](outlook/fix-outlook-crashes-june-2025-update.cmd) | Only creates the quoted `%LOCALAPPDATA%\Microsoft\FORMS2` folder when missing and Outlook is closed. | For the specific June 2025 classic Outlook forms-library crash. Microsoft has fixed the issue in subsequent builds: update Office first. |
| [Hide New Outlook toggle](outlook/hide-new-outlook-button.cmd) | `/apply` sets the current user's `HideNewOutlookToggle=1`; `/restore` removes the local value after confirmation. | Only affects the classic Outlook toggle, not installation of the new app. Do not override organization-managed settings. |
| [Remove selected Appx apps](windows/remove-bloatware.cmd) | Shows **exact package names** first; `/apply` requires admin rights and typed `REMOVE`. | Only removes matching installed apps from the current user and deprovisions matching packages for future accounts. Does not affect every existing user and does **not** permanently block Store/Windows reinstallation. |

### Microsoft Teams troubleshooting

Microsoft does **not** recommend cache deletion as a general fix for missing chats, channels or notifications: it can remove diagnostics that support needs. Use the cache scripts only for a targeted local-client problem after checking network, service and account status. Official procedure: [Clear the Teams client cache](https://learn.microsoft.com/en-us/troubleshoot/microsoftteams/teams-administration/clear-teams-cache).

### OneDrive and managed devices

`DisableFileSyncNGSC` is the Windows policy that prevents OneDrive sync; it affects the machine and may be re-applied or controlled by Group Policy/MDM. See [Microsoft's OneDrive policy guidance](https://support.microsoft.com/en-us/onedrive/onedrive-won-t-start). Do not use the uninstaller until you have independently checked the user's sync queue and backups. The script cannot prove that cloud files are fully synchronized.

### Adobe scope

The script supports detected DC registry footprints for Reader/Acrobat and their 32-/64-bit policy paths. If installation detection fails, it makes no changes. Confirm your Adobe package's registry layout and deploy managed policy through GPO/MDM where appropriate. The keys disable JavaScript and trusted folders; they do not promise to disable every other trust mechanism. See [Adobe's enterprise registry guidance](https://helpx.adobe.com/business/enterprise/deploy-apps-updates/deploy-packages/acrobat-64-bit-for-enterprises.html).

### Outlook scope

Microsoft documents the `FORMS2` workaround for a **fixed** June 2025 crash. Check [the known-issue article](https://support.microsoft.com/en-us/support/known-issues/classic-outlook-crashes-opening-or-starting-a-new-email) and installed build before applying it. The [New Outlook toggle setting](https://learn.microsoft.com/en-us/microsoft-365-apps/outlook/get-started/control-install) does not remove the new Outlook application.

## Validation

GitHub Actions parses every PowerShell helper, runs static safety tests and smoke-tests every CMD launcher in `/preview` mode on Windows. The workflow intentionally never calls `/apply` or `/restore`. Follow [the VM test plan](docs/TESTING.md) for manual changes that cannot safely be exercised in CI.

## Planned additions

- Non-destructive Office licensing diagnostics and report export
- Network, print spooler and system information collection (preview-first)
- A targeted Outlook profile diagnostic, without deleting a user's profile

## License

This project's original code and documentation are licensed under the [MIT License](LICENSE) (SPDX identifier: `MIT`). You may use, modify and redistribute them, including for commercial helpdesk work. If you distribute copies or substantial portions, keep the copyright notice and the MIT license text. You do not have to publish your own changes or license unrelated code under MIT.

The MIT license includes an "as is" warranty disclaimer and a limitation-of-liability clause, subject to applicable law. Neither the license nor a green CI run guarantees that an administrative script is safe for a particular machine. Review targets, verify backups and follow the [Windows VM test plan](docs/TESTING.md) before applying potentially destructive changes.

Microsoft, Adobe and other named third-party products remain subject to their own terms. The MIT license in this repository does not grant rights to third-party software or materials that are not part of this project; preserve any third-party notices if such material is added later.
