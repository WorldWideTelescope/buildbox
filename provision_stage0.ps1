# -*- powershell -*-
# Copyright 2018-2019 the .Net Foundation
# Licensed under the MIT License
#
# Initial provisioning of the WWT buildbox machine. Very early on, we need the
# user to perform an interactive installation, so this script does very
# little.

Set-ExecutionPolicy Bypass -Scope Process -Force

# Avoid automatic poweroff!

powercfg /hibernate off
powercfg /x monitor-timeout-ac 0
powercfg /x monitor-timeout-dc 0
powercfg /x disk-timeout-dc 0
powercfg /x disk-timeout-ac 0
powercfg /x standby-timeout-ac 0
powercfg /x standby-timeout-dc 0
powercfg /x hibernate-timeout-dc 0
powercfg /x hibernate-timeout-ac 0

# Install Chocolatey:

$env:ChocolateyInstall = "$($env:SystemDrive)\ProgramData\Chocolatey"
$ChocoInstallPath = "$($env:ChocolateyInstall)\bin"
$env:Path += ";$ChocoInstallPath"

if (!(Test-Path("$ChocoInstallPath\choco.exe"))) {
   iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco feature enable -n allowGlobalConfirmation
choco upgrade all

# Bits we can install now. Within each invocation, keep packages alphabetized;
# separate invocations are for dependency ordering.

choco install nodejs.install
choco install bower git iisexpress nuget.commandline

# Make a local directory for staging WWT files

mkdir C:\wwt

# Setup to allow the host machine to talk to the IIS Express server used to
# test the web client.

Set-NetFirewallProfile -all -DefaultInboundAction Allow -DefaultOutboundAction Allow
netsh http add urlacl url=http://localhost:26993/Default.aspx user=everyone

# Message to user

echo "."
echo "."
echo "See README.md for the next step -- you must log in to the machine graphically."
