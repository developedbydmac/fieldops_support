#!/bin/bash
set -e

echo "🛑 Stopping FieldOps monitoring stack..."

# Check if docker-compose is available
if ! command -v docker-compose >/dev/null 2>&1; then
    echo "❌ docker-compose not found. Please install docker-compose."
    exit 1
fi

# Stop the stack
echo "📊 Stopping monitoring services..."
docker-compose down

echo ""
echo "✅ FieldOps monitoring stack stopped successfully!"
echo ""
echo "💡 To preserve data volumes, services have been stopped but data is retained."
echo "   To completely remove volumes and data, run: make monitor-clean"
echo ""
echo "🔧 Management commands:"
echo "  • Start stack:     make monitor-up"
echo "  • View status:     make monitor-status"
echo "  • Clean volumes:   make monitor-clean"
echo ""
