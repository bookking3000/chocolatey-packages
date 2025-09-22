$ErrorActionPreference = 'Stop';


$packageName= 'linkus-desktop-client'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = 'https://image.yeastar.com/Yeastardownload/linkus_desktop_windows_msi_version.msi'
  softwareName  = 'Linkus Desktop Client*'
  checksum      = '8239bd99ea01ae0433249d1abe69abb1954e66e10ff2886074234a772f6dce7b'
  checksumType  = 'sha256' 
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
