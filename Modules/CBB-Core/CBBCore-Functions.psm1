<#
.SYNOPSIS
    Removes used session variables, to optimize the current powershell session.
.DESCRIPTION
    Removes used session variables in the current powershell session, except
    from the CustomDirectories and ProtectedObjects

    This function is currently not in use, since the profile is changed so much, but the function has not.
.EXAMPLE
    Optimize-Session
.NOTES
        This function is modified by @codebarbarian - https://github.com/codebarbarian
#>
function Optimize-Session {
    [cmdletbinding()] 
    [OutputType([void])]
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
#>
Function Get-Bootstrapper {
    [cmdletbinding()]
    [OutputType([void])]
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

<#
.SYNOPSIS
    Simple implementation of touch command from *nix
.DESCRIPTION
    See synopsis.
    This script could be accomplished by doing "Net-Alias -Name Touch -Value New-Item"
.EXAMPLE
    touch c:\temp\test.txt
.PARAMETER Path
    The entire FQPN
.LINK
.NOTES
    This function is written by @codebarbarian - https://github.com/codebarbarian
#>
Function Touch {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([void])]
    param (
        [parameter(mandatory=$true)]
        $Path
    )

    if ($PSCmdlet.ShouldProcess("Creating file $($Path)")) {
        Write-Verbose -Message "Creating file $($Path)"
        New-Item -Path $Path -ItemType File -Force
        Write-Verbose -Message "File created."
    }
    return 0
}

Function Get-PSProfileChallenge {
    [cmdletbinding()]
    [OutputType([boolean])]
    param ()

    if (Get-Variable -Name PSProfileChallenge -Scope Global -ErrorAction SilentlyContinue) {
        return $True
    } else {
        $False
    }
}

Function New-PSWindow {
    [cmdletbinding()]
    param (
        $Include 
    )

    Invoke-Expression "cmd /c start powershell.exe -Command $($Include)"
}

Function Get-SessionHistory {
    [cmdletbinding()]
    param (

    )

    $Objects = Get-History | Select-Object CommandLine

    return $Objects.CommandLine

}

Function Get-PSVariables {
    [cmdletbinding()]
    param (

    )
    
    Get-Variable | Where-Object {(@(
        "FormatEnumerationLimit",
        "MaximumAliasCount",
        "MaximumDriveCount",
        "MaximumErrorCount",
        "MaximumFunctionCount",
        "MaximumVariableCount",
        "PGHome",
        "PGSE",
        "PGUICulture",
        "PGVersionTable",
        "PROFILE",
        "PSSessionOption",
        "psISE",
        "psUnsupportedConsoleApplications") -NotContains $_.Name) -and `
        (([PSObject].Assembly.GetType('System.Management.Automation.SpecialVariables').GetFields('NonPublic,Static
        ') | Where-Object FieldType -eq ([string]) | ForEach-Object GetValue $null)) -NotContains $_.Name}
}

## TODO : Get this done
Function Trace-Self {
    [cmdletbinding()]
    [OutputType([void])]
    param (

    )

    "========================================================================"
    "                          Generating report..."
    "========================================================================"
    Write-Host ("__ERRORS: $($Global:Error.Count)") -ForegroundColor RED
    $Global:Error
    Write-Host ("__WARNING: $($Global:Warning.Count)") -ForegroundColor YELLOW
    $Global:Warning
    Write-Host ("__DEBUG: $($Global:Debug.Count)") -ForegroundColor BLUE
    $Global:Debug
    Write-Host ("__VERBOSE: $($Global:Verbose.Count)") -ForegroundColor CYAN

    "========================================================================"
    Write-Host ("__VARIABLES: ") 
    Get-PSVariables


    "========================================================================"
    $SessionHistory = Get-SessionHistory
    Write-Host ("__SESSION_HISTORY:") $SessionHistory.Count
    $SessionHistory
    
    "========================================================================"
    "                           END OF REPORT"
    "========================================================================"
}

Function Show-Procedures {
    [cmdletbinding()]
    [OutputType([string])]
    param (

    )

    $Objects = Get-ChildItem -Path $ProtectedObjects.PSProcedureDirectory -File -Recurse
    return $Objects.Name
}

function Run-Procedure {
    [CmdletBinding()]
    Param()
    DynamicParam {
        $attributes = new-object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $false

        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)

        $arrSet = Get-ChildItem -Path $ProtectedObjects.PSProcedureDirectory -File | Select-Object -ExpandProperty Name
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Name", [string], $attributeCollection)
            
        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("Name", $dynParam1)
        
        return $paramDictionary
    } End {
        $Path = (Join-Path $ProtectedObjects.PSProcedureDirectory $PSBoundParameters['Name'])
        $ScriptBlock = Get-Content -Path $Path
        New-PSWindow -Include $ScriptBlock
    }
}


function Get-Modules {
    [cmdletbinding()]
    [OutputType([psobject])]
    param (

    )

    if ([string]::isNullOrWhitespace($Global:CurrentPrefixTag)) {
        Get-Module
    } else {
        $ReturnObject = @()
        $Objects = Get-ChildItem -Path (Join-Path $ProtectedObjects.PSModuleDirectory $Global:CurrentPrefixTag) -Directory
        foreach($Object in $Objects) {
            $TempName = $Object.Name

            $ModuleObject = Get-Module $TempName | Select-Object ExportedCommands
            
            $ReturnObject += New-Object -TypeName PSObject -Property @{
                Name = $TempName
                ExportedCommands = $ModuleObject.ExportedCommands.Values.Name 
                CommandType = $ModuleObject.ExportedCommands.Values.CommandType 
            }
        }
        return $ReturnObject
    }
}

<#
.SYNOPSIS

.DESCRIPTION
Long description

.PARAMETER Condition
Parameter description

.PARAMETER IfTrue
Parameter description

.PARAMETER IfFalse
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
Function ?? {
    [Cmdletbinding()]
    param (
        [parameter()]
        [Bool]$Condition,
        [parameter()]
        $IfTrue,
        [parameter()]
        $IfFalse
    )

    if ($Condition) {
        $IfTrue
    } else {
        $IfFalse
    }
}

Function Get-ModuleDirectory {
    [cmdletbinding()]
    param ()

    Set-Location -Path $ProtectedObjects.PSModuleDirectory
}