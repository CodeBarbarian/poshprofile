@{

# Script module or binary module file associated with this manifest.
RootModule = 'Discord.psm1'

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = '7798e55a-7fac-4d38-bcd0-556f675c0314'

# Author of this module
Author = 'CodeBarbarian'

# Company or vendor of this module
CompanyName = 'CodeBarbarian Development'

# Description of the functionality provided by this module
Description = 'Discord Webhook API'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
PowerShellHostName = 'ConsoleHost'

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @('.\DefaultWebProxyCredentials.ps1')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('New-DiscordSection', 'New-DiscordAuthor', 'New-DiscordFact', 'New-DiscordImage', 'Send-DiscordMessage', 'Get-DiscordConfig', 'Initialize-DiscordConfig')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @('New-DiscordField', 'New-DiscordThumbnail', 'New-DiscordEmbed')

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{ PSData = @{} }
}