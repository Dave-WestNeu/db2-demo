param location string

param tags object = {
  Owner: 'ram.mudalagiri@neudesic.com'
  Purpose: 'DB2 Container'
}

// create azure resource group
//resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
//  name: 'rg-openaistudio-demo-01'
//}

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
  scope: resourceGroup('rg-openaistudio-demo-01')
  params: {
    rgName: 'rg-openaistudio-demo-01'
    location: location
    tags: tags
  }
}
