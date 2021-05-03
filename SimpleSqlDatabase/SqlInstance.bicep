resource sql 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: 'beardsqlrand01'
  location: 'northeurope'
  properties: {
    administratorLogin: 'sysadmin'
    administratorLoginPassword: 'dbatools.IO' // DON'T DO THIS - EVER
    version: '12.0'
  }

  resource bearddatabase 'databases@2020-11-01-preview' = {
    name: 'BicepDatabase'
    location: 'northeurope'
    sku: {
      name: 'Basic'
    }
    properties: {}
  }
}
