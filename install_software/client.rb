# The below is client.rb file for windows workstation/server vm

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "chefusertest"## This name must much the user name on chef io
client_key               "C:/chef/client.pem"  ## This is user pem key not organsational pem key, this is private key. 
chef_server_url          "https://vm1/organizations/cheforgtest"                                                          #"https://172.19.54.22/organizations/cheforgtest"
validation_client_name  "cheforgtest-validator"
ssl_verify_mode :verify_none      
