"""Non-destructive safeguards for the CMD entry points and PowerShell helpers."""

from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
ENTRY_POINTS = (
    "active-directory/launch-ad-console-as-user.cmd",
    "adobe-acrobat/disable-javascript.cmd",
    "ms-teams/clear-teams-login.cmd",
    "ms-teams/full-clear-teams-cache.cmd",
    "onedrive/disable-onedrive.cmd",
    "outlook/fix-outlook-crashes-june-2025-update.cmd",
    "outlook/hide-new-outlook-button.cmd",
    "windows/remove-bloatware.cmd",
)


def content(path):
    return (ROOT / path).read_text(encoding="utf-8")


class ScriptSafetyTests(unittest.TestCase):
    def test_all_entry_points_are_preview_first(self):
        for path in ENTRY_POINTS:
            with self.subTest(path=path):
                script = content(path).lower()
                self.assertIn('"%~1"==""', script)
                self.assertIn('"/preview"', script)
                self.assertIn('"/apply"', script)
                self.assertIn('"/help"', script)
                self.assertIn("exit /b", script)

    def test_no_shared_microsoft_identity_store_deletion(self):
        for path in (
            "ms-teams/clear-teams-login.cmd",
            "ms-teams/full-clear-teams-cache.cmd",
            "scripts/Reset-TeamsCache.ps1",
        ):
            with self.subTest(path=path):
                self.assertIsNone(
                    re.search(r"OneAuth|TokenBroker|IdentityCache|AAD[.]BrokerPlugin", content(path), re.I)
                )

    def test_onedrive_only_disables_policy_and_never_removes_user_data(self):
        script = content("scripts/Disable-OneDrive.ps1")
        self.assertIn("DisableFileSyncNGSC", script)
        self.assertIsNone(re.search(r"\bDisableFileSync\b", script))
        self.assertNotIn("Remove-Item", script)
        self.assertNotIn("OneDriveTemp", script)

    def test_bloatware_uses_exact_allowlist(self):
        script = content("scripts/Remove-Bloatware.ps1")
        self.assertIn("$packageNames -contains $_.Name", script)
        self.assertNotIn(" -AllUsers", script)
        self.assertNotIn(" -match ", script)
        self.assertNotIn("*Xbox*", script)
        self.assertIn("Confirm-Token -Token 'REMOVE'", script)

    def test_confirmation_and_path_guard_exist(self):
        common = content("scripts/Common.ps1")
        self.assertIn("function Confirm-Token", common)
        self.assertIn("function Assert-SafeDeleteTarget", common)
        self.assertIn("ReparsePoint", common)
        self.assertIn("Confirm-Token -Token 'RESET'", content("scripts/Reset-TeamsCache.ps1"))
        self.assertIn("Confirm-Token -Token 'DISABLE'", content("scripts/Disable-OneDrive.ps1"))

    def test_no_ci_apply_or_restore(self):
        workflow = content(".github/workflows/script-checks.yml")
        self.assertIn("Windows script safety checks", workflow)
        self.assertNotIn("/apply", workflow.lower())
        self.assertNotIn("/restore", workflow.lower())


if __name__ == "__main__":
    unittest.main()
