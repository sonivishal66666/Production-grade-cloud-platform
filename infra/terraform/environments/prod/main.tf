terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Note: Ideally you would enable backend "s3" here for state locking
  # backend "s3" { ... }
}

provider "aws" {
  region = "us-east-1"
}

# --- VPC Module ---
module "vpc" {
  source = "../../modules/vpc"

  environment          = "prod"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.11.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
  cluster_name         = "prod-furever-cluster"
}

# --- EKS Module ---
module "eks" {
  source = "../../modules/eks"

  cluster_name        = "prod-furever-cluster"
  subnet_ids          = module.vpc.private_subnets # Workers in Private Subnets!
  node_instance_types = ["t3.medium"]
  node_desired_size   = 2
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
