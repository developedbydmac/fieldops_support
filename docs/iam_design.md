# Identity and Access Management (IAM) Design - FieldOps Support AI

## Purpose
Automated identity and access management for FieldOps Support AI using Azure RBAC as code with Terraform and Open Policy Agent (OPA). Replaces manual access requests with policy-driven, auditable role assignments and Key Vault access control.

## Inputs
- **User Identities**: Azure Active Directory users, groups, and service principals
- **Access Requirements**: Role definitions, resource scopes, and permission boundaries
- **Policy Rules**: OPA policies defining access patterns and approval workflows
- **Key Vault Secrets**: Secret access patterns and rotation requirements
- **Compliance Standards**: Regulatory requirements and organizational security policies

## Controls
- **Role-Based Access Control**: Terraform-managed Azure RBAC assignments with least privilege
- **Policy as Code**: OPA policy validation before access grant deployment
- **Key Vault RBAC**: Granular secret access control with audit logging
- **Access Reviews**: Automated periodic reviews and access certification
- **Separation of Duties**: Multi-person approval for privileged access changes

## Rollback
- **Permission Revocation**: Immediate RBAC role assignment removal via Terraform
- **Policy Rollback**: Git-based revert to previous OPA policy versions
- **Emergency Access**: Break-glass procedures for critical system access
- **Audit Trail Preservation**: Immutable access logs during rollback operations
- **Service Account Recovery**: Automated service principal credential rotation

## Proof Links
- **IAM Code**: [/infra](../infra/) - Terraform RBAC configurations and Key Vault policies
- **Policy Evidence**: [../evidence/iam](../evidence/iam/) - Access reviews and compliance reports
- **OPA Policies**: Policy evaluation results and access decision logs
- **Key Vault Audits**: Access logs and secret usage analytics from Azure Monitor
