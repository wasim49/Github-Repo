## The below is for windows workstation/server vm 
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "chefusertest" ## This name must much the user name on chef io, this not the node name of VM or compuetr
client_key               "C:/scripts/chef/cookbooks/install_software/.chef/wasimcg.pem"  ## This is user pem key not organsational pem key, this is private key. 
chef_server_url          "https://172.19.54.22/organizations/cheforgtest"    ## "https://chef-automate-ndkh.southcentralus.cloudapp.azure.com/organizations/cheforgtest"     ## 
cookbook_path            "C:/scripts/chef/cookbooks" 
ssl_verify_mode :verify_none




## The below is for ubuntu workstation/server vm 
# current_dir = File.dirname(__FILE__)
# log_level                :info
# log_location             STDOUT
# node_name                "chefuserwk" ## This name must much the user name on chef io, this not the node name of VM or compuetr
# client_key               "/root/scripts/chef/cookbooks/install_software/.chef/wasimcg.pem"  ## This is user pem key not organsational pem key, this is private key.
# chef_server_url          "https://automate.chef.vmware/organizations/cheforgwk"    ## "https://192.168.133.130:443"   or   https://automate.chef.vmware/organizations/cheforgwk
# cookbook_path            "/root/scripts/chef/cookbooks"