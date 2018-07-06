Function New-SchedueledJob {
    [cmdletbinding()]
    param (
        [psobject] $ScheduleObject = $null
    )

    # Simple Check
    if ($ScheduleObject -eq $null) {
        $ScheduleName   = Read-Host("Name of Scheduled Job?")
        $ScriptBlock    = Read-Host("Command To Run")
        $Trigger        = New-JobTrigger
        $JobOptions     = New-ScheduledJobOption
    }

    # The Job Splat for Making a new Scheduled Job
    $JobSplat = @{
        Name        = $ScheduleName
        ScriptBlock = $ScriptBlock
        Trigger     = $Trigger
        ScheduledJobOption = $JobOptions
    }

    Register-ScheduledJob @JobSplat
}