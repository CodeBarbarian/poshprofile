function Get-DirectoryContents {
    [cmdletbinding()]
    param (
        [parameter(mandatory = $true)]
        [string] $Directory
    )

    if (Test-Path $Directory) {
        $ChurchCollectionPlate = Get-ChildItem -Path $Directory -Recurce
    }

    return $ChurchCollectionPlate
}

$Pictures_ACL = @(
    ".jpg",
    ".jpeg",
    ".jfif",
    ".bmp",
    ".png",
    ".tiff",
    ".exif",
    ".gif",
    ".ppm",
    ".pgm",
    ".pbm",
    ".pnm"
)

$Documet_ACL = @(
    ".doc",
    ".docm",
    ".docx",
    ".xls",
    ".xlsb",
    ".xlsm",
    ".xlsx",
    ".rtf",
    ".ppx"
)

$Archive_ACL

$LogFiles_ACL = @(
    ".log",
    ".syslog",
    ".logg"
)

$Videos_ACL
$Music_ACL
$Websites_ACL
$Software_ACL
$Shortcuts_ACL
$Scripts_ACL
$Fonts_ACL



# https://en.wikipedia.org/wiki/List_of_file_formats

