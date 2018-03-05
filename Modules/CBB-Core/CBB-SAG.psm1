# For shits and giggles

Function Get-CBBEvolutionOfText {
    [cmdletbinding()]
    [OutputType([string])]
    param (
        [parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            Position = 0,
            HelpMessage = 'String to use for final evolution'
        )]
        [ValidateNotNullOrEmpty()]
        [string] $EvolutionString
    )

    # To keep track if it is completed or not
    $Completed = $False

    # Characters in the search space - Need to get space character working!!!
    $SearchSpace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890 "


    # Length of the string to search for
    $SearchLength = $EvolutionString.Length

    # Evolution tracking - Starting at evolution Zero.
    $Evolution = 0

    # Current Evolution
    $CurrentEvolution = @()

    # Let us preappend data into the Current Evolution to prevent indexing errors
    for ($I = 0; $I -lt $SearchLength; $I++) {
        $CurrentEvolution += $SearchSpace[(Get-Random -Minimum 0 -Maximum ($SearchSpace.Length))]
    }
    
    # Evolution Loop
    While ($Completed -ne $True) {
        # Set the Completed boolean to true
        $Completed = $True

        # Write the current generation
        Write-Host("Generation $($Evolution)# $(-join $CurrentEvolution)")

        # Business Logic
        for ($I = 0; $I -lt $SearchLength; $I++) {
            # Need to use C-type not equal, since powershell is fundamentally case insensitive
            if ($CurrentEvolution[$I] -cne $EvolutionString[$I]) {
                # Still not complete
                $Completed = $False

                # Give the current index a new choice for our search space
                $CurrentEvolution[$I] = $SearchSpace[(Get-Random -Minimum 0 -Maximum ($SearchSpace.Length -1))]
            }
        }

        # Increment the evolution
        $Evolution += 1
       }

   Write-Host ("It took $($Evolution) generations to generate the evolution string ( $($EvolutionString) )")
}