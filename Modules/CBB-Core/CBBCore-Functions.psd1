@{
# Script module or binary module file associated with this manifest.
RootModule = 'CBBCore-Functions.psm1'

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = '6bd545f7-3b86-486c-9d07-4580f53d70f6'

# Author of this module
Author = 'CodeBarbarian'

# Company or vendor of this module
CompanyName = 'CodeBarbarian Development'

# Copyright statement for this module
Copyright = '(c) 2017 CodeBarbarian. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Core functions for the profile'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
PowerShellHostName = 'ConsoleHost'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Get-Bootstrapper', 'Get-CustomDirectory', 'Touch', 'New-Window', 'Trace-Self', 'Show-Procedures', 'Run-Procedure', 'Get-Modules', 'Get-ModuleDirectory', 'ConvertFrom-Color', 'ConvertFrom-UnixTime')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{ PSData = @{} } 

}

