param(
    [Parameter(Mandatory)]
    [string]$InputCsv, # produced by discover-tags.ps1
    [switch]$WhatIf
)

$items = Import-Csv $InputCsv
foreach ($i in $items) {
    if ([string]::IsNullOrWhiteSpace($i.MissingKeys)) { continue }
    $id = $i.Id
    $tags = (Get-AzResource -ResourceId $id -ExpandProperties).Tags
    if (-not $tags) { $tags = @{} }
    foreach ($k in ($i.MissingKeys -split ';')) {
        if (-not [string]::IsNullOrWhiteSpace($k)) { $tags[$k] = "TBD" }
    }
    Write-Host "Remediating $id ..."
    Set-AzResource -ResourceId $id -Tag $tags -Force -WhatIf:$WhatIf.IsPresent | Out-Null
}
