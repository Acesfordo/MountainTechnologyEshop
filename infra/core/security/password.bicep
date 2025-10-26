param keyVaultName string
param secretName string

// Generate a random password
var password = uniqueString(resourceGroup().id, secretName, deployment().name)

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: secretName
  parent: keyVault
  properties: {
    value: password
  }
}

output value string = secret.properties.value
