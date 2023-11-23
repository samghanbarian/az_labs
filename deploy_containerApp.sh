#!/bin/bash

#instal azure container app extension for CLI
az extension add --name containerapp --upgrade

#register th eIcrosoft.App namespace
az provider register --namespace Microsoft.App

#register the Microsoft.OperationalInsights provider for the Azure Monitor Log Analytics workspace 
az provider register --namespace Microsoft.OperationalInsights

#set environment vars
myRG=az204-appcont-rg
myLocation=<location>
myAppContEnv=az204-env-$RANDOM

#create resource group
az group create \
    --name $myRG \
    --location $myLocation

#----------------create ContainerApp environment---------------
az containerapp env create \
    --name $myAppContEnv \
    --resource-group $myRG \
    --location $myLocation

#----------------create ContainerApp --------------------------
az containerapp create \
    --name my-container-app \
    --resource-group $myRG \
    --environment $myAppContEnv \
    --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
    --target-port 80 \
    --ingress 'external' \  #make it available to public
    --query properties.configuration.ingress.fqdn
#----------------Verify th edeployments------------------------
#check the link returned by azure to verify th econtainer created

#---------------------update container app---------------------
az containerapp update \
  --name <APPLICATION_NAME> \
  --resource-group <RESOURCE_GROUP_NAME> \
  --image <IMAGE_NAME>
#--------------------------------------------------------------
#-----------------list revisions associated with acontainerapp---------
az containerapp revision list \
  --name <APPLICATION_NAME> \
  --resource-group <RESOURCE_GROUP_NAME> \
  -o table
  #--------------------------------------------------------------------

#clean up resources
az group delete --name $myRG