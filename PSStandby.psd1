@{
    RootModule             = 'PSStandby.psm1'
    ModuleVersion          = '1.0.0'
    GUID                   = 'a7f5d9e2-1b3c-4f8a-9d2e-5c7a1f3b8e9d'
    Author                 = 'Philipp Grießer'
    Description            = 'Module to enter standby with delay and session 0 support.'
    PowerShellVersion      = '5.1'
    CompatiblePSEditions   = @('Desktop', 'Core')
    FunctionsToExport      = @('Enter-Standby')
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    PrivateData          = @{
        PSData = @{
            Tags = @('Sleep', 'Standby', 'Modern Standby', 'Windows')
            ProjectUri = 'https://github.com/pgriesser/PSStandby'
        }
    }
}
