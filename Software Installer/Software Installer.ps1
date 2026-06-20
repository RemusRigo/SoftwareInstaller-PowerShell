#---------------------------------------------------------------------------------------------------------------------------
# Software Installer
#    © 2025 Remus Rigo
#       v1.2 2025-07-29                                                     [System.Windows.Forms.MessageBox]::Show("Test")
#---------------------------------------------------------------------------------------------------------------------------

Clear-Host
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$appTitle = "Software Install v1.2 by Remus Rigo"

# --------------------------------------------------------------------------------------------------------------------------
# Initialize

$currentCategory = "*"
$currentPreset = "Software.csv"
$csvPath = Join-Path -Path $PSScriptRoot -ChildPath $currentPreset
if (-Not (Test-Path $csvPath)) {
    [System.Windows.Forms.MessageBox]::Show("CSV not found at: $csvPath", "Error", "OK", "Error")
    exit
}
$swDB = Import-Csv -Path $csvPath
$tooltip = New-Object System.Windows.Forms.ToolTip

$downloadPath = Join-Path -Path $PSScriptRoot -ChildPath "Downloads"
$downloadPathQuoted = "`"$downloadPathQuoted`""

if (!(Test-Path -Path $downloadPath))
{
   New-Item -ItemType Directory -Path $downloadPath
}

#---------------------------------------------------------------------------------------------------------------------------
# Form: Main

$frmMain = New-Object System.Windows.Forms.Form
$frmMain.AutoScroll = $true
$frmMain.FormBorderStyle = "FixedSingle"
$frmMain.MaximizeBox = $false
$frmMain.MinimizeBox = $true
$frmMain.Size = New-Object System.Drawing.Size(([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width*0.7), ([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height*0.8))
$frmMain.StartPosition = "CenterScreen"
$frmMain.Text = $appTitle

# TabControl
$tabControlMain = New-Object System.Windows.Forms.TabControl
$tabControlMain.Dock = 'Fill'

# TabPage: Software
$tabPageSW = New-Object System.Windows.Forms.TabPage
$tabPageSW.Text = "Software"

#---------------------------------------------------------------------------------------------------------------------------
# ListView

$lvSW = New-Object System.Windows.Forms.ListView
$lvSW.Location = New-Object System.Drawing.Point(3,3)
$lvSW.Size = New-Object System.Drawing.Size(($frmMain.Width-270),($frmMain.Height-100))
$lvSW.View = [System.Windows.Forms.View]::Details
$lvSW.FullRowSelect = $true
$lvSW.CheckBoxes = $true
$lvSW.Columns.Add("Name", 320)
$lvSW.Columns.Add("Description", 0) # hide column
$lvSW.Columns.Add("ID", 250)
$lvSW.Columns.Add("Category", 120)
$lvSW.Columns.Add("Source", 80)

   $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
   $categoryList = @("*")
   for ($i = 0; $i -le ($swDB.Count-1); $i++)
   {
      $categoryList += $swDB[$i].Category
   }
   $uniqueCategories = $categoryList | Where-Object { $_ -ne "" -and $_ -ne $null } | Sort-Object -Unique
   # Convert strings into ToolStripMenuItem objects
   $menuItems = @()
   foreach ($category in $uniqueCategories)
   {
      $menuItems += New-Object System.Windows.Forms.ToolStripMenuItem($category)
   }
   $contextMenu.Items.AddRange($menuItems)

   # add OnClick event for all menu items
   foreach ($menuItem in $menuItems) {
     $menuItem.Add_Click({
        param($sender, $e)
        $currentCategory = $sender.Text
        LoadDBItems
     })
   }


#---------------------------------------------------------------------------------------------------------------------------
# GroupBox: Category

$grpBoxCategory = New-Object System.Windows.Forms.GroupBox
$grpBoxCategory.Location = New-Object System.Drawing.Point(($lvSW.Location.X+$lvSW.Width+20),2)
$grpBoxCategory.Size = New-Object System.Drawing.Size(200,50)
$grpBoxCategory.Text = "Category"

$cbCategory = New-Object System.Windows.Forms.ComboBox
$cbCategory.Location = New-Object System.Drawing.Point(5,20)
$cbCategory.Size = New-Object System.Drawing.Size(190,20)
$cbCategory.Items.Clear()
$cbCategory.Items.AddRange($uniqueCategories)
$cbCategory.Text = $currentCategory

#---------------------------------------------------------------------------------------------------------------------------
# GroupBox: Source

$grpBoxSource = New-Object System.Windows.Forms.GroupBox
$grpBoxSource.Location = New-Object System.Drawing.Point(($grpBoxCategory.Location.X),$grpBoxCategory.Height)
$grpBoxSource.Size = New-Object System.Drawing.Size(200,90)
$grpBoxSource.Text = "Source"

# CheckBox: Winget ---------------------------------------------------------------------------------------------------------
$chkBoxSourceWinget = New-Object System.Windows.Forms.CheckBox
$chkBoxSourceWinget.Location = New-Object System.Drawing.Point(10,20)
$chkBoxSourceWinget.Text = "winget"
$chkBoxSourceWinget.Checked = $true
$tooltip.SetToolTip($chkBoxSourceWinget, "Select")

# CheckBox: Scoop ----------------------------------------------------------------------------------------------------------
$chkBoxSourceScoop = New-Object System.Windows.Forms.CheckBox
$chkBoxSourceScoop.Location = New-Object System.Drawing.Point(10,40)
$chkBoxSourceScoop.Text = "scoop"
$chkBoxSourceScoop.Checked = $true

# CheckBox: Chocolatey --------------------------------------------------------------------------------------------------------
$chkBoxSourceChoco = New-Object System.Windows.Forms.CheckBox
$chkBoxSourceChoco.Location = New-Object System.Drawing.Point(10,60)
$chkBoxSourceChoco.Text = "Chocolatey"
$chkBoxSourceChoco.Checked = $true

#---------------------------------------------------------------------------------------------------------------------------
# GroupBox: Presets

$grpBoxPresets = New-Object System.Windows.Forms.GroupBox
$grpBoxPresets.Location = New-Object System.Drawing.Point(($grpBoxSource.Location.X),($grpBoxSource.Location.Y+$grpBoxSource.Height))
$grpBoxPresets.Size = New-Object System.Drawing.Size(200,50)
$grpBoxPresets.Text = "Presets"

#---------------------------------------------------------------------------------------------------------------------------
# ComboBox: Presets

$cbPresets = New-Object System.Windows.Forms.ComboBox
$cbPresets.Location = New-Object System.Drawing.Point(5,20)
$cbPresets.Size = New-Object System.Drawing.Size(156,20)
$cbPresets.Items.Clear()
Get-ChildItem -Path $PSScriptRoot -Filter *.csv | ForEach-Object { $cbPresets.Items.Add($_.Name) }
$cbPresets.Text = $currentPreset

# Button: Refresh Presets
$pngFile = "$PSScriptRoot/Res/refresh_24.png"
$pngFile = [System.Drawing.Image]::FromFile($pngFile)
$btnRefreshPresets = New-Object System.Windows.Forms.Button
$btnRefreshPresets.Image = $pngFile
$btnRefreshPresets.Location = New-Object System.Drawing.Point(($cbPresets.Location.X+$cbPresets.Width+3), ($cbPresets.Location.Y-8))
$btnRefreshPresets.Size = New-Object System.Drawing.Size(30,30)
$tooltip.SetToolTip($btnRefreshPresets, "Refresh Presets")

# Button: Check 
$btnCheck = New-Object System.Windows.Forms.Button
$btnCheck.Text = "&Check"
$btnCheck.Location = New-Object System.Drawing.Point($grpBoxPresets.Location.X, ($grpBoxPresets.Location.Y+$grpBoxPresets.Height+3))
$tooltip.SetToolTip($btnCheck, "Check if app is installed")

# Label: Description
$lblDescription = New-Object System.Windows.Forms.Label
$lblDescription.Dock = "Bottom"
$lblDescription.Text = "Welcome"
$lblDescription.AutoSize = $true

# Button: Install 
$btnInstall = New-Object System.Windows.Forms.Button
$btnInstall.Location = New-Object System.Drawing.Point(($lvSW.Width+12), ($lvSW.Height-82))
$btnInstall.Text = "&Install"
$tooltip.SetToolTip($btnInstall, "Install selected apps")

# Button: Uninstall 
$btnUninstall = New-Object System.Windows.Forms.Button
$btnUninstall.Location = New-Object System.Drawing.Point(($btnInstall.Location.X+$btnInstall.Width+3), ($btnInstall.Location.Y))
$btnUninstall.Text = "&Uninstall"
$tooltip.SetToolTip($btnUninstall, "Uninstall selected apps")

# Button: Download
$btnDownload = New-Object System.Windows.Forms.Button
$btnDownload.Location = New-Object System.Drawing.Point(($btnInstall.Location.X), ($btnInstall.Location.Y+$btnInstall.Height))
$btnDownload.Text = "&Download"
$tooltip.SetToolTip($btnDownload, "Download selected apps")

# Button: Update
$btnUpdate = New-Object System.Windows.Forms.Button
$btnUpdate.Location = New-Object System.Drawing.Point(($btnDownload.Location.x+$btnDownload.Width+3), ($btnDownload.Location.Y))
$btnUpdate.Text = "&Update"
$tooltip.SetToolTip($btnUpdate, "Update installed apps")

# Button: Export Selected
$btnExportSelected = New-Object System.Windows.Forms.Button
$btnExportSelected.Location = New-Object System.Drawing.Point(($btnDownload.Location.X), ($btnDownload.Location.Y+$btnDownload.Height))
$btnExportSelected.Text = "Export"
$tooltip.SetToolTip($btnExportSelected, "Export selected items to CSV")

# Button: XLSX 2 CSV
$btnConvert = New-Object System.Windows.Forms.Button
$btnConvert.Location = New-Object System.Drawing.Point(($btnExportSelected.Location.x+$btnExportSelected.Width+3), ($btnExportSelected.Location.Y))
$btnConvert.Text = "XLSX>CSV"
$tooltip.SetToolTip($btnConvert, "Convert Excel to CSV")

# TabPage: Settings --------------------------------------------------------------------------------------------------------

$tabPageSettings = New-Object System.Windows.Forms.TabPage
$tabPageSettings.Text = "Settings"

$grpBoxPkgMngr = New-Object System.Windows.Forms.GroupBox
$grpBoxPkgMngr.Location = New-Object System.Drawing.Point(5,5)
$grpBoxPkgMngr.Size = New-Object System.Drawing.Size(150,120)
$grpBoxPkgMngr.Text = "Package Manager"

$chkBoxWinget = New-Object System.Windows.Forms.CheckBox
$chkBoxWinget.Location = New-Object System.Drawing.Point(10,20)
$chkBoxWinget.Text = "winget"

$chkBoxScoop = New-Object System.Windows.Forms.CheckBox
$chkBoxScoop.Location = New-Object System.Drawing.Point(10,40)
$chkBoxScoop.Text = "scoop"

$chkBoxChoco = New-Object System.Windows.Forms.CheckBox
$chkBoxChoco.Location = New-Object System.Drawing.Point(10,60)
$chkBoxChoco.Text = "Chocolatey"

# Button: Install Package Manager
$btnInstallPkgMngr = New-Object System.Windows.Forms.Button
$btnInstallPkgMngr.Location = New-Object System.Drawing.Point(10, 90)
$btnInstallPkgMngr.Width = 60
$btnInstallPkgMngr.Text = "Install"
$btnInstallPkgMngr.Add_Click({ Install-PackageManagers })

# Button: Update Package Manager
$btnUpdatePkgMngr = New-Object System.Windows.Forms.Button
$btnUpdatePkgMngr.Location = New-Object System.Drawing.Point(70, 90)
$btnUpdatePkgMngr.Width = 60
$btnUpdatePkgMngr.Text = "Update"

# GroupBox: Import/Export
$grpBoxImpExpApps = New-Object System.Windows.Forms.GroupBox
$grpBoxImpExpApps.Location = New-Object System.Drawing.Point(($grpBoxPkgMngr.Location.X+$grpBoxPkgMngr.Width+5),5)
$grpBoxImpExpApps.Size = New-Object System.Drawing.Size(150,120)
$grpBoxImpExpApps.Text = "Import/Export"

# Button: Import Apps
$btnImportApps = New-Object System.Windows.Forms.Button
$btnImportApps.Location = New-Object System.Drawing.Point(5, 15)
$btnImportApps.Width = 60
$btnImportApps.Text = "Import"

# Button: Export Apps
$btnExportApps = New-Object System.Windows.Forms.Button
$btnExportApps.Location = New-Object System.Drawing.Point($btnImportApps.Location.X, ($btnImportApps.Location.Y+$btnImportApps.Height+3))
$btnExportApps.Width = 60
$btnExportApps.Text = "Export"

# GroupBox: Path
$grpBoxPath = New-Object System.Windows.Forms.GroupBox
$grpBoxPath.Location = New-Object System.Drawing.Point(($grpBoxImpExpApps.Location.X+$grpBoxImpExpApps.Width+5),5)
$grpBoxPath.Size = New-Object System.Drawing.Size(150,120)
$grpBoxPath.Text = "Path"

# Button: Winget Path
$btnPathWinget = New-Object System.Windows.Forms.Button
$btnPathWinget.Location = New-Object System.Drawing.Point(5, 15)
$btnPathWinget.Width = 60
$btnPathWinget.Text = "Winget"

# Load items in ListView ---------------------------------------------------------------------------------------------------
function LoadDBItems
{
   $startProcess = Get-Date
   $lvSW.Items.Clear()
   $lvSW.BeginUpdate()
   $items = New-Object System.Collections.Generic.List[System.Windows.Forms.ListViewItem]
   for ($i = 0; $i -le ($swDB.Count-1); $i++)
   {
      if (($currentCategory -eq "*") -or ($currentCategory -eq $swDB[$i].Category))
      {
         if ($chkBoxSourceWinget.Checked -and ($swDB[$i].Source -eq "winget"))
         {
            $item = New-Object System.Windows.Forms.ListViewItem($swDB[$i].Name)
            $item.SubItems.Add($swDB[$i].Description)
            $item.SubItems.Add($swDB[$i].ID)
            $item.SubItems.Add($swDB[$i].Category)
            $item.SubItems.Add($swDB[$i].Source)
            $items.Add($item)
         }
         if ($chkBoxSourceScoop.Checked -and ($swDB[$i].Source -eq "scoop"))
         {
            $item = New-Object System.Windows.Forms.ListViewItem($swDB[$i].Name)
            $item.SubItems.Add($swDB[$i].Description)
            $item.SubItems.Add($swDB[$i].ID)
            $item.SubItems.Add($swDB[$i].Category)
            $item.SubItems.Add($swDB[$i].Source)
            $items.Add($item)
         }
         if ($chkBoxSourceChoco.Checked -and ($swDB[$i].Source -eq "choco"))
         {
            $item = New-Object System.Windows.Forms.ListViewItem($swDB[$i].Name)
            $item.SubItems.Add($swDB[$i].Description)
            $item.SubItems.Add($swDB[$i].ID)
            $item.SubItems.Add($swDB[$i].Category)
            $item.SubItems.Add($swDB[$i].Source)
            $items.Add($item)
         }
      }
   }
   $lvSW.Items.AddRange($items.ToArray())
   $lvSW.EndUpdate()
   $endProcess = Get-Date
   $duration = $endProcess - $startProcess
   $lblDescription.Text = "Welcome $($env:USERNAME) / Loaded $($lvSW.Items.Count) items in $($duration.TotalSeconds) seconds"
   #auto-size columns
   $lvSW.Columns[0].AutoResize([System.Windows.Forms.ColumnHeaderAutoResizeStyle]::ColumnContent)
   $lvSW.Columns[2].AutoResize([System.Windows.Forms.ColumnHeaderAutoResizeStyle]::ColumnContent)
   $lvSW.Columns[3].AutoResize([System.Windows.Forms.ColumnHeaderAutoResizeStyle]::ColumnContent)
   $lvSW.Columns[4].AutoResize([System.Windows.Forms.ColumnHeaderAutoResizeStyle]::ColumnContent)
}

#---------------------------------------------------------------------------------------------------------------------------
# Install / Uninstall

function Install-SelectedApps
{
   param ([bool]$action)

   for ($i = 0; $i -lt $lvSW.Items.Count; $i++)
   {
      if ($lvSW.Items[$i].checked)
      {
         $id = $lvSW.Items[$i].SubItems[2].Text
         $src = $lvSW.Items[$i].SubItems[4].Text
         switch ($src)
         {
            "winget"
            {
               if ($action)
               {
                  $param="install -e --id $id --silent"
               }
               else
               {
                  $param="uninstall -e --id $id --silent"
               }
            Start-Process "winget" -ArgumentList $param -Wait
            }
         }
      }
   }
}

#---------------------------------------------------------------------------------------------------------------------------

function Check-InstalledApps
{
   $wingetApps = winget list
   for ($i = 0; $i -lt $lvSW.Items.Count; $i++)
   {
      $src = $lvSW.Items[$i].SubItems[4].Text
      switch ($src)
      {
         "winget"
         { 
            if ( $wingetApps -match $lvSW.Items[$i].SubItems[2].Text )
            {
                  $lvSW.Items[$i].checked = $true
            }
         }
            
      }
   }
}

function Check-InstalledAppsOld
{
   #$installedPackages = Get-Package
   $wingetApps = winget list
   
   for ($i = 0; $i -lt $lvSW.Items.Count; $i++)
   {
      $src = $lvSW.Items[$i].SubItems[4].Text
      switch ($src)
      {
         "winget"
         { 
            
            if ($lvSW.Items[$i].Text -eq $swDB[$i].Name)
            {
               [System.Windows.Forms.MessageBox]::Show($appID)
               $appID = $swDB[$i].ID
			      if ($wingetApps | Where-Object { $_ -like "*$appID*" })
               {
                  [System.Windows.Forms.MessageBox]::Show("Test")
                  $lvSW.Items[$i].checked = $true
               }
            }
            
         }
      }
   }
}
#---------------------------------------------------------------------------------------------------------------------------

function Download-SelectedApps
{
   for ($i = 0; $i -lt $lvSW.Items.Count; $i++)
   {
      if ($lvSW.Items[$i].checked)
      {
         $id = $lvSW.Items[$i].SubItems[2].Text
         $src = $lvSW.Items[$i].SubItems[4].Text
         switch ($src)
         {
            "winget"
            {
               #$cmdArgs = "/c winget download --id $id --download-directory `"$downloadPath`""
               #Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArgs
               $cmdArgs = "download --id $id --download-directory `"$downloadPath`""
               Start-Process -FilePath "winget" -ArgumentList $cmdArgs
            }
         }
      }
   }
}

#---------------------------------------------------------------------------------------------------------------------------

function Update-InstalledApps {
   Start-Process -Verb RunAs "cmd" -ArgumentList "/k winget upgrade --all --accept-source-agreements --accept-package-agreements --scope=machine --silent"
}
   
#---------------------------------------------------------------------------------------------------------------------------

function Export-SelectedAppsToCSV {
   $checkedItems = @()
   foreach ($item in $lvSW.CheckedItems)
   {
      $checkedItems += [PSCustomObject]@{
         Name = $item.SubItems[0].Text
         Description = $item.SubItems[1].Text
         ID = $item.SubItems[2].Text
         Category = $item.SubItems[3].Text
         Source = $item.SubItems[4].Text
      }
   }
   $dlgSave = New-Object System.Windows.Forms.SaveFileDialog
   $dlgSave.InitialDirectory = Split-Path -Path $PSCommandPath -Parent
   $dlgSave.Filter = "CSV files (*.csv)|*.csv|All files (*.*)|*.*"
   if ($dlgSave.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
   {
      $checkedItems | Export-Csv -Path $dlgSave.FileName -NoTypeInformation
   }
}

#---------------------------------------------------------------------------------------------------------------------------

function Convert-ExcelToCSV {
   $dlgOpenFile = New-Object System.Windows.Forms.OpenFileDialog
   $dlgOpenFile.InitialDirectory = Split-Path -Path $PSCommandPath -Parent
   $dlgOpenFile.Filter = "Excel Files (*.xlsx)|*.xlsx"
   $dlgResult = $dlgOpenFile.ShowDialog()
   if ($dlgResult -eq [System.Windows.Forms.DialogResult]::OK)
   {
      $xlsxFile = $dlgOpenFile.FileName
      $csvFile = "$($xlsxFile -replace '\.xlsx$', '.csv')"
      # Create an Excel application object
      $excel = New-Object -ComObject Excel.Application
      $excel.Visible = $false
      # Open the workbook
      $workbook = $excel.Workbooks.Open($xlsxFile)
      # Save the first worksheet as CSV
      $workbook.SaveAs($csvFile, 6) # 6 represents CSV format
      # Close the workbook and quit Excel
      $workbook.Close($false)
      $excel.Quit()
      # Release the COM object
      [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook)
      [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
      Write-Host "Conversion completed: $csvFile"
   }
   else
   {
      Write-Host "No file was selected."
   }
}
   
#---------------------------------------------------------------------------------------------------------------------------
   
function Install-PackageManagers {
   if ($chkBoxWinget.Checked)
   {

   }
   if ($chkBoxScoop.Checked)
   {
      if (Get-Command scoop -ErrorAction SilentlyContinue)
      {
         Write-Output "Scoop is installed."
      }
      else
      {
         Write-Output "Installing Scoop..."
         Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
         Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
      }
   }
   if ($chkBoxChoco.Checked)
   {
      if (Get-Command choco -ErrorAction SilentlyContinue)
      {
         Write-Output "Chocolatey is installed."
      }
      else
      {
         Write-Output "Installing Chocolatey..."
         $chocoPath = Join-Path -Path $PSScriptRoot -ChildPath "Utilities\InstallChocolatey.ps1"
         Start-Process -Verb RunAs "powershell" -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$chocoPath`"" -Wait
      }
   }
}

