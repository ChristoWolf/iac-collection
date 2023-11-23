# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

# See https://www.cocosenor.com/articles/windows-10/4-ways-to-disable-or-enable-windows-10-password-expiration-notification.html#way-3.
Write-Host "Disabling password expiration for all users."
$stdout = & wmic useraccount set PasswordExpires=FALSE | Out-String
if (-not $stdout.ToLower().Contains("success")) {
    Write-Host "Failed to disable password expiration for all users!"
    Write-Host $stdout
    exit 1
}
