<#
.SYNOPSIS
    A function to clean up and remove the current powershell sessions. Cleans the entire Variable scope that is used(Private & Global).

.DESCRIPTION
    See Synopsis

.NOTES
    Created by Morten Haugstad, - CodeBarbarian 
    Updated: 28.07.2017
    License: CC

.EXAMPLE
    Use-Cleanup
#>
function Use-CleanUp {
    Write-Host "Cleaning up your mess...  " -ForegroundColor Red # Do I need a message about this?
    Get-Variable | Where-Object {$_.Name -notmatch '(CustomDirectories|ProtectedObjects)'} | 
    
    ForEach-Object {
        try { 
            Remove-Variable -Name "$($_.Name)" -Force -Scope "global" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        } catch { 

        } finally {
            
        }
    }
    Write-Host "Finished!" -ForegroundColor Green
}

<#
.SYNOPSIS
    A function to display custom directories and print the current working directory with a custom title defined in [HashMap] Custom Directories

.DESCRIPTION
    See Synopsis

.NOTES
    Created by Morten Haugstad, - CodeBarbarian 
    Updated: 28.07.2017
    License: CC

.EXAMPLE
    No Example
#>
function Get-CustomDirectory {
    [CmdletBinding()]
    [Alias("CDir")]
    [OutputType([String])]
    Param
    (
        [Parameter(ValueFromPipeline=$true,Position=0)]
        $Path = $PWD.Path
    )
    
    Begin
    {

    }
    Process
    {
        Foreach($Item in $Path)
        {
            $Match = ($CustomDirectories.GetEnumerator().name | Where-Object{$Item -eq "$_" -or $Item -like "$_*"} |`
            Select-Object @{n='Directory';e={$_}},@{n='Length';e={$_.length}} |Sort-Object Length -Descending |Select-Object -First 1).directory
            If($Match)
            {
                [String]($Item -replace [regex]::Escape($Match),$CustomDirectories[$Match])            
            }
            ElseIf($pwd.Path -ne $Item)
            {
                $Item
            }
            Else
            {
                $pwd.Path
            }
        }
    }
    End
    {
    }
}

<#
.SYNOPSIS
    Custom powershell prompt. 

.DESCRIPTION
    See Synopsis

.NOTES
    Created by Morten Haugstad, - CodeBarbarian 
    Updated: 28.07.2017
    License: CC

.EXAMPLE
    Prompt
#>
Function Prompt {   
    Write-Host "[$($ProtectedObjects.Nickname)] " -NoNewline;
    Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; 
    Write-Host "PS " -NoNewline
    Write-Host $(Get-CustomDirectory) -ForegroundColor Green  -NoNewline        
    Write-Host " >_" -NoNewline -ForegroundColor Yellow
    return " "
}


<#
.SYNOPSIS
    Get Bootstrapper loads inn my current functions on startup

.DESCRIPTION
    See Synopsis

.NOTES
    Created by Morten Haugstad, - CodeBarbarian 
    Updated: 28.07.2017
    License: CC

.EXAMPLE
    Get-Bootstrapper
#>
Function Get-Bootstrapper {
    # Clean Up
    Use-CleanUp
    # Clear Host
    Clear-Host
    # Display main header
    Get-MainHeader
}

# Export all functions in this file (two non POSH verb used)
Export-ModuleMember -Function Get-*
Export-ModuleMember -Function Set-*
Export-ModuleMember -Function Use-*
#Export-ModuleMember -Function Load-*
# This will initialize the new prompt
Export-ModuleMember -Function Prompt
