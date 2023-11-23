az group create --name az204-acr-rg --location us-east #create resource group

az acr create --resource-group az204-acr-rg \ 
    --name <myContainerRegistry> --sku Basic #create registry


#---------------------acr create output------------------
# {
#   "adminUserEnabled": false,
#   "anonymousPullEnabled": false,
#   "creationDate": "2023-11-22T13:58:30.193839+00:00",
#   "dataEndpointEnabled": false,
#   "dataEndpointHostNames": [],
#   "encryption": {
#     "keyVaultProperties": null,
#     "status": "disabled"
#   },
#   "id": "/subscriptions/13e19f15-986b-40ec-ba9e-3d357a188acd/resourceGroups/sam_storage_rcgr/providers/Microsoft.ContainerRegistry/registries/samacr123",
#   "identity": null,
#   "location": "eastus",
#   "loginServer": "samacr123.azurecr.io",
#   "name": "samacr123",
#   "networkRuleBypassOptions": "AzureServices",
#   "networkRuleSet": null,
#   "policies": {
#     "azureAdAuthenticationAsArmPolicy": {
#       "status": "enabled"
#     },
#     "exportPolicy": {
#       "status": "enabled"
#     },
#     "quarantinePolicy": {
#       "status": "disabled"
#     },
#     "retentionPolicy": {
#       "days": 7,
#       "lastUpdatedTime": "2023-11-22T13:58:37.136670+00:00",
#       "status": "disabled"
#     },
#     "softDeletePolicy": {
#       "lastUpdatedTime": "2023-11-22T13:58:37.136713+00:00",
#       "retentionDays": 7,
#       "status": "disabled"
#     },
#     "trustPolicy": {
#       "status": "disabled",
#       "type": "Notary"
#     }
#   },
#   "privateEndpointConnections": [],
#   "provisioningState": "Succeeded",
#   "publicNetworkAccess": "Enabled",
#   "resourceGroup": "sam_storage_rcgr",
#   "sku": {
#     "name": "Basic",
#     "tier": "Basic"
#   },
#   "status": null,
#   "systemData": {
#     "createdAt": "2023-11-22T13:58:30.193839+00:00",
#     "createdBy": "samighanbarian@gmail.com",
#     "createdByType": "User",
#     "lastModifiedAt": "2023-11-22T13:58:30.193839+00:00",
#     "lastModifiedBy": "samighanbarian@gmail.com",
#     "lastModifiedByType": "User"
#   },
#   "tags": {},
#   "type": "Microsoft.ContainerRegistry/registries",
#   "zoneRedundancy": "Disabled"
# }
#------------------------------------------------------

#create dockerfile
echo FROM mcr.microsoft.com/hello-world > Dockerfile

#build the image
az acr build --image sample/hello-world:v1 --registry <myContainerRegistry> --file Dockerfile .

#list repos
az acr repository list --name <myContainerRegistry> --output table

#show tags
az acr repository show-tags --name <myContainerRegistry> \
    --repository sample/hello-world --output table

#run the container
az acr run --registry <myContainerRegistry> \
    --cmd '$Registry/sample/hello-world:v1' /dev/null

#----------------------ooutput run command----------
# Queued a run with ID: ca2
# Waiting for an agent...
# 2023/11/22 14:26:02 Alias support enabled for version >= 1.1.0, please see https://aka.ms/acr/tasks/task-aliases for more information.
# 2023/11/22 14:26:02 Creating Docker network: acb_default_network, driver: 'bridge'
# 2023/11/22 14:26:03 Successfully set up Docker network: acb_default_network
# 2023/11/22 14:26:03 Setting up Docker configuration...
# 2023/11/22 14:26:03 Successfully set up Docker configuration
# 2023/11/22 14:26:03 Logging in to registry: samacr123.azurecr.io
# 2023/11/22 14:26:04 Successfully logged into samacr123.azurecr.io
# 2023/11/22 14:26:04 Executing step ID: acb_step_0. Timeout(sec): 600, Working directory: '', Network: 'acb_default_network'
# 2023/11/22 14:26:04 Launching container with name: acb_step_0
# Unable to find image 'samacr123.azurecr.io/sample/hello-world:v' locally
# v: Pulling from sample/hello-world
# 1b930d010525: Pulling fs layer
# 1b930d010525: Download complete
# 1b930d010525: Pull complete
# Digest: sha256:92c7f9c92844bbbb5d0a101b22f7c2a7949e40f8ea90c8b3bc396879d95e899a
# Status: Downloaded newer image for samacr123.azurecr.io/sample/hello-world:v
#----------------------------------------------------------

#cleaning resources
az group delete --name sam_storage_rcrg --no-wait
