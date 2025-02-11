$AppxPackageName = "3CXDMCC.3CX"
Remove-AppProvisionedPackage -AllUsers -Online -Package (Get-AppxPackage -Name $AppxPackageName -AllUsers)