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

    $BaseAPIUri = ("$($Global:ServerProtocol)://$($Global:ServerIP)/$($Global:BaseAPI)/$($APIType)$($Extras)")

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
    
    # Let us first try with predefined credentials
    if ([string]::IsNullOrWhiteSpace($ConfigFile.Config.Vsphere.Username) -or [string]::IsNullOrWhiteSpace($ConfigFile.Config.Vsphere.Password)) {
        $CredentialObject = Get-Credential
    } else {
        $Username = $Global:Username
        $Password = ConvertTo-SecureString -AsPlainText $Global:Password -Force
        $CredentialObject = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $Username,$Password
    }
        
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

Function Get-Datastores {
    [cmdletbinding()] param()
    $APIURI = Get-APIURL -APIType vcenter -Extras "/datastore"
    $Response = Query-API -Uri $APIURI -Method Get

    # First Convert From Json from the Response Content 
    $Response = $Response.Content | ConvertFrom-Json

    # Return Object
    $ReturnObject = @()

    # Now all the values of the datastores are stored in the response object
    foreach($Object in $Response.value) {
        $DatastoreID       = $Object.datastore
        $DatastoreName     = $Object.name
        $DatastoreType     = $Object.type
        $DatastoreFree     = [math]::Ceiling($Object.free_space/1GB)
        $DatastoreCapacity = [math]::Ceiling($Object.capacity/1GB)
    
        $Temp = New-Object PSObject -Property @{
            DatastoreID       = $DatastoreID
            DatastoreName     = $DatastoreName
            DatastoreType     = $DatastoreType
            DatastoreFree     = $DatastoreFree
            DatastoreCapacity = $DatastoreCapacity
        }

        $ReturnObject += $Temp
    }

    return $ReturnObject
}

Function Run-Session {
    [cmdletbinding()] 
    param (

    )
    $Global:ServerProtocol     = $ConfigFile.Config.Vsphere.ServerProtocol
    $Global:ServerIP           = $ConfigFile.Config.Vsphere.ServerIPAddress
    $Global:BaseAPI            = $ConfigFile.Config.Vsphere.BaseAPIUri
    $Global:Username    = $ConfigFile.Config.Vsphere.Username
    $Global:Password    = $ConfigFile.Config.Vsphere.Password
    $Headers            = @{}

    # Check if session id is set
    if (Check-SessionId) {
        Get-Authentication
    }

}

