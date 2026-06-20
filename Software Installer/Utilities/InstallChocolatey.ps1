#--------------------------------------------------------------------------------------------------
# Software Installer: Install Chocolatey Package Manager (as admin)
#  © 2025 Remus Rigo
# v1.0.20250508

Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


