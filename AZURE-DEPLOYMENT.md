# Deploying eShop to Microsoft Azure

This guide explains how to deploy the eShop application to Microsoft Azure using Azure Developer CLI (azd).

## Overview

The eShop application is built on .NET Aspire and can be deployed to Azure Container Apps, which provides a fully managed environment for running containerized applications. Azure Developer CLI (azd) automates the provisioning of Azure resources and deployment of the application.

## Prerequisites

Before deploying to Azure, ensure you have:

1. **Azure Subscription**: An active Azure subscription. [Create a free account](https://azure.microsoft.com/free/) if you don't have one.

2. **Azure Developer CLI (azd)**: Install the latest version of Azure Developer CLI.
   - Windows: `winget install microsoft.azd`
   - macOS: `brew tap azure/azd && brew install azd`
   - Linux: `curl -fsSL https://aka.ms/install-azd.sh | bash`
   
   For more installation options, visit: https://aka.ms/azure-dev/install

3. **.NET 9 SDK**: Ensure you have .NET 9 SDK installed on your machine.
   - Download from: https://dot.net/download

4. **Docker Desktop**: Docker is required for building container images.
   - Download from: https://docs.docker.com/engine/install/

## Deployment Steps

### 1. Login to Azure

First, authenticate with your Azure account:

```bash
azd auth login
```

This will open a browser window for you to sign in to your Azure account.

### 2. Initialize Azure Developer CLI

From the root directory of the repository, initialize azd:

```bash
azd init
```

During initialization:
- Select **"Use code in the current directory"** when prompted
- Azd will automatically detect the .NET Aspire project
- Confirm **.NET (Aspire)** when asked about the project type
- Select which services to expose to the Internet:
  - At minimum, select **webapp** to make the web store accessible
  - Optionally select **identity-api** if you need external identity provider access
- Provide an environment name (e.g., "production", "staging", "dev")

### 3. Deploy to Azure

Deploy the application to Azure:

```bash
azd up
```

This command will:
1. Provision Azure resources (Container Apps Environment, Container Registry, etc.)
2. Build Docker images for all services
3. Push images to Azure Container Registry
4. Deploy containers to Azure Container Apps
5. Configure networking and dependencies

**Note**: The first deployment typically takes 10-15 minutes as it provisions all necessary Azure resources.

### 4. Access Your Application

After successful deployment, azd will display the URLs for accessing your application:

```
Endpoints:
  webapp: https://webapp.{unique-id}.{region}.azurecontainerapps.io
```

Click on the webapp URL to access your deployed eShop application.

## Azure Resources Created

When you deploy using `azd up`, the following Azure resources are automatically created:

- **Resource Group**: Container for all resources
- **Container Apps Environment**: Managed environment for your containers
- **Container Registry**: Private registry for your Docker images
- **Container Apps**: Individual apps for each service (webapp, catalog-api, basket-api, etc.)
- **PostgreSQL Database**: Managed PostgreSQL for data storage
- **Redis Cache**: Managed Redis for caching and sessions
- **Log Analytics Workspace**: For application logging and monitoring
- **Service Bus**: For event messaging (RabbitMQ replacement)

## Managing Your Deployment

### View Resources

To see all deployed resources:

```bash
azd show
```

### Update Application

After making code changes, redeploy with:

```bash
azd deploy
```

This is faster than `azd up` as it only redeploys the application without reprovisioning resources.

### Monitor Application

View application logs:

```bash
azd monitor
```

Or access the Azure Portal for detailed monitoring:

```bash
azd show --output json
```

### Delete Resources

To remove all Azure resources and avoid charges:

```bash
azd down
```

**Warning**: This permanently deletes all resources and data.

## Configuration

### Environment Variables

You can configure environment-specific settings by editing `.azure/{environment}/.env` after running `azd init`.

### Azure OpenAI Integration

To use Azure OpenAI with the deployed application:

1. Provision an Azure OpenAI resource in the Azure Portal
2. Update the connection string in your environment configuration
3. Set the OpenAI flag to true in `src/eShop.AppHost/Program.cs`:
   ```csharp
   bool useOpenAI = true;
   ```
4. Redeploy with `azd deploy`

### Custom Domains

To use a custom domain:

1. Add your domain in the Azure Portal under Container Apps
2. Configure DNS records
3. Add SSL certificate

See [Azure Container Apps custom domains](https://learn.microsoft.com/azure/container-apps/custom-domains-managed-certificates) for details.

## Cost Management

Azure Container Apps uses a consumption-based pricing model:

- **Container Apps**: Charged per vCPU-second and memory GB-second
- **PostgreSQL**: Charged based on compute and storage
- **Redis Cache**: Charged based on cache tier
- **Networking**: Minimal costs for outbound data transfer

To minimize costs:
- Use the free tier where available
- Scale down non-production environments
- Delete resources when not in use with `azd down`

For detailed pricing: https://azure.microsoft.com/pricing/details/container-apps/

## Troubleshooting

### Deployment Fails

If deployment fails:

1. Check the error message from `azd up`
2. Verify you have sufficient permissions in your Azure subscription
3. Ensure your subscription has enough quota for the required resources
4. Check the [azd troubleshooting guide](https://learn.microsoft.com/azure/developer/azure-developer-cli/troubleshoot)

### Application Not Starting

If the application deploys but doesn't start:

1. Check container logs in Azure Portal
2. Verify environment variables are set correctly
3. Check that all dependent services are running

### Connection Issues

If services can't communicate:

1. Verify all services are in the same Container Apps Environment
2. Check service discovery configuration
3. Review network security settings

## Additional Resources

- [Azure Developer CLI Documentation](https://learn.microsoft.com/azure/developer/azure-developer-cli/)
- [.NET Aspire Documentation](https://learn.microsoft.com/dotnet/aspire/)
- [Azure Container Apps Documentation](https://learn.microsoft.com/azure/container-apps/)
- [eShop on Azure Sample](https://github.com/Azure-Samples/eShopOnAzure)

## Support

For issues specific to:
- **Azure Developer CLI**: https://github.com/Azure/azure-dev/issues
- **eShop Application**: https://github.com/dotnet/eShop/issues
- **Azure Services**: https://azure.microsoft.com/support/
