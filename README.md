# Software Installer
Software Installer: a PowerShell GUI script to install, uninstall and update software with the winget package manager



## Author

* [@remusrigo](https://github.com/RemusRigo)
* [@remusrigo](https://sourceforge.net/u/remusrigo/profile)



## Features

* Software list (~400 apps) from a CSV file: name, ID, category, source (winget / scoop / Chocolatey)
* Filter by category (right-click the Category column) and by source
* Presets: your own CSV lists (e.g. `My Software.csv`)
* Check if the selected apps are installed
* Install, uninstall and download the selected apps; update all installed apps
* Export the selected apps to a CSV preset
* Convert the Excel database (`.xlsx`) to CSV
* Settings: install/update the package managers (winget, scoop, Chocolatey), import/export your apps with `winget import` / `winget export`
* Tooltips, greeting and total of items loaded



## User's Guide

See the [User's Guide](UsersGuide.md) for requirements, installation and usage.



## Statistics

![PowerShell](https://img.shields.io/badge/Language-PowerShell-blue)
![VSCode](https://img.shields.io/badge/IDE-VS%20Code-purple)
![CMD](https://img.shields.io/badge/CMD-winget-yellow)
![CSV](https://img.shields.io/badge/File-CSV-yellow)
<br>
![status](https://img.shields.io/badge/status-completed-brightgreen) 
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/RemusRigo/SoftwareInstaller-PowerShell/total)



## Roadmap

* 2025-07-30: Upd: Reorganized source code (grouped GUI components / functions /  methods )
* 2025-07-29: Upd: Rewrote the function to check if App is installed
* 2025-07-28: Add: Download button
* 2025-06-03: Add: image for the Refresh Button
* 2025-05-15: Add: presets (custom CSV lists)
* 2025-05-15: Add: Context Menu for ListView Right-Click on the Category column
* 2025-05-15: Add: tooltips
* 2025-05-15: Add: procedure to convert from Excel to CSV
* 2025-05-15: Add: label to display greeting and total of items loaded
* 2025-05-08: Add: category
* 2025-05-08: Add: settings for winget / scoop / Chocolatey (install and update only)
* 2025-04-11: Upd: replace local DB with csv file
* 2025-03-30: Add: create local DB
* 2025-03-16: Project started
