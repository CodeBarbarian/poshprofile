$PortAssociations = @{
    80  = "HTTP"
    443 = "HTTPS"
    21  = "FTP"
    22  = "SSH"
    23  = "Telnet"
    35  = "SMTP"
    53  = "DNS"
    135 = "POP3"
    137 = "NetBios"
    138 = "NetBios"
    139 = "Netbios"
}

Function Get-HostnameByAddress {
    [cmdletbinding()]
    param (
        $Address
    )

    $Hostname =  ([System.Net.Dns]::GetHostByAddress($Address)).HostName

    if ([string]::IsNullOrEmpty($Hostname)) {
        $Hostname = "Unknown"
    }

    return $Hostname
}
Function Start-Scan {
    [cmdletbinding()]
    param (
        $IP,
        $Port
    )

    $Socket = New-Object System.Net.Sockets.TcpClient
    
    $Socket.Connect($IP, $Port)
    if ($Socket.connected) {        
        # Close Socket
        $Socket.close()
        return $true
    } 
    return $false
}


Function Get-PortScan {
    [cmdletbinding()] 
    param (
        $IP,
        $Port = 0
    )

    # The return object which will store all of our information
    $ReturnObject = @()

    # Run through associated ports
    if ($Port -eq 0) {
        foreach($Port in $PortAssociations.Keys) {
            try {
                Write-Verbose("Trying to scan $($IP) - Port $($Port)")
                $Response = Start-Scan -IP $IP -Port $Port

                if ($Response) {
                    Write-Verbose("Port $($Port) is open")
                    $State = "Open"
                } else {
                    Write-Verbose("Port $($Port) is closed")
                    $State = "Closed"
                }
            } catch {
                Write-Verbose("Port $($Port) is closed")
                $State = "Closed"
            } finally {
               

                if ($PortAssociations.ContainsKey($Port)) {
                    $Description = $PortAssociations.Item($Port)
                } else {
                    $Description = "Unknown"
                }

                Write-Verbose("Processing Object - Found $($Description)") 
                $ReturnObject += New-Object PSObject -Property @{
                    HOSTNAME    = Get-HostnameByAddress -Address $IP -ErrorAction SilentlyContinue
                    IP          = $IP
                    PORT        = $Port
                    STATE       = $State
                    DESCRIPTION = $Description
                } 
            }
        }
    } else {
        try {
            Write-Verbose("Trying to scan $($IP) - Port $($Port)")
            $Response = Start-Scan -IP $IP -Port $Port
            if ($Response) {
                Write-Verbose("Port $($Port) is open")
                $State = "Open"
            } else {
                Write-Verbose("Port $($Port) is closed")
                $State = "Closed"
            }
        } catch {
            Write-Verbose("Port $($Port) is closed")
            $State = "Closed"
        } finally {
            if ($PortAssociations.ContainsKey($Port)) {
                $Description = $PortAssociations.Item($Port)
            } else {
                $Description = "Unknown"
            }

            Write-Verbose("Processing Object - Found $($Description) in associations") 
            $ReturnObject += New-Object PSObject -Property @{
                HOSTNAME    = Get-HostnameByAddress -Address $IP -ErrorAction SilentlyContinue
                IP          = $IP
                PORT        = $Port
                STATE       = $State
                DESCRIPTION = $Description
            } 
        }
    }

    return $ReturnObject | Sort-Object Port | Format-Table HOSTNAME, IP, PORT, STATE, DESCRIPTION -AutoSize
}