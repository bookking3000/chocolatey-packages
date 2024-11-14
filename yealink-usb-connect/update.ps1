import-module Chocolatey-AU

$releases = 'https://www.yealink.com/en/product-detail/usb-connect-management'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases
  $htmlContent = $download_page.Content

  # Regular expression to find MSI download link
  $regex = 'href\s*=\s*"([^"]*yealink-usb-connect-.*\.msi)"'
  $urlMatch = [regex]::Match($htmlContent, $regex)

  if ($urlMatch.Success) {
      $url = $urlMatch.Groups[1].Value
      Write-Host "Found Download Link: $url"

      # Regular expression to extract the version number from the URL
      $versionRegex = '(\d+\.\d+\.\d+\.\d+)'
      $versionMatch = [regex]::Match($url, $versionRegex)

      if ($versionMatch.Success) {
          $version = $versionMatch.Value
          Write-Host "Extracted Version: $version"
      } else {
          throw "No version number found in the URL: $url"
      }
  } else {
      throw "No matching download link found on $releases"
  }

  $checksum = Get-RemoteChecksum $url
  Write-Host "Checksum:"
  Write-Host $checksum

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
