# Uninstall OpenSSH

$installpath = "c:\program files\OpenSSH"
$scriptsdir = "c:\scripts"

# Remove OpenSSH files
if (Test-Path -Path $installpath) {
    Write-Host "Removing OpenSSH files..."
    Remove-Item -Path $installpath -Recurse -Force
} else {
    Write-Host "OpenSSH installation directory not found."
}

# Remove SSH service if it exists
$sshdService = Get-Service -Name sshd -ErrorAction SilentlyContinue
if ($sshdService) {
    Write-Host "Stopping and removing SSH service..."
    Stop-Service -Name sshd -Force
    Set-Service -Name sshd -StartupType Disabled
    sc.exe delete sshd
} else {
    Write-Host "SSHD service is not found."
}

# Remove firewall rule
Write-Host "Removing firewall rule for SSH..."
netsh advfirewall firewall delete rule name=sshd

# Clean up temporary files
if (Test-Path -Path $scriptsdir) {
    Write-Host "Cleaning up temporary installation files..."
    Remove-Item -Path $scriptsdir -Recurse -Force
} else {
    Write-Host "No temporary installation files found."
}

Write-Host "OpenSSH has been uninstalled successfully."
