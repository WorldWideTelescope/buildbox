# -*- powershell -*-
# Copyright 2018 the .Net Foundation
# Licensed under the MIT License
#
# Run a command in the web client tree. Hopefully no escaping will be needed
# since it would be gross ...

cd c:\vagrant\wwt-web-client\webclient
Invoke-Expression ($args -join " ")

