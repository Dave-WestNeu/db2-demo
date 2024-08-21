param tags object
param location string
param rgName string
@description('The name of the Managed Cluster resource.')
param clusterName string = 'akscluster'

param linuxAdminUsername string = 'dwest'
param sshRSAPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOKPVnzSpTeQ2nx0HRZ3tu4DCRUIcjmme4B7SJUJQRzKLQgeAN3gsqZeQfY5NkCzxgt/1k7RMMHgc+I6nCHd/KCeEa55Kk2QToPa9ZgNVJcWUXxZ0BwDcMCEwAPm/G/N93AjZolJe4AKPtu0NnYm0QGKGbk0W/aXn4GZ2k2NJNDDSpPR5ZAiONsCm7LryE79nqhmbvuFl+2pTTi9Bsvnrf5RXiCADxpFXL+kpGWNBaORCaCQFKHVvXeJe9W0udmAFXrOU5H8oG0W6dLVeQzGa0Bh2CK8ITvd+QQ66Xpfb+paYExLUZHo6BBE+QOd9HRNG6B4urQ3silm78nNTgVcaV'

var addressPrefix = '10.0.0.0/16'

// vnet and subnet
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'myVnet'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'mySubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${clusterName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowPort50000'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '50000'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'AllowPort30000'
        properties: {
          priority: 999
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '30000'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// service principal for aks
resource sp 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: 'myServicePrincipal'
  location: location
  tags: tags
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 30
        count: 1
        vmSize: 'Standard_B2s'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
  tags: tags
}

// deploy pod
// resource podDeployment 'Microsoft.ContainerService/managedClusters/kubernetesConfiguration@2021-03-01' = {
//   name: 'podDeployment'
//   parent: aksCluster
//   properties: {
//     namespace: 'default'
//     manifest: '''
// apiVersion: v1
// kind: Pod
// metadata:
//   name: db2-deployment
//   namespace: default
//   labels:
//     app: db2
// spec:
//   containers:
//   - name: db2
//     image: icr.io/db2_community/db2
//     ports:
//     - containerPort: 50000
//       protocol: TCP
//     env:
//     - name: ACCEPT_EULA
//       value: 'Y'
//     - name: DB2INST1_PASSWORD
//       value: 'your_password'
//     - name: LICENSE
//       value: 'accept'
//     securityContext:
//       privileged: true
// ---
// apiVersion: v1
// kind: Service
// metadata:
//   name: db2-service
//   namespace: default
// spec:
//   type: NodePort
//   selector:
//     app: db2
//   ports:
//     - protocol: TCP
//       port: 50000
//       targetPort: 50000
//       nodePort: 30000
// '''
//   }
// }
