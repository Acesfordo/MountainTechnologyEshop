# Quick Start: Deploy eShop to Azure

This is a quick reference guide for deploying the eShop application to Microsoft Azure. For detailed instructions, see [AZURE-DEPLOYMENT.md](./AZURE-DEPLOYMENT.md).

## Prerequisites

- Azure subscription ([Create free account](https://azure.microsoft.com/free/))
- [Azure Developer CLI (azd)](https://aka.ms/azure-dev/install)
- [.NET 9 SDK](https://dot.net/download)
- [Docker Desktop](https://docs.docker.com/engine/install/)

## Quick Deploy

```bash
# 1. Login to Azure
azd auth login

# 2. Initialize (first time only)
azd init

# 3. Deploy to Azure
azd up
```

That's it! Your eShop application will be deployed to Azure Container Apps.

## What Gets Deployed?

- All microservices (Catalog, Basket, Ordering, Identity, etc.)
- PostgreSQL database for data storage
- Redis cache for sessions and caching
- Service Bus for messaging
- Web application accessible via HTTPS

## Post-Deployment

After deployment completes, azd will display the URL for your web application:

```
webapp: https://webapp.{unique-id}.{region}.azurecontainerapps.io
```

Visit this URL to see your deployed eShop application.

## Common Commands

```bash
# Redeploy after code changes
azd deploy

# View deployed resources
azd show

# Monitor application
azd monitor

# Delete all resources
azd down
```

## Cost Estimate

Running this application on Azure typically costs:
- **Development**: ~$30-50/month (with auto-scaling)
- **Production**: Varies based on traffic and scaling

Delete resources with `azd down` when not in use to avoid charges.

## Need Help?

See [AZURE-DEPLOYMENT.md](./AZURE-DEPLOYMENT.md) for:
- Detailed deployment steps
- Configuration options
- Troubleshooting guide
- Azure OpenAI integration
- Custom domain setup
