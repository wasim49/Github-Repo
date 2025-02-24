# The below enables virtulazaition related stuufs on wokrsation vm. Then installs ubuntu and install chef self infra hosted inside ubuntu



# Enable WSL feature
Write-Host "Enabling WSL feature..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform (needed for WSL 2)
Write-Host "Enabling Virtual Machine Platform feature..."
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Optionally, enable Hyper-V for better WSL 2 performance (uncomment if needed)
Write-Host "Enabling Hyper-V feature..."
dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V-All /all /norestart

# Enable Containers (for Docker & containerized workloads)
Write-Host "Enabling Containers feature..."
dism.exe /online /enable-feature /featurename:Containers /all /norestart


#Open port 80 and 443 on windows, this might be optional
New-NetFirewallRule -DisplayName "Allow HTTP (Port 80)" -Direction Inbound -Protocol TCP -Action Allow -LocalPort 80
New-NetFirewallRule -DisplayName "Allow HTTPS (Port 443)" -Direction Inbound -Protocol TCP -Action Allow -LocalPort 443


# Install Ubuntu distribution from the Microsoft Store (this needs a restart)
Write-Host "Installing Ubuntu"

wsl --install -d Ubuntu-22.04



## Now restart the compuetr manually adn wait for minumium 5 minutes ### 



# Script continuation (executed after reboot)

    # Update everything
    wsl sudo apt update
    wsl sudo apt upgrade -y
    
    # Upgrade the locales package and everything else
    wsl sudo apt-get upgrade -y

    # Generate the UTF-8 locale, this might be optional
    wsl sudo sed -i 's/# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
    wsl sudo locale-gen
    wsl sudo update-locale LANG=en_US.UTF-8
    wsl locale

    # Download the Chef Server package
    wsl wget https://packages.chef.io/files/stable/chef-server/15.10.27/ubuntu/22.04/chef-server-core_15.10.27-1_amd64.deb

    
    #Open port 80,443
    wsl iptables -A INPUT -p tcp -m multiport --destination-ports 80,443 -j ACCEPT

    # Install the Chef Server package
    wsl sudo dpkg -i chef-server-core_15.10.27-1_amd64.deb

    # Reconfigure Chef Server
    wsl sudo chef-server-ctl reconfigure --chef-license accept

    #Install chef web ui package 
    wsl sudo chef-server-ctl install chef-manage

    # Restart Chef Server services
    wsl sudo chef-server-ctl restart

    # Reconfigure Chef Server one more time
    wsl sudo chef-server-ctl reconfigure


    # create an user 

    wsl chef-server-ctl user-create chefusertest dave mike tk606450@gmail.com "123456" --filename user.pem

    # create chef org

    wsl chef-server-ctl org-create cheforgtest "local chef organisation" --association_user chefusertest --filename validator.pem  ## the validator key private key is differnet fom organisation private key

    # add the the user to admin group 

    chef-server-ctl org-user-add cheforgwk chefuserwk --admin


    ## add user to server admin group 
    
    chef-server-ctl grant-server-admin-permissions chefuserwk


#-------------------------This marks the end of work----------------------------------------------------##

    # The below are checking commnds 


# list commands 

chef-server-ctl user-list

chef-server-ctl org-list


# delation commands 

chef-server-ctl user-delete chefusertest --remove-from-admin-groups



chef-server-ctl remove-server-admin-permissions chefusertest



chef-server-ctl org-delete cheforgtest


chef-server-ctl user-delete chefusertest

chef-server-ctl uninstall