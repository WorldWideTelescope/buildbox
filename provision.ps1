# PowerShell.

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

choco install dotnet3.5

choco install git nuget.commandline

#### Installing Miniconda3 is now straightforward:
###
###choco install miniconda3 --params="'/D:C:\mc3'"
###$env:Path += ";C:\mc3\Scripts"
###
#### Miniconda + other $PATH futzing
###
###$k = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'
###$path = (Get-ItemProperty -Path $k -Name PATH).path
###$path = "C:\Users\IEUser\.cargo\bin;$path;C:\mc3\Scripts"
###Set-ItemProperty -Path $k -Name PATH -Value $path
###
#### Conda provisioning:
###
###conda config --add channels conda-forge
###conda update --all -y
###conda install -y m2w64-binutils m2-bzip2 m2-git m2-vim posix
###conda clean -tipsy

# Visual Studio 2015

### XXX WORK OUT MANUAL INSTALL SHENANIGANS
### choco install visualstudio2015community --timeout=4800 --package-parameters "--AdminFile c:\vagrant\AdminDeployment.xml"

# Make a directory for WWT work

mkdir C:\wwt

# Message to user

echo ""
echo "Now run `"vagrant reload`" for OS changes to take full effect."