#---------------------------------------------------------------------------------------------------------------------------

function Update-PackageManagers {
   if ($chkBoxWinget.Checked)
   {
      Start-Process "winget" -ArgumentList "install --id Microsoft.AppInstaller" -Wait  
      Start-Process "winget" -ArgumentList "upgrade --id Microsoft.AppInstaller" -Wait
   }
}

#---------------------------------------------------------------------------------------------------------------------------

function Winget-ImportInstalledApps {
   $dlgOpenFile = New-Object System.Windows.Forms.OpenFileDialog
   $dlgOpenFile.InitialDirectory = Join-Path -Path $PSScriptRoot -ChildPath "Installed Apps\winget"
   $dlgOpenFile.Filter = "json configuration file (*.json)|*.json"
   $dlgResult = $dlgOpenFile.ShowDialog()
   if ($dlgResult -eq [System.Windows.Forms.DialogResult]::OK)
   {
      winget import -i $dlgOpenFile.FileName
   }
   else
   {
      Write-Host "No file was selected."
   }
}

#---------------------------------------------------------------------------------------------------------------------------

function Winget-ExportInstalledApps {
   $exportedApps = Join-Path -Path $PSScriptRoot -ChildPath "Installed Apps\winget"
   if (!(Test-Path -Path $exportedApps))
   {
      New-Item -ItemType Directory -Path $exportedApps
   }
   $exportedAppsFile = Get-Date -Format "yyyy-MM-dd"
   $exportedApps = Join-Path -Path $exportedApps -ChildPath "$($exportedAppsFile) - $($env:COMPUTERNAME) - $($env:USERNAME) - winget.json"
   winget export -o $exportedApps
}

