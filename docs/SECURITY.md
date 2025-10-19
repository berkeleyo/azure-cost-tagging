# SECURITY

- No secrets or identifiers are stored in this repo.
- Use **Azure Key Vault** for credentials and tokens in your automation.
- Scope assignments at **Management Group** where possible to prevent drift.
- Prefer **Deny** for critical tags and **Modify** for inheritance behavior.
- Review **role assignments** for CI/CD service principals driving remediation.
