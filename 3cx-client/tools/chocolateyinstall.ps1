$ErrorActionPreference = 'Stop' 
$url = "https://downloads-global.3cx.com/downloads/3cxsoftphone/3CX.msix"

$version        = "20.0.664.0"
$AppxPackageName = "3CXDMCC.3CX"
$checksum = "4e5123f5fdaf461ccb4a8b4e03e018d143a6bab57ffed8894c7ad4e802853201"

[version]$AppxVer = (Get-AppxPackage -Name $AppxPackageName -AllUsers).Version

# Check if the installed version is newer than the package version
if ($AppxVer -gt [version]$version) {
  throw "The installed $version version is newer than this package version, it may have autoupdated on your current OS..."
  return;
} 

# === Download MSIX===
$tempPath = [System.IO.Path]::GetTempFileName() + ".msix"
Write-Host "Downloading $url to $tempPath"

Invoke-WebRequest -Uri $url -OutFile $tempPath

#Checksum of TempPath
$checksumTempPath = Get-FileHash -Path $tempPath -Algorithm SHA256 | Select-Object -ExpandProperty Hash
Write-Host "Checksum of TempPath: $checksumTempPath"

if ($checksum -ne $checksumTempPath) {
  throw "Aborted! Checksums mismatch..."
  return;
}

Add-AppProvisionedPackage -Online -PackagePath $tempPath -SkipLicense