#---------------------------------------------------------------------------------------------------------------------------

function Winget-OpenPackagesPath {
   Start-Process "explorer" -ArgumentList "$($env:userprofile)\AppData\Local\Microsoft\WinGet\Packages"
}

#---------------------------------------------------------------------------------------------------------------------------
# Methods/Events

$lvSW.Add_SelectedIndexChanged({
   if ($lvSW.SelectedItems.Count -gt 0)
   {
      $result = $swDB | Where-Object { $_.ID -eq $lvSW.SelectedItems[0].SubItems[1].Text }
      if ($result)
      {
         $lblDescription.Text = $result.Description
      }
   }
})

$lvSW.Add_ColumnClick({
    param($sender, $e)
    
    # Check if the clicked column is the "Category" column (index 0)
    if ($e.Column -eq 3)
    {
        $headerX = $lvSW.Location.X + $lvSW.Columns[0].Width +$lvSW.Columns[1].Width + $lvSW.Columns[2].Width
        $contextMenu.Show($lvSW, [System.Drawing.Point]::new($headerX, $lvSW.Location.Y))
    }
})

$cbCategory.Add_SelectedIndexChanged({
   $currentCategory = $cbCategory.SelectedItem
   LoadDBItems
})

$chkBoxSourceWinget.Add_Click({
   $currentCategory = $cbCategory.SelectedItem
   LoadDBItems
})
$chkBoxSourceScoop.Add_Click({
   $currentCategory = $cbCategory.SelectedItem
   LoadDBItems
})
$chkBoxSourceChoco.Add_Click({
   $currentCategory = $cbCategory.SelectedItem
   LoadDBItems
})

