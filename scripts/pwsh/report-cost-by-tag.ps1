param(
    [Parameter(Mandatory)]
    [string]$Scope,
    [string]$OutFile = "./cost-by-tag.csv",
    [string]$TagKey = "costCenter",
    [int]$MonthsBack = 1
)

# Placeholder: Real cost export requires Cost Management API
# This stub emits a CSV structure you can join with cost exports from your pipeline.
"TagValue,Cost" | Out-File -FilePath $OutFile -Encoding UTF8
"CC-1234,0.00"  | Add-Content -Path $OutFile
"CC-5678,0.00"  | Add-Content -Path $OutFile
Write-Host "Wrote placeholder report to $OutFile (integrate with Cost Management exports)."
