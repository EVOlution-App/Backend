#!/bin/bash

set -e

# Create services
echo "Creating services..."
cf create-service "Auto-Scaling" "free" "swift-evolution-auto-scaling"
echo "Services created."
