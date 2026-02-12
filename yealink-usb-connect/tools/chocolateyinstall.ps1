$ErrorActionPreference = 'Stop' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = 'https://www.yealink.com/website-service/download/Yealink-USB-Connect(X86)-4.41.22.0.msi' 
  softwareName  = 'Yealink USB Connect*'

  checksum      = 'f18d7942c8d5bc3d155b15d7f0051170ccfc20d3a5af0e6a5f5bea3bc2fd5f09'
  checksumType  = 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
