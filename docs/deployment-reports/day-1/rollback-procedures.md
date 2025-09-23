# Rollback Procedures & Recovery Plan
**FieldOps Support AI — Day-1 Rollback Guide**

---

## 🚨 Emergency Rollback Procedures

### Quick Rollback (5 minutes)
If immediate rollback is required due to critical issues:

```bash
# 1. Navigate to infrastructure directory
cd /Users/daquanmcdaniel/Documents/power5/FieldOps\ Support\ AI/infra

# 2. Destroy all Terraform-managed resources
terraform destroy -var-file=envs/dev/main.tfvars -auto-approve

# 3. Clean up workspace
terraform workspace select default
terraform workspace delete dev

# 4. Remove state files
rm -rf .terraform/
rm terraform.tfstate*
```

**⚠️ Warning:** This will destroy all deployed infrastructure. Manual resources (APIM) require separate cleanup.

### Selective Rollback by Component
For targeted rollback of specific components:

```bash
# Rollback networking only
terraform destroy -target=azurerm_virtual_network.main -var-file=envs/dev/main.tfvars

# Rollback storage only  
terraform destroy -target=azurerm_storage_account.logs -var-file=envs/dev/main.tfvars

# Rollback Key Vault only
terraform destroy -target=azurerm_key_vault.main -var-file=envs/dev/main.tfvars
```

---

## 📦 State Recovery Options

### Option 1: Git Tag Recovery
```bash
# Restore to Day-1 baseline
git checkout v0.1-day1-foundation

# Verify state
git log --oneline -5
git status
```

### Option 2: Fresh Start Recovery
```bash
# Create new branch from main
git checkout main
git pull origin main
git checkout -b day-1-recovery

# Start fresh infrastructure
cd infra
terraform init
terraform workspace new dev-recovery
```

### Option 3: Import Existing Resources
If resources exist but state is corrupted:

```bash
# Re-import existing resources
terraform import azurerm_resource_group.main /subscriptions/f485fe19-a2f2-4fc7-b122-e950cf371813/resourceGroups/rg-fieldops-dev

terraform import azurerm_virtual_network.main /subscriptions/f485fe19-a2f2-4fc7-b122-e950cf371813/resourceGroups/rg-fieldops-dev/providers/Microsoft.Network/virtualNetworks/vnet-fieldops-dev

# Continue for each resource...
```

---

## 🔄 Recovery Validation Steps

### Step 1: Infrastructure State Check
```bash
# Verify Terraform state
terraform state list
terraform show

# Check Azure resources
az resource list --resource-group rg-fieldops-dev --output table
```

### Step 2: Connectivity Validation
```bash
# Test Key Vault access
az keyvault secret show --vault-name kv-fieldops-dev --name postgres-admin-password

# Test storage access
az storage container show --name application-logs --account-name stfieldopslogsdev

# Test network configuration
az network vnet show --name vnet-fieldops-dev --resource-group rg-fieldops-dev
```

### Step 3: Configuration Validation
```bash
# Verify Terraform configuration
terraform validate
terraform plan -var-file=envs/dev/main.tfvars

# Check for drift
terraform refresh -var-file=envs/dev/main.tfvars
```

---

## 📊 Current State Backup

### Terraform State Backup
```bash
# Create state backup before any changes
cp terraform.tfstate terraform.tfstate.backup.$(date +%Y%m%d_%H%M%S)

# Export current state
terraform show -json > day-1-state-backup.json
```

### Azure Resource Export
```bash
# Export resource group template
az group export --name rg-fieldops-dev > day-1-azure-backup.json

# Create resource inventory
az resource list --resource-group rg-fieldops-dev --output json > day-1-resources.json
```

### Git State Backup
```bash
# Tag current state
git tag -a v0.1-day1-foundation -m "Day-1 infrastructure foundation with documented issues"

# Push backup
git push origin v0.1-day1-foundation

# Create recovery branch
git checkout -b day-1-recovery-point
git push origin day-1-recovery-point
```

