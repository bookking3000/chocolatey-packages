$ErrorActionPreference = 'Stop' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = 'https://www.yealink.com/website-service/download/Yealink-USB-Connect-4.39.19.0.msi' 
  softwareName  = 'Yealink USB Connect*'

  checksum      = 'b4a042e42d838c636acf1fb023c85abe772203abcfb8ea8eed328f46e404d342'
  checksumType  = 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
