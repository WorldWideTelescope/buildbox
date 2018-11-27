# -*- powershell -*-
# Copyright 2018 the .Net Foundation
# Licensed under the MIT License
#
# "stage1" provisioning: run after the user has installed dotnet3.5 and
# rebooted the machine.

Set-ExecutionPolicy Bypass -Scope Process -Force

# We can now install Visual Studio.

choco install visualstudio2015community --timeout=4800 --package-parameters "--AdminFile c:\vagrant\AdminDeployment.xml"

# Message to user

echo ""
echo "See README.md for the next step"
