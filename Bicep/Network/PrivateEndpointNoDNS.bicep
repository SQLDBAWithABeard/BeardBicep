targetScope = 'resourceGroup'

param name string
param location string = ''
param tags object = {}
param subnetid string
param privateLinkServiceId string
param groupIds array

resource privateendpoint 'Microsoft.Network/privateEndpoints@2020-07-01' = {
  name: name
  location: location == '' ? resourceGroup().location : location
  tags: tags
  properties: {
    subnet: {
      id: subnetid
    }
    privateLinkServiceConnections: [
      {
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: groupIds
        }
        name: name
      }
    ]
  }
}
