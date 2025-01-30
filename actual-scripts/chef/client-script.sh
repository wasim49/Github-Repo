#!/bin/bash

# Ensure Git is installed
if command -v git &>/dev/null; then
    echo "Git is already installed."
else
    echo "Git is not installed. Installing Git..."
    sudo apt-get update
    sudo apt-get install -y git
fi

# Install or Upgrade Chef Infra Client
echo "Installing or upgrading Chef Infra Client..."
if command -v chef-client &>/dev/null; then
    echo "Chef Infra Client is already installed. Upgrading..."
    sudo apt-get install --only-upgrade chef
else
    echo "Installing Chef Infra Client..."
    sudo apt-get install -y chef
fi

# Clone the repository into /chef (directory will be created if it doesn't exist)
REPO_URL="https://github.com/Wasim49/Github-Repo.git"
REPO_PATH="/chef"

echo "Cloning the repository from $REPO_URL..."
git clone "$REPO_URL" "$REPO_PATH"

# Remove unwanted folders inside the cloned repository
UNWANTED_FOLDERS=("actual-scripts" "wrapper-scripts")
for folder in "${UNWANTED_FOLDERS[@]}"; do
    FOLDER_PATH="$REPO_PATH/$folder"
    if [ -d "$FOLDER_PATH" ]; then
        echo "Removing unwanted folder: $FOLDER_PATH"
        rm -rf "$FOLDER_PATH"
    fi
done

# Retain only the required files in install_software folder
INSTALL_SOFTWARE_PATH="$REPO_PATH/install_software"
if [ -d "$INSTALL_SOFTWARE_PATH" ]; then
    echo "'install_software' folder found successfully."

    # Remove everything except the required files (.chef folder and client.rb)
    RETAIN_FILES=(".chef" "client.rb")
    for file in "$INSTALL_SOFTWARE_PATH"/*; do
        FILE_NAME=$(basename "$file")
        if [[ ! " ${RETAIN_FILES[@]} " =~ " ${FILE_NAME} " ]]; then
            echo "Removing unwanted file or folder: $file"
            rm -rf "$file"
        fi
    done
else
    echo "The 'install_software' folder was not found in the cloned repository."
    exit 1
fi

# Copy the necessary PEM files to /chef
echo "Copying client.pem to /chef/client.pem..."
cp "$INSTALL_SOFTWARE_PATH/.chef/client.pem" "/chef/client.pem"

echo "Copying validation.pem to /chef/validation.pem..."
cp "$INSTALL_SOFTWARE_PATH/.chef/client.pem" "/chef/validation.pem"

echo "Copying client.rb to /chef/client.rb..."
cp "$INSTALL_SOFTWARE_PATH/client.rb" "/chef/client.rb"

echo "Chef Infra Client installation and setup completed."
