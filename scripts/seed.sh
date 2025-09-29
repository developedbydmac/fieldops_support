#!/bin/bash
# FieldOps Monitoring Stack - Seed data script

set -e

echo "🌱 Seeding FieldOps monitoring data..."

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Function to check if service is ready
wait_for_service() {
    local url=$1
    local name=$2
    local max_attempts=30
    local attempt=1
    
    echo "🔍 Waiting for $name to be ready..."
    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" > /dev/null 2>&1; then
            echo "✅ $name is ready"
            return 0
        fi
        echo "⏳ Attempt $attempt/$max_attempts - waiting for $name..."
        sleep 2
        ((attempt++))
    done
    
    echo "❌ $name failed to start within expected time"
    return 1
}

# Wait for services
wait_for_service "http://localhost:9105/health" "FieldOps Sync Exporter"
wait_for_service "http://localhost:9090" "Prometheus"
wait_for_service "http://localhost:3000" "Grafana"

# Generate successful sync events
echo "📊 Generating successful sync metrics..."
for i in {1..10}; do
    curl -s -X POST "http://localhost:9105/simulate" \
        -H "Content-Type: application/json" \
        -d '{"status": "success", "device_type": "camera", "venue": "msg", "count": 3}' \
        > /dev/null
    
    curl -s -X POST "http://localhost:9105/simulate" \
        -H "Content-Type: application/json" \
        -d '{"status": "success", "device_type": "wifi_ap", "venue": "barclays", "count": 2}' \
        > /dev/null
        
    sleep 1
done

# Generate some failures for testing
echo "📊 Generating failure metrics for testing..."
curl -s -X POST "http://localhost:9105/simulate" \
    -H "Content-Type: application/json" \
    -d '{"status": "fail", "device_type": "camera", "venue": "msg", "count": 2}' \
    > /dev/null

curl -s -X POST "http://localhost:9105/simulate" \
    -H "Content-Type: application/json" \
    -d '{"status": "fail", "device_type": "wifi_ap", "venue": "barclays", "count": 1}' \
    > /dev/null

echo "✅ Seed data generated successfully!"
echo ""
echo "📊 Access your monitoring stack:"
echo "   Grafana:      http://localhost:3000 (admin/admin)"
echo "   Prometheus:   http://localhost:9090"
echo "   Alertmanager: http://localhost:9093"
echo "   Sync Metrics: http://localhost:9105/metrics"
echo ""
echo "🎯 To trigger alerts, run:"
echo "   curl -X POST http://localhost:9105/simulate -H 'Content-Type: application/json' -d '{\"status\": \"fail\", \"count\": 10}'"
