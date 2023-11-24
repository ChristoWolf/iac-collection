# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

$regPath = "HKCU:\Control Panel\Desktop"
$regName = "ScreenSaveActive"
$regValue = 0
Write-Output "Disabling screensaver."
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord
$actualRegValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ("$actualRegValue" -ne "$regValue") {
    Write-Host "Failed to modify registry value, got '$actualRegValue'!"
    exit 1
}
# Retrieving the following again is very complicated,
# so I will not check these for now.
powercfg.exe -x -monitor-timeout-ac 0
powercfg.exe -x -monitor-timeout-dc 0
