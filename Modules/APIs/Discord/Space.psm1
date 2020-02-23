$DiscordUrl = ''

function Send-SpaceX_Schedule {
    [cmdletbinding()]
    param()

    $Call2 = Get-SpaceX -Endpoint upcominglaunches

    $Launch = $Call2.Content | ConvertFrom-Json

    $SX_LaunchMissionName = $Launch[0].mission_name
    $SX_LaunchDateUnix  = $Launch[0].launch_date_unix

    $SX_LaunchRocketName = $Launch[0].rocket.rocket_name
    $SX_LaunchSite = $Launch[0].launch_site.site_name

    $Image = New-DiscordImage -Url "https://mk0spaceflightnoa02a.kinstacdn.com/wp-content/uploads/2020/02/190411-F-UT715-1072.jpg"

    $Fact1 = New-DiscordFact -Name "Mission" -Value $SX_LaunchMissionName -Inline $true
    $Fact2 = New-DiscordFact -Name "Rocket" -Value $SX_LaunchRocketName -Inline $true
    $Fact3 = New-DiscordFact -Name "Launch Site" -Value $SX_LaunchSite -Inline $true

    $LaunchDate =  ConvertFrom-UnixTime($SX_LaunchDateUnix)
    $RealDate = Get-Date("$($LaunchDate)")

    $HowManyDays = New-TimeSpan -Start "$(Get-Date)" -End $RealDate

    $Fact4 = New-DiscordFact -Name "Launching" -Value "*$($RealDate)* -- **$(($HowManyDays).Days) Days from now**"

    $Section1 = New-DiscordSection -Title 'Next Launch' -Description '' -Facts $Fact1, $Fact2, $Fact3, $Fact4 -Color BlueViolet -Image $Image
    Send-DiscordMessage -WebHookUrl $DiscordUrl -Sections $Section1 -AvatarName 'SpaceX Launch Schedule'
}

function Send-SpaceX_Info {

}

