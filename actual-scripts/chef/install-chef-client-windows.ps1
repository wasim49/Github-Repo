## The below installs chef client on client vm



# Ensure Chocolatey is installed
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Output "Chocolatey is already installed. Upgrading Chocolatey..."
    choco upgrade chocolatey -y
} else {
    Write-Output "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Ensure Git is installed
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Output "Git is already installed."
} else {
    Write-Output "Git is not installed. Installing Git..."
    choco upgrade git -y
}


# Install or Upgrade Chef Client
Write-Output "Installing or upgrading Chef Infra Client..."
choco upgrade chef-client -y

# Refresh environment variables by importing Chocolatey profile
Write-Output "Refreshing environment variables..."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv


# Verify the installation
try {
    $chefVersion = chef-client --version
    Write-Output "Chef Infra Client installed successfully: $chefVersion"
} catch {
    Write-Output "Chef Client binary not found. Ensure PATH is updated and restart your session."
}

# Step 1: Clone the repository into C:\chef (directory already exists)
$repoUrl = "https://github.com/Wasim49/Github-Repo.git"
$repoPath = "C:\chef"

Write-Output "Cloning the repository from $repoUrl..."
git clone $repoUrl $repoPath

# Step 2: Remove unwanted folders inside the cloned repository
$unwantedFolders = @("actual-scripts", "wrapper-scripts")
foreach ($folder in $unwantedFolders) {
    $folderPath = Join-Path $repoPath $folder
    if (Test-Path $folderPath) {
        Write-Output "Removing unwanted folder: $folderPath"
        Remove-Item -Recurse -Force -Path $folderPath
    }
}

# Step 3: Retain only the required files in install_software folder
$installSoftwarePath = Join-Path $repoPath "install_software"
if (Test-Path $installSoftwarePath) {
    Write-Output "'install_software' folder found successfully."

    # Remove everything except the required files (.chef folder and client.rb)
    $retainFiles = @(".chef", "client.rb")
    $allFiles = Get-ChildItem -Path $installSoftwarePath

    foreach ($file in $allFiles) {
        if ($file.Name -notin $retainFiles) {
            Write-Output "Removing unwanted file or folder: $($file.FullName)"
            Remove-Item -Recurse -Force -Path $file.FullName
        }
    }
} else {
    Write-Output "The 'install_software' folder was not found in the cloned repository."
    Exit 1
}

# Step 4: Copy the necessary PEM files to C:\chef
Write-Output "Copying client.pem to C:/chef/client.pem..."
Copy-Item -Path "C:/chef/install_software/.chef/client.pem" -Destination "C:/chef/client.pem" -Force

Write-Output "Copying validation.pem to C:/chef/validation.pem..."
Copy-Item -Path "C:/chef/install_software/.chef/client.pem" -Destination "C:/chef/validation.pem" -Force

Write-Output "Copying client.rb to C:/chef/client.rb..."
Copy-Item -Path "C:/chef/install_software/client.rb" -Destination "C:/chef/client.rb" -Force





