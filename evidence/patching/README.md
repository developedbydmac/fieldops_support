# Patching Evidence Collection

## Required Screenshots
- **Azure Update Management**: Patch deployment status and schedule configuration
- **System Health**: Before and after system performance metrics
- **Application Status**: Service availability during maintenance windows
- **Ansible Dashboard**: Playbook execution results and task completion status
- **Log Analytics**: Patch compliance dashboard and error trending
- **Azure Arc**: Connected machine status and policy compliance

## Required Logs
- **patch-deployment.log**: Complete patch installation log with success/failure details
- **ansible-playbook.log**: Ansible execution log with task-by-task results
- **system-reboot.log**: Server restart logs and boot sequence verification
- **application-health.log**: Pre/post-patch application health check results
- **rollback-execution.log**: Any rollback operations performed during patching

## Compliance Artifacts
- **patch-compliance-report.json**: System-wide patch status and vulnerability closure
- **maintenance-window-summary.pdf**: Maintenance execution summary with downtime tracking
- **security-scan-results.json**: Vulnerability scan before and after patching
- **change-impact-analysis.csv**: Applications and services affected by patches
- **sla-compliance.json**: Service level agreement compliance during maintenance

## Naming Convention
Use format: `YYYY-MM-DD_maintenance-cycle_<artifact-name>.<extension>`
Example: `2025-09-29_monthly-patches_patch-deployment.log`

## Retention Policy
- Screenshots: 6 months for operational review
- Logs: 2 years for compliance and troubleshooting
- Compliance artifacts: 3 years per audit requirements
