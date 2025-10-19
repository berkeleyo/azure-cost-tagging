param(
    [Parameter(Mandatory)]
    [string]$Scope,
    [string[]]$RequiredTagKeys = @("costCenter","owner","env","service"),
    [switch]$WhatIf
)

# This script ensures required tag KEYS exist by stamping placeholder values where allowed.
# Prefer policy Modify; use this only for one-time remediation.
$resources = Get-AzResource -Scope $Scope -ExpandProperties -ErrorAction Stop

foreach ($r in $resources) {
    $tags = @{} + ($r.Tags ?? @{})
    $missing = $RequiredTagKeys | Where-Object { -not $tags.ContainsKey($_) }
    if ($missing.Count -gt 0) {
        foreach ($k in $missing) { $tags[$k] = "TBD" }
        Write-Host "Stamping tags on $($r.ResourceId): $($missing -join ', ')"
        Set-AzResource -ResourceId $r.ResourceId -Tag $tags -Force -WhatIf:$WhatIf.IsPresent | Out-Null
    }
}
