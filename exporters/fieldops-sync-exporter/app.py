#!/usr/bin/env python3
"""
FieldOps Sync Exporter - Custom Prometheus metrics exporter
Simulates device sync operations and exposes metrics for monitoring
"""

import logging
import os
import time
from typing import Dict, Any

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST
from prometheus_client.core import CollectorRegistry
from starlette.responses import Response
import uvicorn

# Configure logging
logging.basicConfig(
    level=getattr(logging, os.getenv('LOG_LEVEL', 'INFO')),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title="FieldOps Sync Exporter",
    description="Custom Prometheus exporter for FieldOps device sync metrics",
    version="1.0.0"
)

# Prometheus metrics registry
registry = CollectorRegistry()

# Define metrics
sync_attempts_total = Counter(
    'fieldops_sync_attempts_total',
    'Total number of device sync attempts',
    ['device_type', 'venue'],
    registry=registry
)

sync_success_total = Counter(
    'fieldops_sync_success_total', 
    'Total number of successful device syncs',
    ['device_type', 'venue'],
    registry=registry
)

sync_duration_seconds = Histogram(
    'fieldops_sync_duration_seconds',
    'Time spent on device sync operations',
    ['device_type', 'venue'],
    buckets=[0.1, 0.5, 1.0, 2.0, 5.0, 10.0, 30.0],
    registry=registry
)

http_requests_total = Counter(
    'fieldops_http_requests_total',
    'Total HTTP requests processed',
    ['method', 'endpoint', 'code'],
    registry=registry
)

active_devices = Gauge(
    'fieldops_active_devices',
    'Number of currently active devices',
    ['device_type', 'venue'],
    registry=registry
)

# Simulation state
class SimulationState:
    def __init__(self):
        self.sync_success_rate = 0.95  # Default 95% success rate
        self.latency_base = 1.2  # Base latency in seconds
        self.active_device_count = 45
        
simulation_state = SimulationState()

# Request models
class SimulateRequest(BaseModel):
    status: str  # 'success' or 'fail'
    device_type: str = 'camera'
    venue: str = 'msg'
    count: int = 1

# Routes
@app.get('/health')
async def health_check():
    """Health check endpoint"""
    http_requests_total.labels(method='GET', endpoint='/health', code='200').inc()
    return {'status': 'healthy', 'timestamp': time.time()}

@app.get('/metrics')
async def metrics():
    """Prometheus metrics endpoint"""
    http_requests_total.labels(method='GET', endpoint='/metrics', code='200').inc()
    
    # Update active devices gauge
    active_devices.labels(device_type='camera', venue='msg').set(simulation_state.active_device_count)
    active_devices.labels(device_type='wifi_ap', venue='msg').set(12)
    active_devices.labels(device_type='audio', venue='msg').set(8)
    
    metrics_output = generate_latest(registry)
    return Response(content=metrics_output, media_type=CONTENT_TYPE_LATEST)

@app.post('/simulate')
async def simulate_sync(request: SimulateRequest):
    """Simulate device sync operations for testing"""
    logger.info(f"Simulating {request.count} {request.status} sync(s) for {request.device_type} at {request.venue}")
    
    try:
        for _ in range(request.count):
            # Record sync attempt
            sync_attempts_total.labels(
                device_type=request.device_type, 
                venue=request.venue
            ).inc()
            
            # Simulate sync duration
            duration = simulation_state.latency_base + (0.5 if request.status == 'fail' else 0)
            sync_duration_seconds.labels(
                device_type=request.device_type,
                venue=request.venue
            ).observe(duration)
            
            # Record success/failure
            if request.status == 'success':
                sync_success_total.labels(
                    device_type=request.device_type,
                    venue=request.venue
                ).inc()
            
            # Small delay between simulations
            time.sleep(0.1)
        
        http_requests_total.labels(method='POST', endpoint='/simulate', code='200').inc()
        
        return {
            'message': f'Simulated {request.count} {request.status} sync(s)',
            'device_type': request.device_type,
            'venue': request.venue,
            'timestamp': time.time()
        }
        
    except Exception as e:
        logger.error(f"Error during simulation: {e}")
        http_requests_total.labels(method='POST', endpoint='/simulate', code='500').inc()
        raise HTTPException(status_code=500, detail=str(e))

@app.get('/status')
async def get_status():
    """Get current simulation status"""
    http_requests_total.labels(method='GET', endpoint='/status', code='200').inc()
    
    return {
        'sync_success_rate': simulation_state.sync_success_rate,
        'latency_base': simulation_state.latency_base,
        'active_devices': simulation_state.active_device_count,
        'timestamp': time.time()
    }

@app.post('/config')
async def update_config(config: Dict[str, Any]):
    """Update simulation configuration"""
    try:
        if 'sync_success_rate' in config:
            simulation_state.sync_success_rate = float(config['sync_success_rate'])
        if 'latency_base' in config:
            simulation_state.latency_base = float(config['latency_base']) 
        if 'active_devices' in config:
            simulation_state.active_device_count = int(config['active_devices'])
            
        http_requests_total.labels(method='POST', endpoint='/config', code='200').inc()
        logger.info(f"Updated configuration: {config}")
        
        return {
            'message': 'Configuration updated',
            'config': config,
            'timestamp': time.time()
        }
        
    except Exception as e:
        logger.error(f"Error updating configuration: {e}")
        http_requests_total.labels(method='POST', endpoint='/config', code='500').inc()
        raise HTTPException(status_code=500, detail=str(e))

# Background task to generate baseline metrics
@app.on_event("startup")
async def startup_event():
    """Initialize baseline metrics on startup"""
    logger.info("FieldOps Sync Exporter starting up...")
    
    # Generate some baseline metrics
    venues = ['msg', 'barclays', 'staples']
    device_types = ['camera', 'wifi_ap', 'audio', 'lighting']
    
    for venue in venues:
        for device_type in device_types:
            # Initial sync attempts
            sync_attempts_total.labels(device_type=device_type, venue=venue).inc(0)
            sync_success_total.labels(device_type=device_type, venue=venue).inc(0)
            active_devices.labels(device_type=device_type, venue=venue).set(0)
    
    logger.info("Baseline metrics initialized")

if __name__ == "__main__":
    port = int(os.getenv('PORT', 9105))
    host = os.getenv('HOST', '0.0.0.0')
    
    logger.info(f"Starting FieldOps Sync Exporter on {host}:{port}")
    
    uvicorn.run(
        "app:app",
        host=host,
        port=port,
        log_level=os.getenv('LOG_LEVEL', 'info').lower(),
        access_log=True
    )
