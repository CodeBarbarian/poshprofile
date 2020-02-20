<#
.SYNOPSIS
    Get Custom Directory Path - Shows predefined paths instead of a long pathname
.DESCRIPTION
    This function is modifed from one of my favorite Powershell developers
        - Prateek Singh
        - https://geekeefy.wordpress.com/2016/10/19/powershell-customize-directory-path-in-ps-prompt/
.NOTES
        This function is modified by @codebarbarian - https://github.com/codebarbarian
#>
function Get-CustomDirectory {
    [CmdletBinding()]
    [OutputType([String])]
    Param (
        [Parameter(ValueFromPipeline=$true,Position=0)]
        $Path = $PWD.Path
    )

    foreach ($Item in $Path) {
        $Match = ($CustomDirectories.GetEnumerator().name | Where-Object{$Item -eq "$_" -or $Item -like "$_*"} |`
        Select-Object @{n='Directory';e={$_}},@{n='Length';e={$_.length}} |Sort-Object Length -Descending | Select-Object -First 1).directory
        if ($Match) {
            [String]($Item -Replace [regex]::Escape($Match),$CustomDirectories[$Match])            
        } elseif ($pwd.Path -ne $Item) {
            $Item
        } else {
            $pwd.Path
        }
    }
}
$Script:RGBColors = @{
    "Black"                = 0, 0, 0
    "Navy"                 = 0, 0, 128
    "DarkBlue"             = 0, 0, 139
    "MediumBlue"           = 0, 0, 205
    "Blue"                 = 0, 0, 255
    "DarkGreen"            = 0, 100, 0
    "Green"                = 0, 128, 0
    "Teal"                 = 0, 128, 128
    "DarkCyan"             = 0, 139, 139
    "DeepSkyBlue"          = 0, 191, 255
    "DarkTurquoise"        = 0, 206, 209
    "MediumSpringGreen"    = 0, 250, 154
    "Lime"                 = 0, 255, 0
    "SpringGreen"          = 0, 255, 127
    "Aqua"                 = 0, 255, 255
    "Cyan"                 = 0, 255, 255
    "MidnightBlue"         = 25, 25, 112
    "DodgerBlue"           = 30, 144, 255
    "LightSeaGreen"        = 32, 178, 170
    "ForestGreen"          = 34, 139, 34
    "SeaGreen"             = 46, 139, 87
    "DarkSlateGray"        = 47, 79, 79
    "DarkSlateGrey"        = 47, 79, 79
    "LimeGreen"            = 50, 205, 50
    "MediumSeaGreen"       = 60, 179, 113
    "Turquoise"            = 64, 224, 208
    "RoyalBlue"            = 65, 105, 225
    "SteelBlue"            = 70, 130, 180
    "DarkSlateBlue"        = 72, 61, 139
    "MediumTurquoise"      = 72, 209, 204
    "Indigo"               = 75, 0, 130
    "DarkOliveGreen"       = 85, 107, 47
    "CadetBlue"            = 95, 158, 160
    "CornflowerBlue"       = 100, 149, 237
    "MediumAquamarine"     = 102, 205, 170
    "DimGray"              = 105, 105, 105
    "DimGrey"              = 105, 105, 105
    "SlateBlue"            = 106, 90, 205
    "OliveDrab"            = 107, 142, 35
    "SlateGray"            = 112, 128, 144
    "SlateGrey"            = 112, 128, 144
    "LightSlateGray"       = 119, 136, 153
    "LightSlateGrey"       = 119, 136, 153
    "MediumSlateBlue"      = 123, 104, 238
    "LawnGreen"            = 124, 252, 0
    "Chartreuse"           = 127, 255, 0
    "Aquamarine"           = 127, 255, 212
    "Maroon"               = 128, 0, 0
    "Purple"               = 128, 0, 128
    "Olive"                = 128, 128, 0
    #"Grey" = 92, 92, 92
    "Gray"                 = 128, 128, 128
    "Grey"                 = 128, 128, 128
    "SkyBlue"              = 135, 206, 235
    "LightSkyBlue"         = 135, 206, 250
    "BlueViolet"           = 138, 43, 226
    "DarkRed"              = 139, 0, 0
    "DarkMagenta"          = 139, 0, 139
    "SaddleBrown"          = 139, 69, 19
    "DarkSeaGreen"         = 143, 188, 143
    "LightGreen"           = 144, 238, 144
    "MediumPurple"         = 147, 112, 219
    "DarkViolet"           = 148, 0, 211
    "PaleGreen"            = 152, 251, 152
    "DarkOrchid"           = 153, 50, 204
    "YellowGreen"          = 154, 205, 50
    "Sienna"               = 160, 82, 45
    "Brown"                = 165, 42, 42
    "DarkGray"             = 169, 169, 169
    "DarkGrey"             = 169, 169, 169
    "LightBlue"            = 173, 216, 230
    "GreenYellow"          = 173, 255, 47
    "PaleTurquoise"        = 175, 238, 238
    "LightSteelBlue"       = 176, 196, 222
    "PowderBlue"           = 176, 224, 230
    "FireBrick"            = 178, 34, 34
    "DarkGoldenrod"        = 184, 134, 11
    "MediumOrchid"         = 186, 85, 211
    "RosyBrown"            = 188, 143, 143
    "DarkKhaki"            = 189, 183, 107
    "Silver"               = 192, 192, 192
    "MediumVioletRed"      = 199, 21, 133
    "IndianRed"            = 205, 92, 92
    "Peru"                 = 205, 133, 63
    "Chocolate"            = 210, 105, 30
    "Tan"                  = 210, 180, 140
    "LightGray"            = 211, 211, 211
    "LightGrey"            = 211, 211, 211
    "Thistle"              = 216, 191, 216
    "Orchid"               = 218, 112, 214
    "Goldenrod"            = 218, 165, 32
    "PaleVioletRed"        = 219, 112, 147
    "Crimson"              = 220, 20, 60
    "Gainsboro"            = 220, 220, 220
    "Plum"                 = 221, 160, 221
    "BurlyWood"            = 222, 184, 135
    "LightCyan"            = 224, 255, 255
    "Lavender"             = 230, 230, 250
    "DarkSalmon"           = 233, 150, 122
    "Violet"               = 238, 130, 238
    "PaleGoldenrod"        = 238, 232, 170
    "LightCoral"           = 240, 128, 128
    "Khaki"                = 240, 230, 140
    "AliceBlue"            = 240, 248, 255
    "Honeydew"             = 240, 255, 240
    "Azure"                = 240, 255, 255
    "SandyBrown"           = 244, 164, 96
    "Wheat"                = 245, 222, 179
    "Beige"                = 245, 245, 220
    "WhiteSmoke"           = 245, 245, 245
    "MintCream"            = 245, 255, 250
    "GhostWhite"           = 248, 248, 255
    "Salmon"               = 250, 128, 114
    "AntiqueWhite"         = 250, 235, 215
    "Linen"                = 250, 240, 230
    "LightGoldenrodYellow" = 250, 250, 210
    "OldLace"              = 253, 245, 230
    "Red"                  = 255, 0, 0
    "Fuchsia"              = 255, 0, 255
    "Magenta"              = 255, 0, 255
    "DeepPink"             = 255, 20, 147
    "OrangeRed"            = 255, 69, 0
    "Tomato"               = 255, 99, 71
    "HotPink"              = 255, 105, 180
    "Coral"                = 255, 127, 80
    "DarkOrange"           = 255, 140, 0
    "LightSalmon"          = 255, 160, 122
    "Orange"               = 255, 165, 0
    "LightPink"            = 255, 182, 193
    "Pink"                 = 255, 192, 203
    "Gold"                 = 255, 215, 0
    "PeachPuff"            = 255, 218, 185
    "NavajoWhite"          = 255, 222, 173
    "Moccasin"             = 255, 228, 181
    "Bisque"               = 255, 228, 196
    "MistyRose"            = 255, 228, 225
    "BlanchedAlmond"       = 255, 235, 205
    "PapayaWhip"           = 255, 239, 213
    "LavenderBlush"        = 255, 240, 245
    "Seashell"             = 255, 245, 238
    "Cornsilk"             = 255, 248, 220
    "LemonChiffon"         = 255, 250, 205
    "FloralWhite"          = 255, 250, 240
    "Snow"                 = 255, 250, 250
    "Yellow"               = 255, 255, 0
    "LightYellow"          = 255, 255, 224
    "Ivory"                = 255, 255, 240
    "White"                = 255, 255, 255

    <# Alternative version
    "darkSlateGray" = 42, 42, 42
    "darkGray" = 163, 163, 163
    "whiteSmoke" = 240, 240, 240
    "whiteSmoke" = 242, 242, 242
    "DeepSkyBlue" = 0, 102, 221
    "DarkSlateGrey" = 38, 38, 38
    "DarkSlateGrey" = 51, 51, 51
    "cornflowerblue" = 0, 102, 153
    "WhiteSmoke" = 248, 248, 248
    "Green" = 0, 130, 0
    "SteelBlue" = 127, 157, 185
    "Red" = 163, 21, 21
    "cornflowerblue" = 43, 145, 175
    "Royalblue" = 46, 117, 181
    #>
}

Add-Type -TypeDefinition @"
public enum RGBColors {
    Black,
    Navy,
    DarkBlue,
    MediumBlue,
    Blue,
    DarkGreen,
    Green,
    Teal,
    DarkCyan,
    DeepSkyBlue,
    DarkTurquoise,
    MediumSpringGreen,
    Lime,
    SpringGreen,
    Aqua,
    Cyan,
    MidnightBlue,
    DodgerBlue,
    LightSeaGreen,
    ForestGreen,
    SeaGreen,
    DarkSlateGray,
    DarkSlateGrey,
    LimeGreen,
    MediumSeaGreen,
    Turquoise,
    RoyalBlue,
    SteelBlue,
    DarkSlateBlue,
    MediumTurquoise,
    Indigo,
    DarkOliveGreen,
    CadetBlue,
    CornflowerBlue,
    MediumAquamarine,
    DimGray,
    DimGrey,
    SlateBlue,
    OliveDrab,
    SlateGray,
    SlateGrey,
    LightSlateGray,
    LightSlateGrey,
    MediumSlateBlue,
    LawnGreen,
    Chartreuse,
    Aquamarine,
    Maroon,
    Purple,
    Olive,
    Grey,
    Gray,
    //Grey,
    SkyBlue,
    LightSkyBlue,
    BlueViolet,
    DarkRed,
    DarkMagenta,
    SaddleBrown,
    DarkSeaGreen,
    LightGreen,
    MediumPurple,
    DarkViolet,
    PaleGreen,
    DarkOrchid,
    YellowGreen,
    Sienna,
    Brown,
    DarkGray,
    DarkGrey,
    LightBlue,
    GreenYellow,
    PaleTurquoise,
    LightSteelBlue,
    PowderBlue,
    FireBrick,
    DarkGoldenrod,
    MediumOrchid,
    RosyBrown,
    DarkKhaki,
    Silver,
    MediumVioletRed,
    IndianRed,
    Peru,
    Chocolate,
    Tan,
    LightGray,
    LightGrey,
    Thistle,
    Orchid,
    Goldenrod,
    PaleVioletRed,
    Crimson,
    Gainsboro,
    Plum,
    BurlyWood,
    LightCyan,
    Lavender,
    DarkSalmon,
    Violet,
    PaleGoldenrod,
    LightCoral,
    Khaki,
    AliceBlue,
    Honeydew,
    Azure,
    SandyBrown,
    Wheat,
    Beige,
    WhiteSmoke,
    MintCream,
    GhostWhite,
    Salmon,
    AntiqueWhite,
    Linen,
    LightGoldenrodYellow,
    OldLace,
    Red,
    Fuchsia,
    Magenta,
    DeepPink,
    OrangeRed,
    Tomato,
    HotPink,
    Coral,
    DarkOrange,
    LightSalmon,
    Orange,
    LightPink,
    Pink,
    Gold,
    PeachPuff,
    NavajoWhite,
    Moccasin,
    Bisque,
    MistyRose,
    BlanchedAlmond,
    PapayaWhip,
    LavenderBlush,
    Seashell,
    Cornsilk,
    LemonChiffon,
    FloralWhite,
    Snow,
    Yellow,
    LightYellow,
    Ivory,
    White
}
"@

function ConvertFrom-UnixTime {
    [cmdletbinding()]
    param(
        [int32] $UTS
    )

    $TimeObject = [datetimeoffset]::FromUnixTimeMilliseconds(1000 * $UTS)

    return $TimeObject
}

function ConvertFrom-Color {
    [alias('Convert-FromColor')]
    [CmdletBinding()]
    param (
        [RGBColors] $Color,
        [switch] $AsDecimal
    )

    $Value = $Script:RGBColors."$Color"
    Write-Verbose "Convert-FromColor - Color Name: $Color Value: $Value"
    foreach ($arg in $Value) {
        $hexval = $hexval + [Convert]::ToString($arg, 16).ToUpper()
    }
    if ($AsDecimal) {
        return  [Convert]::ToInt64($hexval,16)
    } else {
        return "#$($hexval)" # .Substring(2)
    }
}

<#
.SYNOPSIS
    Clears the host screen and displays the appropriate ascii art
.DESCRIPTION
    See synopsis.
.NOTES
    This function is written by @codebarbarian - https://github.com/codebarbarian
#>
Function Get-Bootstrapper {
    [cmdletbinding()]
    [OutputType([void])]
    param()

    # Clear Host
    Clear-Host
    
    # Retrieved from the core_art.psm1
    Get-MainHeader
}

<#
.SYNOPSIS
    Simple implementation of touch command from *nix
.DESCRIPTION
    See synopsis.
    This script could be accomplished by doing "Net-Alias -Name Touch -Value New-Item"
.EXAMPLE
    touch c:\temp\test.txt
.PARAMETER Path
    The entire FQPN
.LINK
.NOTES
    This function is written by @codebarbarian - https://github.com/codebarbarian
#>
Function Touch {
    [cmdletbinding(SupportsShouldProcess=$true)]
    [OutputType([void])]
    param (
        [parameter(mandatory=$true)]
        $Path
    )

    if ($PSCmdlet.ShouldProcess("Creating file $($Path)")) {
        Write-Verbose -Message "Creating file $($Path)"
        New-Item -Path $Path -ItemType File -Force
        Write-Verbose -Message "File created."
    }
    return 0
}

Function Get-PSProfileChallenge {
    [cmdletbinding()]
    [OutputType([boolean])]
    param ()

    if (Get-Variable -Name PSProfileChallenge -Scope Global -ErrorAction SilentlyContinue) {
        return $True
    } else {
        $False
    }
}

Function New-PSWindow {
    [cmdletbinding()]
    param (
        $Include 
    )

    Invoke-Expression "cmd /c start powershell.exe -Command $($Include)"
}

Function Get-SessionHistory {
    [cmdletbinding()]
    param (

    )

    $Objects = Get-History | Select-Object CommandLine

    return $Objects.CommandLine

}

Function Get-PSVariables {
    [cmdletbinding()]
    param (

    )
    
    Get-Variable | Where-Object {(@(
        "FormatEnumerationLimit",
        "MaximumAliasCount",
        "MaximumDriveCount",
        "MaximumErrorCount",
        "MaximumFunctionCount",
        "MaximumVariableCount",
        "PGHome",
        "PGSE",
        "PGUICulture",
        "PGVersionTable",
        "PROFILE",
        "PSSessionOption",
        "psISE",
        "psUnsupportedConsoleApplications") -NotContains $_.Name) -and `
        (([PSObject].Assembly.GetType('System.Management.Automation.SpecialVariables').GetFields('NonPublic,Static
        ') | Where-Object FieldType -eq ([string]) | ForEach-Object GetValue $null)) -NotContains $_.Name}
}

## TODO : Get this done
Function Trace-Self {
    [cmdletbinding()]
    [OutputType([void])]
    param (

    )

    "========================================================================"
    "                          Generating report..."
    "========================================================================"
    Write-Host ("__ERRORS: $($Global:Error.Count)") -ForegroundColor RED
    $Global:Error
    Write-Host ("__WARNING: $($Global:Warning.Count)") -ForegroundColor YELLOW
    $Global:Warning
    Write-Host ("__DEBUG: $($Global:Debug.Count)") -ForegroundColor BLUE
    $Global:Debug
    Write-Host ("__VERBOSE: $($Global:Verbose.Count)") -ForegroundColor CYAN

    "========================================================================"
    Write-Host ("__VARIABLES: ") 
    Get-PSVariables


    "========================================================================"
    $SessionHistory = Get-SessionHistory
    Write-Host ("__SESSION_HISTORY:") $SessionHistory.Count
    $SessionHistory
    
    "========================================================================"
    "                           END OF REPORT"
    "========================================================================"
}

Function Show-Procedures {
    [cmdletbinding()]
    [OutputType([string])]
    param (

    )

    $Objects = Get-ChildItem -Path $ProtectedObjects.PSProcedureDirectory -File -Recurse
    return $Objects.Name
}

function Start-Procedure {
    [CmdletBinding()]
    Param()
    DynamicParam {
        $attributes = new-object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $false

        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)

        $arrSet = Get-ChildItem -Path $ProtectedObjects.PSProcedureDirectory -File | Select-Object -ExpandProperty Name
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Name", [string], $attributeCollection)
            
        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("Name", $dynParam1)
        
        return $paramDictionary
    } End {
        $Path = (Join-Path $ProtectedObjects.PSProcedureDirectory $PSBoundParameters['Name'])
        $ScriptBlock = Get-Content -Path $Path
        New-PSWindow -Include $ScriptBlock
    }
}


function Get-Modules {
    [cmdletbinding()]
    [alias("Get-Module")]
    [OutputType([psobject])]
    param ( )

    if ([string]::isNullOrWhitespace($Global:CurrentPrefixTag)) {
        Get-Module
    } else {
        $ReturnObject = @()
        $Objects = Get-ChildItem -Path (Join-Path $ProtectedObjects.PSModuleDirectory $Global:CurrentPrefixTag) -Directory
        foreach($Object in $Objects) {
            $TempName = $Object.Name

            $ModuleObject = Get-Module $TempName | Select-Object ExportedCommands
            
            $ReturnObject += New-Object -TypeName PSObject -Property @{
                Name = $TempName
                ExportedCommands = $ModuleObject.ExportedCommands.Values.Name 
                CommandType = $ModuleObject.ExportedCommands.Values.CommandType 
            }
        }
        return $ReturnObject
    }
}

Function Get-ModuleDirectory {
    [cmdletbinding()]
    param ()

    Set-Location -Path $ProtectedObjects.PSModuleDirectory
}
