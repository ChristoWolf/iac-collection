# Always disable progress output,
# see https://github.com/crc-org/crc/issues/1184#issuecomment-1182124711.
# It's in any case redundant, 
# as its not piped to the output stream.
$ProgressPreference = "SilentlyContinue"

# Workaround: https://stackoverflow.com/questions/34331206/ignore-ssl-warning-with-powershell-downloadstring
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12
#[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

try {
    $urlPattern = "https://*"
    $LatestReleaseUrl = 'https://api.github.com/repos/microsoft/WinAppDriver/releases/latest'
    $InstallerUrl = (Invoke-WebRequest -Uri $LatestReleaseUrl -UseBasicParsing | ConvertFrom-Json).assets.browser_download_url
    $InstallerPath = "C:\WindowsApplicationDriver.msi"
    Write-Host "Downloading WinAppDriver."
    if ($InstallerUrl -cnotlike $urlPattern) {
        throw "'$InstallerUrl' is not a valid URL!"
    }
    Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerPath -UseBasicParsing
    Write-Host "Installing WinAppDriver."
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $InstallerPath /quiet" -NoNewWindow -Wait
    Remove-Item -Path $InstallerPath -ErrorAction SilentlyContinue
    $installLocation = "$env:ProgramFiles (x86)\Windows Application Driver\WinAppDriver.exe"
    if (-not(Test-Path -Path $installLocation)) {
        throw "Failed to find '$installLocation'!"
    }
} catch {
    Write-Host "Failed to properly install WinAppDriver:"
    Write-Host $_.Exception
    exit 1
}
