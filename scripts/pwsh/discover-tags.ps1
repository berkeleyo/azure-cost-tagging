param(
    [Parameter(Mandatory)]
    [string]$Scope,  # e.g., /subscriptions/00000000-0000-0000-0000-000000000000 or /providers/Microsoft.Management/managementGroups/MG-CORP
    [string]$OutFile = "./tag-inventory.csv",
    [string[]]$TagKeys = @("costCenter","owner","env","service","businessUnit","retention")
)

# Safety: read-only
Write-Host "Enumerating resources under scope $Scope..."

$resources = Get-AzResource -Scope $Scope -ExpandProperties -ErrorAction Stop

$rows = foreach ($r in $resources) {
    $tags = @{} + ($r.Tags ?? @{})
    [PSCustomObject]@{
        Id            = $r.ResourceId
        Name          = $r.Name
        Type          = $r.ResourceType
        Location      = $r.Location
        ResourceGroup = $r.ResourceGroupName
        costCenter    = $tags['costCenter']
        owner         = $tags['owner']
        env           = $tags['env']
        service       = $tags['service']
        businessUnit  = $tags['businessUnit']
        retention     = $tags['retention']
        MissingKeys   = ($TagKeys | Where-Object { -not $tags.ContainsKey($_) }) -join ';'
    }
}

$rows | Export-Csv -Path $OutFile -NoTypeInformation -Encoding UTF8
Write-Host "Inventory written to $OutFile"
