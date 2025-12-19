# Production-Grade Cloud Platform

This project implements a fully automated, self-healing, and secure cloud platform on AWS using Kubernetes, Terraform, and Ansible.

## Architecture

- **Infrastructure**: AWS VPC (Multi-AZ), EKS (Managed Node Groups), NAT Gateways.
- **IaC**: Terraform (Modular design).
- **Configuration**: Ansible (Bastion setup).
- **CI/CD**: GitHub Actions (Lint, Test, Build, Deploy).
- **Observability**: Prometheus, Grafana, CloudWatch.

## Project Structure

```text
├── app/                # Application Source Code
│   ├── backend/        # Python Flask API
│   ├── frontend/       # React App
│   └── kubernetes/     # K8s Manifests (Deployment, Svc, Ingress)
├── infra/              # Infrastructure Code
│   ├── terraform/      # Terraform Modules & Envs
│   └── ansible/        # Ansible Playbooks
├── scripts/            # Helper Scripts (Monitoring, Ingress)
└── docs/               # Documentation (Chaos Engineering, etc.)
```

## Getting Started

### 1. Prerequisites
- AWS CLI configured with Admin permissions.
- Terraform v1.5+.
- Docker installed.

### 2. Deploy Infrastructure
```bash
cd infra/terraform/environments/prod
terraform init
terraform apply
```

### 3. Configure Kubernetes
```bash
# Update local kubeconfig
aws eks update-kubeconfig --region us-east-1 --name prod-furever-cluster

# Install Ingress & Monitoring
./scripts/install_ingress.sh
./scripts/install_monitoring.sh
```

### 4. Deploy Application
The CI/CD pipeline runs on push to `main`.
To deploy manually:
```bash
kubectl apply -f app/kubernetes/
```

### 5. Verify & Test
See [docs/chaos_engineering.md](docs/chaos_engineering.md) to run failure simulations.
