# Software Installer

A PowerShell GIU script to install software via the winget package manager.



## Authors

* [@remusrigo](https://github.com/RemusRigo)
* [@remusrigo](https://sourceforge.net/u/remusrigo/profile)



## Installation

Just right click on "Software Installer.ps1 and select "Run with PowerShell" or run the "Software Installer.bat"

Files:
* Software Installer.bat: start the script
* Software Installer.ps1: main PowerShell script
* Software.csv: software database in csv format
* Software.xlsx: software database in Excel format
* Utilities\\InstallChocolatey.ps1: PowerShell script to install Chocolatey Package Manager
* Res\\\*.png: PNG Icons



## Statistics

![status](https://img.shields.io/badge/status-completed-brightgreen)
<br>
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/RemusRigo/SoftwareInstaller-PowerShell/total)



## Roadmap

* 2025-07-30: Reorganized source code (grouped GUI components / functions /  methods )
* 2025-07-29: Rewrote the function to check if App is installed
* 2025-07-28: Add: Download button
* 2025-06-03: Add: image for the Refresh Button
* 2025-05-15: Add: presets (custom CSV lists)
* 2025-05-15: Add: Context Menu for ListView Right-Click on the Category column
* 2025-05-15: Add: tooltips
* 2025-05-15: Add: procedure to convert from Excel to CSV
* 2025-05-15: Add: label to display greeting and total of items loaded
* 2025-05-08: Add: category
* 2025-05-08: Add: settings for winget / scoop / Chocolatey (install and update only)
* 2025-04-11: replace local DB with csv file
* 2025-03-30: create local DB
* 2025-03-16: Project started

