#!/bin/bash

# Step 1: Check if Chef Workstation is installed
if command -v chef &> /dev/null
then
    echo "Chef Workstation is already installed. Skipping installation."
else
    echo "Chef Workstation is not installed. Installing it now..."
    wget https://packages.chef.io/files/stable/chef-workstation/24.4.1064/ubuntu/20.04/chef-workstation_24.4.1064-1_amd64.deb
    sudo dpkg -i chef-workstation_24.4.1064-1_amd64.deb
    echo "Chef Workstation installed successfully."
fi

# Step 2: Verify if Git is installed, install it if necessary
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Installing Git..."
    sudo apt update
    sudo apt install -y git
    echo "Git installed successfully."
else
    echo "Git is already installed."
fi

# Step 3: Create required directories
basePath="$HOME/scripts"
chefPath="$basePath/chef"
cookbooksPath="$chefPath/cookbooks"

echo "Ensuring required directory structure exists..."
if [ ! -d "$cookbooksPath" ]; then
    mkdir -p "$cookbooksPath"
    echo "Directory structure created at $cookbooksPath."
else
    echo "Directory structure already exists at $cookbooksPath."
fi

# Step 4: Clone the specific repository
repoUrl="https://github.com/Wasim49/Github-Repo.git"
repoPath="$cookbooksPath/install_software"

echo "Cloning the repository from $repoUrl into $repoPath..."
git clone "$repoUrl" "$repoPath"

# Debug: Show the contents of the cloned folder
echo "Contents of $cookbooksPath after cloning:"
ls "$cookbooksPath"

# Step 5: Remove unwanted folders immediately after cloning
foldersToRemove=("actual-scripts" "wrapper-scripts")
for folder in "${foldersToRemove[@]}"
do
    folderPath="$repoPath/$folder"
    if [ -d "$folderPath" ]; then
        echo "Removing unwanted folder: $folderPath"
        rm -rf "$folderPath"
    fi
done

# Step 6: Check if a nested install_software folder exists
nestedFolderPath="$repoPath/install_software"
if [ -d "$nestedFolderPath" ]; then
    echo "Removing nested install_software folder at $nestedFolderPath"
    # Move the contents of the nested folder to the current install_software folder
    mv "$nestedFolderPath"/* "$repoPath/"
    # Remove the nested folder after moving contents
    rmdir "$nestedFolderPath"
fi

# Step 7: Verify that install_software now has valid content
echo "Checking contents of install_software folder..."
if [ ! "$(ls -A $repoPath)" ]; then
    echo "'install_software' folder is empty or missing content after cleaning up. Please verify the repository structure."
    exit 1
fi

echo "'install_software' folder found with valid content."

# Step 8: Change directory to Chef working directory
cd "$repoPath"

# Step 9: Run `chef-client` in local mode with --why-run
echo "Running chef-client in local mode with --why-run..."
chef-client --local-mode default.rb --why-run

# Step 10: Set the KNIFE_CONFIG environment variable
knifeConfigPath="$chefPath/install_software/knife.rb"
if [ ! -f "$knifeConfigPath" ]; then
    echo "Warning: No knife configuration file found at $knifeConfigPath. You may need to create one for proper Chef Server interaction."
else
    echo "Knife configuration file found at $knifeConfigPath."
    export KNIFE_CONFIG="$knifeConfigPath"
fi

# Step 11: Fetch SSL certificates (Optional if needed)
echo "Fetching SSL certificates from the Chef server..."
knife ssl fetch

# Step 12: Check SSL certificates (Optional if needed)
echo "Checking SSL certificates..."
knife ssl check

# Step 13: Change directory to the install_software folder and upload all cookbooks to Chef server
echo "Changing directory to $repoPath before uploading cookbooks..."
cd "$repoPath"

echo "Uploading all cookbooks to the Chef server..."
knife cookbook upload -a

echo "Automation completed successfully."

