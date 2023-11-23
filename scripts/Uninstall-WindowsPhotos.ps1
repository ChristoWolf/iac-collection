# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

try {
    $packageName = "*Microsoft.Windows.Photos*"
    $package = Get-AppxPackage -Name $packageName
    if ($null -eq $package) {
        Write-Host "Package '$packageName' not found, nothing to do."
        exit 0
    }
    Write-Host "Package '$packageName' found, uninstalling now."
    Remove-AppxPackage -Package $package
    $package = Get-AppxPackage -Name $packageName
    if ($null -eq $package) {
        Write-Host "Successfully uninstalled package '$packageName'."
        exit 0
    }
    Write-Host "Failed to uninstall package '$packageName'!"
    exit 1
} catch {
    Write-Host "Failed to find or uninstall package '$packageName' due to exception:"
    Write-Host $_.Exception
    exit 1
}
