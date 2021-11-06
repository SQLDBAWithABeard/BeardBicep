targetScope = 'subscription'

@minLength(1)
@maxLength(90)
@description('The name of the Resource Group')
param rgName string 
param rgLocation string = 'uksouth'

@minLength(3)
@maxLength(24)
@description('The name of the storage account -3-24	Lowercase letters and numbers.')
param storageAccountName string

@description('an array of container names')
param storageAccountContainers array = [] 

@description('An array of allowed ResourceGroup/VirtualNetwork/Subnet for access to the storage account')
param rgVirtualNetworksSubnets array

@description('ResourceGroup/VirtualNetwork/Subnet for the Private Endpoint')
param peRGVnetSubnet string

module resourceGroup '../ResourceGroup.bicep' = {
  name: 'deploy-${rgName}'
  params: {
    location: rgLocation
    name: rgName
  }
}

module storageaccount '../Storage/StorageV2.bicep' = {
  scope: az.resourceGroup(rgName)
  name: 'storageaccount${storageAccountName}-deploy'
  params: {
    name: storageAccountName
    rgVirtualNetworksSubnets: rgVirtualNetworksSubnets
    isHnsEnabled: true
    networkAclsBypass: 'AzureServices'
    skuName: 'Standard_LRS'
  }
  dependsOn:[
    resourceGroup
  ]
}

resource KeyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: 'passbeard-kv'
  scope: az.resourceGroup('PassBeard-Admin')
}

module adminpwdtokev '../KeyVault/KeyVaultSecret.bicep' = {
  name: 'storagekey-to-kv-${storageAccountName}'
  scope: az.resourceGroup('PassBeard-Admin')
  params: {
    contentType: 'The storage primary key for ${storageAccountName} in ${rgName}'
    name: '${KeyVault.name}/${rgName}-${storageAccountName}-key'
    value: storageaccount.outputs.storagePrimaryKey
  }
  dependsOn:[
    KeyVault
    storageaccount
  ]
}

module container '../Storage/StorageAccountContainer.bicep' = [for container in storageAccountContainers: {
  scope: az.resourceGroup(rgName)
  name: '${container}-deploy'
  params: {
    parent: storageAccountName
    containerName: container
  }
  dependsOn: [
    storageaccount
  ]
}]

module privateendpoint '../Network/PrivateEndpointNoDNS.bicep' = {
  scope: az.resourceGroup(rgName)
  name: '${storageAccountName}-pe-deploy'
  params: {
    groupIds: [
      'blob'
    ]
    name: '${storageAccountName}-pe'
    privateLinkServiceId: storageaccount.outputs.storageID
    subnetid: resourceId(first(split(peRGVnetSubnet, '/')), 'Microsoft.Network/virtualNetworks/subnets',substring(peRGVnetSubnet, indexOf(peRGVnetSubnet, '/') + 1, (lastIndexOf(peRGVnetSubnet, '/') - indexOf(peRGVnetSubnet, '/')) -1) , last(split(peRGVnetSubnet, '/')))
  }
}
