# -*- powershell -*-
# Copyright 2018 the .Net Foundation
# Licensed under the MIT License
#
# This is a PowerShell script for launching the IIS Express server to test the
# web client package. THIS IS A WORK IN PROGRESS! Some features don't work.

Set-ExecutionPolicy Bypass -Scope Process -Force

# Debug?
###Set-PSDebug -Trace 2

$srcdir = "C:\vagrant\wwt-web-client"
$runparent = "C:\wwt"
$rundir = "$runparent\webclient"

# IIS Express won't serve directly out of the c:\vagrant directory, seemingly
# because it is (fakily) network-mounted. So, copy the current tree to a local
# directory.

rm -recurse $rundir
cd $srcdir
cp -recurse webclient $runparent
cd $rundir

# We need to customize the applicationhost.config to work with our current
# setup and allow access from the VM host machine. We have to jump through
# some extra hoops to process the file, because otherwise PowerShell's text
# processing inserts a UTF8 Byte Order Marker that IIS's XML parser then
# rejects. Also note that PowerShell doesn't need to escape \'s in strings,
# but regular expressions still do ...

$cfg = Get-Content .vs\config\applicationhost.config |
  %{ $_ -replace "C:\\wwt-web-client\\webclient", "$rundir" } |
  %{ $_ -replace "26993:localhost`" />", "26993:localhost`"/><binding protocol=`"http`" bindingInformation=`"*:26993:MSEDGEWIN10`" />"}
[IO.File]::WriteAllLines("$rundir\applicationhost.config", $cfg)

# Ready to go!

echo ""
echo "THE Q KEY DOES NOT WORK! Kill the server over SSH with `"taskkill /f /im iisexpress.exe`""
echo ""

&'c:\Program Files\IIS Express\iisexpress.exe' /trace:i /site:webclient /config:applicationhost.config