$cbPresets.Add_SelectedIndexChanged({
   $cbPresets.Text = $cbPresets.SelectedItem
   $csvPath = Join-Path -Path $PSScriptRoot -ChildPath $cbPresets.SelectedItem
   $swDB = @()
   $swDB = Import-Csv -Path $csvPath
   LoadDBItems
   $cbCategory.Text = ""
   $cbCategory.Items.Clear()
   $categoryList = @("*")
   for ($i = 0; $i -le ($swDB.Count-1); $i++) {
      $categoryList += $swDB[$i].Category
   }
   $uniqueCategories = $categoryList | Where-Object { $_ -ne "" -and $_ -ne $null } | Sort-Object -Unique
   $cbCategory.Items.AddRange($uniqueCategories)
})

$btnRefreshPresets.Add_Click({
   $cbPresets.Items.Clear()
   Get-ChildItem -Path $PSScriptRoot -Filter *.csv | ForEach-Object { $cbPresets.Items.Add($_.Name) }   
})

$btnInstall.Add_Click({ Install-SelectedApps($true) })
$btnUninstall.Add_Click({ Install-SelectedApps($false) })
$btnCheck.Add_Click({ Check-InstalledApps })
$btnDownload.Add_Click({ Download-SelectedApps })
$btnUpdate.Add_Click({ Update-InstalledApps })
$btnExportSelected.Add_Click({ Export-SelectedAppsToCSV })
$btnConvert.Add_Click({ Convert-ExcelToCSV })

