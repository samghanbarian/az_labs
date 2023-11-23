#create resource group
az group create --name az204-aci-rg --location <myLocation>

#---------------output resource group creation------------------
{
  "id": "/subscriptions/13e19f15-986b-40ec-ba9e-3d357a188acd/resourceGroups/az204-aci-rg",
  "location": "eastus",
  "managedBy": null,
  "name": "az204-aci-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
#---------------------------------------------------------
#Create a DNS name to expose your container to the Internet.
DNS_NAME_LABEL=aci-example-$RANDOM

#start the container instance
az container create --resource-group az204-aci-rg \
    --name mycontainer \
    --image mcr.microsoft.com/azuredocs/aci-helloworld
    --ports 80 \
    --dns-name-label $DNS_NAME_LABEL --location <myLocation>
#------------------------out put : container instance creation------------
{
  "confidentialComputeProperties": null,
  "containers": [
    {
      "command": null,
      "environmentVariables": [],
      "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
      "instanceView": {
        "currentState": {
          "detailStatus": "",
          "exitCode": null,
          "finishTime": null,
          "startTime": "2023-11-23T10:56:28.768000+00:00",
          "state": "Running"
        },
        "events": null,
        "previousState": null,
        "restartCount": 0
      },
      "livenessProbe": null,
      "name": "mycontainer",
      "ports": [],
      "readinessProbe": null,
      "resources": {
        "limits": null,
        "requests": {
          "cpu": 1.0,
          "gpu": null,
          "memoryInGb": 1.5
        }
      },
      "securityContext": null,
      "volumeMounts": null
    }
  ],
  "diagnostics": null,
  "dnsConfig": null,
  "encryptionProperties": null,
  "extensions": null,
  "id": "/subscriptions/13e19f15-986b-40ec-ba9e-3d357a188acd/resourceGroups/az204-aci-rg/providers/Microsoft.ContainerInstance/containerGroups/mycontainer",
  "identity": null,
  "imageRegistryCredentials": null,
  "initContainers": [],
  "instanceView": {
    "events": [],
    "state": "Running"
  },
  "ipAddress": null,
  "location": "eastus",
  "name": "mycontainer",
  "osType": "Linux",
  "priority": null,
  "provisioningState": "Succeeded",
  "resourceGroup": "az204-aci-rg",
  "restartPolicy": "Always",
  "sku": "Standard",
  "subnetIds": null,
  "tags": {},
  "type": "Microsoft.ContainerInstance/containerGroups",
  "volumes": null,
  "zones": null
}
#---------------------------------------------
#----------------specifying a restart policy when creating container instance mount vol -------------------

az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name hellofiles \
    --image mcr.microsoft.com/azuredocs/aci-hellofiles \
    --restart-policy OnFailure #/Never/Always ; default Always
    --dns-name-label aci-demo \
    --ports 80 \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /aci/logs/
    #------------------------------------------------------

#--------------set environment vars in container-------------
az container create \
    --resource-group myResourceGroup \
    --name mycontainer2 \
    --image mcr.microsoft.com/azuredocs/aci-wordcount:latest 
    --restart-policy OnFailure \
    --environment-variables 'NumWords'='5' 'MinLength'='8'\
#-------------------------------------------------------------
#--------------specify a securevalue ENV----------------------
#yamlfile
apiVersion: 2018-10-01
location: eastus
name: securetest
properties:
  containers:
  - name: mycontainer
    properties:
      environmentVariables:
        - name: 'NOTSECRET'
          value: 'my-exposed-value'
        - name: 'SECRET'
          secureValue: 'my-secret-value'
      image: nginx
      ports: []
      resources:
        requests:
          cpu: 1.0
          memoryInGB: 1.5
  osType: Linux
  restartPolicy: Always
tags: null
type: Microsoft.ContainerInstance/containerGroups

az container create --resource-group myResourceGroup \
    --file secure-env.yaml \
#---------------------------------------------------------
#-------------------verify the instance-----------------------
az container show --resource-group az204-aci-rg \
    --name mycontainer \
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
    --out table
#navigate to FQDN to see the website

#clean up resources
az group delete --name az204-aci-rg --no-wait
