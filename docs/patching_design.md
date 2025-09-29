# Patching Design - FieldOps Support AI

## Purpose
Automated security patching and configuration management for FieldOps Support AI infrastructure using Ansible playbooks with Azure Arc or Virtual Machine Scale Sets (VMSS). Replaces manual server updates with scheduled, auditable patch management.

## Inputs
- **Patch Schedules**: Maintenance windows defined per environment (dev, staging, prod)
- **Server Inventory**: Dynamic Azure resource discovery via Azure Arc or VMSS metadata
- **Patch Classifications**: Security updates, critical updates, definition updates filtering
- **Application Dependencies**: Service shutdown/startup sequences and health checks
- **Rollback Triggers**: Automated failure detection criteria and thresholds

## Controls
- **Maintenance Windows**: Enforced scheduling to minimize business impact
- **Pre-Patch Validation**: System health checks and backup verification before patching
- **Staged Deployment**: Phased rollout across development → staging → production environments
- **Health Monitoring**: Real-time application and infrastructure monitoring during patches
- **Change Tracking**: Complete audit trail of all applied patches and configuration changes

## Rollback
- **Snapshot Restoration**: VM snapshots taken before patch application
- **Package Rollback**: Automated downgrade to previous package versions
- **Configuration Restore**: Ansible-based restoration of previous system configurations
- **Blue-Green Switching**: Traffic redirection to unpatched infrastructure if available
- **Emergency Procedures**: Manual intervention processes for critical patch failures

## Proof Links
- **Ansible Playbooks**: [/ops](../ops/) or [/config](../config/) - Patch management automation
- **Pipeline Evidence**: [../evidence/patching](../evidence/patching/) - Patch deployment logs and compliance reports
- **Monitoring Dashboards**: Log Analytics queries showing patch status and system health
- **Compliance Scans**: Security vulnerability assessments before and after patching
