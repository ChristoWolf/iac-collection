# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
$regName = "AllowDevelopmentWithoutDevLicense"
$regValue = 1
Write-Host "Enabling Developer mode (needed e.g. for WinAppDriver)."
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord -Force
$actualRegValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ("$actualRegValue" -ne "$regValue") {
    Write-Host "Failed to modify registry value, got '$actualRegValue'!"
    exit 1
}
