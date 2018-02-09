<#
                                                                                                                    
                                                                                                                    
    SSSSSSSSSSSSSSS                                                                           XXXXXXX       XXXXXXX
    SS:::::::::::::::S                                                                          X:::::X       X:::::X
    S:::::SSSSSS::::::S                                                                          X:::::X       X:::::X
    S:::::S     SSSSSSS                                                                          X::::::X     X::::::X
    S:::::S           ppppp   ppppppppp     aaaaaaaaaaaaa      cccccccccccccccc    eeeeeeeeeeee  XXX:::::X   X:::::XXX
    S:::::S           p::::ppp:::::::::p    a::::::::::::a   cc:::::::::::::::c  ee::::::::::::ee   X:::::X X:::::X   
    S::::SSSS        p:::::::::::::::::p   aaaaaaaaa:::::a c:::::::::::::::::c e::::::eeeee:::::ee  X:::::X:::::X    
    SS::::::SSSSS   pp::::::ppppp::::::p           a::::ac:::::::cccccc:::::ce::::::e     e:::::e   X:::::::::X     
        SSS::::::::SS  p:::::p     p:::::p    aaaaaaa:::::ac::::::c     ccccccce:::::::eeeee::::::e   X:::::::::X     
        SSSSSS::::S p:::::p     p:::::p  aa::::::::::::ac:::::c             e:::::::::::::::::e   X:::::X:::::X    
                S:::::Sp:::::p     p:::::p a::::aaaa::::::ac:::::c             e::::::eeeeeeeeeee   X:::::X X:::::X   
                S:::::Sp:::::p    p::::::pa::::a    a:::::ac::::::c     ccccccce:::::::e         XXX:::::X   X:::::XXX
    SSSSSSS     S:::::Sp:::::ppppp:::::::pa::::a    a:::::ac:::::::cccccc:::::ce::::::::e        X::::::X     X::::::X
    S::::::SSSSSS:::::Sp::::::::::::::::p a:::::aaaa::::::a c:::::::::::::::::c e::::::::eeeeeeeeX:::::X       X:::::X
    S:::::::::::::::SS p::::::::::::::pp   a::::::::::aa:::a cc:::::::::::::::c  ee:::::::::::::eX:::::X       X:::::X
    SSSSSSSSSSSSSSS   p::::::pppppppp      aaaaaaaaaa  aaaa   cccccccccccccccc    eeeeeeeeeeeeeeXXXXXXX       XXXXXXX
                    p:::::p                                                                                        
                    p:::::p                                                                                        
                    p:::::::p                                                                                       
                    p:::::::p                                                                                       
                    p:::::::p                                                                                       
                    ppppppppp                                                                                       
#>
Function Get-SpaceX {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([string])]
    param (
        [parameter(mandatory=$true)]
        [ValidateSet('info', 'rockets', 'capsules', 'launchpads', 'pastlaunches', 'latestlaunch', 'upcominglaunches', 'capsulesdetailed', 'coresdetailed')]
        $Endpoint,
        [parameter()]
        $Optional = $null,
        [parameter()]
        $APIEndpoint = "https://api.spacexdata.com/v2/",
        [parameter()]
        [ValidateSet('json', 'html')]
        $OutputType = "json"
    )

    # Switch to take care of endpoint prefix
    Switch($Endpoint) {
        'info'              {$Prefix    = "info"}                  # Company info
        'rockets'           {$Prefix    = "rockets"}               # Rockets info
        'capsules'          {$Prefix    = "capsules"}              # Capsule info
        'launchpads'        {$Prefix    = "launchpads"}            # Launchpad info
        'pastlaunches'      {$Prefix    = "launches"}              # Past Launches info
        'latestlaunch'      {$Prefix    = "launches/latest"}       # Latest Launch info
        'upcominglaunches'  {$Prefix    = "launches/upcoming"}     # Upcoming Launches info
        'capsulesdetailed'  {$Prefix    = "parts/caps"}            # Capsule Detailed info
        'coresdetailed'     {$Prefix    = "parts/cores"}           # Cores Detailed info
    }   

    # Most of the above in the switch statement support optionals such as name or tag or date.
    if ([string]::IsNullOrEmpty($Optional) -eq $false) { $Prefix += "/$($Optional)" }

    # Build URL
    $FullUri = "$($APIEndpoint)$($Prefix)"

    # Verbose statement regarding the current action
    Write-Verbose ("Trying to fetch data from $($APIEndpoint)")
    if ($PSCmdlet.ShouldProcess("Fetching data from $($FullUri)")) {
        try {
            # Try and fetch the API data
            $Response = Invoke-WebRequest -Uri $FullUri -UserAgent curl -ErrorVariable $ResponsetError
        } catch {
            # Catch any errors
            $ResponseError
        } finally {
            # Verbose statement regarding the state of the process
            Write-Verbose ("Fetched data successfully from $($ApiEndpoint)... Returning response for further processing")
            
            # Switch to handle output type Json or html
            switch ($OutputType) {
                'json'  {$ReturnData = $Response}
                'html'  {$ReturnData = $Response | ConvertTo-Html}
            }
        }

        # Return the data
        return $ReturnData
    }
}
