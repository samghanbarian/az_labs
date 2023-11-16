#!/bin/bash #it should be run on az cli


#---------------create vm via az cli-------------------------------------
az vm create \
--resource-group learn-4bee0b24-abb2-48b6-b10f-3df877c5753b \
--name my-vm \ #vm name
--public-ip-sku Standard \
--image Ubuntu2204 \ #what image
--admin-username azureuser \
--generate-ssh-keys

#the command output
#SSH key files '/home/samaneh/.ssh/id_rsa' and '/home/samaneh/.ssh/id_rsa.pub' 
#have been generated under ~/.ssh to allow SSH access to the VM.
# If using machines without permanent storage, back up your keys to a safe location.
#----------------------------json output------------------------
# {
#   "fqdns": "",
#   "id": "/subscriptions/2ed34f93-942c-4b20-af93-16e135cc3589/resourceGroups/learn-4bee0b24-abb2-48b6-b10f-3df877c5753b/providers/Microsoft.Compute/virtualMachines/my-vm",
#   "location": "westus",
#   "macAddress": "00-0D-3A-36-BD-32",
#   "powerState": "VM running",
#   "privateIpAddress": "10.0.0.4",
#   "publicIpAddress": "40.112.253.180",
#   "resourceGroup": "learn-4bee0b24-abb2-48b6-b10f-3df877c5753b",
#   "zones": ""
# }

#------------------configure nginx on machine with az extention set---------------------
# This command uses the Custom Script Extension to run a Bash script on your VM. 
# The script is stored on GitHub. 

az vm extension set \
--resource-group learn-4bee0b24-abb2-48b6-b10f-3df877c5753b \
--vm-name my-vm \
--name customScript \
--publisher Microsoft.Azure.Extensions \
--version 2.1 \
--settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' \
--protected-settings '{"commandToExecute": "./configure-nginx.sh"}'

#----------------------------the script to configure nginx------------
# #!/bin/bash

# # Update apt cache.
# sudo apt-get update

# # Install Nginx.
# sudo apt-get install -y nginx

# # Set the home page.
# echo "<html><body><h2>Welcome to Azure! My name is $(hostname).</h2></body></html>" | sudo tee -a /var/www/html/index.html
