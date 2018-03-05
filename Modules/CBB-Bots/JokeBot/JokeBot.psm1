<# Sources
    https://ron-swanson-quotes.herokuapp.com/v2/quotes
    https://icanhazdadjoke.com/api
    https://quotes.rest
#>

Function Get-Quote {
    [cmdletbinding()]
    param (

    )

    $URI 

}

Function Get-QuoteOfTheDay {
    [cmdletbinding(
        SupportsShouldProcess = $true
    )]
    param (

    )

    $URI = "https://quotes.rest/qod"

}