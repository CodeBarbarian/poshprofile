<#
.SYNOPSIS
    This function will display weather forecast from http://wttr.in/
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
    # CodeBarbarian       0.0.1         22/05/2017         First initial modifcation
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

[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

Function Get-Weather {
    [Cmdletbinding()]
    Param (
            [Parameter(
                Mandatory = $False,
                ValueFromPipeline = $True,
                Position = 0
            )]
            [ValidateNotNullOrEmpty()]
            $City = $ProtectedObjects.DefaultCity,
            [switch] $Full
    )

    Process {
        Foreach($Item in $City) {
            try {
                # I would only be needing this profile on a system running windows 10.
                $Weather = $(Invoke-WebRequest "http://wttr.in/$City" -UserAgent curl).content -split "`n"
                
                # Did we get a response from the web-request? 
                If($Weather) {
                    # List todays Rows. The first 16 rows in the respons
                    $Weather[0..16]
                    # If the switch full is set, list the full weather report
                    if ($Full) {$Weather[17..36]}
                }
            }
            catch {
                $_.exception.Message
            }
        }            
    }

}

# Export module
Export-ModuleMember -Function Get-*