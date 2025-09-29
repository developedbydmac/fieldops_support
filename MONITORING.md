# FieldOps Support AI - Phase 2 Monitoring System

## 📊 Overview

This directory contains a comprehensive monitoring and alerting system for the FieldOps Support AI platform. The system implements production-grade observability with SLI/SLO-based alerting, custom metrics, and modern tooling.

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│    Grafana      │────│   Prometheus    │────│  Alertmanager   │
│   (Dashboards)  │    │   (Metrics)     │    │  (Alerting)     │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│ Node Exporter   │    │ Blackbox Probe  │    │ FieldOps Sync   │
│ (System Metrics)│    │ (Uptime Checks) │    │ (Custom Metrics)│
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Make (optional, for convenience commands)

### 1. Setup Environment
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your configuration (especially Slack webhook)
vi .env
```

### 2. Start the Stack
```bash
# Using Make (recommended)
make monitor-up

# Or using Docker Compose directly
docker-compose up -d
```

### 3. Access Services
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Alertmanager**: http://localhost:9093
- **Custom Metrics**: http://localhost:9105/metrics

### 4. Verify Installation
```bash
# Run comprehensive tests
make monitor-test

# Check service status
make monitor-status

# View logs
make monitor-logs
```

## 📈 SLI/SLO Definitions

### Service Level Indicators (SLIs)
- **Availability**: Percentage of successful requests
- **Latency**: 95th percentile response time
- **Error Rate**: Percentage of failed requests
- **Sync Success**: Percentage of successful sync operations

### Service Level Objectives (SLOs)
- **Availability**: 99.5% over 30 days
- **Latency**: P95 < 300ms over 30 days
- **Error Rate**: < 1% over 30 days
- **Sync Success**: 98% over 30 days

### Error Budget & Burn Rate
- Multi-window burn rate alerting (1h, 6h)
- Fast burn: 14.4x normal rate
- Slow burn: 6x normal rate

## 🔔 Alerting Rules

### SLO-Based Alerts
- **High Error Budget Burn**: Fast consumption of error budget
- **Medium Error Budget Burn**: Sustained error budget consumption
- **SLO Breach Warning**: Approaching SLO violation

### Infrastructure Alerts
- **High CPU Usage**: >90% for 5 minutes
- **High Memory Usage**: >90% for 5 minutes
- **High Disk Usage**: >90% for 5 minutes
- **Service Down**: Service unavailable for 30 seconds

### Application Alerts
- **Sync Operation Failure**: High sync failure rate
- **High Response Time**: P95 latency >500ms
- **API Errors**: Error rate >5%

## 🛠️ Management Commands

```bash
# Start/Stop Stack
make monitor-up        # Start monitoring stack
make monitor-down      # Stop monitoring stack
make monitor-restart   # Restart stack

# Monitoring & Testing
make monitor-status    # Show service status
make monitor-logs      # View all logs
make monitor-test      # Run health checks
make seed             # Generate test data

# Maintenance
make monitor-clean     # Remove all containers and volumes
```

## 📊 Custom Metrics Exporter

The FieldOps Sync Exporter provides business-specific metrics:

### Endpoints
- `GET /metrics` - Prometheus metrics
- `GET /health` - Health check
- `POST /simulate` - Generate test metrics
- `GET /config` - View configuration

### Key Metrics
- `fieldops_sync_total` - Total sync operations
- `fieldops_sync_duration_seconds` - Sync operation duration
- `fieldops_sync_last_success_timestamp` - Last successful sync
- `fieldops_active_connections` - Active connections
- `fieldops_error_count` - Error count by type

### Simulation API
```bash
# Generate success metrics
curl -X POST http://localhost:9105/simulate \
  -H "Content-Type: application/json" \
  -d '{"status": "success", "count": 5}'

# Generate failure metrics (triggers alerts)
curl -X POST http://localhost:9105/simulate \
  -H "Content-Type: application/json" \
  -d '{"status": "fail", "count": 10}'
```

## 🎯 Grafana Dashboards

### FieldOps Overview Dashboard
- **System Health**: Service status overview
- **SLI Metrics**: Real-time SLI measurements
- **Error Budget**: Burn rate visualization
- **Active Alerts**: Current firing alerts
- **Infrastructure**: CPU, Memory, Disk usage
- **Application**: Sync operations, response times

### Dashboard Features
- Auto-refresh every 30 seconds
- Time range picker (1h, 6h, 24h, 7d)
- Alert annotations
- Drill-down capabilities

## 🚨 Slack Integration

Configure Slack notifications in `.env`:
```bash
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
SLACK_CHANNEL=#fieldops-alerts
```

### Alert Message Format
```
🚨 [CRITICAL] FieldOps Alert
Alert: High Error Budget Burn
Description: Availability error budget burning at 15.2x rate
Runbook: https://wiki.company.com/fieldops/runbooks/availability
```

## 🔧 Configuration

### Prometheus
- **Configuration**: `prometheus/prometheus.yml`
- **Retention**: 30 days (configurable)
- **Scrape Interval**: 15s (configurable)

### Alertmanager
- **Configuration**: `alertmanager/alertmanager.yml`
- **Routing**: Severity-based routing
- **Grouping**: By alertname and cluster

### Grafana
- **Provisioning**: `grafana/provisioning/`
- **Dashboards**: `grafana/dashboards/`
- **Data Sources**: Auto-configured Prometheus

## 🧪 Testing

### Automated Tests
```bash
make monitor-test
```

Tests include:
- Service availability checks
- Prometheus query validation
- Grafana API connectivity
- Custom exporter functionality
- Alert rule validation

### Manual Testing
```bash
# Test alert firing
make test-alert-failure

# Test alert recovery
make test-alert-success

# View metrics
curl http://localhost:9105/metrics
```

## 📈 Performance Tuning

### Resource Requirements
- **Minimum**: 2 CPU, 4GB RAM
- **Recommended**: 4 CPU, 8GB RAM
- **Storage**: ~1GB/day for metrics (retention dependent)

### Scaling Considerations
- Prometheus: Increase retention and storage
- Grafana: Add read replicas for dashboards
- Alertmanager: Cluster for high availability

## 🔒 Security

### Default Credentials
- **Grafana**: admin/admin (change in production!)
- **Prometheus**: No authentication (add reverse proxy)
- **Alertmanager**: No authentication (add reverse proxy)

### Production Hardening
1. Change default passwords
2. Enable HTTPS/TLS
3. Add authentication proxy
4. Network segmentation
5. Regular security updates

## 📚 Documentation

### Runbooks
- Create runbooks for each alert type
- Include escalation procedures
- Document troubleshooting steps

### Training Materials
- Dashboard usage guide
- Alert response procedures
- Incident management workflow

## 🚀 Cloud Deployment

### Terraform Modules (Coming Soon)
- AWS CloudWatch integration
- Azure Monitor integration
- Google Cloud Operations

### CI/CD Integration
- GitHub Actions workflows
- Automated testing
- Configuration validation

## 🤝 Contributing

1. Test changes locally with `make monitor-test`
2. Update documentation for new features
3. Follow monitoring best practices
4. Add tests for new functionality

## 📞 Support

### Escalation Path
1. **L1**: Field technicians
2. **L2**: Platform team
3. **L3**: Engineering team
4. **L4**: External vendor support

### Resources
- Internal Wiki: [Link to internal docs]
- Slack: #fieldops-support
- On-call: PagerDuty rotation
