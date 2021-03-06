@{
# Script module or binary module file associated with this manifest.
RootModule = 'CBB-Profile.psm1'

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = '4cad4b51-b525-49ad-9cbb-15457da913ca'

# Author of this module
Author = 'CodeBarbarian'

# Company or vendor of this module
CompanyName = 'CodeBarbarian Development'

# Copyright statement for this module
Copyright = '(c) 2017 CodeBarbarian. All rights reserved.'

# Description of the functionality provided by this module
Description = 'My Personal Powershell profile'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
PowerShellHostName = 'ConsoleHost'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @("$PSScriptRoot\CBB-Core\CBBCore-Art.psd1", 
                    "$PSScriptRoot\CBB-Core\CBBCore-Functions.psd1",
                    "$PSScriptRoot\CBB-Core\CBB-SAG.psd1",
                    "$PSScriptRoot\NetworkingUtilities\MacAddressUtilities\MacAddressUtilities.psd1",
                    "$PSScriptRoot\NetworkingUtilities\Whois\Whois.psd1",                    
                    "$PSScriptRoot\GeoUtilities\WeatherUtilities\WeatherUtilities.psd1",
                    "$PSScriptRoot\APIs\SpaceX\SpaceX.psd1",
                    "$PSScriptRoot\APIs\Discord\Discord.psd1",
                    "$PSScriptRoot\APIs\Discord\Space.psd1"
                    )

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @('.\..\Config\CBB-Config.ps1',  # Configuration file
                     # Menus
                     '.\NetworkingUtilities\NetworkMenu.ps1',
                     '.\APIs\APIsMenu.ps1'
                    )

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @()

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{ PSData = @{} }
}

