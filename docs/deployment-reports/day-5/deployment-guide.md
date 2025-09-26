# Day-5 Deployment Guide
**FieldOps Support AI - Key Vault Integration**

---

## 🚀 Day-5 Overview
Day-5 adds secure credential management through Azure Key Vault with RBAC model, system-assigned managed identity integration, and PostgreSQL connection string automation.

### 🎯 Key Features Added
- **Azure Key Vault**: Standard SKU with soft-delete and purge protection
- **RBAC Authorization**: Role-based access control instead of access policies
- **Managed Identity Integration**: Web App system-assigned identity with Key Vault Secrets User role
- **Automated Secret Management**: PostgreSQL connection string stored securely
- **Zero-Secret Repository**: No credentials stored in source control or tfvars files

---

## 🏗️ Architecture Components

### Key Vault Module (`infra/modules/keyvault/`)
```hcl
# Core Features
- RBAC Authorization Model
- Soft Delete (7-day retention)
- Purge Protection (enabled)
- Standard SKU
- Public Network Access (enabled for dev)

# Security Integration
- Web App System-Assigned Identity → Key Vault Secrets User role
- PostgreSQL connection string → Secure secret storage
- Runtime credential retrieval via managed identity
```

### Integration Points
1. **App Service** → System-assigned managed identity created
2. **Key Vault** → RBAC role assignment grants secret access
3. **PostgreSQL** → Connection string components assembled securely
4. **Application** → Runtime secret retrieval via Key Vault URI

---

## 📋 Prerequisites

### Required Permissions
- **Key Vault Contributor**: Create and configure Key Vault
- **Role Assignment Administrator**: Assign RBAC roles
- **App Service Contributor**: Create App Service with managed identity

### Required Variables
- `postgres_administrator_password`: Must be passed via CLI or environment variable
- **Never store in tfvars files or source control**

---

## 🔧 Deployment Commands

### 1. Initialize and Plan
```bash
cd infra
terraform init
terraform workspace select dev || terraform workspace new dev
```

### 2. Plan with Secure Password
```bash
# Option A: CLI Variable
terraform plan -var-file=envs/dev/main.tfvars -var 'postgres_administrator_password=YourSecurePassword123!'

# Option B: Environment Variable
export TF_VAR_postgres_administrator_password='YourSecurePassword123!'
terraform plan -var-file=envs/dev/main.tfvars
```

### 3. Apply Infrastructure
```bash
# Option A: CLI Variable
terraform apply -var-file=envs/dev/main.tfvars -var 'postgres_administrator_password=YourSecurePassword123!'

# Option B: Environment Variable
export TF_VAR_postgres_administrator_password='YourSecurePassword123!'
terraform apply -var-file=envs/dev/main.tfvars
```

---

## 🔐 Security Configuration

### RBAC Role Assignment
```hcl
# Key Vault Secrets User Role
Role Definition ID: 4633458b-17de-4a8f-8f48-4f6f9ceae4a8
Principal: Web App System-Assigned Managed Identity
Scope: Key Vault Resource
Permissions: Read secrets only
```

### Connection String Format
```
Host=<postgres_fqdn>;Database=fieldops;Username=fieldopsadmin;Password=<secure_password>;SslMode=Require
```

### Application Integration
```python
# Example application code for secret retrieval
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

credential = DefaultAzureCredential()
client = SecretClient(vault_url="https://fieldopsdevkv.vault.azure.net/", credential=credential)
pg_connection = client.get_secret("pg-conn").value
```

---

## 📊 Expected Outputs

### Terraform Outputs
```bash
key_vault_uri           = "https://fieldopsdevkv.vault.azure.net/"
key_vault_name          = "fieldopsdevkv"
pg_secret_name          = "pg-conn"
web_app_principal_id    = "<system-assigned-identity-guid>"
web_app_default_hostname = "fieldops-dev-app.azurewebsites.net"
```

### Resource Validation
```bash
# Verify Key Vault
az keyvault show --name fieldopsdevkv --resource-group rg-fieldops-dev

# Verify Secret
az keyvault secret list --vault-name fieldopsdevkv

# Verify Role Assignment
az role assignment list --assignee <web_app_principal_id> --scope /subscriptions/<subscription_id>/resourceGroups/rg-fieldops-dev/providers/Microsoft.KeyVault/vaults/fieldopsdevkv
```

---

## 🎯 Post-Deployment Checklist

### Infrastructure Validation
- [ ] Key Vault created with RBAC authorization
- [ ] Web App system-assigned identity enabled
- [ ] Role assignment: Web App → Key Vault Secrets User
- [ ] PostgreSQL connection string secret stored
- [ ] App Service Plan and Web App deployed successfully
- [ ] PostgreSQL Flexible Server operational

### Security Validation
- [ ] No passwords in source control or tfvars
- [ ] RBAC permissions correctly assigned
- [ ] Soft delete and purge protection enabled
- [ ] Secret accessible via managed identity

### Application Integration
- [ ] Web App can retrieve secrets from Key Vault
- [ ] PostgreSQL connectivity via Key Vault connection string
- [ ] Application logs show successful secret retrieval
- [ ] No credential-related errors in diagnostics

---

## 🔄 Troubleshooting

### Common Issues

#### 1. PostgreSQL Regional Restrictions
**Symptom**: "LocationIsOfferRestricted" error
**Solution**: 
```bash
# Check available regions
az postgres flexible-server list-skus --location westus2
# Update location in main.tfvars if needed
```

#### 2. App Service Quota Issues
**Symptom**: Quota exceeded for Standard tier
**Solution**: 
```bash
# Check current quota
az vm list-usage --location eastus --query "[?name.localizedValue=='Standard Av2 Family vCPUs']"
# Request quota increase via Azure Portal
```

#### 3. Key Vault Access Issues
**Symptom**: Cannot retrieve secrets from application
**Solution**: 
```bash
# Verify role assignment
az role assignment list --assignee <principal_id> --all
# Check managed identity configuration
az webapp identity show --name fieldops-dev-app --resource-group rg-fieldops-dev
```

#### 4. Secret Creation Failures
**Symptom**: Key Vault secret not created
**Solution**: 
```bash
# Verify password parameter was passed
echo $TF_VAR_postgres_administrator_password
# Check create_pg_secret variable
terraform console
> var.create_pg_secret
```

---

## 📈 Next Steps (Day-6 Preparation)

### Application Deployment
1. **Container Configuration**: Prepare Docker images for App Service
2. **Environment Variables**: Configure Key Vault references in app settings
3. **Database Schema**: Deploy application schema to PostgreSQL
4. **API Configuration**: Configure APIM policies and endpoints

### Monitoring Enhancement
1. **Application Insights**: Connect application telemetry
2. **Key Vault Monitoring**: Enable diagnostic settings
3. **Security Monitoring**: Configure access and secret usage alerts
4. **Performance Baselines**: Establish monitoring thresholds

### Production Readiness
1. **Backup Strategy**: Implement automated backups
2. **Disaster Recovery**: Configure geo-redundancy
3. **Security Hardening**: Review and enhance security configurations
4. **Cost Optimization**: Implement resource management policies

---

**Generated**: September 25, 2025  
**Phase**: Day-5 Key Vault Integration  
**Status**: Ready for Deployment
