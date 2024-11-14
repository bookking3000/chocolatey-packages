import-module Chocolatey-AU

$releases = 'www.yeastar.com/de/linkus-download/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases
  $htmlContent = $download_page.Content

  # Regular expression to find MSI download link
  $regex = 'href\s*=\s*"(https?://[^"]*linkus_desktop_windows_msi_version\.msi)"'
  $urlMatch = [regex]::Match($htmlContent, $regex)

  if ($urlMatch.Success) {
      $url = $urlMatch.Groups[1].Value
      Write-Host "Found Download Link: $url"
  } else {
      throw "No matching download link found on $releases"
  }

  $checksum = Get-RemoteChecksum $url

  Write-Host "Download URL: $url"
  Write-Host "Checksum: $checksum"

  # ===Temporary Download to read the Version from the MSI===
  $tempPath = [System.IO.Path]::GetTempFileName() + ".msi"
  Invoke-WebRequest -Uri $url -OutFile $tempPath

  $versionObject = Get-AppLockerFileInformation -Path $tempPath | Select-Object -ExpandProperty Publisher
  $version = ($versionObject -split ',')[-1].Trim()  # Splits by comma and takes the last part, then trims whitespace
  Write-Host "Extracted Version: $version"

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
