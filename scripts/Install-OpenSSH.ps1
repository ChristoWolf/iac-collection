# See https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse#install-openssh-using-powershell.

# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

try {
    Get-WindowsCapability -Online | ? Name -Like 'OpenSSH*'
    Write-Host "Installing the OpenSSH Client."
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    Write-Host "Installing the OpenSSH Server."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Write-Host "Start the sshd service."
    Start-Service -Name sshd
    # OPTIONAL but recommended:
    Write-Host "Ensuring that the sshd service is (re)started automatically."
    Set-Service -Name sshd -StartupType 'Automatic'
    # Confirm the firewall rule is configured. It should be created automatically by setup.
    Write-Host "Verifying that the correct firewall rules have been configured."
    Get-NetFirewallRule -Name *ssh*
    # There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled.
    # If the rule does not exist, create one.
    Write-Host "Ensuring that the OpenSSH Server (sshd) firewall rule is configured."
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} catch {
    Write-Host "Failed to properly install OpenSSH:"
    Write-Host $_.Exception
    exit 1
}
