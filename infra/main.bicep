targetScope = 'subscription'

param location string

param tags object = {
  Owner: 'Dave.West@neudesic.com'
  Purpose: 'DB2 Container'
}

// create azure resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'myResourceGroup'
  location: location
  tags: tags
}

// module azureContainerInstance 'modules/azureContainerInstance.bicep' = {
//   name: 'azureContainerInstance'
//   scope: rg
//   params: {
//     location: location
//     tags: tags
//   }
// }

module aks 'modules/aks.bicep' = {
  name: 'aks'
  scope: rg
  params: {
    rgName: rg.name
    location: location
    tags: tags
  }
}
