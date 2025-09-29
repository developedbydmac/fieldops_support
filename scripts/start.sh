#!/bin/bash
set -e

echo "🚀 Starting FieldOps monitoring stack..."

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose >/dev/null 2>&1; then
    echo "❌ docker-compose not found. Please install docker-compose."
    exit 1
fi

# Start the stack
echo "📊 Starting monitoring services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service health
echo "🔍 Checking service health..."

# Check Prometheus
echo -n "Prometheus: "
if curl -s http://localhost:9090/-/ready >/dev/null 2>&1; then
    echo "✅ Ready"
else
    echo "❌ Not ready"
fi

# Check Grafana
echo -n "Grafana: "
if curl -s http://localhost:3000/api/health >/dev/null 2>&1; then
    echo "✅ Ready"
else
    echo "❌ Not ready"
fi

# Check Alertmanager
echo -n "Alertmanager: "
if curl -s http://localhost:9093/-/ready >/dev/null 2>&1; then
    echo "✅ Ready"
else
    echo "❌ Not ready"
fi

# Check FieldOps Sync Exporter
echo -n "FieldOps Sync Exporter: "
if curl -s http://localhost:9105/health >/dev/null 2>&1; then
    echo "✅ Ready"
else
    echo "❌ Not ready"
fi

echo ""
echo "🎉 FieldOps monitoring stack is running!"
echo ""
echo "📊 Access URLs:"
echo "  • Grafana:      http://localhost:3000 (admin/admin)"
echo "  • Prometheus:   http://localhost:9090"
echo "  • Alertmanager: http://localhost:9093"
echo "  • Metrics API:  http://localhost:9105/metrics"
echo ""
echo "🔧 Management commands:"
echo "  • View logs:    make monitor-logs"
echo "  • Stop stack:   make monitor-down"
echo "  • Restart:      make monitor-restart"
echo "  • Test alerts:  make monitor-test"
echo ""
