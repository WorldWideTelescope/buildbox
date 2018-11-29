# -*- powershell -*-
# Copyright 2018 the .Net Foundation
# Licensed under the MIT License
#
# Initial provisioning of the WWT buildbox machine. Very early on, we need the
# user to perform an interactive installation, so this script does very
# little.

Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey:

$env:ChocolateyInstall = "$($env:SystemDrive)\ProgramData\Chocolatey"
$ChocoInstallPath = "$($env:ChocolateyInstall)\bin"
$env:Path += ";$ChocoInstallPath"

if (!(Test-Path("$ChocoInstallPath\choco.exe"))) {
   iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco feature enable -n allowGlobalConfirmation
choco upgrade all

# Bits we can install now

choco install bower git iisexpress nodejs.install nuget.commandline

# Make a local directory for staging WWT files

mkdir C:\wwt

# Setup to allow the host machine to talk to the IIS Express server used to
# test the web client.

Set-NetFirewallProfile -all -DefaultInboundAction Allow -DefaultOutboundAction Allow
netsh http add urlacl url=http://localhost:26993/Default.aspx user=everyone

# Message to user

echo ""
echo "See README.md for the next step -- you must log in to the machine graphically."
