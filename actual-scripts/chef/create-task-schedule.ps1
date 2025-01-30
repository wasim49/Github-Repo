
## The below script creates a task on cleint vm 






# Get list of user accounts on the system
$userAccounts = Get-WmiObject -Class Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true -and $_.Disabled -eq $false }

# Pick the first non-system user account (not SYSTEM or Administrator)
$nonSystemUser = $userAccounts | Where-Object { $_.Name -notin @('SYSTEM', 'Administrator') } | Select-Object -First 1

# Check if a non-system user was found
if ($nonSystemUser) {
    $userName = $nonSystemUser.Name
    Write-Host "Non-System User Found: $userName"
    
    # Now register the scheduled task with this user, making the PowerShell window hidden
    $action = New-ScheduledTaskAction -Execute "PowerShell" -Argument "-WindowStyle Hidden -File C:\scripts\run-chef-client.ps1"
    $trigger = New-ScheduledTaskTrigger -Daily -At "12:00AM"
    $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable -WakeToRun

    # Register the task under the selected non-system user
    $task = Register-ScheduledTask -TaskName "Chef Client" -Action $action -Trigger $trigger -Settings $taskSettings -Description "Runs chef-client every 5 minutes" -User $userName

    # Modify the trigger to repeat every 5 minutes indefinitely
    $task.Triggers.Repetition.Interval = "PT5M"
    $task.Triggers.Repetition.Duration = "P9999D"

    # Apply the changes
    $task | Set-ScheduledTask
    Write-Host "Scheduled task for Chef Client created successfully."
} else {
    Write-Host "No valid non-system user account found."
}
