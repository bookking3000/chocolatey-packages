$ErrorActionPreference = 'Stop' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = 'https://www.yealink.com/website-service/download/Yealink-USB-Connect(X86)--4.42.11.0.msi' 
  softwareName  = 'Yealink USB Connect*'

  checksum      = '58bffeba937c277a39d6667ddac5cf3b2343645e9257f805e6b70ad26355fd92'
  checksumType  = 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
