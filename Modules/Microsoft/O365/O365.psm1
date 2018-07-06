
# Work in progress
function Update-O365IPAddresses {
    [cmdletbinding(SupportsShouldProcess=$true)]
    param (
        [string]$URI = "https://support.content.office.net/en-us/static/O365IPAddresses.xml"
    )

    if ($PSCmdlet.ShouldProcess("Downloading O365IPAddresses.xml")) {
       begin {
            Write-Verbose("Download started @ $(Get-Date)")        
       } process {
            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile($URI, "$($ProtectedObjects.PSDataDirectory)\O365IPAddresses.xml")
       } finally {
            Write-Verbose("Download finished @ $(Get-Date)")
       }
    }
}

function Parse-0365IPAddresses {
    [cmdletbinding()]
    param (

    )

    

}

# CHANGE PATH
$Path = 'E:'
 
$Report = "$Path\Report.txt"
$LastFile = Get-Content (Get-ChildItem -Path $Path -Filter "*- o365Rules.txt" | sort CreationTime | select -Last 1).FullName
$ChangeDate = Get-Content $Report
$Last = $ChangeDate[-1].Substring($ChangeDate[-1].Length -10,$ChangeDate[-1].Length - ($ChangeDate[-1].Length -10))
 
try { [xml]$o365IpList = Invoke-RestMethod $Link }
catch  {
    $_ | Out-File "$Path\$date - Errors.txt"
    Add-Content $Report "$dateReport Error!!!"
}
 
if (!(Test-Path "$Path\$date - Errors.txt")) {
    $Result = @()
    $ErrorList = @()
    foreach ($Product in $o365IpList.Products.product) {
            foreach ($Addresslist in $Product.addresslist) {
                if ($Addresslist.type -eq "IPV4") {
                    foreach ($Address in $Addresslist.address) {
                        try {
                            [string]$Parse = $Address
                            [string]$IPAddress = $Parse.Substring(0,$Parse.IndexOf("/"))
                            [string]$Cidr = $Parse.Substring($Parse.IndexOf("/")+1,$Parse.Length - $Parse.IndexOf("/")-1)
                            [int]$Prefix = $Cidr
                            if ($Prefix -eq 32) { [string]$Value = "network-object host $IPAddress" }
                            else {
                                $mask = ([Math]::Pow(2,$Prefix)-1) * [Math]::Pow(2,(32-$Prefix))
                                $bytes = [BitConverter]::GetBytes([UInt32] $mask)
                                $IPMask = (($bytes.Count-1)..0 | ForEach-Object {[String]$bytes[$_]}) -join "."
                                [string]$Value = "network-object $IPAddress $IPMask"
                            }
                            $Result += $Value.Trim()
                        }
                        catch { $ErrorList += "$Address --> $_" }
                    }
                }
            }
    }
    $Final = ,"object-group network o365Rules" + ($Result | Sort-Object -Unique)
    $Final | ft | Out-File "$Path\o365Rules.txt"
    $Final | ft | Out-File "$Path\$date - o365Rules.txt"
    if ($ErrorList) { 
        $ErrorList | Out-File "$Path\$date - Errors.txt"
        Add-Content $Report "$dateReport Error!!!"
    }
    else { 
        $Missing = @()
        $Changed = ($o365IpList.Products.updated).Split('/')
        $ChangedFormated = "{0}.{1}.{2}" -f $Changed[1],$Changed[0],$Changed[2]
        $Text = "$dateReport OK, last change $ChangedFormated"
        Add-Content $Report $Text
        $Current = $Text.Substring($Text.Length -10,$Text.Length - ($Text.Length -10))
        if (!($Current -eq $Last)) {
            $LatestRules = Get-Content "$Path\$date - o365Rules.txt"
            foreach ($line in $LatestRules) { if ($LastFile -notcontains $line)      {$Missing += $line} }
            foreach ($line in $LastFile)      { if ($LatestRules -notcontains $line) {$Missing += "no $line"} }
            $FinalMissing = ,"object-group network o365Rules" + ($Missing | sort)
            $FinalMissing | Out-File "$Path\$date - Changes.txt"
        }
    }
}