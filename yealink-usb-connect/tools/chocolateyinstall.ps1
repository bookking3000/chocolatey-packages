$ErrorActionPreference = 'Stop' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = 'https://www.yealink.com/website-service/download/Yealink-USB-Connect(X86)-4.41.12.0.msi' 
  softwareName  = 'Yealink USB Connect*'

  checksum      = '6849eff3d75c815f0b00480497602ef59f4e1c94e09de5f679ab3dd0d753d295'
  checksumType  = 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
