# Import Directory class
using module ".\Directory.psm1"

Add-Type -AssemblyName System.Windows.Forms

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

class DirectoryTreeView {
    hidden [System.Windows.Forms.Form]$Form

    DirectoryTreeView([Directory]$dir, [Bool]$showChildren = $true) {
        CreateForm
    }

    hidden [void] CreateForm() {
        $newForm = New-Object -TypeName System.Windows.forms.Form
        $newForm.Text = "SizeTree for " + $this.dir
        $newForm.Width = 400
        $newForm.Height = 600
        $newForm.AutoSize = $true
        $newForm.
        

        $treeView = New-Object -TypeName System.Windows.forms.TreeView

        $this.Form = $newForm
    }

    [void] ShowDialog() {
        $this.Form.ShowDialog
    }
}