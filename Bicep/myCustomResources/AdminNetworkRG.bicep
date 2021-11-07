targetScope = 'subscription'

@minLength(1)
@maxLength(90)
@description('The name of the Resource Group')
param rgName string = 'beardednetwork-rg'
param rgLocation string = 'uksouth'

param subnets array = [
  {
    subnetName: 'Public'
    addressPrefix: '10.0.1.0/24'
  }
]

@minLength(2)
@maxLength(64)
@description('The name of the Virtual Network')
param vNetName string = 'beardvnet'

@description('A list of address blocks reserved for this virtual network in CIDR notation')
param vNetaddressPrefixes array = [
  '10.0.0.0/16'
]
@description('An array of serviceEndpoints for the subnets objects - service: Name ; locations: []')
param vNetserviceEndpoints array = [
  {
    service: 'Microsoft.AzureCosmosDB'
    locations: '*'
  }
  {
    service: 'Microsoft.KeyVault'
    locations: '*'
  }
  {
    service: 'Microsoft.Sql'
    locations: 'uksouth'
  }
  {
    service: 'Microsoft.Storage'
    locations: [
      'uksouth'
      'ukwest'
    ]
  }
]

@minLength(1)
@maxLength(80)
@description('The subnet name - vNetName/subnetName')
param subnet1Name string = 'private'

@description('Address Prefix for this subnet in CIDR notation')
param subnet1addressPrefix string = '10.0.2.0/24'

@minLength(1)
@maxLength(80)
@description('The subnet name - vNetName/subnetName')
param subnet2Name string = 'private'

@description('Address Prefix for this subnet in CIDR notation')
param subnet2addressPrefix string = '10.0.2.0/24'


@description('An array of serviceEndpoints for the subnets objects - service: Name ; locations: []')
param subnetServiceEndpoints array = [
  {
    service: 'Microsoft.AzureCosmosDB'
    locations: '*'
  }
  {
    service: 'Microsoft.KeyVault'
    locations: 'uksouth'
  }
  {
    service: 'Microsoft.Sql'
    locations: 'uksouth'
  }
  {
    service: 'Microsoft.Storage'
    locations: [
      'uksouth'
      'ukwest'
    ]
  }
  {
    service: 'Microsoft.Web'
    locations: '*'
  }
]
@minLength(1)
@maxLength(80)
@description('The name of the NSG')
param nsgName string = 'gandalf'

var tags = {
  Role: 'Network'
  owner: 'Beardy McBeardFace'
  budget: 'Ben Weissman personal account'
  bicep: true
  BenIsAwesome: 'Always'
}

// the resource group
module resourceGroup '../ResourceGroup.bicep' = {
  name: 'deploy-${rgName}'
  params: {
    location: rgLocation
    name: rgName
    tags: tags
  }
}

// the vNet with a single subnet

module vNet '..//Network/VirtualNetwork.bicep' = {
  scope: az.resourceGroup(rgName)
  name: 'deploy-${vNetName}'
  params: {
    addressPrefixes: vNetaddressPrefixes
    name: vNetName
    subnets: subnets
    serviceEndpoints: vNetserviceEndpoints
    tags: tags
  }
  dependsOn:[
    resourceGroup
  ]
}

// another subnet with other properties

module firstsubnet '../Network/SubNet.bicep' = {
  scope: az.resourceGroup(rgName)
  name: 'deploy-${subnet1Name}'
  params: {
    addressPrefix: subnet1addressPrefix
    name: '${vNetName}/${subnet1Name}'
    serviceEndpoints: subnetServiceEndpoints
  }
  dependsOn:[
    vNet
  ]
}
module secondsubnet '../Network/SubNet.bicep' = {
  scope: az.resourceGroup(rgName)
  name: 'deploy-${subnet2Name}'
  params: {
    addressPrefix: subnet2addressPrefix
    name: '${vNetName}/${subnet2Name}'
    serviceEndpoints: subnetServiceEndpoints
    privateEndpointNetworkPolicies: 'Disabled'
  }
  dependsOn:[
    vNet
    firstsubnet
  ]
}

module nsg '../Network/NSG.bicep' = {
  scope: az.resourceGroup(rgName)
  name: 'deploy-${nsgName}'
  params: {
    name: nsgName
    tags: tags
  }
  dependsOn:[
  resourceGroup
  ]
}
