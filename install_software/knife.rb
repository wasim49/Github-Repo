current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "chefuserwk" ## This name must much the user name on chef io, this not the node name of VM or compuetr
client_key               "/root/scripts/chef/cookbooks/install_software/.chef/wasimcg.pem"  ## This is user pem key not organsational pem key, this is private key.
chef_server_url          "https://automate.chef.vmware/organizations/cheforgwk"    ## "https://192.168.133.130:443"   or   https://automate.chef.vmware/organizations/cheforgwk
cookbook_path            "/root/scripts/chef/cookbooks"