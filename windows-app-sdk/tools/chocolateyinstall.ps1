$ErrorActionPreference = 'Stop';

$packageName= 'windows-app-sdk'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://aka.ms/windowsappsdk/1.7/1.7.250401001/windowsappruntimeinstall-x64.exe'
$url64      = 'https://aka.ms/windowsappsdk/1.7/1.7.250401001/windowsappruntimeinstall-x86.exe'

$silentArgs = "--quiet"

$pp = Get-PackageParameters
if ($pp['forceInstall'] -eq 'true') {
    $silentArgs += " --force"
}


$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64
  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Windows App Runtime*'
  checksum      = 'E932F9764EB52901257C2B92E00CE5422BC47D037A9381D4F82FEDC2EAA1C772'
  checksumType  = 'sha256'
  checksum64    = '16ACAAD86B8CC3BD2A07AD11695E6B43C66F9C8A01EE542E3AC3A4A05241B43B'
  checksumType64= 'sha256'
}

Install-ChocolateyPackage @packageArgs