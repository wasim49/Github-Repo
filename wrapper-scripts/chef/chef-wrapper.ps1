$logfilepath = "c:\scripts\chef-install-session.log"  # Log file inside c:\scripts folder

# Start the transcript to capture everything in the PowerShell session
Start-Transcript -Path $logfilepath -Append

Write-Host "Starting execution of Chef and OpenSSH wrapper script..."

# Define the URLs for the installation and uninstallation scripts
$chefInstallScriptUrl = "https://raw.githubusercontent.com/Wasim49/Github-Repo/refs/heads/main/actual-scripts/chef/install-chef-client-windows.ps1"
$chefRunScriptUrl = "https://raw.githubusercontent.com/Wasim49/Github-Repo/refs/heads/main/actual-scripts/chef/run-chef-client.ps1"  # URL for the new script
$createTaskScheduleScriptUrl = "https://raw.githubusercontent.com/Wasim49/Github-Repo/refs/heads/main/actual-scripts/chef/create-task-schedule.ps1"  # URL for the task creation script

# Define the local folder where scripts will be saved
$scriptsdir = "c:\scripts"

# Define the local file paths for the installation scripts
$chefInstallScriptPath = "$scriptsdir\install-chef-client-windows.ps1"
$chefRunScriptPath = "$scriptsdir\run-chef-client.ps1"  # Local path for the new script
$createTaskScheduleScriptPath = "$scriptsdir\create-task-schedule.ps1"  # Local path for task schedule script

# Create the c:\scripts folder if it doesn't exist
if (-not (Test-Path -Path $scriptsdir)) {
    New-Item -Path $scriptsdir -ItemType Directory
    Write-Host "Created scripts folder at $scriptsdir."
}

# Download the Chef installation script
Write-Host "Downloading Chef Installation Script..."
Invoke-WebRequest -Uri $chefInstallScriptUrl -OutFile $chefInstallScriptPath
Write-Host "Chef Installation Script downloaded to $chefInstallScriptPath."

# Download the Chef client run script
Write-Host "Downloading Chef Client Run Script..."
Invoke-WebRequest -Uri $chefRunScriptUrl -OutFile $chefRunScriptPath
Write-Host "Chef Client Run Script downloaded to $chefRunScriptPath."

# Download the Task Schedule creation script
Write-Host "Downloading Task Schedule Script..."
Invoke-WebRequest -Uri $createTaskScheduleScriptUrl -OutFile $createTaskScheduleScriptPath
Write-Host "Task Schedule Script downloaded to $createTaskScheduleScriptPath."

# Execute the Chef installation script
Write-Host "Executing Chef Installation Script..."
. $chefInstallScriptPath

# Now execute the downloaded task schedule creation script
Write-Host "Executing Task Schedule Script..."
. $createTaskScheduleScriptPath

# Stop the transcript to end capturing the session
Stop-Transcript




