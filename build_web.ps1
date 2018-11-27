# This is a PowerShell script for building the web client. It's pretty simple
# but escaping the commands in the driver.sh script would be gnarly.

cd c:\vagrant\wwt-web-client
& 'C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe' .\Html5Sdk.sln $args
