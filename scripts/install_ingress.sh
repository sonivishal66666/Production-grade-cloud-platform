#!/bin/bash
set -e

echo "Installing Nginx Ingress Controller..."

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Create namespace
kubectl create namespace ingress-nginx || true

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.service.type=LoadBalancer

echo "Ingress Controller Installed!"
