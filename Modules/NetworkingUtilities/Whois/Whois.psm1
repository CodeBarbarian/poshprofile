Function Whois {
    [cmdletbinding(SupportsShouldProcess)]
    param (
        [string] $Query
    )

    if ($PSCmdlet.ShouldProcess("Trying whois lookup for $($Query)")) {
        try {
            $Domain = (Invoke-WebRequest -Uri "https://www.whois.com/whois/$($Query)" -UserAgent curl)

            if ($Domain) {
                $Result = $Domain.ParsedHtml.getElementsByTagName('pre')

                if ([string]::isNullorEmpty($Result)) {
                    return "Could not locate any domain records for $($Query)"
                } else {
                    return $Result.Item().InnerText
                }   
            }
        } catch {
            $_.exception.Message
        }
    }
}