param location string
param tags object

// create azure container instance
resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: 'myContainerGroup'
  tags: tags
  location: location
  properties: {
    containers: [
      {
        name: 'db2-demo'
        properties: {
          image: 'icr.io/db2_community/db2'
          
          ports: [
            {
              port: 50000
              protocol: 'TCP'
            }
          ]
          environmentVariables: [
            {
              name: 'ACCEPT_EULA'
              value: 'Y'
            }
            {
              name: 'DB2INST1_PASSWORD'
              value: 'db2inst1'
            }
            {
              name: 'LICENSE'
              value: 'accept'
            }
            {name: 'DBNAME'
              value: 'sample'
            }
            {
              name: 'AUTOCONFIG'
              value: 'true'
            }
            {
              name: 'TO_CREATE_SAMPLEDB'
              value: 'true'
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
        }
      }
    ]
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'TCP'
          port: 50000
        }
      ]
    }
    restartPolicy: 'OnFailure'
  }
}