---

## 🛠️ Manual Resource Cleanup

### API Management (Manual Resource)
```bash
# Check APIM status
az apim show --name apim-fieldops-dev --resource-group rg-fieldops-dev

# Delete APIM if needed
az apim delete --name apim-fieldops-dev --resource-group rg-fieldops-dev --yes
```

### Service Principal Cleanup (if needed)
```bash
# List current service principals
az ad sp list --display-name "fieldops-support-dev"

# Delete if rollback requires it
az ad sp delete --id 04b07795-8ddb-461a-bbee-02f9e1bf7b46
```

### Resource Group Complete Cleanup
```bash
# Nuclear option - delete entire resource group
az group delete --name rg-fieldops-dev --yes --no-wait
```

---

## 🔧 Recovery Scenarios

### Scenario 1: Terraform State Corruption
**Symptoms:** State file corrupted, resources exist but not tracked

**Recovery:**
1. Backup current state: `cp terraform.tfstate terraform.tfstate.corrupted`
2. Initialize new state: `terraform init -reconfigure`
3. Import existing resources (see import commands above)
4. Validate: `terraform plan -var-file=envs/dev/main.tfvars`

### Scenario 2: Azure Resource Drift
**Symptoms:** Terraform plan shows unexpected changes

**Recovery:**
1. Refresh state: `terraform refresh -var-file=envs/dev/main.tfvars`
2. Review changes: `terraform plan -var-file=envs/dev/main.tfvars`
3. Apply corrections: `terraform apply -var-file=envs/dev/main.tfvars`

### Scenario 3: Complete Environment Reset
**Symptoms:** Multiple issues, fresh start needed

**Recovery:**
1. Document current state (outputs, resources)
2. Execute complete rollback
3. Restore from git tag: `git checkout v0.1-day1-foundation`
4. Redeploy: `terraform apply -var-file=envs/dev/main.tfvars`

---

## 📋 Rollback Checklist

### Pre-Rollback Steps
- [ ] Document current issue causing rollback need
- [ ] Export current Terraform state
- [ ] Export Azure resource configuration
- [ ] Notify stakeholders of rollback plan
- [ ] Verify git repository is up to date

### During Rollback
- [ ] Execute rollback commands step by step
- [ ] Verify each step completion
- [ ] Document any unexpected behavior
- [ ] Take screenshots of error messages if any

### Post-Rollback Validation
- [ ] Verify Terraform state consistency
- [ ] Test resource connectivity (if partial rollback)
- [ ] Confirm git repository state
- [ ] Update project documentation
- [ ] Plan forward path to resolution

---

## 🎯 Day-2 Recovery Strategy

### If Complete Rollback Required
**Timeline:** 30 minutes setup + 2 hours redeployment

1. **Morning (Day-2):**
   - Execute rollback procedures
   - Address quota issues with Azure Support
   - Submit regional access requests

2. **Afternoon (Day-2):**
   - Redeploy with corrected configuration
   - Alternative: Deploy to different region
   - Alternative: Use Container Apps instead of App Service

### Alternative Architecture Path
If blockers persist, pivot to Container Apps:

```hcl
# Replace App Service Plan with Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                = "cae-${var.name_prefix}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  # Lower quota requirements, serverless billing
}
```

---

## 📞 Emergency Contacts

### Azure Support
- **Portal:** [portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade](https://portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade)
- **Subscription ID:** f485fe19-a2f2-4fc7-b122-e950cf371813
- **Priority:** Standard (quota requests typically 1-2 business days)

### Internal Escalation
- **Infrastructure Lead:** Review rollback decision
- **Project Manager:** Timeline impact assessment  
- **Security Team:** Service principal cleanup if needed

---

**Recovery Plan Version:** 1.0  
**Last Updated:** September 22, 2025  
**Tested:** Not tested (recommend dry run on non-prod subscription)**
