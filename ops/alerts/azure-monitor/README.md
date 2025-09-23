# Azure Monitor Alerts

This directory will contain Azure Monitor alert rules and configurations for FieldOps Support AI.

## Planned Alert Categories (Week 4+)

### 1. Infrastructure Alerts
- **API Management**
  - High error rate (>5% for 5 minutes)
  - High latency (>2s average for 5 minutes)
  - Rate limiting triggered
- **App Service**
  - High CPU utilization (>80% for 10 minutes)
  - High memory usage (>90% for 5 minutes)
  - Application errors (>10 errors in 5 minutes)
- **PostgreSQL**
  - High connection usage (>80% of max)
  - Slow queries (>30s average)
  - Storage usage (>85% full)

### 2. Application Alerts
- **Support Metrics**
  - Average Handle Time exceeds threshold (>30 min)
  - First-Fix Rate drops below threshold (<80%)
  - High escalation rate (>20% in 1 hour)
- **Adapter Health**
  - Vendor adapter failure rate (>10% for vendor)
  - Diagnostic flow failures (>5 failures in 10 minutes)

### 3. Security Alerts
- **Authentication**
  - Multiple failed login attempts
  - Unusual access patterns
- **Key Vault**
  - Unauthorized access attempts
  - Secret access anomalies

## Alert Configuration
- **Severity Levels**: Critical, High, Medium, Low
- **Notification Channels**: 
  - Email for non-critical alerts
  - SMS/Teams for critical alerts
  - PagerDuty integration for production
- **Escalation**: Auto-escalate unacknowledged critical alerts

## Implementation
- Alert rules defined as ARM templates
- Automated deployment via Terraform
- Integration with Log Analytics queries

## TODO
- [ ] Define alert rule templates
- [ ] Create notification action groups
- [ ] Set up alert correlation rules
- [ ] Configure suppression rules for maintenance
