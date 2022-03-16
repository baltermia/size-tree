class Directory {
    [String]$Path
    [String]$Name
    [Double]$Bytes
    [System.Collections.Generic.IEnumerable[Directory]]$Children = $null;

    Directory([String]$path, [Bool]$getChildren = $false) {
        if (!(Test-Path -Path $path -PathType Container)) {
            throw "Directory does not exist"
        }

        $path | FromPath 

        if ($getChildren) {
            GetChildren
        }
    }

    Direcotry([String]$path, [Double]$Bytes, [System.Collections.Generic.IEnumerable[Directory]]$children) {
        $this.Path = $path;
        $this.Bytes = $bytes;
        $this.Cildren = $children;
    }

    hidden FromPath([String]$path) {

    }

    [bool] GetChildren() {
        return $false;
    }

    <#. 
        .DESCRIPTION
        Displays the Directory object
    .#>
    [void]Display([bool]$includeChildren = $true) {

    }
}
