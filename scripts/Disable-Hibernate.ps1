# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\"
$offValue = 0
$hiberFileSizePercent = "HiberFileSizePercent"
$hibernateEnabled = "HibernateEnabled"
$hibernateEnabledDefault = "HibernateEnabledDefault"
Write-Host "Disabling system hibernation."
Set-ItemProperty -Path $regPath -Name $hiberFileSizePercent -Value $offValue
Set-ItemProperty -Path $regPath -Name $hibernateEnabled -Value $offValue
Set-ItemProperty -Path $regPath -Name $hibernateEnabledDefault -Value $offValue
# Check if the registry was updated correctly.
$actualRegValue1 = Get-ItemPropertyValue -Path $regPath -Name $hiberFileSizePercent
$actualRegValue2 = Get-ItemPropertyValue -Path $regPath -Name $hibernateEnabled
$actualRegValue3 = Get-ItemPropertyValue -Path $regPath -Name $hibernateEnabledDefault
if ("$actualRegValue1" -ne "$offValue" -or
    "$actualRegValue2" -ne "$offValue" -or
    "$actualRegValue3" -ne "$offValue") {
    Write-Host "Failed to modify registry value(s), got '$hiberFileSizePercent=$actualRegValue1', '$hibernateEnabled=$actualRegValue2' and '$hibernateEnabledDefault=$actualRegValue3'!"
    exit 1
}
# The following are based on https://stackoverflow.com/a/33856010.
# Retrieving them again is very complicated,
# so I will not check these for now.
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0
