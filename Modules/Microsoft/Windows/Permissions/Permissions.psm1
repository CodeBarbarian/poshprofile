<#

    Following is according to Windows 2000 permission standards:
        - Read is the only permission needed to run scripts. Execute permission doesn't matter.
        - Read access is required to access a shortcut and its target.
        - Giving a user permission to write to a file but not to delete it doesn't prevent the user from deleting the file's contents. A user can still delete the contents.
        - If a user has full control over a folder, the user can delete files in the folder regardless of the permission on the files.

#>

<#
.SYNOPSIS
    Get-Permission retrives any given file or folder ACL
.DESCRIPTION
    Get-Permissions retrieves any given file or folder ACL by using Get-Permission
    and returns with the ACLObject
.PARAMETER Path
    Path is a mandatory parameter, which is any given folder or file where you would like to retrieve the acl from
.EXAMPLE
    Get-Permission -Path "C:\users\example\desktop\test.txt"
.NOTES
    -- None -- 
#>
Function Get-Permission {
    [cmdletbinding()]
    [OutputType([Object])]
    param (
        # Path parameter, mandatory.
        [parameter(mandatory=$true)]
        [string] $Path
    )

    # Store the ACL data into the ACLObject variable
    $ACLObject = Get-ACL -Path $Path

    # Return the ACLObject
    return $ACLObject
}

<#
.SYNOPSIS
    Set-Permission sets the acl of any given folder or file using an existing ACLObject
.DESCRIPTION
    Set-Permission set the acl of any given folder or file using an existing ACLObject using the Set-ACL cmdlet.
    Returns the response, if any
.PARAMETER Path
    Path is a mandatory parameter for which must be supplied by any given file or folder for which you'd like to set the ACL
.PARAMETER ACLObject
    ACLObject is a mandatory parameter for which contains an already extracted ACL object.
    Important use Get-ACL on any file or folder from which you would like to copy the access properties from.
.EXAMPLE
    $Path           = "C:\users\example\desktop\test.txt"
    $ACLObject      = Get-Permission -Path $Path
    $NewACLObject   = Set-Permission -Path $Path -ACLObject $ACLObject
.NOTES
    -- None --
#>
Function Set-Permission {
    [cmdletbinding()]
    [OutputType([void])]
    param (
        [parameter()]
        [string] $Path,
        [parameter()]
        [string] $ACLObject
    )

    $ACLResponse = Set-ACL -Path $Path -AclObject $ACLObject

    return $ACLResponse
}

### User Permissions
Function Set-UserPermission {
    [cmdletbinding()]
    param (
        # Username
        [parameter()]
        [string] $Username,
        
        # Permission Type
        [parameter()]
        [ValidateSet('ReadAndExecute', 'Modify', 'FullControl')]
        [string] $Permission = "FullControl",
        
        # Permission Action
        [parameter()]
        [ValidateSet('Allow', 'Deny')]
        [string] $Type = "Allow",
        
        # Inheritance
        [parameter()]
        [ValidateSet('None', 'True')]
        [string] $Inherit = "None",

        # Access rule type 
        [parameter(mandatory=$true)]
        [ValidateSet('Add', 'Remove')]
        $AccessRuleType,

        # Path for ACL
        [parameter()]
        [string] $Path
    )

    # Get ACL of object
    $ACLObject = Get-Acl -Path $Path

    $Attribute = New-Object System.Security.AccessControl.FileSystemAccessRule("$($Username)", "$($Permission)", "ContainerInherit,ObjectInherit", "$($Inherit)", "$($Type)")
    
    # Atrribute to add or remove
    if ($AccessRuleType -eq 'Add') {
        # Add attribute to ACLObject
        $ACLObject.SetAccessRule($Attribute)
    } else {
        # Remove attribute from ACLObject
        $ACLObject.RemoveAccessRule($Attribute)
    }

    # Set ACL
    Set-Acl -Path $Path -AclObject $ACLObject
}

Function Set-HomeFolderACL {
    [cmdletbinding()] 
    param (
        [parameter(mandatory=$true)]
        [string] $Path,
        
        [parameter()]
        [string] $Exclude
    )

    # Return Object
    $ReturnObject = @()

    # Set the location to share
    Set-Location $Path

    # Get all the home folders (On share, probably)
    $Folders = Get-ChildItem -Path $Path -Directory
}

