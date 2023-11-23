# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

$regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
$regName = "ShellFeedsTaskbarViewMode"
$regValue = 2
Write-Host "Disabling news feed (and 'News and interests' task bar button)."
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWORD -Force
$actualRegValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ("$actualRegValue" -ne "$regValue") {
    Write-Host "Failed to modify registry value of '$regName', got '$actualRegValue'!"
    exit 1
}
