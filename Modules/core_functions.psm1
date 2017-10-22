<#
.SYNOPSIS
    Removes used session variables, to optimize the current powershell session.
.DESCRIPTION
    Removes used session variables in the current powershell session, except
    from the CustomDirectories and ProtectedObjects
.EXAMPLE
    Optimize-Session
.NOTES
        This function is modified by @codebarbarian - https://github.com/codebarbarian
    ========================================================================================================
    #                                               CHANGELOG
    ========================================================================================================
    #    Author         Version         Date                       Description    
    ========================================================================================================      
    # CodeBarbarian       0.0.1         30/05/2017         First initial modifcation
    # 
    #
    #
    #
    #
    #
    #
    #
    #
#>
function Optimize-Session {
    [cmdletbinding()] 
    [Alias("PS-Clean")]
    param()

    Get-Variable | Where-Object {$_.Name -notmatch '(CustomDirectories|ProtectedObjects)'} | ForEach-Object {
        Remove-Variable -Name "$($_.Name)" -Force -Scope "global" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    Write-Warning -Message "Profile may behave unexpectedly, if problems occur, restart powershell"
}

<#
.SYNOPSIS
    Get Custom Directory Path - Shows predefined paths instead of a long pathname
.DESCRIPTION
    This function is modifed from one of my favorite Powershell developers
        - Prateek Singh
        - https://geekeefy.wordpress.com/2016/10/19/powershell-customize-directory-path-in-ps-prompt/
.NOTES
        This function is modified by @codebarbarian - https://github.com/codebarbarian
    ========================================================================================================
    #                                               CHANGELOG
    ========================================================================================================
    #    Author         Version         Date                       Description    
    ========================================================================================================      
    # CodeBarbarian       0.0.1         30/05/2017         First initial modifcation
    # 
    #
    #
    #
    #
    #
    #
    #
    #
#>
function Get-CustomDirectory {
    [CmdletBinding()]
    [OutputType([String])]
    Param (
        [Parameter(ValueFromPipeline=$true,Position=0)]
        $Path = $PWD.Path
    )

    foreach ($Item in $Path) {
        $Match = ($CustomDirectories.GetEnumerator().name | Where-Object{$Item -eq "$_" -or $Item -like "$_*"} |`
        Select-Object @{n='Directory';e={$_}},@{n='Length';e={$_.length}} |Sort-Object Length -Descending | Select-Object -First 1).directory
        if ($Match) {
            [String]($Item -Replace [regex]::Escape($Match),$CustomDirectories[$Match])            
        } elseif ($pwd.Path -ne $Item) {
            $Item
        } else {
            $pwd.Path
        }
    }
}

<#
.SYNOPSIS
    Clears the host screen and displays the appropriate ascii art
.DESCRIPTION
    See synopsis.
.NOTES
    This function is written by @codebarbarian - https://github.com/codebarbarian
    ========================================================================================================
    #                                               CHANGELOG
    ========================================================================================================
    #    Author         Version         Date                       Description    
    ========================================================================================================      
    # CodeBarbarian     0.0.1         22/10/2017            First initial relase of function
    #
    #
    #
    #
    #
    #
    #
#>
Function Get-Bootstrapper {
    [cmdletbinding()]
    param()

    # Clear Host
    Clear-Host
    
    # Retrieved from the core_art.psm1
    Get-MainHeader
}

<#
.SYNOPSIS
    Powershell implementation of uname (Unix Name)
.DESCRIPTION
    See synopsis.
.NOTES
    This function is written by @codebarbarian - https://github.com/codebarbarian
    ========================================================================================================
    #                                               CHANGELOG
    ========================================================================================================
    #    Author         Version         Date                       Description    
    ========================================================================================================      
    #
    #
    #
    #
    #
    #
    #
    #

    Current status: Outlined, early development
#>
Function Get-PowerShellName {
    [cmdletbinding()]
    [Alias("pname")]
    [OutputType([string])]
    param (
        # All
        [switch] $a,
        [switch] $all,
        # Kernel Name
        [switch] $s,
        [switch] $kernalname,
        # Nodename
        [switch] $n,
        [switch] $nodename,
        # Kernel Release
        [switch] $r,
        [switch] $kernelrelease,
        # Kernel Version
        [switch] $v,
        [switch] $kernelversion,
        # Machine
        [switch] $m,
        [switch] $machine,
        # Processor
        [switch] $p,
        [switch] $processor,
        # Operating System
        [switch] $o,
        [switch] $operatingsystem
    )
}





# Export all functions in this file
Export-ModuleMember -Function Get-*
Export-ModuleMember -Function Set-*
Export-ModuleMember -Function Optimize-*