@minLength(1)
@maxLength(80)
@description('The name of the NSG')
param name string

@description('The location - uses the resource group location by default')
param location string = resourceGroup().location

@description('The tags')
param tags object = {}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: name
  location: location
  tags: tags
  properties:{
    securityRules:[]
  }
}
