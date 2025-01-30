# Set variables
$Path_of_files = "C:\Users\wnavaskh\Desktop\local repo\Github-Repo\actual-scripts\chef"  # Update with the actual path to your scripts folder
$OutputDirectory = "$($Path_of_files)\Reports"

# Ensure the output directory exists
if (-not (Test-Path -Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

# Install PSScriptAnalyzer if not already installed
if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Output "PSScriptAnalyzer is not installed. Installing..."
    Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -AllowClobber
} else {
    Write-Output "PSScriptAnalyzer is already installed."
}

# Scan PowerShell scripts and output results
Get-ChildItem -Path $Path_of_files -Recurse -Include *.ps1 | ForEach-Object {
    Write-Output "Analyzing $($_.FullName)"
    $ReportFilePath = "$OutputDirectory\$($_.BaseName).report.txt"
    Invoke-ScriptAnalyzer -Path $_.FullName | Out-File -FilePath $ReportFilePath
    Write-Output "Report saved to $ReportFilePath"
}

Write-Output "Scanning completed. Reports saved in $OutputDirectory."


