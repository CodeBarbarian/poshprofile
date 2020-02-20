$DiscordUrl = 'WEBHOOK URL'

function Send-SpaceXInfo {
    [cmdletbinding()]
    param()

    $Call1 = Get-SpaceX -Endpoint Info
    $Call2 = Get-SpaceX -Endpoint upcominglaunches

    $Info = $Call1.Content | ConvertFrom-Json
    $Launch = $Call2.Content | ConvertFrom-Json
    
    $SX_Name = $Info.name
    $SX_Founder = $Info.founder
    $SX_summary = $Info.summary
    
    $SX_LaunchFlightNumber = $Launch[0].flight_number
    $SX_LaunchMissionName = $Launch[0].mission_name
    $SX_LaunchMissionID = $Launch[0].mission_id
    $SX_LaunchLDateUnix = $Launch[0].launch_date_unix
    $SX_LaunchRocketName = $Launch[0].rocket.rocket_name
    $SX_LaunchSite = $Launch[0].launch_site.site_name

    $Thumbnail = New-DiscordImage -Url "https://mk0spaceflightnoa02a.kinstacdn.com/wp-content/uploads/2020/02/190411-F-UT715-1072.jpg"


    $Fact1 = New-DiscordFact -Name "Mission" -Value $SX_LaunchMissionName -Inline $true
    $Fact2 = New-DiscordFact -Name "Rocket" -Value $SX_LaunchRocketName -Inline $true
    $Fact3 = New-DiscordFact -Name "Launch Site" -Value $SX_LaunchSite -Inline $true
    $Fact4 = New-DiscordFact -Name "Launching" -Value $SX_LaunchLDateUnix 

    $Section1 = New-DiscordSection -Title 'Next Launch' -Description '' -Facts $Fact1, $Fact2, $Fact3, $Fact4 -Color BlueViolet -Image $Thumbnail
    Send-DiscordMessage -WebHookUrl $DiscordUrl -Sections $Section1 -AvatarName 'SpaceX'


    




}