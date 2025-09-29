# Provisioning Design - FieldOps Support AI

## Purpose
Automated infrastructure provisioning for FieldOps Support AI using Infrastructure as Code (IaC) with Terraform on Azure. Replaces manual Azure resource creation with versioned, repeatable deployments.

## Inputs
- **Environment Configuration**: Development, staging, production parameters via tfvars files
- **Azure Credentials**: Service principal or managed identity with appropriate RBAC permissions  
- **Resource Specifications**: VM sizes, storage tiers, network configurations, Key Vault policies
- **Application Requirements**: Container images, database schemas, API gateway configurations

## Controls
- **Terraform State Management**: Remote state in Azure Storage with state locking
- **Resource Tagging**: Mandatory tags for environment, cost center, and compliance tracking
- **Security Policies**: Network security groups, private endpoints, Key Vault RBAC enforcement
- **Change Management**: Terraform plan review and approval process via GitHub Actions
- **Resource Quotas**: Automated quota checks before deployment to prevent failures

## Rollback
- **Terraform Destroy**: Complete environment teardown with `terraform destroy`
- **Version Rollback**: Git-based rollback to previous infrastructure version
- **Selective Rollback**: Target specific resources for rollback using Terraform targeting
- **Backup Restoration**: Database and storage restoration from automated backups
- **Traffic Redirection**: Blue-green deployment rollback via API Management policies

## Proof Links
- **Infrastructure Code**: [/infra](../infra/) - Complete Terraform modules and configurations
- **Pipeline Evidence**: [../evidence/provisioning](../evidence/provisioning/) - Deployment logs and validation reports
- **Compliance Reports**: Generated terraform plan outputs and security scan results
- **Live Infrastructure**: Azure portal screenshots showing deployed resources and configurations
