# Manual Windows VM test plan

Use a disposable, snapshotted Windows 11 VM and a separate test account. **Never use real user files or active corporate accounts as test data.** GitHub Actions covers PowerShell parsing, static safety rules and non-mutating previews only.

## Preparation

1. Take a VM snapshot, create a test user's profile and document the Windows, Teams, OneDrive, Office, Acrobat and PowerShell versions.
2. If testing OneDrive, use a disposable test account and put uniquely named **backed-up** sample files in the test OneDrive directory. Verify which files are cloud-only, locally available, unsynchronized or synced; do not claim the script can determine this.
3. Run all eight `/preview` commands from the affected account; record exit codes and verify file timestamps, registry values and installed package lists do not change.
4. Run each script with `/help` and invalid arguments. The invalid-usage exit code should be 2.
5. Test operations with missing applications, missing RSAT, already-applied policies, non-ASCII or spaced profile paths and a different admin account.

## Apply cases

- **Teams:** Keep Teams open and verify `/apply` refuses the deletion. Quit Teams, run `/apply`, decline confirmation and check that no files changed. Repeat with confirmation on disposable local cache data. Verify that shared M365 identity paths still exist.
- **OneDrive:** Verify a declined confirmation is a no-op. With a disposable synchronized profile, confirm that the OneDrive user directory and its files are byte-for-byte unchanged after applying policy/uninstall. Inspect policy backup and `DisableFileSyncNGSC`; verify the app uninstall result separately. Restore the VM snapshot.
- **Appx:** Run as the intended admin test account, compare preview package IDs with the exact allowlist and provisioned package IDs. Decline, then confirm; verify only listed packages changed. Check that an unrelated Xbox/Windows dependency remains installed. Restore the snapshot.
- **Acrobat:** With a supported Reader/Acrobat install, verify a declined confirmation changes nothing. After confirmation, inspect both DWORD values and the exported REG backup. Repeat on a device without the product and verify a safe skip.
- **Outlook:** Verify the toggle only changes the current user's HKCU key; test `/restore` with and without a pre-existing override. For `FORMS2`, verify Outlook-open refusal, idempotent creation and correct behavior with a spaced user-profile path.
- **AD console:** Verify missing RSAT, invalid account input and canceling the credential prompt. With a non-production test domain, verify the console uses the intended credentials. Never record passwords.

Record results, failed/unsupported combinations and a screenshot or log excerpt that contains no secrets. Do not mark live system behavior as tested based only on a green CI run.
