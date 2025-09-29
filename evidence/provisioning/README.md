# Provisioning Evidence Collection

## Required Screenshots
- **Azure Portal**: Resource group overview showing all deployed infrastructure
- **Terraform State**: State file status and resource count verification
- **Key Vault**: Deployed vault with RBAC assignments and secret configuration
- **API Management**: APIM gateway configuration and developer portal access
- **Network Topology**: VNet, subnets, NSGs, and private endpoint configurations
- **Log Analytics**: Workspace setup with diagnostic settings enabled

## Required Logs
- **terraform-plan.log**: Complete Terraform plan output before deployment
- **terraform-apply.log**: Full deployment log with resource creation timestamps
- **azure-activity.log**: Azure Activity Log showing resource creation events
- **deployment-validation.log**: Post-deployment validation and health checks
- **compliance-scan.log**: Security scanning results (tfsec, Checkov, or similar)

## Compliance Artifacts
- **resource-inventory.json**: Complete list of deployed Azure resources with metadata
- **cost-analysis.csv**: Resource cost breakdown and budget impact assessment
- **security-baseline.pdf**: Infrastructure security posture assessment
- **rbac-assignments.json**: All role assignments and permissions mapping
- **network-security.json**: NSG rules, firewall configurations, and access controls

## Naming Convention
Use format: `YYYY-MM-DD_HH-MM_<artifact-name>.<extension>`
Example: `2025-09-29_14-30_terraform-apply.log`

## Retention Policy
- Screenshots: 90 days minimum for compliance audits
- Logs: 1 year for troubleshooting and forensic analysis  
- Compliance artifacts: 7 years per regulatory requirements
