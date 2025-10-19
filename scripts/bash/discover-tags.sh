#!/usr/bin/env bash
set -euo pipefail

SCOPE="${1:-/subscriptions/00000000-0000-0000-0000-000000000000}"
OUT="${2:-./tag-inventory.csv}"

echo "Id,Name,Type,Location,ResourceGroup,costCenter,owner,env,service,businessUnit,retention,MissingKeys" > "$OUT"

# Requires az cli + jq
az resource list --scope "$SCOPE" --include-format --query "[]" -o json | jq -r '
  .[] | . as $r |
  ($r.tags // {}) as $t |
  [
    $r.id, $r.name, $r.type, $r.location, $r.resourceGroup,
    ($t.costCenter // ""), ($t.owner // ""), ($t.env // ""), ($t.service // ""), ($t.businessUnit // ""), ($t.retention // ""),
    (["costCenter","owner","env","service","businessUnit","retention"] | map(select($t[.]|not)) | join(";"))
  ] | @csv
' >> "$OUT"

echo "Wrote $OUT"
