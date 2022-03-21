Add-Type -AssemblyName System.Windows.Forms

class Directory {
    [String]$Path
    [String]$Name
    [System.Collections.Generic.List[Directory]]$Children

    Directory([String]$path, [Bool]$getChildren = $true) {
        $this.CheckIsFolder($path)

        $this.Path = $path

        if ($getChildren) {
            $this.GetChildren()
        }
    }

    [double] GetSize() {
        if ($this.Children.Count -le 0) {
            return (Get-ChildItem $this.Path -Recurse | Measure-Object -Property Length -Sum).Sum
        }

        $sum = 0;

        foreach ($dir in $this.Children) {
            $sum += $dir.GetSize()
        }

        return $sum
   }

    [void] GetChildren() {
        $childDirs = Get-ChildItem -Path $this.Path -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName

        if ($childDirs.Length -le 0) {
            return
        }

        $list = $childDirs | ForEach-Object { return [Directory]::New($_.FullName, $true) }

        $this.Children = $list
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

    [object] GetTreeNode([bool]$firstNodeFullPath) {
        $nodeText = $this.Path 

        if (!$firstNodeFullPath) {
            $nodeText = $nodeText.Substring($this.Path.LastIndexOf("\"))
        }

        $nodeText += " - " + $this.GetSizeAsString()

        $node =  New-Object System.Windows.Forms.TreeNode
        $node.Name = $nodeText
        $node.Text = $nodeText

        foreach ($dir in $this.Children) {
            $node.Nodes.Add($dir.GetTreeNode($false))
        }

        return $node;
    }

    [void] Display() {
        if ($this.Children.Count -le 0) {
            "Path: '" + $this.Path + "', Size: '" + $this.GetSizeAsString() + "'" | Write-Host

            return
        }

        $newForm =  New-Object System.Windows.Forms.Form
        $treeView = New-Object System.Windows.Forms.TreeView 

        $newForm.Text = "SizeTree for " + $this.Path
        $newForm.Width = 500
        $newForm.Height = 500
        $newForm.AutoSize = $true

        $treeView.Dock = "Fill"
        $treeView.Font = [System.Drawing.Font]::New($treeView.Font.FontFamily, 14)
        $treeView.Nodes.Add($this.GetTreeNode($true))
        
        $newForm.Controls.Add($treeView)
        $newForm.ShowDialog()
    }
}
