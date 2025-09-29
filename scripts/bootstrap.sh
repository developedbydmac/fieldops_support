#!/bin/bash
# FieldOps Monitoring Stack - Bootstrap script

set -e

echo "🚀 FieldOps Monitoring Stack - Bootstrap"
echo "========================================"

# Check for required tools
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "❌ $1 is required but not installed"
        exit 1
    fi
    echo "✅ $1 found"
}

echo "📋 Checking prerequisites..."
check_command docker
check_command docker-compose

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please update .env with your actual values before starting"
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p logs
mkdir -p data/{prometheus,grafana,alertmanager}

# Set permissions for Grafana
echo "🔒 Setting permissions..."
sudo chown -R 472:472 grafana/ || echo "⚠️  Could not set Grafana permissions (run as root if needed)"

# Pull Docker images
echo "📦 Pulling Docker images..."
docker-compose pull

echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "1. Update .env with your Slack webhook URL"
echo "2. Run 'make up' to start the stack"
echo "3. Run 'make seed' to generate test data"
echo "4. Open http://localhost:3000 for Grafana"
