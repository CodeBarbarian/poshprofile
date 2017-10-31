Function Get-DefaultVMPath {
    [cmdletbinding()]
    [OutputType([string])]
    param (
        
    )
    
    return ("$(Join-Path $env:USERPROFILE Documents)\Hyper-V\VHD")
}

Function Get-VMPath {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType([string])]
    param (
        [parameter()]
        $Path
    )

    

}

Function New-VirtualSwitch {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([void])]
    param (
        [parameter(mandatory=$true)]
        $SwitchName,
        [parameter(mandatory=$true)]
        [ValidateSet("Private", "Internal", "External")]
        $Type
    )

    $TestSwitch = Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue 

    if ($TestSwitch.Count -eq 0) {
        if ($PSCmdlet.ShouldProcess("Creating new virtual switch $($SwitchName)")) {
            Write-Verbose "Trying to create new virtual switch $($SwitchName)"
            if (New-VMSwitch -Name $SwitchName -SwitchType $Type) {
                Write-Verbose "Virtual Switch created"
            } else {
                Write-Verbose "Virtual Switch not created"
            }
        }    
    } else {
        Write-Verbose "Switch $($SwitchName) already created"
    }


}

Function New-VirtualMachine {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([void])]
    param (
        [parameter(mandatory=$true)]
        [ValidatePattern("([ts][-]){0,1}[a-zA-Z]{2,}[\d]{2}[spiec]")]
        [string]$Name,
        #Optional
        [string]$VMPath,
        [string]$VMDisk,
        [int]$StartMemory,
        [string]$NetworkSwitch
    )

    if ([string]::IsNullOrEmpty($VMPath)) {
        $VMPath = Get-VMPath
    }

    if ($PSCmdlet.ShouldProcess("Creating VM $($Name)")) {
        Write-Verbose "Trying to create VM => $($Name)"
        New-VM 
    }
}