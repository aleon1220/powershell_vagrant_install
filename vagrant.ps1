# vagrant.ps1
# Powershell script to install Vagrant on Windows 
# Bertrand Szoghy
# last modified: 2019-05-09

# BEFORE launching make a copy of your Windows system path

# TO RUN, open Powershell as an administrator, wait a moment for the PS command prompt to appear, Navigate to the directory where the script lives, execute the script
# .\vagrant.ps1

# ref https://codingbee.net/vagrant/vagrant-installing-vagrant-on-windows 
# ref https://stackoverflow.com/questions/37767619/possibility-to-automate-installation-of-desktop-application-in-vagrant
# ref https://bertrandszoghy.wordpress.com/2018/05/03/building-the-hyperledger-fabric-vm-and-docker-images-version-1-1-from-scratch/
# ref https://gallery.technet.microsoft.com/scriptcenter/3aa9d51a-44af-4d2a-aa44-6ea541a9f721?SRC=Home
# ref https://stackoverflow.com/questions/2035193/how-to-run-a-powershell-script/2035209

# Set PowerShell policy to Unrestricted
Set-ExecutionPolicy AllSigned -Force
Set-ExecutionPolicy Bypass -Force
Set-ExecutionPolicy Unrestricted -Force

# Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Turn off confirmation in Chocolatey
chocolatey feature enable -n=allowGlobalConfirmation

# Install Vagrant and virtualbox, cinst is a an alias for "choco install", --yes option might be overkill
cinst --yes virtualbox vagrant cyg-get

cyg-get dos2unix

# Create folder where Vagrant box will be placed
New-Item -ItemType directory -Path "C:\VagrantBoxes"

# Add the following to Windows system PATH
# VirtualBox : C:\Program Files\Oracle\VirtualBox
# Vagrant : C:\HashiCorp\Vagrant\bin
# cyg-get : C:\tools\cygwin and also: C:\tools\cygwin\bin
# chocolatey : C:\ProgramData\chocolatey\bin

# ref https://gallery.technet.microsoft.com/scriptcenter/3aa9d51a-44af-4d2a-aa44-6ea541a9f721?SRC=Home

Function global:TEST-LocalAdmin() 
    { 
    Return ([security.principal.windowsprincipal] [security.principal.windowsidentity]::GetCurrent()).isinrole([Security.Principal.WindowsBuiltInRole] "Administrator") 
    } 
     
Function global:SET-PATH() 
{ 
[Cmdletbinding(SupportsShouldProcess=$TRUE)] 
param 
( 
[parameter(Mandatory=$True,  
ValueFromPipeline=$True, 
Position=0)] 
[String[]]$NewPath 
) 
 
If ( ! (TEST-LocalAdmin) ) { Write-Host 'Need to RUN AS ADMINISTRATOR first'; Return 1 } 
     
# Update the Environment Path 
 
if ( $PSCmdlet.ShouldProcess($newPath) ) 
{ 
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath 
 
# Show what we just did 
 
Return $NewPath 
} 
} 
 
Function global:ADD-PATH() 
{ 
[Cmdletbinding(SupportsShouldProcess=$TRUE)] 
param 
    ( 
    [parameter(Mandatory=$True,  
    ValueFromPipeline=$True, 
    Position=0)] 
    [String[]]$AddedFolder 
    ) 
 
If ( ! (TEST-LocalAdmin) ) { Write-Host 'Need to RUN AS ADMINISTRATOR first'; Return 1 } 
     
# Get the Current Search Path from the Environment keys in the Registry 
 
$OldPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path 
 
# See if a new Folder has been supplied 
 
IF (!$AddedFolder) 
    { Return ‘No Folder Supplied.  $ENV:PATH Unchanged’} 
 
# See if the new Folder exists on the File system 
 
IF (!(TEST-PATH $AddedFolder)) 
    { Return ‘Folder Does not Exist, Cannot be added to $ENV:PATH’ } 
 
# See if the new Folder is already IN the Path 
 
$PathasArray=($Env:PATH).split(';') 
IF ($PathasArray -contains $AddedFolder -or $PathAsArray -contains $AddedFolder+'\') 
    { Return ‘Folder already within $ENV:PATH' } 
 
If (!($AddedFolder[-1] -match '\')) { $Newpath=$Newpath+'\'} 
 
# Set the New Path 
 
$NewPath=$OldPath+';’+$AddedFolder 
if ( $PSCmdlet.ShouldProcess($AddedFolder) ) 
{ 
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath 
 
# Show our results back to the world 
 
Return $NewPath  
} 
} 
 
FUNCTION GLOBAL:GET-PATH() 
{ 
Return (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path 
} 
 
ADD-PATH "C:\Program Files\Oracle\VirtualBox"
ADD-PATH "C:\HashiCorp\Vagrant\bin"
ADD-PATH "C:\tools\cygwin"
ADD-PATH "C:\tools\cygwin\bin"
ADD-PATH "C:\ProgramData\chocolatey\bin"
 
