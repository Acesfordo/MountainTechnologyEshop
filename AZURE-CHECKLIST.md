# Azure Deployment Checklist

Use this checklist to ensure a smooth deployment of the eShop application to Microsoft Azure.

## Pre-Deployment

- [ ] **Azure Account Setup**
  - [ ] Have an active Azure subscription
  - [ ] Know your Azure subscription ID
  - [ ] Have appropriate permissions (Contributor or Owner role)

- [ ] **Local Environment**
  - [ ] Docker Desktop is installed and running
  - [ ] .NET 9 SDK is installed (`dotnet --version`)
  - [ ] Azure Developer CLI (azd) is installed (`azd version`)
  - [ ] Git is installed and repository is cloned

- [ ] **Azure Resources Planning**
  - [ ] Decided on Azure region (e.g., eastus, westeurope)
  - [ ] Decided on environment name (e.g., dev, staging, production)
  - [ ] Reviewed [Azure pricing](https://azure.microsoft.com/pricing/) for Container Apps

## Initial Deployment

- [ ] **Authentication**
  ```bash
  azd auth login
  ```
  - [ ] Browser opened and successfully logged in
  - [ ] Correct Azure account is selected

- [ ] **Initialize Project**
  ```bash
  azd init
  ```
  - [ ] Selected "Use code in the current directory"
  - [ ] Confirmed .NET (Aspire) as project type
  - [ ] Selected services to expose (minimum: webapp)
  - [ ] Provided environment name

- [ ] **Deploy to Azure**
  ```bash
  azd up
  ```
  - [ ] Deployment started successfully
  - [ ] All resources provisioned (10-15 minutes)
  - [ ] Deployment completed without errors
  - [ ] Webapp URL is displayed

## Post-Deployment Verification

- [ ] **Access Application**
  - [ ] Open webapp URL in browser
  - [ ] Home page loads successfully
  - [ ] Can browse product catalog
  - [ ] Can search for products

- [ ] **Test Core Functionality**
  - [ ] User registration works
  - [ ] User login works
  - [ ] Can add items to basket
  - [ ] Can view basket
  - [ ] Can place an order

- [ ] **Check Azure Resources**
  ```bash
  azd show
  ```
  - [ ] All services are running
  - [ ] No errors in service status
  - [ ] Resource group is visible in Azure Portal

## Configuration (Optional)

- [ ] **Azure OpenAI Integration** (if needed)
  - [ ] Azure OpenAI resource created
  - [ ] Added connection string to configuration
  - [ ] Set `useOpenAI = true` in Program.cs
  - [ ] Redeployed with `azd deploy`

- [ ] **Custom Domain** (if needed)
  - [ ] Domain configured in Azure Portal
  - [ ] DNS records updated
  - [ ] SSL certificate added
  - [ ] Application accessible via custom domain

- [ ] **Monitoring Setup**
  - [ ] Reviewed Log Analytics workspace
  - [ ] Set up Application Insights (if needed)
  - [ ] Configured alerts for critical metrics
  - [ ] Tested `azd monitor` command

## Security Review

- [ ] **Access Control**
  - [ ] Reviewed who has access to Azure resources
  - [ ] Configured RBAC if needed
  - [ ] Reviewed network security groups

- [ ] **Data Protection**
  - [ ] Database connection strings are secure
  - [ ] Secrets are stored in Azure Key Vault (if applicable)
  - [ ] HTTPS is enforced for all endpoints

- [ ] **Backup and Recovery**
  - [ ] Reviewed backup policies for databases
  - [ ] Tested restore procedures (if critical)
  - [ ] Documented recovery time objectives

## Cost Management

- [ ] **Monitor Costs**
  - [ ] Set up Azure Cost Management alerts
  - [ ] Reviewed pricing for all services
  - [ ] Configured budget alerts

- [ ] **Optimization**
  - [ ] Reviewed container scaling settings
  - [ ] Considered using reserved instances (if applicable)
  - [ ] Scheduled `azd down` for dev/test environments when not in use

## Documentation

- [ ] **Team Documentation**
  - [ ] Documented environment name and region
  - [ ] Documented Azure resource group name
  - [ ] Shared webapp URL with team
  - [ ] Documented any custom configurations

- [ ] **Runbook**
  - [ ] Documented deployment process
  - [ ] Documented rollback procedure
  - [ ] Documented troubleshooting steps
  - [ ] Documented monitoring procedures

## Maintenance

- [ ] **Regular Tasks**
  - [ ] Schedule for updating dependencies
  - [ ] Schedule for security patches
  - [ ] Schedule for reviewing logs
  - [ ] Schedule for cost reviews

- [ ] **CI/CD Integration** (if needed)
  - [ ] Integrated with GitHub Actions or Azure DevOps
  - [ ] Configured automatic deployments
  - [ ] Set up deployment approvals
  - [ ] Tested rollback procedures

## Troubleshooting Reference

If issues occur during deployment:

1. **Check the error message** from `azd up`
2. **Review logs** with `azd monitor`
3. **Check service status** with `azd show`
4. **Consult documentation**: [AZURE-DEPLOYMENT.md](./AZURE-DEPLOYMENT.md)
5. **Check Azure Portal** for resource status
6. **Review troubleshooting** section in deployment guide

## Emergency Procedures

- [ ] **Rollback Plan**
  - [ ] Document previous working version
  - [ ] Test rollback with `azd deploy` using previous commit
  - [ ] Document rollback time estimate

- [ ] **Incident Response**
  - [ ] Document who to contact for issues
  - [ ] Document escalation procedures
  - [ ] Document communication channels

## Cleanup (When Needed)

To avoid ongoing charges when done testing:

```bash
azd down
```

- [ ] Confirmed all resources will be deleted
- [ ] Backed up any important data
- [ ] Executed cleanup command
- [ ] Verified resources are removed in Azure Portal

---

## Notes

Use this space to document environment-specific information:

- **Environment Name**: _______________
- **Azure Region**: _______________
- **Resource Group**: _______________
- **Webapp URL**: _______________
- **Deployment Date**: _______________
- **Deployed By**: _______________

## Related Documents

- [AZURE-QUICKSTART.md](./AZURE-QUICKSTART.md) - Quick reference
- [AZURE-DEPLOYMENT.md](./AZURE-DEPLOYMENT.md) - Detailed guide
- [README.md](./README.md) - Project overview
