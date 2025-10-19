# CUTOVER CHECKLIST

**Objective:** Flip from **Audit** to **Modify/Deny** safely.

- [ ] Change approved; comms sent to application owners.
- [ ] Initiative parameters validated in non-prod.
- [ ] Exemption workflow established and documented.
- [ ] `remediate-untagged.ps1` dry-run completed; batch plan ready.
- [ ] Monitoring dashboards in place (Policy compliance, Deployments).
- [ ] Flip effects:
  - [ ] `audit` → `modify` for inheritance
  - [ ] `audit` → `deny` for missing critical tags
- [ ] Post-cutover watch for 24–48h.
- [ ] Document outcomes and lessons learned.
