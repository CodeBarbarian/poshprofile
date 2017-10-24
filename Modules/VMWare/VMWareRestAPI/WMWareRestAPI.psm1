[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

Function Get-DefaultConfigPath {
    [cmdletbinding()]
    [OutputType([string])]
    param()
    return ("$(Join-Path $ENV:USERPROFILE Documents)\WindowsPowershell\Config\VMWareAPIConfig.xml")
}

Function Get-ConfigFile {
    [cmdletbinding()]
    [OutputType([xml])]
    param ( 
        $ConfigPath
    )

    if ([string]::IsNullOrEmpty($ConfigPath)) {
        $ConfigPath = Get-DefaultConfigPath
    }

    $ConfigObject = Get-Content -Path $ConfigPath

    return [xml]$ConfigObject
}

Function Get-APIURL {
    [cmdletbinding()]
    [OutputType([string])]
    param(
        [parameter(mandatory=$true)]
        [validateset("com", "appliance", "cis", "content", "vapi", "vcenter")]
        $APIType,
        $Extras
    )

    $BaseAPIUri = ("$($ServerProtocol)://$($ServerIP)/rest/$($APIType)$($Extras)")

    return $BaseAPIUri
}

Function Get-Credentials {
    [cmdletbinding()]
    [OutputType([string])]
    param (
        [parameter(mandatory=$true)] 
        $CredentialObject
    )
    
    $Authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($CredentialObject.UserName+':'+$CredentialObject.GetNetworkCredential().Password))

    return $Authorization
}

Function Get-Authentication {
    [cmdletbinding()]
    param(
    )

    $CredentialObject = Get-Credential
    $AuthorizationObject = Get-Credentials -CredentialObject $CredentialObject
    $SessionToken        = Get-SessionToken -Authorization $AuthorizationObject

    Add-Headers -Key "vmware-api-session-id" -Value $SessionToken    
}

Function Get-SessionToken {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType([string])]
    param (
        [parameter(mandatory=$true)]
        $Authorization
    )

    
    $Headers = @{
        'Authorization' = "Basic $Authorization"
    }

    $Response = Invoke-WebRequest -Uri ("$(Get-APIURL -APIType 'com' -Extras '/vmware/cis/session')") -Method Post -Headers $Headers

    return (ConvertFrom-Json $Response.Content).Value

}

Function Get-Headers {
    [cmdletbinding()]
    param ()

    return $Headers
}

Function Add-Headers {
    [cmdletbinding()]
    param (
        [parameter(mandatory=$true)]
        $Key,
        [parameter(mandatory=$true)]
        $Value
    )

    $Headers.add($Key, $Value)
}

Function Check-SessionId {
    [cmdletbinding()]
    param ()

    if ($Headers.ContainsKey("vmware-api-session-id")) {
        return $false
    }

    return $true
}

Function Query-API {
    [cmdletbinding()]
    param (
        [parameter()]
        $Uri,
        [parameter()]
        $Method = "Get"
    )

    $Response = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $Headers

    return $Response
}

$ServerProtocol = $ConfigFile.Config.Vsphere.ServerProtocol
$ServerIP       = $ConfigFile.Config.Vsphere.ServerIPAddress
$BaseAPI        = $ConfigFile.Config.Vsphere.BaseAPIUri
$Headers        = @{}

# Check if session id is set
if (Check-SessionId) {
    Get-Authentication
}
