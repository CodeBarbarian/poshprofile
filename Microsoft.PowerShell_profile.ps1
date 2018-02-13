<#

                 ██████╗ ██████╗ ██████╗ ███████╗██████╗  █████╗ ██████╗ ██████╗  █████╗ ██████╗ ██╗ █████╗ ███╗   ██╗
                ██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗████╗  ██║
                ██║     ██║   ██║██║  ██║█████╗  ██████╔╝███████║██████╔╝██████╔╝███████║██████╔╝██║███████║██╔██╗ ██║
                ██║     ██║   ██║██║  ██║██╔══╝  ██╔══██╗██╔══██║██╔══██╗██╔══██╗██╔══██║██╔══██╗██║██╔══██║██║╚██╗██║
                ╚██████╗╚██████╔╝██████╔╝███████╗██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║██║  ██║██║██║  ██║██║ ╚████║
                 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
                            Powershell is unique, because if all else fail - use the force.

██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ███████╗██╗  ██╗███████╗██╗     ██╗         ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝██║     ██║         ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝███████╗███████║█████╗  ██║     ██║         ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗╚════██║██╔══██║██╔══╝  ██║     ██║         ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║███████║██║  ██║███████╗███████╗███████╗    ██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝
                                                                                                                    

Authenticity Challenge Code: .:Mike Oscar Romeo Tango Echo November:.
#>

$VerbosePreference = "Continue"
# Powershell Module Directory
$PSModulesDirectory = "$(Join-Path $ENV:USERPROFILE Documents)\WindowsPowershell\Modules"

# Import the powershell profile
Import-Module ("$($PSModulesDirectory)\CBB-Profile.psd1")

# Clear The Screen
Clear-Host

# Main Header
Get-MainHeader

<####################################################################
Things to do here:
    - Create a starting method, for allowing to choose what profile
    setting you'd like to run. i.e
        - [1] - Full [Name on profile]
        - [2] - [Name on profile] Lite - Only the core functions
        - [3] - Clean Powershell - No Profile
#####################################################################>

# Let us set up some directories here
$ProfilesPath = (Join-Path $PSScriptRoot profiles)

Function Get-Profiles {
    [cmdletbinding()]
    param ()

    $Profiles = Get-ChildItem -Path $ProfilesPath

    $ReturnObject = @()

    $Count = 1
    foreach($PSProfile in $Profiles) {
        $TempPath = (Join-Path $ProfilesPath $PSProfile.Name)

        $ReturnObject += New-Object PSObject -Property @{
            id = $Count
            name = $PSProfile.name
            path = ("$($TempPath)\$($PSProfile.name).psd1")
        }

        $Count += 1
    }

    return $ReturnObject
} 

Function Select-Profile {
    [cmdletbinding()]
    param (
        [parameter(mandatory=$true)]
        $ProfileObject
    )

    # Display options
    Write-Host ("=========================")
    Write-Host ("Powershell profile loader")
    Write-Host ("=========================")
    

    foreach ($PSProfile in $ProfileObject) {
        Write-Host("[$($PSProfile.id)] - $($PSProfile.Name)")
    }

    $ProfileSelection =  Read-Host ("Profile >_ ")
    $ReturnResponse = $ProfileObject | Where-Object {$_.id -eq $ProfileSelection} | Select-Object Path
    if ([string]::IsNullOrEmpty($ReturnResponse.path)) {
        Write-Error ("Could not load profile, selection is out of bounds") -ErrorAction Stop
    }

    Return $ReturnResponse.path
}

Function Start-Profile {
    [cmdletbinding()]
    param (
        [string] $Path
    )

    Import-Module -Name $Path
}

Function Start-Classic {
    [cmdletbinding()] 
    param ()

    # Start the classic powershell without loading any profile.
}

Function Start-Lite {
    [cmdletbinding()]
    param ()

    # Start powershell but with the core functions (if available) only.
}

Function Start-Full {
    [cmdletbinding()]
    param ()

    # Start powershell with the full profile (if available).
}