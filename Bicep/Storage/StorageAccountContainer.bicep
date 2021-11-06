param containerName string
param parent string

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${parent}/default/${containerName}'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}
