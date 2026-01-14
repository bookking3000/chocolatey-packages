$ErrorActionPreference = 'Stop';


$packageName= 'linkus-desktop-client'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = 'https://image.yeastar.com/Yeastardownload/linkus_desktop_windows_msi_version.msi'
  softwareName  = 'Linkus Desktop Client*'
  checksum      = '21db5a1bb77dbe59c774fcfede462ead699dbe0efd63b4021a82f132ee7ea46f'
  checksumType  = 'sha256' 
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
