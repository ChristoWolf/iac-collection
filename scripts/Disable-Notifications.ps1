# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

$regPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
$regName = "DisableNotificationCenter"
$regValue = 1
Write-Host "Disabling notification center."
New-Item -Path $regPath -Force -ErrorAction "SilentlyContinue"
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWORD -Force
$actualRegValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ("$actualRegValue" -ne "$regValue") {
    Write-Host "Failed to modify registry value of '$regName', got '$actualRegValue'!"
    exit 1
}
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"
$regName = "ToastEnabled"
$regValue = 0
Write-Host "Disabling toast notifications."
New-Item -Path $regPath -Force -ErrorAction "SilentlyContinue"
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWORD -Force
$actualRegValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ("$actualRegValue" -ne "$regValue") {
    Write-Host "Failed to modify registry value of '$regName', got '$actualRegValue'!"
    exit 1
}
