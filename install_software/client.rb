# The below is client.rb file for windows workstation/server vm

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "chefusertest"## This name must much the user name on chef io
client_key               "C:/chef/client.pem"  ## This is user pem key not organsational pem key, this is private key. 
chef_server_url          "https://172.20.145.124/organizations/cheforgtest"         #"https://chef-automate-ndkh.southcentralus.cloudapp.azure.com/organizations/cheforgtest"
validation_client_name  "cheforgtest-validator"
ssl_verify_mode :verify_none      


## The below are linux related client file
# current_dir = File.dirname(__FILE__)
# log_level        :info
# log_location     "/var/log/chef/client.log"
# chef_server_url  "https://172.20.145.124/organizations/cheforgtest"
# node_name        "chefusertest"
# client_key       "/root/.chef/user.pem"