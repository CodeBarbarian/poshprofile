<#
.SYNOPSIS
    This is the main update script to update the powershell profile.
.DESCRIPTION
    This script takes the profile version located in a directory of the users choice, and updates the current powershell profile.
    This script works even if your powershell profile is not configured.
.NOTES
    Changelog:
    ___________________________________________________________________________
    ---------------------------------------------------------------------------
    | Author                        Version                     Date
    ---------------------------------------------------------------------------
    | Morten Haugstad                 1.0                    28.09.2017
    ---------------------------------------------------------------------------
    ___________________________________________________________________________
#>

param (
    [parameter(Mandatory=$True)]
    $SourcePath,
    [parameter(Mandatory=$True)]
    $DestinationPath
)


# Acquire manifest file in source

# Check the destination folder if it is empty or needs to be taken backup.

# Backup is automatically initiated when there is no