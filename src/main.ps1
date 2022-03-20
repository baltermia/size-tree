using module .\DirectoryClasses.psm1

<# 
    .SYNOPSIS  
    Displays the Size of directories in a Tree-/GridView. Files are not shown, only their size is being taken into consideration.
 
    .DESCRIPTION 
    Given no parameter, the biggest directories on the computer are being shown in a GridView. Otherwise the given Directory is being displayed in a TreeView, showing the size of all child-folders.
 
    .INPUTS 
    The parameters are:- 
    
    Prompt (optional):  
    When given, the TreeView with all child-folders for the directory is shown. Otherwise a Gridview with the biggest directories is displayed.
 
    .OUTPUTS 
    TreeView, GridView
 
    .EXAMPLE 
    C:\PS> Show-SizeTree 
    Shows the GridView for the biggest directories.
 
    .EXAMPLE 
    C:\PS> Show-SizeTree "C:\Program Files (x86)\"
    Display the TreeView for the Program Files directory.
#> 
Function Show-SizeTree {
    [CmdletBinding()]
    param ( 
        [Parameter(Mandatory=$false)]
        [String] $Directory
    )

    Clear-Host
    Write-Host "Getting Directories... This might take a moment."

    $isDirSet = $PSBoundParameters.ContainsKey((Get-Variable Directory | Select-Object -ExpandProperty Name))

    $path = $Directory

    if (!$isDirSet) {
        $path = "C:\"
    }
    
    $dir = [Directory]::New($path, $isDirSet)

    "Path: '" + $dir.Path + "', Size: '" + $dir.Size+ "'" | Write-Host

    
}
