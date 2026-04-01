$privateScripts = Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1" -File
foreach ($scriptFile in $privateScripts) {
    . $scriptFile.FullName
}

$script:ModernStandbyPSScriptPath = Join-Path -Path $PSScriptRoot -ChildPath 'Private/Enter-S0ix.ps1'
$script:InterruptibleSleepPSScriptPath = Join-Path -Path $PSScriptRoot -ChildPath 'Private/Start-InterruptibleSleep.ps1'

$publicScripts = Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" -File
foreach ($scriptFile in $publicScripts) {
    . $scriptFile.FullName
}

Export-ModuleMember -Function ($publicScripts | ForEach-Object { $_.BaseName })
