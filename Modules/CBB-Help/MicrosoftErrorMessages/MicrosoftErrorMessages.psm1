[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

$Endpoint = "https://msdn.microsoft.com/en-us/library/windows/desktop/ms681382(v=vs.85).aspx"
$HTML = New-Object -ComObject "HTMLFile"

$Call = Invoke-WebRequest -Uri $Endpoint

$Content = $Call.Content

$HTML.IHTMLDocument2_write($Content)

$Test = $HTML.all.tags("dt") | % InnerText 

$RegEx_CodeName   = '(ERROR)_[A-Z_]{1,50}'
$RegEx_CodeNumber = '([0-9]{1,9}) ([()0-9A-Fa-f]{0,20})' 
$RegEx_Comment    = '([A-Za-z0-9-_., ]{1,100})'


foreach($Item in $Test) {
    if ($Item -Match $RegEx_CodeName) {
        Write-Host($Item) -ForegroundColor RED
    }

    if ($Item -Match $RegEx_CodeNumber) {
        Write-Host($Item) -ForegroundColor Green
    }
}


# Not yet finished