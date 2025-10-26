param environmentName string
param location string = resourceGroup().location
param principalId string = ''
param tags object = {}

// Container Apps Environment
module containerAppsEnvironment './core/host/container-apps-environment.bicep' = {
  name: 'container-apps-environment'
  params: {
    name: '${environmentName}-env'
    location: location
    tags: tags
    logAnalyticsWorkspaceName: logAnalyticsWorkspace.outputs.name
  }
}

// Log Analytics Workspace
module logAnalyticsWorkspace './core/monitor/loganalytics.bicep' = {
  name: 'log-analytics'
  params: {
    name: '${environmentName}-logs'
    location: location
    tags: tags
  }
}

// Application Insights
module applicationInsights './core/monitor/applicationinsights.bicep' = {
  name: 'application-insights'
  params: {
    name: '${environmentName}-appinsights'
    location: location
    tags: tags
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.id
  }
}

// Container Registry
module containerRegistry './core/host/container-registry.bicep' = {
  name: 'container-registry'
  params: {
    name: '${replace(environmentName, '-', '')}acr'
    location: location
    tags: tags
  }
}

// Azure Database for PostgreSQL Flexible Server
module postgresServer './core/database/postgresql.bicep' = {
  name: 'postgres-server'
  params: {
    name: '${environmentName}-postgres'
    location: location
    tags: tags
    administratorLogin: 'pgadmin'
    administratorLoginPassword: postgresPassword.outputs.value
    databases: [
      'catalogdb'
      'identitydb'
      'orderingdb'
      'webhooksdb'
    ]
  }
}

// Azure Cache for Redis
module redis './core/database/redis.bicep' = {
  name: 'redis'
  params: {
    name: '${environmentName}-redis'
    location: location
    tags: tags
  }
}

// Azure Service Bus (replacing RabbitMQ)
module serviceBus './core/messaging/servicebus.bicep' = {
  name: 'service-bus'
  params: {
    name: '${environmentName}-servicebus'
    location: location
    tags: tags
    queues: []
    topics: [
      'integration-events'
    ]
  }
}

// Key Vault for secrets
module keyVault './core/security/keyvault.bicep' = {
  name: 'key-vault'
  params: {
    name: '${take(replace(environmentName, '-', ''), 20)}kv'
    location: location
    tags: tags
    principalId: principalId
  }
}

// Generate PostgreSQL password
module postgresPassword './core/security/password.bicep' = {
  name: 'postgres-password'
  params: {
    keyVaultName: keyVault.outputs.name
    secretName: 'postgres-password'
  }
}

// Container Apps for services
var containerAppsConfig = {
  basketApi: {
    name: 'basket-api'
    targetPort: 8080
    external: false
  }
  catalogApi: {
    name: 'catalog-api'
    targetPort: 8080
    external: false
  }
  identityApi: {
    name: 'identity-api'
    targetPort: 8080
    external: true
  }
  orderingApi: {
    name: 'ordering-api'
    targetPort: 8080
    external: false
  }
  webhooksApi: {
    name: 'webhooks-api'
    targetPort: 8080
    external: false
  }
  orderProcessor: {
    name: 'order-processor'
    targetPort: 8080
    external: false
  }
  paymentProcessor: {
    name: 'payment-processor'
    targetPort: 8080
    external: false
  }
  mobileBff: {
    name: 'mobile-bff'
    targetPort: 8080
    external: false
  }
  webapp: {
    name: 'webapp'
    targetPort: 8080
    external: true
  }
  webhookClient: {
    name: 'webhooksclient'
    targetPort: 8080
    external: false
  }
}

// Deploy Container Apps (placeholder - actual deployment done by azd)
// The actual container images will be built and pushed by Azure Developer CLI

// Outputs
output containerAppsEnvironmentId string = containerAppsEnvironment.outputs.id
output containerAppsEnvironmentName string = containerAppsEnvironment.outputs.name
output containerRegistryEndpoint string = containerRegistry.outputs.loginServer
output containerRegistryName string = containerRegistry.outputs.name
output postgresConnectionString string = 'Host=${postgresServer.outputs.fqdn};Database=catalogdb;Username=${postgresServer.outputs.administratorLogin};Password=${postgresPassword.outputs.value}'
output redisConnectionString string = redis.outputs.connectionString
output serviceBusConnectionString string = serviceBus.outputs.connectionString
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString
output webappUri string = 'https://${containerAppsConfig.webapp.name}.${containerAppsEnvironment.outputs.defaultDomain}'
output identityApiUri string = 'https://${containerAppsConfig.identityApi.name}.${containerAppsEnvironment.outputs.defaultDomain}'