$btnUpdatePkgMngr.Add_Click({ Update-PackageManagers })
$btnImportApps.Add_Click({ Winget-ImportInstalledApps })
$btnExportApps.Add_Click({ Winget-ExportInstalledApps })
$btnPathWinget.Add_Click({ Winget-OpenPackagesPath })

#---------------------------------------------------------------------------------------------------------------------------
# Methods/Controls

$grpBoxCategory.Controls.Add($cbCategory)
$grpBoxSource.Controls.AddRange(@($chkBoxSourceWinget, $chkBoxSourceScoop, $chkBoxSourceChoco))
$grpBoxPresets.Controls.AddRange(@($cbPresets, $btnRefreshPresets))
$tabPageSW.Controls.AddRange(@($lvSW, $grpBoxCategory, $grpBoxSource, $grpBoxPresets, $btnCheck, $btnInstall, $btnUninstall, $btnDownload, $btnUpdate, $btnExportSelected, $btnConvert, $lblDescription))

$grpBoxPkgMngr.Controls.AddRange(@($chkBoxWinget, $chkBoxScoop, $chkBoxChoco, $btnInstallPkgMngr, $btnUpdatePkgMngr))
$grpBoxImpExpApps.Controls.AddRange(@($btnImportApps, $btnExportApps))
$grpBoxPath.Controls.Add($btnPathWinget)
$tabPageSettings.Controls.AddRange(@($grpBoxPkgMngr, $grpBoxImpExpApps, $grpBoxPath))

$tabControlMain.TabPages.AddRange(@($tabPageSW, $tabPageSettings))

$frmMain.Controls.Add($tabControlMain)

#---------------------------------------------------------------------------------------------------------------------------

$frmMain.Add_Shown({
   $frmMain.Activate()
   LoadDBItems
})

[void] $frmMain.ShowDialog()