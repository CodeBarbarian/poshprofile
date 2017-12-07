<#
.SYNOPSIS
    My customized Powershell Profile
.DESCRIPTION
    See synopsis.
.NOTES
#>



# Automatically Install PSImaging
<#

# Need to test this, if it does not work, find another solution. 
& ([scriptblock]::Create((iwr -uri https://gist.githubusercontent.com/KirkMunro/131308abfb2d857bea40/raw/Install-ModuleFromGitHub.ps1).Content)) `
  -GitHubUserName Positronic-IO -ModuleName PSImaging -Branch 'master' -Scope CurrentUser

#>