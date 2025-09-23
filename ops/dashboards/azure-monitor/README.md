# Azure Monitor Dashboards

This directory will contain Azure Monitor dashboard definitions for FieldOps Support AI.

## Planned Dashboards (Week 4+)

### 1. Operational Dashboard
- **Average Handle Time (AHT)** - Track time from ticket creation to resolution
- **First-Fix Rate** - Percentage of issues resolved on first attempt
- **Escalation Rate** - Percentage of tickets escalated to Tier-2
- **Active Tickets** - Real-time view of open support tickets

### 2. Infrastructure Dashboard
- **API Management Metrics**
  - Request rate and latency
  - Error rates by endpoint
  - Throttling events
- **App Service Metrics**
  - CPU and memory utilization
  - Response time
  - HTTP errors
- **PostgreSQL Metrics**
  - Connection count
  - Query performance
  - Storage utilization

### 3. Adapter Performance Dashboard
- **Vendor Adapter Health**
  - Success/failure rates by vendor
  - Response times
  - Error patterns
- **Diagnostic Flow Metrics**
  - Camera power checks
  - DHCP/VLAN diagnostics
  - Port status verification

## Implementation Notes
- Dashboards will be created using Azure Monitor Workbooks
- JSON definitions will be stored here for version control
- Automated deployment via ARM templates or Terraform

## TODO
- [ ] Create operational dashboard JSON
- [ ] Create infrastructure dashboard JSON
- [ ] Create adapter performance dashboard JSON
- [ ] Add dashboard deployment automation
