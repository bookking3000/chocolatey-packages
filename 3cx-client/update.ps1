import-module Chocolatey-AU

$url = 'https://downloads-global.3cx.com/downloads/3cxsoftphone/3CX.msix'

function global:au_GetLatest { 

  $checksum = Get-RemoteChecksum $url
  $AppxPackageName = "3CXDMCC.3CX"

  # ===Temporary Download to read the Version from the MSI===
  $tempPath = [System.IO.Path]::GetTempFileName() + ".msix"
  Invoke-WebRequest -Uri $url -OutFile $tempPath

  Write-Host "TempPath: $tempPath"
  [version]$AppxVer = (Get-AppxPackage -Name $AppxPackageName -AllUsers).Version

  Write-Host "Extracted Version: $AppxVer"
  Remove-Item $tempPath

  return @{ Version = $AppxVer; URL32 = $url; Checksum32 = $checksum }
}

function global:au_SearchReplace {
  return @{
      "tools\chocolateyinstall.ps1" = @{
          "(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.checksum)'"   # Update the Checksum
          "(^\s*version\s*=\s*)('.*')"  = "`$1'$($Latest.Version)'" # Update the version
      }
  }
}


update
