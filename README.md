# 🚀 Product-Grade Cloud Platform (AWS EKS + Terraform)

![Terraform](https://img.shields.io/badge/IaC-Terraform_1.9.0-purple?style=for-the-badge&logo=terraform)
![Kubernetes](https://img.shields.io/badge/K8s-AWS_EKS_1.30-blue?style=for-the-badge&logo=kubernetes)
![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-black?style=for-the-badge&logo=githubactions)
![Docker](https://img.shields.io/badge/Container-Docker-blue?style=for-the-badge&logo=docker)
![Prometheus](https://img.shields.io/badge/Observability-Prometheus-orange?style=for-the-badge&logo=prometheus)
![Ansible](https://img.shields.io/badge/Config-Ansible-red?style=for-the-badge&logo=ansible)

> **Live Demo**: [Click Here](http://k8s-ingress-nginx-controller-a13ec5b81f-675516227.us-east-1.elb.amazonaws.com/) *(Note: If link is down, infrastructure may be destroyed to save costs)*

## 📖 Overview
This repository hosts the source code for a highly available, self-healing, and observable cloud platform. It demonstrates a **GitOps-driven** approach to infrastructure and application delivery, built to withstand production-grade traffic and failures.

**Key Engineering Highlights:**
*   **Zero-Touch Provisioning**: Entire stack (VPC, EKS, IAM) bootstrapped via **Terraform**.
*   **Self-Healing Compute**: **Kubernetes HPA** (Horizontal Pod Autoscaler) scales pods based on CPU load.
*   **Immutable Infrastructure**: Application updates delivered via **Docker** containers using a Rolling Update strategy.
*   **Observability First**: Integrated **Prometheus** & **Grafana** stack for real-time metrics and alerting.
*   **Security by Design**: Least-privilege IAM roles (IRSA) and private subnets for worker nodes.

---

## 🏗️ System Architecture

The architecture is designed for **High Availability (HA)** across multiple Availability Zones.

```mermaid
graph TD
    User([👱 User]) -->|HTTPS/443| ALB[AWS Application Load Balancer]
    
    subgraph VPC [AWS VPC (us-east-1)]
        ALB -->|Route| Ingress[Nginx Ingress Controller]
        
        subgraph Public_Subnet [Public Subnets]
            NAT[NAT Gateway]
            Bastion[Ansible Bastion Host]
        end

        subgraph EKS_Cluster [EKS Cluster (Private Subnets)]
            Ingress -->|Service Routing| Frontend[⚛️ React UI]
            Ingress -->|Service Routing| Backend[🐍 Python API]
            
            Backend <-->|Metrics| Prometheus[🔥 Prometheus]
            Prometheus -->|Viz| Grafana[📊 Grafana Dashboard]
            
            HPA[⚖️ HPA] -.->|Scaling Signal| Backend
        end
    end
    
    Backend -->|Outbound Traffic| NAT
```

---

## 🛠️ Technology Stack & Decisions

| Component | Tooling | Justification |
|-----------|---------|---------------|
| **IaC** | Terraform | State management (S3+DynamoDB) and modularity for reproducible infrastructure. |
| **Config Mgmt** | Ansible | Idempotent configuration of EC2 Bastion hosts and initial node bootstrapping. |
| **Orchestration** | AWS EKS | Managed control plane reduces operational overhead; focus on workload management. |
| **CI/CD** | GitHub Actions | Native integration with repo; Matrix builds for testing; OIDC for secure AWS auth. |
| **Ingress** | Nginx Controller | Flexible path-based routing, rewrite rules, and high-performance SSL termination. |
| **Monitoring** | Prometheus Stack | Industry standard for scraping `/metrics` endpoints from cloud-native apps. |

---

## ⚡ CI/CD Pipeline (GitOps)

The pipeline is triggered on every push to `main`.

1.  **Code Analysis**: Pylint (Python) and ESLint (React) for static analysis.
2.  **Container Build**:
    *   Build Docker images.
    *   Tag with Git SHA + `latest`.
    *   Push to **AWS ECR** (Elastic Container Registry).
3.  **Delivery**:
    *   Update Kubernetes manifests.
    *   `kubectl rollout restart` to trigger zero-downtime deployment.

---

## 📂 Repository Structure

```tree
.
├── .github/workflows/   # CI/CD definitions
├── app/                 # Application Monorepo
│   ├── frontend/        # React.js (Mission Control UI)
│   ├── backend/         # Python Flask API
│   └── kubernetes/      # Helm Charts & Raw Manifests
├── infra/
│   ├── terraform/       # Infrastructure as Code
│   │   ├── modules/     # Reusable VPC/EKS modules
│   │   └── envs/prod/   # Production state files
│   └── ansible/         # Playbooks for VM config
└── scripts/             # Automation helpers
```

---

## 🚀 Deployment Guide

### Prerequisites
*   AWS CLI v2
*   Terraform v1.9+
*   Kubectl & Helm

### 1. Provision Infrastructure
```bash
cd infra/terraform/environments/prod
terraform init
terraform apply --auto-approve
```

### 2. Configure Cluster
```bash
# Update Kubeconfig
aws eks update-kubeconfig --region us-east-1 --name prod-furever-cluster

# Deploy Ingress & Monitoring
./scripts/install_ingress.sh
./scripts/install_monitoring.sh
```

### 3. Deploy Workloads
```bash
kubectl apply -f app/kubernetes/
```

### 4. Verify Access
```bash
kubectl get ingress
# Copy the Address URL
```

---

## 🧪 Chaos Engineering (Resilience Testing)

We validate system stability using manual chaos experiments.

**Scenario 1: Pod Failure**
```bash
# Kill a random backend pod
kubectl delete pod -l app=backend
# Result: Kubernetes seamlessly restarts the pod; Service remains available.
```

**Scenario 2: High Load Autoscaling**
```bash
# Generate synthetic traffic
kubectl run load-generator --image=busybox -- /bin/sh -c "while true; do wget -q -O- http://backend; done"
# Result: HPA detects CPU spike > 50% and scales replicas from 2 -> 5.
```

---

## 🧹 Teardown
To destroy all resources and avoid AWS costs:

```bash
cd infra/terraform/environments/prod
terraform destroy
```

---

## 🔮 Future Roadmap
*   [ ] Implement **ArgoCD** for true Pull-based GitOps.
*   [ ] Add **Terrascan** for IaC security auditing.
*   [ ] Integrate **ELK Stack** for centralized logging.

---
*Maintained by an aspiring DevOps Engineer ☁️*