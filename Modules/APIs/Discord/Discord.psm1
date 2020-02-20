<#
.SYNOPSIS
    Simple Powershell Module allowing to send messages to Discord Channels over Webhooks.
.NOTES
    Created by EvotecIT @ https://github.com/EvotecIT/PSDiscord
#>


function New-DiscordSection {
    [alias("New-DiscordEmbed")]
    [CmdletBinding()]
    param (
        [string] $Title,
        [string] $Description,
        [alias('Fields')][System.Collections.IDictionary[]] $Facts,
        [String] $Color,
        [System.Collections.IDictionary] $Author,
        [System.Collections.IDictionary] $Thumbnail,
        [System.Collections.IDictionary] $Image
    )
    $Section = [ordered] @{
        title       = $Title
        description = $Description
        fields      = @()
    }
    $Field = foreach ($Fact in $Facts) {
        if ($null -ne $Fact) {
            $Fact
        }
    }
    $Section.fields = @($Field)
    if ($null -ne $Color) {
        $Section.color = ConvertFrom-Color -Color $Color -AsDecimal
    }
    if ($null -ne $Author) {
        $Section.author = $Author
    }
    if ($null -ne $Image) {
        $Section.image = $Image
    }
    if ($null -ne $Thumbnail) {
        $Section.thumbnail = $Thumbnail
    }
    return $Section
}

function New-DiscordAuthor {
    [CmdletBinding()]
    param (
        [string] $Name,
        [Uri] $Url,
        [Uri] $IconUrl,
        [Uri] $ProxyUrlIcon
    )
    $Author = [ordered] @{
        name           = $Name
        url            = $Url
        icon_url       = $IconUrl
        proxy_icon_url = $ProxyUrlIcon
    }
    return $Author
}

function New-DiscordFact {
    [alias("New-DiscordField")]
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $Value,
        [bool] $Inline
    )

    If ($Name -ne '' -and $Value -ne '') {
        $Fact = [ordered] @{
            name   = $Name
            value  = $Value
            inline = $inline
        }
        return $Fact
    }
}

function New-DiscordImage {
    [alias('New-DiscordThumbnail')]
    [CmdletBinding()]
    param (
        [Uri] $Url,
        [int] $Width,
        [int] $Height
    )
    $Thumbnail = [ordered] @{
        "url"    = $Url
        "width"  = $Width
        "height" = $Height
    }
    return $Thumbnail
}

function Send-DiscordMessage {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [alias('Url', 'Uri')][Uri] $WebHookUrl,
        [alias('Embeds', 'Embed', 'Section')][System.Collections.IDictionary[]] $Sections,
        [alias('Content', 'Message')][string] $Text,
        [alias('Username')] [string] $AvatarName,
        [Uri] $AvatarUrl,
        [alias('TTS')][switch] $TextToSpeech,
        [switch] $CreateConfig,
        [string] $ConfigName,
        [switch] $OutputJSON
    )
    if (-not $WebHookUrl) {
        $WebHookUrl = Get-DiscordConfig -Name 'Primary'
    }
    if ($null -eq $WebHookUrl) {
        Write-Warning 'Send-DiscordMessage - WebhookUrl is not set. Either provide it as parameter or initialize it with config.'
    }
    if ($CreateConfig) {
        if (-not $ConfigName) {
            $ConfigName = 'Primary'
        }
        Initialize-DiscordConfig -ConfigName $ConfigName -URI $WebHookUrl
    }
    $FullMessage = [ordered] @{
        "embeds" = @()
    }
    if ($null -ne $Sections) {
        foreach ($Section in $Sections) {
            $FullMessage.embeds += $Section
        }
    }
    if ($null -ne $Text) {
        if ($TextToSpeech) {
            # Applies only to Content
            $FullMessage.tts = $true
        }
        $FullMessage.content = $Text
    }
    if ($null -ne $AvatarName) {
        $FullMessage.username = $AvatarName
    }
    if ($null -ne $AvatarUrl) {
        $FullMessage.avatar_url = $AvatarUrl
    }

    $Body = ConvertTo-Json -Depth 6 -InputObject $FullMessage
    Write-Verbose -Message "Send-DiscordMessage - Body: `n$Body"
    if ($PSCmdlet.ShouldProcess("$([System.Environment]::NewLine)$Body", 'Invoke-RestMethod')) {
        Invoke-RestMethod -Uri $WebHookUrl -Body $Body -Method Post -ContentType "application/json" -Verbose:$false
    }
    if ($OutputJSON) {
        return $Body
    }
}

  
function Get-DiscordConfig {
    [CmdletBinding()]
    param(
        [string] $Name = 'Primary'
    )
    [string] $Path = [IO.Path]::Combine($Env:USERPROFILE, '.psdiscord')
    [string] $PathXML = [IO.Path]::Combine($Path, "config.xml")

    if (Test-Path -Path $PathXML) {
        $Configuration = Import-Clixml -Path $PathXML
        if ($null -ne $Configuration.$Name) {
            return $Configuration.$Name
        }
    }
    return $null
}

  
function Initialize-DiscordConfig {
    [CmdletBinding()]
    param(
        [string] $Name = 'Primary',
        [Uri] $URI
    )
    [string] $Path = [IO.Path]::Combine($Env:USERPROFILE, '.psdiscord')
    [string] $PathXML = [IO.Path]::Combine($Path, "config.xml")
    # Creates required folder

    $Configuration = @{}
    $Configuration.$Name = $URI

    $null = New-Item -Path $Path -ItemType Directory -Force
    Export-Clixml -Path $PathXML -InputObject $Configuration -Force
}