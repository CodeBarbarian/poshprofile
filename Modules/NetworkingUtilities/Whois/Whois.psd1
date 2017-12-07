@{

# Script module or binary module file associated with this manifest.
RootModule = 'Whois.psm1'

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = '5b0b7e0c-53ef-4784-ae2d-6e1c45a61725'

# Author of this module
Author = 'CodeBarbarian'

# Company or vendor of this module
CompanyName = 'CodeBarbarian Development'

# Copyright statement for this module
Copyright = '(c) 2017 CodeBarbarian. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Whois Lookup'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
PowerShellHostName = 'ConsoleHost'

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @('.\DefaultWebProxyCredentials.ps1')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Whois')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{ PSData = @{} } 
}

