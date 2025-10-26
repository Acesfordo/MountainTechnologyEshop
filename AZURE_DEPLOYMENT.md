# Azure Deployment Guide

This guide explains how to deploy the eShop application to Microsoft Azure using Azure Developer CLI (azd).

## Prerequisites

1. **Azure Subscription**: You need an active Azure subscription. If you don't have one, create a [free account](https://azure.microsoft.com/free/).

2. **Azure Developer CLI (azd)**: Install the latest version of azd from [aka.ms/azd](https://aka.ms/azd).

3. **Docker Desktop**: Required for building container images. Install from [docs.docker.com](https://docs.docker.com/engine/install/).

4. **.NET 9 SDK**: Install from [dot.net/download](https://dot.net/download).

## Deployment Steps

### 1. Login to Azure

```bash
azd auth login
```

This will open a browser window for you to authenticate with your Azure account.

### 2. Initialize the Environment

```bash
azd init
```

When prompted:
- Choose **"Use code in the current directory"**
- Confirm **".NET (Aspire)"** as the project type
- Select which services to expose publicly (at minimum, expose `webapp` and `identity-api`)
- Provide a name for your environment (e.g., `eshop-prod`)

### 3. Provision and Deploy

```bash
azd up
```

This command will:
- Create all required Azure resources (Container Apps, PostgreSQL, Redis, Service Bus, etc.)
- Build Docker images for all services
- Push images to Azure Container Registry
- Deploy containers to Azure Container Apps
- Configure networking and service connections

The first deployment typically takes 10-15 minutes.

### 4. Access Your Application

After deployment completes, azd will display the URLs for your deployed services:

```
Deployed services:
- webapp: https://webapp.{unique-id}.{region}.azurecontainerapps.io
- identity-api: https://identity-api.{unique-id}.{region}.azurecontainerapps.io
```

Open the `webapp` URL in your browser to access the eShop application.

## Azure Resources Created

The deployment creates the following Azure resources:

- **Resource Group**: Contains all resources for the environment
- **Container Apps Environment**: Hosts all microservices
- **Azure Container Registry**: Stores Docker images
- **Azure Database for PostgreSQL**: Flexible Server with 4 databases (catalog, identity, ordering, webhooks)
- **Azure Cache for Redis**: For basket/session storage
- **Azure Service Bus**: For event-driven messaging between services
- **Log Analytics Workspace**: For logging and monitoring
- **Application Insights**: For application performance monitoring
- **Key Vault**: For secrets management

## Managing Your Deployment

### Update the Application

After making code changes:

```bash
azd deploy
```

This rebuilds and redeploys only the changed services.

### View Logs

```bash
azd monitor
```

This opens the Azure Portal monitoring dashboard.

### Cleanup Resources

When done testing:

```bash
azd down
```

This deletes all Azure resources to avoid ongoing charges.

## Configuration

### Environment Variables

The application uses the following connection strings, automatically configured by azd:

- `POSTGRES_CONNECTION_STRING`: PostgreSQL database connection
- `REDIS_CONNECTION_STRING`: Redis cache connection  
- `SERVICEBUS_CONNECTION_STRING`: Service Bus connection
- `APPLICATIONINSIGHTS_CONNECTION_STRING`: Application Insights telemetry

### Customization

To customize the infrastructure:

1. Edit files in the `infra/` directory
2. Modify `azure.yaml` to add/remove services
3. Run `azd provision` to apply changes

## Troubleshooting

### Deployment Failures

Check deployment logs:
```bash
azd deploy --debug
```

### Connection Issues

Verify firewall rules allow your IP:
```bash
az postgres flexible-server firewall-rule list --resource-group <rg-name> --name <server-name>
```

### Cost Management

Monitor costs in the [Azure Portal](https://portal.azure.com) under Cost Management + Billing.

The default configuration uses budget-friendly tiers:
- Container Apps: Consumption plan
- PostgreSQL: Burstable B1ms tier
- Redis: Basic C0 tier
- Service Bus: Standard tier

## Support

For issues with:
- **Azure Developer CLI**: [Azure/azure-dev](https://github.com/Azure/azure-dev/issues)
- **eShop Application**: [dotnet/eShop](https://github.com/dotnet/eShop/issues)
- **Azure Services**: [Azure Support](https://azure.microsoft.com/support/)

## Additional Resources

- [Azure Developer CLI Documentation](https://learn.microsoft.com/azure/developer/azure-developer-cli/)
- [.NET Aspire Documentation](https://learn.microsoft.com/dotnet/aspire/)
- [Azure Container Apps Documentation](https://learn.microsoft.com/azure/container-apps/)
