variable "cluster_name" {
  type = string
}

variable "k8s_version" {
  default = "1.29"
  type    = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for EKS and Nodes"
}

variable "node_instance_types" {
  default = ["t3.medium"]
  type    = list(string)
}

variable "node_desired_size" {
  default = 2
  type    = number
}

variable "node_max_size" {
  default = 3
  type    = number
}

variable "node_min_size" {
  default = 1
  type    = number
}
