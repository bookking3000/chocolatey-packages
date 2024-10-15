import-module au

$releases = 'https://www.yealink.com/en/product-detail/usb-connect-management'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases
  $regex   = 'yealink-usb-connect-.*\.msi$'
  $url     = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href

  Write-Host "Found Download-Link:"
  Write-Host $url

  $checksum = Get-RemoteChecksum $url
  Write-Host "Checksum:"
  Write-Host $checksum

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