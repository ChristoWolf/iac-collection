# This is needed for Windows 11,
# see https://github.com/StefanScherer/packer-windows/blob/main/windows_11.json
# and https://gearupwindows.com/fix-this-pc-cant-run-windows-11-error-in-virtualbox-or-vmware/.

# TODO: As PowerShell cmdlets (and other stuff inhttps://gearupwindows.com/fix-this-pc-cant-run-windows-11-error-in-virtualbox-or-vmware/)!
reg add HKLM\\SYSTEM\\Setup\\LabConfig /t REG_DWORD /v BypassTPMCheck /d 1
reg add HKLM\\SYSTEM\\Setup\\LabConfig /t REG_DWORD /v BypassSecureBootCheck /d 1
