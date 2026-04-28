@{
    RootModule             = 'PSStandby.psm1'
    ModuleVersion          = '1.2.1'
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
            Tags = @('Sleep', 'Standby', 'ModernStandby', 'Hibernation', 'Windows')
            ProjectUri = 'https://github.com/pgriesser/PSStandby'
            ReleaseNotes = @'
1.2.1:
- Publish to PSGallery without .git folder

1.2.0:
- Added support for hibernation

1.1.0:
- Introduced InterruptibleSleep to allow preventing standby if user activity is detected
- Added return value to indicate if standby was entered

1.0.0:
- Initial release
'@
        }
    }
}
