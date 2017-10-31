# Which drive on your computer is the server located
$ServerDrive = "C:"
# Which Path is the server directory located
$ServerPath  = "\temp\servers\minecraft"
    

Function Show-MCHeader {
    [cmdletbinding()] param () 
    "
    ███╗   ███╗██╗███╗   ██╗███████╗ ██████╗██████╗  █████╗ ███████╗████████╗
    ████╗ ████║██║████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
    ██╔████╔██║██║██╔██╗ ██║█████╗  ██║     ██████╔╝███████║█████╗     ██║   
    ██║╚██╔╝██║██║██║╚██╗██║██╔══╝  ██║     ██╔══██╗██╔══██║██╔══╝     ██║   
    ██║ ╚═╝ ██║██║██║ ╚████║███████╗╚██████╗██║  ██║██║  ██║██║        ██║   
    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
                                                                                
    "
}
    

# This will be removed
Function Write-Event {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([void])]
    param (
        [string]$Message,
        [string]$Type
    )
    
    switch ($Type) {
        'error' {}
        'verbose' {
            # Write Verbose message
            Write-Verbose ("$($Message)")
        }
    }
}
    
<#
.SYNOPSIS
    Get the default server directory
.DESCRIPTION
    Get the default server directory, which is based on the VARIABLE:$ServerDrive and VARIABLE:$ServerPath
.LINK
    https://github.com/CodeBarbarian/poshprofile/tree/master/Modules/CBB-Gaming/Minecraft/MinecraftServerUtilities
.NOTES  
#>
Function Get-MCDefaultServerDirectory {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([string])]
    param ()
        
    $RealPath = (Join-Path $ServerDrive $ServerPath)  
    
    if ($PSCmdlet.ShouldProcess("$($RealPath)")) {
        return $RealPath   
    }
}

<#
.SYNOPSIS  
    Get the name of all the minecraft servers intalled on the local machine, in the given directory
.DESCRIPTION
    Retrieves all the server names of all the installed minecraft servers in a given directory,
    this is usually defined in the $ServerDrive and $ServerPath
.LINK
.NOTES
.EXAMPLE
    Get-Servers -Path C:\temp\servers\minecraft
.PARAMETER Path
    The path parameter is the path to the defined server directory
#>
Function Get-MCServers {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='medium')]
    [OutputType([psobject])]
    param (
        [parameter(mandatory=$true)]
        [string]$Path
    )
    
    # Return Object
    $ReturnObject = @()

    # Test Path vs Create path
    if ((Test-Path -Path $Path) -ne $true) {
        Write-Event -Message ("No server directory found, creating it..") -Type 'Verbose'
        $DefaultServerPath = Get-DefaultServerDirectory
        New-Item -Path $DefaultServerPath -ItemType Directory | Out-Null
        Write-Event -Message ("Directory Created => $($Path)")
    }
    
    $Servers = Get-ChildItem -Path $Path 

    # Exit early
    if (($Servers | Measure-Object).Count -eq 0) {
        return $ReturnObject = @{
            name = "none"
        }
    } 

    foreach ($Server in $Servers) {
        $ReturnObject += New-Object PSObject -Property @{
            name = $Server.name
        }
    }
}

Function Get-MCDefaultServerConfiguration {
    [cmdletbinding()] 
    [OutputType([string])]
    param()
    return ("$(Join-Path $ServerDrive $ServerPath)\config\server.properties")
}

Function Get-MCServerConfiguration {
    [cmdletbinding()]
    param (
        [parameter(mandatory=$true)]
        [string] $Path
    )
}

Function Install-MCServer {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([void])]
    param (
        [parameter(Mandatory=$true)]
        $ServerType,
        $ServerVersion = "latest" # 'latest' keyword will download the server which are defined as default
    )
    
    if ($PSCmdlet.ShouldProcess("Downloading server files...")) { }
}

Function Update-MCServer {}
Function Start-MCServer {}
Function Pause-MCServer {}
Function Restart-MCServer {}
Function Stop-MCServer {}
Function Test-MCServer {}
Function Get-MCServerStatus {}
Function Get-MCServerUsers {}
Function Get-MCLogs {}
Function Prepare-Environment {}
Function Rebuild-Environment {}
Function Teardown-Environment {}