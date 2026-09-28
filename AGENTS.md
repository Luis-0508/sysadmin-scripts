# Repository agent instructions

This repository contains Windows administrative scripts. Treat it as a **high-impact support toolkit**, not a general-purpose cleanup collection.

- All code, comments, commit messages, branches, PR titles and PR descriptions must be in English.
- Keep the existing CMD entry points and `/preview`, `/apply` and `/help` interface. Preview must never change a user profile, registry, apps or files.
- Never silently delete `%UserProfile%\OneDrive`, shared Microsoft identity stores, user documents or arbitrary package matches. Changes with data-loss potential require a specific target list, explicit opt-in and a documented backup/recovery path.
- Never force-close Teams, Outlook or OneDrive during preview. An apply operation should require the user to close applications and acknowledge data or sync risks.
- Respect current-user versus elevated administrator context. Prefer checking prerequisites and refusing unsupported installations over guessing registry paths.
- Use exact package names instead of wildcards or broad regular expressions when removing Appx applications. Do not claim that deprovisioning permanently prevents Store reinstalls.
- Preserve previous policy settings when possible; offer reversible changes. Do not remove organization-managed GPO/MDM settings or add credential logging.
- For all code changes, update README documentation and regression checks; run the Windows workflow. CI must never execute any apply/restore action.
- Open a task branch and PR for review; do not push directly to `main`, merge or deploy without explicit approval. Report checks not run and remaining assumptions.
