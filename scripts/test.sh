#!/bin/bash
set -e

echo "🧪 Running FieldOps monitoring stack tests..."

# Function to check if a service is responding
check_service() {
    local service_name=$1
    local url=$2
    local max_attempts=10
    local attempt=1
    
    echo -n "Testing $service_name... "
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" >/dev/null 2>&1; then
            echo "✅ Responding"
            return 0
        fi
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "❌ Not responding after $max_attempts attempts"
    return 1
}

# Function to test Prometheus queries
test_prometheus_queries() {
    echo "🔍 Testing Prometheus queries..."
    
    local prometheus_url="http://localhost:9090"
    
    # Test basic query
    local query_result=$(curl -s "${prometheus_url}/api/v1/query?query=up" | grep -o '"status":"success"' || echo "")
    if [ -n "$query_result" ]; then
        echo "  ✅ Basic query test passed"
    else
        echo "  ❌ Basic query test failed"
        return 1
    fi
    
    # Test FieldOps metrics exist
    local fieldops_metrics=$(curl -s "${prometheus_url}/api/v1/query?query=fieldops_sync_total" | grep -o '"status":"success"' || echo "")
    if [ -n "$fieldops_metrics" ]; then
        echo "  ✅ FieldOps metrics available"
    else
        echo "  ❌ FieldOps metrics not found"
        return 1
    fi
    
    return 0
}

# Function to test Grafana API
test_grafana_api() {
    echo "🔍 Testing Grafana API..."
    
    local grafana_url="http://localhost:3000"
    
    # Test health endpoint
    if curl -s "${grafana_url}/api/health" | grep -q '"status":"ok"'; then
        echo "  ✅ Grafana health check passed"
    else
        echo "  ❌ Grafana health check failed"
        return 1
    fi
    
    # Test dashboard API (with basic auth)
    local auth_header="Authorization: Basic YWRtaW46YWRtaW4="  # admin:admin
    if curl -s -H "$auth_header" "${grafana_url}/api/search" | grep -q '\['; then
        echo "  ✅ Grafana API accessible"
    else
        echo "  ❌ Grafana API not accessible"
        return 1
    fi
    
    return 0
}

# Function to test custom exporter
test_custom_exporter() {
    echo "🔍 Testing FieldOps sync exporter..."
    
    local exporter_url="http://localhost:9105"
    
    # Test health endpoint
    if curl -s "${exporter_url}/health" | grep -q '"status":"healthy"'; then
        echo "  ✅ Exporter health check passed"
    else
        echo "  ❌ Exporter health check failed"
        return 1
    fi
    
    # Test metrics endpoint
    if curl -s "${exporter_url}/metrics" | grep -q "fieldops_sync_total"; then
        echo "  ✅ Exporter metrics available"
    else
        echo "  ❌ Exporter metrics not available"
        return 1
    fi
    
    # Test simulation endpoint
    local sim_result=$(curl -s -X POST "${exporter_url}/simulate" \
        -H "Content-Type: application/json" \
        -d '{"status": "success", "count": 1}' | grep -o '"status":"success"' || echo "")
    if [ -n "$sim_result" ]; then
        echo "  ✅ Exporter simulation working"
    else
        echo "  ❌ Exporter simulation failed"
        return 1
    fi
    
    return 0
}

# Function to test alerting rules
test_alerting_rules() {
    echo "🔍 Testing alerting rules..."
    
    local prometheus_url="http://localhost:9090"
    
    # Check if rules are loaded
    local rules_result=$(curl -s "${prometheus_url}/api/v1/rules" | grep -o '"status":"success"' || echo "")
    if [ -n "$rules_result" ]; then
        echo "  ✅ Alerting rules loaded"
    else
        echo "  ❌ Alerting rules not loaded"
        return 1
    fi
    
    return 0
}

# Main test execution
echo "Starting comprehensive monitoring stack tests..."
echo ""

# Check if stack is running
if ! docker-compose ps | grep -q "Up"; then
    echo "❌ Monitoring stack is not running. Please start with 'make monitor-up'"
    exit 1
fi

# Wait a moment for services to stabilize
echo "⏳ Waiting for services to stabilize..."
sleep 5

# Run tests
failed_tests=0

# Test service availability
check_service "Prometheus" "http://localhost:9090/-/ready" || failed_tests=$((failed_tests + 1))
check_service "Grafana" "http://localhost:3000/api/health" || failed_tests=$((failed_tests + 1))
check_service "Alertmanager" "http://localhost:9093/-/ready" || failed_tests=$((failed_tests + 1))
check_service "FieldOps Exporter" "http://localhost:9105/health" || failed_tests=$((failed_tests + 1))

echo ""

# Test functionality
test_prometheus_queries || failed_tests=$((failed_tests + 1))
test_grafana_api || failed_tests=$((failed_tests + 1))
test_custom_exporter || failed_tests=$((failed_tests + 1))
test_alerting_rules || failed_tests=$((failed_tests + 1))

echo ""

# Report results
if [ $failed_tests -eq 0 ]; then
    echo "🎉 All tests passed! The monitoring stack is working correctly."
    echo ""
    echo "📊 Quick links:"
    echo "  • Grafana:      http://localhost:3000"
    echo "  • Prometheus:   http://localhost:9090"
    echo "  • Alertmanager: http://localhost:9093"
    echo "  • Metrics API:  http://localhost:9105/metrics"
    exit 0
else
    echo "❌ $failed_tests test(s) failed. Please check the logs:"
    echo "   make monitor-logs"
    exit 1
fi
