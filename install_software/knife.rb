## The below is for windows workstation/server vm 
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "chefusertest" ## This name must much the user name on chef io, this not the node name of VM or compuetr
client_key               "C:/scripts/chef/cookbooks/install_software/.chef/wasimcg.pem"  ## This is user pem key not organsational pem key, this is private key. 
chef_server_url          "https://172.20.145.124/organizations/cheforgtest"    ## "https://chef-automate-ndkh.southcentralus.cloudapp.azure.com/organizations/cheforgtest"     ## 
cookbook_path            "C:/scripts/chef/cookbooks" 
ssl_verify_mode :verify_none




## The below is for ubuntu workstation/server vm 
# log_level                :info
# log_location             STDOUT
# node_name                "chefusertest"
# client_key               "/root/.chef/user.pem"
# chef_server_url          "https://172.20.145.124/organizations/cheforgtest"
# cookbook_path            "/root/.chef/my_cookbook"

