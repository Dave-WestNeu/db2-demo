param location string = 'eastus'

resource db2Deployment 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: 'db2Deployment'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      contentVersion: '1.0.0.0'
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      resources: [
        {
          apiVersion: 'apps/v1'
          kind: 'Deployment'
          metadata: {
            name: 'db2-deployment'
            namespace: 'default'
          }
          spec: {
            replicas: 1
            selector: {
              matchLabels: {
                app: 'db2'
              }
            }
            template: {
              metadata: {
                labels: {
                  app: 'db2'
                }
              }
              spec: {
                containers: [
                  {
                    name: 'db2'
                    image: 'ibmcom/db2'
                    ports: [
                      {
                        containerPort: 50000
                      }
                    ]
                    securityContext: {
                      privileged: true
                    }
                  }
                ]
              }
            }
          }
        }
      ]
    }
  }
}
