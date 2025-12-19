#!/bin/bash
set -e

echo "Installing Prometheus and Grafana via Helm..."

# Add Prometheus Community Repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create monitoring namespace
kubectl create namespace monitoring || true

# Install the Stack
# This installs Prometheus, Grafana, Alertmanager, and Node Exporters
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword='admin' \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

echo "Monitoring Stack Installed!"
echo "To access Grafana: kubectl port-forward svc/prometheus-stack-grafana -n monitoring 3000:80"
echo "Login with admin / admin"
