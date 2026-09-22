$ErrorActionPreference = 'Stop';


$packageName= 'linkus-desktop-client'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = 'https://image.yeastar.com/Yeastardownload/linkus_desktop_windows_msi_version.msi'
  softwareName  = 'Linkus Desktop Client*'
  checksum      = '8ae4f4b73f774f9476a295d2585493b41866d22f32114b4e9362acf3186339a2'
  checksumType  = 'sha256' 
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
