
$Remarklist = @(
    "test",
    "testing",
    "temp",
    "temporary"
)

function Start-Parsing {
    [cmdletbinding()]
    param(
        [string] $Title,
        [string] $ExportedFile,
        [string] $SaveToFile
    )

    $CSVFile = Get-ExportedFile -Path $ExportedFile

    # Get the content of the CSV file
    $Content = Import-CSV -Path $CSVFile

    # What do we want to get from the object
    $ContentSelection = $Content | Select-Object Interface,Source,Destination,Service,Action,Description

    # Create the Word Application Com Object
    $Word           = New-Object -ComObject Word.Application
    $Word.Visible   = $True
    $Document       = $Word.Documents.Add()
    $Selection      = $Word.Selection

    # Some Customization
    $Selection.Style = 'Title'
    $Selection.TypeText($Title)
    $Selection.TypeParagraph()
    $Selection.Style = 'Heading 1'
    $Selection.TypeText("Report compiled at $(Get-Date) by PSASA.")
    $Selection.TypeParagraph()
    $Selection.Font.Size = 10

    # Create the table with the following properties
    $Table = $Selection.Tables.add($Selection.Range,(($ContentSelection.Count)),5)

    # Header
    $Table.cell(1,1).range.text = "Interface"
    $Table.cell(1,2).range.text = "Source"
    $Table.cell(1,3).range.text = "Destination"
    $Table.cell(1,4).range.text = "Service"
    $Table.cell(1,5).range.text = "Description"

    # Start Cell will be row 2
    $StartCell = 2

    # Store the remarks position in this variable
    $Remarks = @()

    foreach($Contents in $ContentSelection) {
        $Table.cell($StartCell,1).range.text = $Contents.Interface
        
        # Source Address - Make it more readable
        if ($Contents.Source.Contains(",")) {
            $Table.cell($StartCell,2).range.text = $Contents.Source.Replace(",",", ")
        } else {
            $Table.cell($StartCell,2).range.text = $Contents.Source
        }

        # Destination Address - Make it more readable
        if ($Contents.Destination.Contains(",")) {
            $Table.cell($StartCell,3).range.text = $Contents.Destination.Replace(",",", ")
        } else {
            $Table.cell($StartCell,3).range.text = $Contents.Destination
        }
        
        # Service - Make it more readable
        if ($Contents.Service.Contains(",")) {
            $Table.cell($StartCell,4).range.text = $Contents.Service.Replace(",",", ")
        } else {
            $Table.cell($StartCell,4).range.text = $Contents.Service
        }

        # Description - Make it more readable
        if ([string]::IsNullOrEmpty($Contents.Description) -or $Contents.Description -eq "[]") {
            $Table.cell($StartCell,5).range.text = "No Description"
            $Remarks += $StartCell
        } else {
            $RemarkList = Get-Remarklist
            foreach($Remark in $RemarkList) {
                if ($Contents.Description.Contains($Remark)) {
                    $Remarks += $StartCell
                }
            }
        }

        $StartCell += 1
    }

    # Auto Formatting
    $Table.AutoFormat(16)

    # Making the headers look a bit nicer
    $Table.cell(1,1).range.Bold=1
    $Table.cell(1,2).range.Bold=1
    $Table.cell(1,3).range.Bold=1
    $Table.cell(1,4).range.Bold=1
    $Table.cell(1,5).range.Bold=1

    # Remark formatting - Make them stick out like a Vefsning in Rana
    foreach($Remark in $Remarks) {
        $Table.cell($Remark,1).Range.Shading.BackgroundPatternColor = 255
        $Table.cell($Remark,2).Range.Shading.BackgroundPatternColor = 255
        $Table.cell($Remark,3).Range.Shading.BackgroundPatternColor = 255
        $Table.cell($Remark,4).Range.Shading.BackgroundPatternColor = 255
        $Table.cell($Remark,5).Range.Shading.BackgroundPatternColor = 255
    }

    # Save the Word Document and Quit Word
    $Document.SaveAs($SaveToFile)
    $Document.close()
    $Word.Quit() 
}