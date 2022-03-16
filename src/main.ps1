. "Directory.ps1"

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

    Function DisplayDirectory([String]$Directory) {
        $dir = [Directory]::New($Directory, $true)

        $dir.Display()
    }
    
    Function DisplayAllDirectories {
        $dir = [Directory]::New("C:\")
    }

    if ($PSBoundParameters.ContainsKey((Get-Variable Directory | Select-Object -ExpandProperty Name))) {
        DisplayDirectory($Directory)
    }
    else {
        DisplayAllDirectories
    }
}
