# Import Directory class
using module ".\DirectoryTreeView.ps1"

class Directory {

    [String]$Path
    [String]$Name
    [Double]$Size
    [System.Collections.Generic.IEnumerable[Directory]]$Children = $null; 

    Directory([String]$path, [Bool]$getChildren = $true) {
        $this.CheckIsFolder($path)

        $this.Path = $path
        
        $this.Size = $this.GetFolderSize($path)

        if ($getChildren) {
            $this.GetChildren
        }
    }

    Directory([String]$path, [Double]$size, [System.Collections.Generic.IEnumerable[Directory]]$children) {
        $this.Path = $path;
        $this.Size = $size;
        $this.Cildren = $children;
    }

    [void] GetChildren() {

    }

    [double] GetFolderSize([string]$path) {
        $this.CheckIsFolder($path)
        Get-ChildItem $path -Recurse | Out-GridView
        return (Get-ChildItem $path -Recurse | Measure-Object -Property Length -Sum).Sum
    }

    [Void] CheckIsFolder([string]$path) {
        if (!(Test-Path -Path $path -PathType Container)) {
            throw "Directory does not exist"
        }
    }

    [string] GetSizeAsString() {
        return "TODO"
    }

    <#. 
        .DESCRIPTION
        Displays the Directory object
    .#>
    [void]Display([bool]$includeChildren = $true) {
        $treeView = [DirectoryTreeView]::New($this)

        $treeView.ShowDialog()
    }
}
