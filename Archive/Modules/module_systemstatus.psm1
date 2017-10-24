Function Get-EventLog_Status
{   

    Write-Host ("Collecting System Error Events which has occurred the past 7 days ...") -ForegroundColor Red -BackgroundColor Black
    $ErrorEvents = Get-EventLog -LogName System -EntryType Error | ?{$_.TimeGenerated -ge (get-date).AddDays(-7) } | Group-Object source | sort count -Descending | Select Count, Name -First 3 
    Write-Host ($ErrorEvents |%{"$($_.count) error messages logged related to $(($_.name).Replace('-',' ')) ."}) -ForegroundColor Red -BackgroundColor Black
    Write-Host ("Collecting System Warning events which has occurred the past 7 days...") -ForegroundColor Yellow -BackgroundColor Black
    $WarningEvents = Get-EventLog -LogName System -EntryType Warning | ?{$_.TimeGenerated -ge (get-date).AddDays(-7) } | Group-Object source | sort count -Descending | Select Count, Name -First 3 
    Write-Host ($WarningEvents |%{"$($_.count) Warning messages logged related to $(($_.name).Replace('-',' ')) ."})  -ForegroundColor Yellow -BackgroundColor Black
}

# Export all functions in this file (two non POSH verb used)
Export-ModuleMember -Function Get-*
Export-ModuleMember -Function Set-*
Export-ModuleMember -Function Use-*