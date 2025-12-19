variable "environment" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster (for tagging)"
  type        = string
}
