# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

# First we disable them via an according registry entry.
# Based on https://github.com/StefanScherer/packer-windows/blob/main/scripts/dis-updates.ps1.
# There is no need to do it via
# the "Microsoft.Update.AutoUpdate" COM object
# as outlined at https://learn.microsoft.com/en-us/azure/automation/update-management/configure-wuagent
# or done in https://github.com/StefanScherer/packer-windows/blob/main/scripts/dis-updates.ps1.
# That actually does nothing
# according to my experiments.
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$regValue = 1
Write-Host "Creating registry path '$regPath'."
New-Item -Path $regPath -Force -ErrorAction "SilentlyContinue"
$regName = "NoAutoBootWithLoggedOnUsers"
Write-Host "Disabling automatic reboots."
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWORD -Force
$actualRegValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ("$actualRegValue" -ne "$regValue") {
    Write-Host "Failed to modify registry value, got '$actualRegValue'!"
    exit 1
}
$regName = "NoAutoUpdate"
Write-Host "Disabling automatic updates."
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWORD -Force
$actualRegValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ("$actualRegValue" -ne "$regValue") {
    Write-Host "Failed to modify registry value, got '$actualRegValue'!"
    exit 1
}
