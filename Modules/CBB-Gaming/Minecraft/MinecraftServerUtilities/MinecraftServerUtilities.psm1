# THIS FILE IS CURRENTLY UNDER PROTOTYPING
#
#
#
#
#
#
$Servers = @(
    @{name=""; shortname=""; version="" baseuri=""},
    @{name=""}
)


# This is representing the server.properties file
$ServerConfig = @{


}

Function Show-MCHeader {
    [cmdletbinding()] param () 
    "
    ███╗   ███╗██╗███╗   ██╗███████╗ ██████╗██████╗  █████╗ ███████╗████████╗
    ████╗ ████║██║████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
    ██╔████╔██║██║██╔██╗ ██║█████╗  ██║     ██████╔╝███████║█████╗     ██║   
    ██║╚██╔╝██║██║██║╚██╗██║██╔══╝  ██║     ██╔══██╗██╔══██║██╔══╝     ██║   
    ██║ ╚═╝ ██║██║██║ ╚████║███████╗╚██████╗██║  ██║██║  ██║██║        ██║   
    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
                                                                            
    "
}

Function Install-Server {
    [cmdletbinding(SupportsShouldProcess=$true)]
    param (
        [parameter(Mandatory=$true)]
        $ServerType,
        [parameter(Mandatory=$true)]
        $ServerVersion
    )
}

