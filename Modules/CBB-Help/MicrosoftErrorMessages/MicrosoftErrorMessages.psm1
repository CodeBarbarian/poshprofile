[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
<#
$Endpoint = "https://msdn.microsoft.com/en-us/library/windows/desktop/ms681383(v=vs.85).aspx"
$HTML = New-Object -ComObject "HTMLFile"

$Call = Invoke-WebRequest -Uri $Endpoint

$Content = $Call.Content

$HTML.IHTMLDocument2_write($Content)

$Test = $HTML.all.tags("dt") | % InnerText 

$RegEx_CodeName   = '(ERROR[A-Z_*]{5,100})'
$RegEx_CodeNumber = '([0-9]{1,5}.\([0]x[0-9A-F]{1,10}\))' 
$RegEx_Comment    = '([a-zA-Z.; ]{1,100})'

# Full Pattern
$Pattern = "(?<ERROR_MESSAGE>ERROR[A-Z_*]{5,100})\n(?<ERROR_CODE>[0-9]{1,5}.\([0]x[0-9A-F]{1,10}\))\n(?<ERROR_COMMENT>[a-zA-Z.; ]{1,100})"

foreach($Item in $Test) {
    if ($Item -Match $RegEx_CodeName) {
        Write-Host ($Item) -ForegroundColor Red
        continue
        
    }

    if ($Item -Match $RegEx_CodeNumber) {
        Write-Host($Item) -ForegroundColor Yellow
        continue
    }

    if ($Item -Match $RegEx_Comment) {
        Write-Host($Item) -ForegroundColor Green
        continue
    }
}

#>

Function Get-DefaultDataFile {
    <#
    .SYNOPSIS
        Get the default data file located in the data directory of the CBB powershell profile
    .DESCRIPTION
        Get the default data file located in the data directory of the CBB powershell profile. 
        Done by using the ProtectedObjects hashtable from the configuration file, and appending "MicorosoftErrorMessages.CSV" to it
    .EXAMPLE
        Get-DefaultDataFile
    #>
    [cmdletbinding()]
    [OutputType([string])]
    param ()

    # Datafile set to the MicrosoftErrorMessages in data directory
    $DataFile = "$($ProtectedObjects.PSDataDirectory)\MicorosoftErrorMessages.csv"
    
    # Return the datafile
    return $DataFile
}

Function Get-DataFile {
    [cmdletbinding(
        SupportsShouldProcess = $True
    )]
    param (
        [parameter()]
        [string] $DataFile
    )

    if ([string]::IsNullOrEmpty($DataFile)) {
        # Let us try and use the default data file
        $DataFile = Get-DefaultDataFile
    }

    if (Test-Path -Path $DataFile) {
        Write-Verbose ("Datafile exists!")
    } else {
        Write-Verbose ("Datafile does not exist. Creating $($DataFile)")
        if ($PSCmdlet.ShouldProcess("Creating file $($DataFile)")) {
            New-Item -Path $DataFile -Force -Confirm:$False
        }
    }

    return $DataFile
}

Function Update-MicrosoftErrorMessages {
    [cmdletbinding(
        SupportsShouldProcess = $True
    )]
    param ()
    # RegEx Pattern for finding ErrorMessage, ErrorCode and Error Description
    $RegEx_ErrorMessage     = '(ERROR[A-Z_*]{5,100})'               # Error Message
    $RegEx_ErrorCode        = '([0-9]{1,5}.\([0]x[0-9A-F]{1,10}\))' # Error Code
    $RegEx_ErrorDescription = '([a-zA-Z.; ]{1,100})'                # Error Description

    $DataFile = Get-DataFile -DataFile "C:\users\$($ENV:USERNAME)\desktop\Datafile.csv"
        # Let us try and download error messages directly from microsoft.
        try {
            # System Error Codes (0-499) - https://msdn.microsoft.com/en-us/library/windows/desktop/ms681382(v=vs.85).aspx
            if ($PSCmdlet.ShouldProcess("Trying to download Microsoft System Error Codes (0-499)")) {
                try {
                    # URI for downloading error codes
                    $URI = "https://msdn.microsoft.com/en-us/library/windows/desktop/ms681382(v=vs.85).aspx"
                    
                    # Verbose statement for declaring download start with date
                    Write-Verbose ("Started downloading @ - $(Get-Date)")
                    
                    # Response, store the content of the web request
                    $Response = Invoke-WebRequest -Uri $URI
                    
                    # Verbose statement for declaring download stop with date
                    Write-Verbose ("Ended @ - $(Get-Date)")
                } catch {} Finally {
                    # Storing the content of the response in its own variable
                    $Content = $Response.Content
    
                    # Creating the HTMLFile Com object to be able to parse the file better
                    $HTML = New-Object -ComObject "HTMLFile"
    
                    # Writing the content to the htmlfile document type 2
                    $HTML.IHTMLDocument2_write($Content)
    
                    $Parser = $HTML.all.tags("dt") | ForEach-Object InnerText
                    
                    $ReturnObjectErrorMessages = @()
                    $ReturnObjectErrorCodes   = @()
                    $ReturnObjectErrorDescriptions = @()

                    $ReturnObject = @()

                    foreach ($Item in $Parser) {
                        if ($Item -Match $RegEx_ErrorMessage) {
                            # Store the Error Message in a way
                            $ReturnObjectErrorMessages += New-Object -TypeName PSObject -Property @{
                                ErrorMessage = $Item
                            }
                            # Continue - To skip rest of the current iteration of the loop
                            Continue
                        }
    
                        if ($Item -Match $RegEx_ErrorCode) {
                            # Store the Error Code in a way
                            $ReturnObjectErrorCodes += New-Object -TypeName PSObject -Property @{
                                ErrorCode = $Item
                            }
                            # Continue - To skip the rest of the current iteration of the loop
                            Continue
                        }
    
                        if ($Item -Match $RegEx_ErrorDescription) {
                            # Store the error description in some mystical/magical way
                            $ReturnObjectErrorDescriptions += New-Object -TypeName PSObject -Property @{
                                ErrorDescription = $Item
                            }
                            # Continue - To skip the rest of the current iteration of the lopp
                            Continue
                        }
                    }
                }
            }

           
            
            # System Error Codes (500-999)      https://msdn.microsoft.com/en-us/library/windows/desktop/ms681388(v=vs.85).aspx
            if ($PSCmdlet.ShouldProcess("Trying to download Microsoft System Error Codes (0-499)")) {
                try {
                    # URI for downloading error codes
                    $URI = "https://msdn.microsoft.com/en-us/library/windows/desktop/ms681388(v=vs.85).aspx"
                    
                    # Verbose statement for declaring download start with date
                    Write-Verbose ("Started downloading @ - $(Get-Date)")
                    
                    # Response, store the content of the web request
                    $Response = Invoke-WebRequest -Uri $URI
                    
                    # Verbose statement for declaring download stop with date
                    Write-Verbose ("Ended @ - $(Get-Date)")
                } catch {} Finally {
                    # Storing the content of the response in its own variable
                    $Content = $Response.Content
    
                    # Creating the HTMLFile Com object to be able to parse the file better
                    $HTML = New-Object -ComObject "HTMLFile"
    
                    # Writing the content to the htmlfile document type 2
                    $HTML.IHTMLDocument2_write($Content)
    
                    $Parser = $HTML.all.tags("dt") | ForEach-Object InnerText
                    
                    $ReturnObjectErrorMessages = @()
                    $ReturnObjectErrorCodes   = @()
                    $ReturnObjectErrorDescriptions = @()

                    $ReturnObject = @()

                    foreach ($Item in $Parser) {
                        if ($Item -Match $RegEx_ErrorMessage) {
                            # Store the Error Message in a way
                            $ReturnObjectErrorMessages += New-Object -TypeName PSObject -Property @{
                                ErrorMessage = $Item
                            }
                            # Continue - To skip rest of the current iteration of the loop
                            Continue
                        }
    
                        if ($Item -Match $RegEx_ErrorCode) {
                            # Store the Error Code in a way
                            $ReturnObjectErrorCodes += New-Object -TypeName PSObject -Property @{
                                ErrorCode = $Item
                            }
                            # Continue - To skip the rest of the current iteration of the loop
                            Continue
                        }
    
                        if ($Item -Match $RegEx_ErrorDescription) {
                            # Store the error description in some mystical/magical way
                            $ReturnObjectErrorDescriptions += New-Object -TypeName PSObject -Property @{
                                ErrorDescription = $Item
                            }
                            # Continue - To skip the rest of the current iteration of the lopp
                            Continue
                        }
                    }
                }
            }
            # System Error Codes (1000-1299)    https://msdn.microsoft.com/en-us/library/windows/desktop/ms681383(v=vs.85).aspx
            # System Error Codes (1300-1699)    https://msdn.microsoft.com/en-us/library/windows/desktop/ms681385(v=vs.85).aspx
            # System Error Codes (1700-3999)    https://msdn.microsoft.com/en-us/library/windows/desktop/ms681386(v=vs.85).aspx
            # System Error Codes (4000-5999)    https://msdn.microsoft.com/en-us/library/windows/desktop/ms681387(v=vs.85).aspx
            # System Error Codes (6000-8199)    https://msdn.microsoft.com/en-us/library/windows/desktop/ms681389(v=vs.85).aspx
            # System Error Codes (8200-8999)    https://msdn.microsoft.com/en-us/library/windows/desktop/ms681390(v=vs.85).aspx
            # System Error Codes (9000-11999)   https://msdn.microsoft.com/en-us/library/windows/desktop/ms681391(v=vs.85).aspx
            # System Error Codes (12000-15999)  https://msdn.microsoft.com/en-us/library/windows/desktop/ms681384(v=vs.85).aspx
        } catch {
            # Catch Error Exception
        } finally {
                        $Count = 0

            foreach($Item in $ReturnObjectErrorMessages) {
                $ReturnObject += New-Object -TypeName PSObject -Property @{
                    ErrorMessage = $Item
                    ErrorCode    = $ReturnObjectErrorCodes[$Count]
                    ErrorDescription = $ReturnObjectErrorDescriptions[$Count]
                }

                $Count += 1
            }

            # Insert it into the CSV file
            $ReturnObject | Select-Object ErrorMessage, ErrorCode, ErrorDescription | Sort-Object ErrorCode | Export-Csv -Path $DataFile
        }
}

# Not yet finished