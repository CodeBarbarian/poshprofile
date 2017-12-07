<#
.SYNOPSIS
    Configuration for my Powershell Profile
.DESCRIPTION
    See synopsis.
.NOTES
    This script is written by @codebarbarian - https://github.com/codebarbarian
#>

[cmdletbinding()]
param()

################################# Script Config ##################################
# -------------------------- Script Dependant Variables -------------------------#
$ProtectedObjects = New-Object PSObject -Property @{
    Nickname    = 'CodeBarbarian'   # Custom nickname
    Author      = 'Morten Haugstad' # Author of the profile
    Version     = '1.0'             # Version of the profile
    DefaultCity = 'Mo I Rana, Norway'       # Used by the weather module and other geo modules
    
    # Important ojects
    UserProfile         = $ENV:USERPROFILE
    Username            = $ENV:USERNAME

    # PS Directories
    PSProfileDirectory      = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)")
    PSConfigDirectory       = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\Config")
    PSModuleDirectory       = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\Modules")
    PSDataDirectory         = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\Data")
    PSToolsDirectory        = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\Tools") # not in use yet
    PSProcedureDirectory    = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\StoredProcedures")
    # Some theme options
    ColorPromptDates            = "RED"
    ColorPromptNickname         = "WHITE"
    ColorPromptCustomDirectory  = "GREEN"
    ColorPromptArrow            = "Yellow"    
}

$CustomDirectories = @{
    # Typicals 
    $env:Temp       = '[Temp]'
    $env:AppData    = '[AppData]'
    
    # Replicates, to make the prompt look nicer (Need to do this automatic in the future)
    ("$($ProtectedObjects.PSProfileDirectory)") = '[PS-Profile]'
    ("$($ProtectedObjects.PSConfigDirectory)")  = '[PS-Config]'
    ("$($ProtectedObjects.PSModuleDirectory)")  = '[PS-Modules]'
    ("$($ProtectedObjects.PSDataDirectory)")    = '[PS-Data]'
    ("$($ProtectedObjects.PSToolsDirectory)")   = '[PS-Toolshed]'

    # These are custom directories
    ("$($ENV:USERPROFILE)")                             = '[User Profile]'
    ("$(Join-Path $ENV:USERPROFILE Desktop)")           = '[Desktop]'
    ("$(Join-Path $ENV:USERPROFILE Documents)")         = '[Documents]'
    ("$(Join-Path $ENV:USERPROFILE Documents)\git")     = '[Git Repository]'

}

# Profile Challenge Code
$PSProfileChallenge = "MIKE OSCAR ROMEO TANGO ECHO NOVEMBER"

# Warning Preferance
$WarningPreference = "Continue"

# Error Action Preference
# Continue          Ignore            Inquire           SilentlyContinue  Stop              Suspend
$ErrorActionPreference = "Continue"

# Verbose Preference
$VerbosePreference = "Continue"
# --------------------------------- Theme Config --------------------------------#

# ---------------------------------- POSH Prompt --------------------------------#
Function Use-CustomDirectory {
    $Global:CurrentPrefixName   = ""
    $Global:CurrentPrefixColour = ""
    $Global:CurrentPrefixTag    = ""
}

Function Prompt {
    [cmdletbinding()]
    param (
    )   

    $Time = Get-Date -Format ("HH\:mm\:ss")
    Write-Host "[$($Time)] " -ForegroundColor $ProtectedObjects.ColorPromptDates -NoNewline
    Write-Host "[$($ProtectedObjects.Nickname)] " -ForegroundColor $ProtectedObjects.ColorPromptNickname -NoNewline;
    
    # Simple check
    if ([string]::IsNullOrEmpty($Global:CurrentPrefixName)) {
        Write-Host $(Get-CustomDirectory) -ForegroundColor $ProtectedObjects.ColorPromptCustomDirectory  -NoNewline
    } else {
        Write-Host "[$($Global:CurrentPrefixName)]" -ForegroundColor $Global:CurrentPrefixColour -NoNewline
    }

    Write-Host " >_" -ForegroundColor $ProtectedObjects.ColorPromptArrow -NoNewline 
    return " "
}

##################################################################################
# ----------------------------------- Aliases  ----------------------------------#
New-Alias -Name Reset -Value Use-CustomDirectory
##################################################################################