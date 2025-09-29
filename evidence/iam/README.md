# IAM Evidence Collection

## Required Screenshots
- **Azure RBAC**: Role assignments overview showing users, groups, and scopes
- **Key Vault Access**: Access policies and RBAC assignments for secrets management
- **OPA Policy Engine**: Policy evaluation results and decision logs
- **Access Reviews**: Periodic access certification and approval workflows
- **Audit Dashboard**: Identity and access monitoring with suspicious activity alerts
- **Service Principals**: Managed identity assignments and application registrations

## Required Logs
- **rbac-changes.log**: All role assignment modifications with timestamps and justifications
- **keyvault-access.log**: Secret access attempts and successful/failed operations
- **opa-decisions.log**: Policy evaluation results for access requests
- **access-review.log**: Quarterly access review outcomes and remediation actions
- **authentication.log**: Sign-in events and multi-factor authentication results

## Compliance Artifacts
- **access-matrix.xlsx**: Complete user-to-resource access mapping
- **privileged-access-report.pdf**: High-privilege account usage and monitoring
- **policy-compliance.json**: OPA policy adherence and violation summaries
- **segregation-of-duties.csv**: Role separation analysis and conflict detection
- **emergency-access-report.json**: Break-glass access usage and justifications

## Naming Convention
Use format: `YYYY-MM-DD_access-review_<artifact-name>.<extension>`
Example: `2025-09-29_quarterly-review_access-matrix.xlsx`

## Retention Policy
- Screenshots: 1 year for access audit trails
- Logs: 7 years per regulatory compliance (SOX, GDPR)
- Compliance artifacts: 10 years for legal and audit requirements
