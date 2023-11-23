# This is needed for Windows 11,
# see https://github.com/StefanScherer/packer-windows/blob/main/windows_11.json
# and https://gearupwindows.com/fix-this-pc-cant-run-windows-11-error-in-virtualbox-or-vmware/.

# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

$regPath = "HKLM:\SYSTEM\Setup\LabConfig"
$regNames = @("BypassTPMCheck","BypassSecureBootCheck","BypassRAMCheck","BypassCPUCheck")
$regValue = 1
New-Item -Path $regPath -Force -ErrorAction "SilentlyContinue"
foreach ($regName in $regNames) {
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWORD -Force
}
