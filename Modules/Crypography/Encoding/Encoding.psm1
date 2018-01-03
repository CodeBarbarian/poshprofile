Function Base64Encode {
    [cmdletbinding()]
    param (
        [parameter(mandatory=$true)]
        [string] $Path
    )

    [convert]::ToBase64String((Get-Content $Path -Encoding byte))
}

Function Base64Decode {
    [cmdletbinding()]
    param (
        [parameter(mandatory=$true)]
        [string] $InputData,
        [parameter(mandatory=$true)]
        [string] $OutputFile
    )

    $Bytes = [convert]::FromBase64String($InputData)
    [IO.File]::WriteAllBytes($OutputFile, $Bytes)
}

Function Base64Copy {
    [cmdletbinding()]
    param (
        [paramter(Mandatory=$true)]
        [string]$From,
        [paramter(Mandatory=$true)]
        [string]$To,
    )
}