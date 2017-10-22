<#
.SYNOPSIS
    My customized Powershell Profile
.DESCRIPTION
    See synopsis.
.NOTES
    This script is written by @codebarbarian - https://github.com/codebarbarian
    ========================================================================================================
    #                                               CHANGELOG
    ========================================================================================================
    #    Author         Version         Date                       Description    
    ========================================================================================================      
    # CodeBarbarian       0.0.1       22/10/2017                Initial Relase of powershell profile
    #
    #
    #
    #
    #
    #
    #
    #
#>

################################# Script Config ##################################
# -------------------------- Script Dependant Variables -------------------------#
$ProtectedObjects = New-Object PSObject -Property @{
    Nickname    = 'CodeBarbarian'   # Custom nickname
    Author      = 'Morten Haugstad' # Author of the profile
    Version     = '0.0.1'           # Version of the profile
    DefaultCity = 'Mo I Rana'       # Used by the weather module and other geo modules
    
    # Important ojects
    UserProfile         = $ENV:USERPROFILE
    Username            = $ENV:USERNAME

    # PS Directories
    PSProfileDirectory  = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)")
    PSConfigDirectory   = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\Config")
    PSModuleDirectory   = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\Modules")
    PSDataDirectory     = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\Data")
    PSToolsDirectory    = ("$(Join-Path $ENV:USERPROFILE Documents\WindowsPowerShell)\Tools")

    # Some theme options
    ColorPromptDates            = "RED"
    ColorPromptNickname         = "WHITE"
    ColorPromptCustomDirectory  = "GREEN"
    ColorPromptArrow            = "Yellow"
}
# ------------------------------------ Paths ------------------------------------#
# Custom Directories are listed here
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
# --------------------------------- Theme Config --------------------------------#
# ---------------------------------- POSH Prompt --------------------------------#
Function Prompt {   
    Write-Host "[$(Get-Date)] " -ForegroundColor $ProtectedObjects.ColorPromptDates -NoNewline
    Write-Host "[$($ProtectedObjects.Nickname)] " -ForegroundColor $ProtectedObjects.ColorPromptNickname -NoNewline;
    Write-Host $(Get-CustomDirectory) -ForegroundColor $ProtectedObjects.ColorPromptCustomDirectory  -NoNewline        
    Write-Host " >_" -ForegroundColor $ProtectedObjects.ColorPromptArrow -NoNewline 
    return " "
}

##################################################################################

################################# Module Config ##################################
# -------------------------- Module Import Dependencies -------------------------#
Import-Module ("$($ProtectedObjects.PSModuleDirectory)\core_art.psm1")          # Ascii Art
Import-Module ("$($ProtectedObjects.PSModuleDirectory)\core_functions.psm1")    # Core functions
Import-Module ("$($ProtectedObjects.PSModuleDirectory)\module_networking.psm1") # Module for networking
Import-Module ("$($ProtectedObjects.PSModuleDirectory)\module_weather.psm1")    # Module for displaying weather

# ---------------------------- Functions and Aliases  ---------------------------#
Set-Alias -Name "PS-Clean" -Value Optimize-Session # Optimize the powershell session
##################################################################################

# Initialize bootstrapper - Get things running
Get-Bootstrapper
