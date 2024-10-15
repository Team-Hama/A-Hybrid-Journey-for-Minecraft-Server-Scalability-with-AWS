variable "account_id" {
  type = string
}

variable "project_name" {
  description = "Project name that the EKS cluster will use"
  type        = string
  default     = "eks-cluster"
}

variable "eks_cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.27`)"
  type        = string
  default     = "1.30"
}

variable "node_group_name" {
  description = "Kubernetes node group name"
  type        = string
  default     = "managed-ondemand"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC that the EKS cluster will use"
  type        = string
  default     = "10.0.0.0/16"
}

variable "deploy_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "aws_alb_controller_name" {
  description = "AWS ALB controller name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "aws_load_balancer_controller_image_tag" {
  description = "Desired AWS ALB Controller image tag to pull"
  type        = string
  default     = "v2.8.2"
}

variable "eks_managed_nodes_instance_types" {
  description = "Desired instance type(s) to use as worker node(s)"
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "eks_managed_nodes_capacity_type" {
  description = "Desired AWS ALB Controller image tag to pull"
  type        = string
  default     = "SPOT"
  validation {
    condition     = contains(["SPOT", "ON_DEMAND"], var.eks_managed_nodes_capacity_type)
    error_message = "Valid values for eks_managed_nodes_capacity_type are (SPOT, ON_DEMAND)"
  }
}

variable "kube_prometheus_stack_chart_version" {
  description = "Desired Kube Prometheus Stack Help chart version"
  type        = string
  default     = "62.6.0"
}

variable "karpenter_chart_version" {
  description = "Desired Karpenter Help chart version"
  type        = string
  default     = "1.0.1"
}

variable "external_secrets_service_account_name" {
  description = "external secrets addon service account name"
  type        = string
  default     = "external-secrets-sa"
}

variable "external_secrets_helm_chart_version" {
  description = "external secrets helm chart version"
  type        = string
  default     = "0.10.3"
}

###########################################################
## default
###########################################################

variable "default_arch_choices" {
  description = "Allowed Karpenter node architecture choices"
  type        = list(string)
  default     = ["amd64"]
}

variable "default_instance_cpu_choices" {
  description = "Allowed Karpenter instance cpu choices"
  type        = list(string)
  default     = ["2", "4"]
  # default     = ["2", "4", "8", "16", "32", "48", "64"]
}

variable "default_capacity_type_choices" {
  description = "Allowed Karpenter instance category choices"
  type        = list(string)
  default     = ["spot", "on-demand"]
}

variable "default_instance_category_choices" {
  description = "Allowed Karpenter instance categories"
  type        = list(string)
  default     = ["c", "t"]
  # default     = ["c", "t", "m", "r", "i", "d"]
}

variable "default_instance_az" {
  description = "Allowed karpenter node availability zone"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}



###########################################################
## farm
###########################################################

variable "farm_arch_choices" {
  description = "Allowed Karpenter node architecture choices"
  type        = list(string)
  default     = ["amd64"]
}

variable "farm_instance_cpu_choices" {
  description = "Allowed Karpenter instance cpu choices"
  type        = list(string)
  default     = ["4", "8", "16", "32"]
  # default     = ["2", "4", "8", "16", "32", "48", "64"]
}

variable "farm_capacity_type_choices" {
  description = "Allowed Karpenter instance category choices"
  type        = list(string)
  default     = ["on-demand"]
}

variable "farm_instance_category_choices" {
  description = "Allowed Karpenter instance categories"
  type        = list(string)
  default     = ["c", "t", "m"]
  # default     = ["c", "t", "m", "r", "i", "d"]
}

variable "farm_instance_az" {
  description = "Allowed karpenter node availability zone"
  type        = list(string)
  default     = ["ap-northeast-2c"]
}

###########################################################
## wild
###########################################################

variable "wild_arch_choices" {
  description = "Allowed Karpenter node architecture choices"
  type        = list(string)
  default     = ["amd64"]
}

variable "wild_instance_cpu_choices" {
  description = "Allowed Karpenter instance cpu choices"
  type        = list(string)
  default     = ["4", "8", "16", "32"]
  # default     = ["2", "4", "8", "16", "32", "48", "64"]
}

variable "wild_capacity_type_choices" {
  description = "Allowed Karpenter instance category choices"
  type        = list(string)
  default     = ["on-demand"]
}

variable "wild_instance_category_choices" {
  description = "Allowed Karpenter instance categories"
  type        = list(string)
  default     = ["c", "t", "m"]
  # default     = ["c", "t", "m", "r", "i", "d"]
}

variable "wild_instance_az" {
  description = "Allowed karpenter node availability zone"
  type        = list(string)
  default     = ["ap-northeast-2a"]
}

###########################################################
## RDS
###########################################################

variable "db_name" {
  description = "AWS RDS Database Name"
  type        = string
  default     = "gamelogdb"
}
# DB Instance Identifier
variable "db_instance_identifier" {
  description = "AWS RDS Database Instance Identifier"
  type        = string
  default     = "gamelogdb"
}
# DB Username - Enable Sensitive flag
variable "db_username" {
  description = "AWS RDS Database Administrator Username"
  type        = string
  default     = "user1"
}
# DB Password - Enable Sensitive flag
variable "db_password" {
  description = "AWS RDS Database Administrator Password"
  type        = string
  # sensitive   = true - secrets.tfvars
  default     = "test1234"
}


###########################################################
## argocd
###########################################################

variable "argocd_deploy_name" {
  type = string
  default = "argocd"
}

variable "argocd_helm_chart_name" {
  type = string
  default = "argo-cd"
}

variable "argocd_helm_repo_url" {
  type = string
  default = "https://argoproj.github.io/argo-helm"
}

variable "argocd_target_namespace" {
  type = string
  default = "argocd"
}

variable "argocd_server_insecure" {
  type = bool
  default = true
}

###########################################################
## transit gateway
###########################################################

variable "on-premise_ip" {
  description = "On-premise_ip of VyOS"
  type = string
  default = "175.117.83.206"
}