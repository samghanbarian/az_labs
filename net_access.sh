#!/bin/bash
#this is a series of commands that should be run using az cli
az vm list
#create a network security group that changes that by allowing inbound HTTP access on port 80.

#get the ip address of the machine and save it to a var
IPADDRESS="$(az vm list-ip-addresses \
--resource-group learn-4bee0b24-abb2-48b6-b10f-3df877c5753b \
--name my-vm \
--query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
--output tsv)"

#download the homepage
curl --connect-timeout 5 http://$IPADDRESS

#List the current network security group rules
az network nsg list \
--resource-group [sandbox resource group name] \
--query '[].name' \
--output tsv

#list the rules associated with the NSG named my-vmNSG
az network nsg rule list \
--resource-group [sandbox resource group name] \
--nsg-name my-vmNSG

# Run the az network nsg rule list command a second time.
#  This time, use the --query argument to retrieve only the name, priority, affected ports,
#   and access (Allow or Deny) for each rule. 
#   The --output argument formats the output as a table so that it's easy to read.

az network nsg rule list \
--resource-group [sandbox resource group name] \
--nsg-name my-vmNSG \
--query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
--output table

#Create the network security rule to allow access on port 80; 
#You would need to consider the priority if you had overlapping port ranges.
az network nsg rule create \
--resource-group [sandbox resource group name] \
--nsg-name my-vmNSG \
--name allow-http \
--protocol tcp \
--priority 100 \
--destination-port-range 80 \
--access Allow

#see the updated network security list
az network nsg rule list \
--resource-group [sandbox resource group name] \
--nsg-name my-vmNSG \
--query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
--output table