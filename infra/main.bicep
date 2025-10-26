targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Id of the user or app to assign application roles')
param principalId string = ''

// Optional parameters
@description('Name of the resource group')
param resourceGroupName string = ''

// Tags that should be applied to all resources
var tags = {
  'azd-env-name': environmentName
}

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${environmentName}-rg'
  location: location
  tags: tags
}

// Deploy resources
module resources './resources.bicep' = {
  name: 'resources'
  scope: rg
  params: {
    environmentName: environmentName
    location: location
    principalId: principalId
    tags: tags
  }
}

// Outputs
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_RESOURCE_GROUP string = rg.name

// Container Apps Environment outputs
output AZURE_CONTAINER_APPS_ENVIRONMENT_ID string = resources.outputs.containerAppsEnvironmentId
output AZURE_CONTAINER_APPS_ENVIRONMENT_NAME string = resources.outputs.containerAppsEnvironmentName

// Container Registry outputs
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = resources.outputs.containerRegistryEndpoint
output AZURE_CONTAINER_REGISTRY_NAME string = resources.outputs.containerRegistryName

// Database outputs
output POSTGRES_CONNECTION_STRING string = resources.outputs.postgresConnectionString

// Redis outputs
output REDIS_CONNECTION_STRING string = resources.outputs.redisConnectionString

// Service Bus outputs  
output SERVICEBUS_CONNECTION_STRING string = resources.outputs.serviceBusConnectionString

// Application Insights outputs
output APPLICATIONINSIGHTS_CONNECTION_STRING string = resources.outputs.applicationInsightsConnectionString

// Service endpoints
output WEBAPP_URI string = resources.outputs.webappUri
output IDENTITY_API_URI string = resources.outputs.identityApiUri
