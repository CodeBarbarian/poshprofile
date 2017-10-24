Function Get-Modules {
    [cmdletbinding()]
    param (
        
    )

    # Import Neccassery Modules and Packages
    $NugetSource      = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
    $NugetDestination = ("$($ProtectedObjects.PSModuleDirectory)\Nuget\nuget.exe")

    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($NugetSource, $($NugetDestination))
}

Export-ModuleMember -Function Get-Modules