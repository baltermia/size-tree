Add-Type -AssemblyName System.Windows.Forms


class Directory {
    [String]$Path
    [String]$Name
    [System.Collections.Generic.IEnumerable[Directory]]$Children

    Directory([String]$path, [Bool]$getChildren = $true) {
        $this.CheckIsFolder($path)

        $this.Path = $path

        if ($getChildren) {
            $this.GetChildren()
        }
    }

    [double] GetSize() {
        if (![Linq.Enumerable]::Any($this.Children)) {
            return (Get-ChildItem $this.Path -Recurse | Measure-Object -Property Length -Sum).Sum
        }

        $sum = 0;

        foreach ($dir in $this.Children) {
            $sum += $dir.GetSize()
        }

        return $sum
   }

    [void] GetChildren() {
        $this.Children = New-Object System.Collections.Generic.List[Directory]

        foreach ($subdir in Get-ChildItem -Path $this.Path -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName) {
            $this.Children.Add([Directory]::New($subdir.Fullname, $true))
        }
    }

    [Void] CheckIsFolder([string]$path) {
        if (!(Test-Path -Path $path -PathType Container)) {
            throw "Directory does not exist"
        }
    }

    [string] GetSizeAsString() {
        $result = ""
        $bytes = 1024
        [String[]]$list = ("Bytes", "KB", "MB", "GB")

        $tmpSize = $this.GetSize()

        for ($i = $list.Length - 1; $i -ge 0; $i--) {
            $pow = [Math]::Pow($bytes, $i)

            if ($pow -gt $tmpSize) {
                continue
            }

            $rest = $tmpSize % $pow

            $result += (($tmpSize - $rest) / $pow).ToString() + " " + $list[$i] + " "

            $tmpSize = $rest
        }

        return $result
    }

    <#. 
        .DESCRIPTION
        Displays the Directory object
    .#>
    [void]Display([bool]$includeChildren = $true) {
        $newForm = New-Object System.Windows.Forms.Form

        $newForm.Text = "SizeTree for " + $this.Directory
        $newForm.Width = 400
        $newForm.Height = 600
        $newForm.AutoSize = $true
        
        $newForm.ShowDialog()
    }
}
