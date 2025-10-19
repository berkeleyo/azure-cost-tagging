# RUNBOOK — Azure Cost Tagging & Governance

This runbook describes the **operational procedures** to deploy and operate cost tagging governance in Azure.

> **Change type:** Standard change (pre-approved) for Audit; Normal change for Deny/Modify cutover.

---

## 0. Prereqs

- Azure role: Policy Contributor + Resource Policy Contributor (or Owner) at target scope.
- PowerShell: `Az` modules installed.
- Change ticket approved; business communication prepared.

---

## 1. Discover (Audit only)

1. Run `scripts/pwsh/discover-tags.ps1 -Scope "<scope>" -OutFile "./tag-inventory.csv"`
2. Review CSV for:
   - Missing required tags
   - Invalid values vs. the schema
   - Resources not inheriting RG-level tags

Deliverable: **Discovery Report** attached to the change ticket.

---

## 2. Import policy definitions (safe)

1. Create/Update **Require Tags** and **Inherit Tags** definitions using files in `scripts/policy/`.
2. Keep effects in `audit` initially.
3. Assign initiative at **Management Group** (preferred) or Subscription scope.

Check: Policy compliance shows resources & exemptions as expected.

---

## 3. Remediation (Modify)

- Enable **Modify** where possible to stamp missing tags using RG or subscription parameters.
- For resources not coverable by Modify, run `remediate-untagged.ps1` in **supervised batches** with `-WhatIf` first.

Rollback: revert effects to `audit` and remove temporary assignments.

---

## 4. Cutover to enforcement (Deny)

- Communicate cutover window and exemption process.
- Flip initiative definitions/effects from `audit` to `deny` (or split via parameters).
- Monitor policy compliance and deployment failures.

Exit criteria: 24–48 hours without material deployment failures.

---

## 5. Operate

- Weekly: run `report-cost-by-tag.ps1` and attach to FinOps cadence.
- Monthly: validate exemptions; expire stale ones.
- Quarterly: review schema and update allow lists/parameters.

---

## 6. Support & Break/Fix

- Build failures due to deny: advise teams to use approved tag sets.
- Emergency bypass: temporary **exemption** with expiry + reason code.
- Incident logging: link to policy assignment ID and correlation IDs.

---

## 7. Rollback (high level)

- Set all effects back to `audit`.
- Remove remediation assignments.
- Optionally delete initiative and definitions if decommissioning the control.

See `docs/ROLLBACK.md` for details.
