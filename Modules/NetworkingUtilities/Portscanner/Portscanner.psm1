<# IDEA

| Host        | Port | State | Description |
| 192.168.1.1 |  80  | Open  | Could be a webserver

#>

$PortAssociations = @{
    "HTTP"  = 80
    "HTTPS" = 443 
    "FTP"   = 21
    "SSH"   = 22
    "Telnet" = 23
    "SMTP"  = 35
    "DNS"   = 53
    "POP3"  = 135
    "NetBios" = 137
    "NetBios" = 138
    "NetBios" = 139
    
}

Function Scan-Port {
    [cmdletbinding()]
    param ()
}