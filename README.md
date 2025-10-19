# Azure Cost Tagging & Governance ðŸ·ï¸ðŸ’¸

![Redaction Badge](https://img.shields.io/badge/REDACTED-No%20secrets%20or%20tenant%20info-green)
> **Redaction statement:** This repository is **fully redacted**. It contains **no secrets, IP addresses, tenant IDs, subscription IDs, hostnames, or organization identifiers**. All values are placeholders intended for safe sharing.

A clean, production-ready implementation to standardize, enforce, and report **Azure cost tags** across subscriptions and resource groups. It includes design guidance, ready-to-run scripts, Azure Policy JSON, and operational runbooksâ€”built to be cloned, adapted, and deployed safely.

---

## Why this repo?

- Drive **cost visibility** and **chargeback/showback** via consistent tags (e.g., `costCenter`, `owner`, `env`, `service`, `businessUnit`).
- Enforce governance with **Azure Policy** (require + inherit) and automate **remediation**.
- Report costs by tag in **Azure Cost Management** and your FinOps tooling of choice.
- Operate with clear **RUNBOOK** procedures and **CUTOVER / ROLLBACK** checklists.

---

## Repository map

```
.
â”œâ”€ README.md
â”œâ”€ RUNBOOK.md
â”œâ”€ .gitignore
â”œâ”€ docs/
â”‚  â”œâ”€ OVERVIEW.md
â”‚  â”œâ”€ ARCHITECTURE.md
â”‚  â”œâ”€ CUTOVER_CHECKLIST.md
â”‚  â”œâ”€ ROLLBACK.md
â”‚  â””â”€ SECURITY.md
â””â”€ scripts/
   â”œâ”€ pwsh/
   â”‚  â”œâ”€ discover-tags.ps1
   â”‚  â”œâ”€ enforce-tags.ps1
   â”‚  â”œâ”€ remediate-untagged.ps1
   â”‚  â””â”€ report-cost-by-tag.ps1
   â”œâ”€ bash/
   â”‚  â””â”€ discover-tags.sh
   â”œâ”€ policy/
   â”‚  â”œâ”€ policy-definition-require-tags.json
   â”‚  â”œâ”€ policy-definition-inherit-tags.json
   â”‚  â”œâ”€ policy-initiative-cost-governance.json
   â”‚  â””â”€ policy-assignment-example.json
   â””â”€ examples/
      â””â”€ sample-tag-schema.json
```

---

## Lifecycle stages

1. **Discover** â†’ Inventory current tags; baseline gaps.
2. **Design** â†’ Define tag schema & ownership; choose enforcement scope.
3. **Build** â†’ Author policy (require + inherit); prepare initiatives & assignments.
4. **Test** â†’ Dry-run (Audit) in non-prod; validate exemptions.
5. **Cutover** â†’ Switch to Deny/Modify; run remediation tasks.
6. **Operate** â†’ Periodic reports; exception flow; continuous improvement.

---

## 🪄 Solution Overview (Mermaid)

```mermaid
flowchart LR
  A["Stakeholders & FinOps"] --> B["Tag Schema & Standards"]
  B --> C["Azure Policy<br/>(require + inherit)"]
  C --> D["Assignments at Mgmt Group / Subscription"]
  D --> E["Automated Remediation<br/>(Modify or DeployIfNotExists)"]
  E --> F["Consistent Resource Tags"]
  F --> G["Azure Cost Management<br/>& FinOps Reports"]
  G --> H["Showback / Chargeback"]
  H -->|Feedback| A


---

## Getting started

- ðŸ’» **Scripts**: See `scripts/pwsh/*.ps1` and `scripts/bash/*.sh` (non-destructive by default).
- ðŸ›¡ï¸ **Policy**: Import JSON in `scripts/policy/` (definitions â†’ initiative â†’ assignment).
- ðŸ“š **Docs**: Start with `docs/OVERVIEW.md`, then `ARCHITECTURE.md`, then follow `RUNBOOK.md`.

> **Safety defaults**: Provided scripts favor **read-only** operations unless you pass `-WhatIf:$false` or `-Confirm:$false` explicitly. Review before running.

---

## Quick start (PowerShell)

```powershell
# Login & select a context
Connect-AzAccount
Set-AzContext -Subscription "SUBSCRIPTION-NAME-OR-ID"

# 1) Discover current tag posture (CSV export)
./scripts/pwsh/discover-tags.ps1 -Scope "/subscriptions/00000000-0000-0000-0000-000000000000" -OutFile "./tag-inventory.csv"

# 2) Import policy definitions
$polRoot = "./scripts/policy"
New-AzPolicyDefinition -Name "require-tags" -Policy (Get-Content "$polRoot/policy-definition-require-tags.json" -Raw)
New-AzPolicyDefinition -Name "inherit-tags" -Policy (Get-Content "$polRoot/policy-definition-inherit-tags.json" -Raw)

# 3) Create initiative (policy set) & assign
$initiative = Get-Content "$polRoot/policy-initiative-cost-governance.json" -Raw
New-AzPolicySetDefinition -Name "cost-governance" -PolicyDefinition $initiative
New-AzPolicyAssignment -Name "cost-governance-assignment" -Scope "/providers/Microsoft.Management/managementGroups/MG-CORP" `
  -PolicySetDefinition (Get-AzPolicySetDefinition -Name "cost-governance")

# 4) Review effects in Audit mode, then flip to Deny/Modify during cutover.
```

---

## Tag schema (example)

| Tag Key       | Example Value         | Purpose                               |
|---------------|-----------------------|----------------------------------------|
| `costCenter`  | `CC-1234`            | Chargeback/showback                    |
| `owner`       | `email@domain.tld`   | Accountability                         |
| `env`         | `prod` `nonprod`     | Lifecycle isolation                    |
| `service`     | `payments-api`       | Service / application mapping          |
| `businessUnit`| `Retail`             | Financial rollups                      |
| `retention`   | `90d` `365d`         | Data lifecycle alignment               |

> Replace with your authoritative schema. Keep **keys** stable and values validated (policy parameters or allow lists).

---

## Trust & redaction

- âœ… No secrets, IPs, tenant names, or organizational identifiers.
- ðŸ” Use your own secure secret store for creds/tokens (e.g., Azure Key Vault).
- ðŸ§ª All example IDs are **fabricated** / zero-value.

---

## License

MIT â€” see `LICENSE` (add one if required by your org).

