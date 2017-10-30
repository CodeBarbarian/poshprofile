# Verbose Preference
$VerbosePreference = 'continue'


    
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
Function Get-DefaultServerDirectory {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([string])]
    param ()
        
    $RealPath = (Join-Path $ServerDrive $ServerPath)  
    
    if ($PSCmdlet.ShouldProcess("$($RealPath)")) {
        return $RealPath   
    }
}
    
    
Function Get-Servers {
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
            size = 0
        }
    } 

    ## TODO 
    foreach ($Server in $Servers) {
        $ReturnObject += New-Object PSObject -Property @{
            name = $Server.name
            size = $Server.length
        }
    }

}
    
Function Install-Server {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([void])]
    param (
        [parameter(Mandatory=$true)]
        $ServerType,
        $ServerVersion = "latest" # 'latest' keyword will download the server which are defined as default
    )
    
    if ($PSCmdlet.ShouldProcess("Downloading server files...")) {
        #
    }
}
    