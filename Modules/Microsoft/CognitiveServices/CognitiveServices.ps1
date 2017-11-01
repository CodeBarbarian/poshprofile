# In case of proxy
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

# Set the API Endpoint
[string] $ApiEndPoint = "https://westcentralus.api.cognitive.microsoft.com/vision/v1.0"

<#
.SYNOPSIS
    Helper function for drawing windows forms, and manipulating images
.DESCRIPTION
    See synopsis. 
.NOTES
    Originally written by Prateek Singh - https://github.com/PrateekKumarSingh/ProjectOxford/tree/master/ProjectOxford

    This function is modified by @codebarbarian - https://github.com/codebarbarian
    ========================================================================================================
    #                                               CHANGELOG
    ========================================================================================================
    #    Author         Version         Date                       Description    
    ========================================================================================================      
    # CodeBarbarian      1.0          01/11/2017                First initial modification
    #
    #
    #
    #
    #
    #
#>
Function DrawAgeAndGenderOnImage {
    [cmdletbinding()]
    param(
        [parameter()]
        $Response,
        [parameter()]
        $ImagePath,
        [parameter()]
        $Title = 'Age & Gender'
    )

    #Calling the Assemblies
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    $Image = [System.Drawing.Image]::fromfile($ImagePath)
    $Graphics = [System.Drawing.Graphics]::FromImage($Image)

    Foreach($R in $Response)
    {
        #Individual Emotion score and rectangle dimensions of all Faces identified
        $Age = $R.Age
        $Gender = $R.Gender
        $FaceRect = $R.faceRectangle

        $LabelText = "$Age, $Gender"
        
        #Create a Rectangle object to box each Face
        $FaceRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,$FaceRect.top,$FaceRect.width,$FaceRect.height)

        #Create a Rectangle object to Sit above the Face Rectangle and express the emotion
        $AgeGenderRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,($FaceRect.top-22),$FaceRect.width,22)
        $Pen = New-Object System.Drawing.Pen ([System.Drawing.Brushes]::crimson,5)

        #Creating the Rectangles
        $Graphics.DrawRectangle($Pen,$FaceRectangle)    
        $Graphics.DrawRectangle($Pen,$AgeGenderRectangle)
        $Region = New-Object System.Drawing.Region($AgeGenderRectangle)
        $Graphics.FillRegion([System.Drawing.Brushes]::Crimson,$Region)

        #Defining the Fonts for Emotion Name
        $FontSize = 14
        $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold) 
        
        $TextWidth = ($Graphics.MeasureString($LabelText,$Font)).width
        $TextHeight = ($Graphics.MeasureString($LabelText,$Font)).Height

            #A While Loop to reduce the size of font until it fits in the Emotion Rectangle
            While(($Graphics.MeasureString($LabelText,$Font)).width -gt $AgeGenderRectangle.width -or ($Graphics.MeasureString($LabelText,$Font)).Height -gt $AgeGenderRectangle.height )
            {
                $FontSize = $FontSize-1
                $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold)  
            }

        #Inserting the Emotion Name in the EmotionRectabgle
        $Graphics.DrawString($LabelText,$Font,[System.Drawing.Brushes]::White,$AgeGenderRectangle.x,$AgeGenderRectangle.y)
    }

    #Define a Windows Form to insert the Image
    $Form = New-Object system.Windows.Forms.Form
    $Form.BackColor = 'white'
    $Form.AutoSize = $true
    $Form.StartPosition = "CenterScreen"
    $Form.Text = $Title
    $Form.Activate()

    #Create a PictureBox to place the Image
    $PictureBox = New-Object System.Windows.Forms.PictureBox
    $PictureBox.Image = $Image
    $PictureBox.Height = 850
    $PictureBox.Width = 850
    $PictureBox.Sizemode = 'StretchImage'
    $PictureBox.BackgroundImageLayout = 'stretch'

    #Adding PictureBox to the Form
    $Form.Controls.Add($PictureBox)

    [void]$Form.ShowDialog()

    #Disposing Objects and Garbage Collection
    $Image.Dispose()
    $Pen.Dispose()
    $PictureBox.Dispose()
    $Graphics.Dispose()
    $Form.Dispose()
    [GC]::Collect()
}

Function Get-DefaultConfigFile {
    [cmdletbinding()]
    [OutputType([string])]
    param ()

    return ("$(Join-Path $ENV:USERPROFILE Documents)\WindowsPowershell\Config\MSCognitiveServices.xml")
}

Function Get-ConfigFile {
    [cmdletbinding()]
    [OutputType([xml])]
    param (
        [parameter()]
        $ConfigPath
    )

    if ([string]::IsNullOrEmpty($ConfigPath)) {
        $ConfigPath = Get-DefaultConfigFile
    }

    [xml]$ConfigObject = Get-Content -Path $ConfigPath

    return $ConfigObject
}

Function Get-MSCognitiveVision {
    [cmdletbinding(SupportsShouldProcess)]
    param (
        [parameter()]
        [string] $Path,
        [parameter(mandatory=$true)]
        [ValidateSet('description', 'faces', 'adult')]
        [string] $Type
    )

    # Get the config file object
    $Config = Get-ConfigFile
    $APISubscriptionKey = $Config.CognitiveVisionAPIKey

    # Iterate through items in path
    foreach ($Item in $Path) {
        # Get full filename
        $Item = (Get-Item $Item).versioninfo.filename

        # Build API uri
        $URI = "/analyze?visualFeatures=$($Type)"
        
        # Build the full API URI
        $FullURI = "$($ApiEndPoint)$($URI)"

        # Build the Header
        $Header = @{
            'Ocp-Apim-Subscription-Key' = $APISubscriptionKey
            'Content-Type'              = 'application/octet-stream'
        }

        # Process API Request
        if ($PSCmdlet.ShouldProcess("Fetching request from $($FullURI)")) {
            $Response = Invoke-RestMethod -Uri $FullURI -Method Post -InFile $Path -Headers $Header
        }
    }

    # Need some checksh here: -- TODO

    # Customized type output
    Switch($Type) {
        'description' {
            
            Write-Host ($Response.description.tags)
            Write-Host ($Response.description.captions.text)
        }
    
        'faces' {
            DrawAgeAndGenderOnImage -Response $Response.faces -ImagePath $Path
        }

        'adult' {
            Write-Host ($Response.adult)
        }
    }
    # Return response
    return $Response
}