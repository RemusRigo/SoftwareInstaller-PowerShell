# Software Installer: User's Guide



## Requirements

* Windows 10/11 with **Windows PowerShell 5.1** (included in Windows)
* [winget](https://learn.microsoft.com/windows/package-manager/winget/) (App Installer, included in Windows 11; can be installed from **Settings**)
* Optional: [scoop](https://scoop.sh) and [Chocolatey](https://chocolatey.org) (can be installed from **Settings**)
* Optional: Microsoft Excel, only for **XLSX>CSV**



## Install

1. Download the latest release from the [Releases page](https://github.com/RemusRigo/SoftwareInstaller-PowerShell/releases).
2. Copy the `Software Installer` folder to a location where you have write access, for example `D:\My Apps\Software Installer\`.
3. Start it, either way:
   * double-click `Software Installer.bat`, or
   * right-click `Software Installer.ps1` → **Run with PowerShell**.

> If Windows blocks the script, right-click it → **Properties** → check **Unblock** → **OK**.

|File|Description|
|-|-|
|`Software Installer.bat`|Starts the script|
|`Software Installer.ps1`|The main PowerShell script|
|`Software.csv`|The software database|
|`My Software.csv`|An example preset (your own list)|
|`Utilities\InstallChocolatey.ps1`|Installs the Chocolatey package manager|
|`Res\*.png`|Icons|
|`Excel\Software.xlsx`, `Excel\My Software.xlsx`|The databases in Excel format|



## Software tab

1. Choose a **Preset** (any `.csv` file in the script folder; click the refresh button after you add one).
2. Filter the list:
   * **Category**: choose it in the **Category** box, or right-click the **Category** column;
   * **Source**: check **winget**, **scoop** and/or **Chocolatey**.
3. Check the apps you want, then click a button:

|Button|Description|
|-|-|
|**Check**|Check which of the listed apps are installed (with `winget list`)|
|**Install**|Install the checked apps (`winget install -e --id <ID> --silent`)|
|**Uninstall**|Uninstall the checked apps|
|**Download**|Download the installers of the checked apps to the `Downloads` folder next to the script (`winget download`)|
|**Update**|Update **all** installed apps (`winget upgrade --all`, as administrator)|
|**Export**|Save the checked apps to a new CSV preset|
|**XLSX>CSV**|Convert an Excel database to CSV (needs Excel)|

> **Install**, **Uninstall** and **Download** work with **winget** apps; scoop and Chocolatey apps are listed but not installed yet.

The text under the list shows the description of the selected app, and how many items were loaded.



## Settings tab

|Group|Description|
|-|-|
|**Package Manager**|Check winget, scoop and/or Chocolatey, then click **Install** or **Update** to install/update the package manager itself|
|**Import/Export**|**Export** all the apps installed with winget to a JSON file (`<name> - <computer> - <user> - winget.json`); **Import** a JSON file to install the same apps on another PC (`winget import`)|
|**Path**|**Winget**: open the folder where winget keeps its downloaded packages|



## The software database (CSV)

```
Name,Description,ID,Category,Source
7-ZIP,File archiver,7zip.7zip,Archiver,winget
7-ZIP,File archiver,7zip,Archiver,scoop
```

|Column|Description|
|-|-|
|**Name**, **Description**|Shown in the list|
|**ID**|The package ID; find it with `winget search <name>`|
|**Category**|Used for the category filter|
|**Source**|`winget`, `scoop` or `choco`|

To make your own preset, copy `Software.csv`, keep only the apps you want, and save it in the script folder.



## Uninstall

Delete the `Software Installer` folder. The apps you installed stay installed.
