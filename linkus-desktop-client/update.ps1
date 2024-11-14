import-module Chocolatey-AU

$releases = 'https://www.yeastar.com/de/linkus-download/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases
  $regex   = 'linkus_desktop_windows_msi_version.msi$'
  $url     = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href

  if (-not $url) {
      throw "No matching download link found on $releases"
  }

  $checksum = Get-RemoteChecksum $url

  Write-Host "Download URL: $url"
  Write-Host "Checksum: $checksum"

  # ===Temporary Download to read the Version from the MSI===
  $tempPath = [System.IO.Path]::GetTempFileName() + ".msi"
  Invoke-WebRequest -Uri $url -OutFile $tempPath

  $versionObject = Get-AppLockerFileInformation -Path $tempPath | Select-Object -ExpandProperty Publisher | Select-Object BinaryVersion
  $version = $versionObject.BinaryVersion.ToString()

  Remove-Item $tempPath

  return @{ Version = $version; URL32 = $url; Checksum32 = $checksum }
}

function global:au_SearchReplace {
  return @{
      "tools\chocolateyinstall.ps1" = @{
          "(^\s*url\s*=\s*)('.*')"       = "`$1'$($Latest.URL32)'"   # Update the download URL
          "(^\s*checksum\s*=\s*)('.*')"  = "`$1'$($Latest.Checksum32)'" # Update the checksum
      }
  }
}


update
