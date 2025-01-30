# The below script installs worksation, then grabs folders from github and uploads the cookbook to chef sever - either your own hosted infra server or chef hosted server

# Step 1: Verify Chocolatey Installation
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Output "Chocolatey is already installed. Upgrading Chocolatey..."
    choco upgrade chocolatey -y
} else {
    Write-Output "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Step 2: Verify Chef Workstation Installation
Write-Output "Installing or upgrading Chef Workstation..."
choco upgrade chef-workstation -y

# Step 3: Check if Git is installed
if (-Not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output "Git is not installed. Installing Git..."
    choco install git -y
    Write-Output "Git installed successfully."

    # Refresh environment variables by importing Chocolatey profile
    Write-Output "Refreshing environment variables..."
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    refreshenv
}

# Step 4: Create required directories
$basePath = "C:\scripts"
$chefPath = Join-Path $basePath "chef"
$cookbooksPath = Join-Path $chefPath "cookbooks"

Write-Output "Ensuring required directory structure exists..."
if (-Not (Test-Path $cookbooksPath)) {
    New-Item -ItemType Directory -Path $cookbooksPath -Force | Out-Null
    Write-Output "Directory structure created at $cookbooksPath."
} else {
    Write-Output "Directory structure already exists at $cookbooksPath."
}

# Step 5: Clone the specific repository
$repoUrl = "https://github.com/Wasim49/Github-Repo.git"
$repoPath = Join-Path $cookbooksPath "install_software"

Write-Output "Cloning the repository from $repoUrl into $repoPath..."
git clone $repoUrl $repoPath

# Debug: Show the contents of the cloned folder
Write-Output "Contents of $cookbooksPath after cloning:"
Get-ChildItem -Path $cookbooksPath

# Step 5a: Remove unwanted folders immediately after cloning
$foldersToRemove = @("actual-scripts", "wrapper-scripts")
foreach ($folder in $foldersToRemove) {
    $folderPath = Join-Path $repoPath $folder
    if (Test-Path $folderPath) {
        Write-Output "Removing unwanted folder: $folderPath"
        Remove-Item -Recurse -Force -Path $folderPath
    }
}

# Step 6: Check if a nested install_software folder exists
$nestedFolderPath = Join-Path $repoPath "install_software"
if (Test-Path $nestedFolderPath) {
    Write-Output "Removing nested install_software folder at $nestedFolderPath"
    # Move the contents of the nested folder to the current install_software folder
    Get-ChildItem -Path $nestedFolderPath | Move-Item -Destination $repoPath
    # Remove the nested folder after moving contents
    Remove-Item -Recurse -Force -Path $nestedFolderPath
}

# Step 7: Verify that install_software now has valid content
Write-Output "Checking contents of install_software folder..."
Get-ChildItem -Path $repoPath

if (-Not (Get-ChildItem -Path $repoPath)) {
    Write-Output "'install_software' folder is empty or missing content after cleaning up. Please verify the repository structure."
    Exit 1
}

Write-Output "'install_software' folder found with valid content."

# Step 8: Change directory to Chef working directory
Set-Location $repoPath

# Step 9: Run `chef-client` in local mode
Write-Output "Running chef-client in local mode with --why-run..."
chef-client --local-mode default.rb --why-run

# Step 10: Set the KNIFE_CONFIG environment variable
$knifeConfigPath = Join-Path $chefPath "install_software\knife.rb"
if (-Not (Test-Path $knifeConfigPath)) {
    Write-Output "Warning: No knife configuration file found at $knifeConfigPath. You may need to create one for proper Chef Server interaction."
} else {
    Write-Output "Knife configuration file found at $knifeConfigPath."
    $env:KNIFE_CONFIG = $knifeConfigPath  # Set the environment variable for knife
}

# Step 11: Fetch SSL certificates (Optional if needed)
Write-Output "Fetching SSL certificates from the Chef server..."
knife ssl fetch

# Step 12: Check SSL certificates (Optional if needed)
Write-Output "Checking SSL certificates..."
knife ssl check

# Step 13: Change directory to the install_software folder and upload all cookbooks to Chef server
Write-Output "Changing directory to $repoPath before uploading cookbooks..."
Set-Location $repoPath  # Change directory directly to the install_software folder

Write-Output "Uploading all cookbooks to the Chef server..."
knife cookbook upload -a  # No need to specify the cookbook path since we're already in the folder

Write-Output "Automation completed successfully."







