# Import Directory class
using module ".\Directory.ps1"

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Add-Type -AssemblyName System.Windows.Forms


class DirectoryTreeView {
    hidden [System.Windows.Forms.Form]$Form

    DirectoryTreeView([Directory]$dir, [Bool]$showChildren = $true) {
        CreateForm
    }

    hidden [void] CreateForm() {
        $newForm = [System.Windows.Forms.Form]::New
        $treeView = [System.Windows.Forms.TreeView]::New

        $newForm.Text = "SizeTree for " + $this.dir
        $newForm.Width = 400
        $newForm.Height = 600
        $newForm.AutoSize = $true
        $newForm.
        



        $newForm.Controls.Add($treeView)
        $this.Form = $newForm
    }

    [void] ShowDialog() {
        $this.Form.ShowDialog
    }
}
