variable "database_master_user" {
  default = "admin"
}

variable "database_master_password" {
  default = "MyS3KretPa55w0rD"
}

resource "aws_ssm_parameter" "db_admin_json" {
  name        = "/eks-cluster/json_credentials"
  description = "EKS cluster username and password in json"
  type        = "String"
  value = jsonencode({
    username = "secretuser",
    password = "secretpassword"
  })
  tags = local.tags
}

resource "aws_ssm_parameter" "db_admin_username" {
  name        = "/eks-cluster/db-admin"
  description = "EKS cluster DB admin username"
  type        = "String"
  value       = var.database_master_user
  tags        = local.tags
}

resource "aws_ssm_parameter" "db_admin_password" {
  name        = "/eks-cluster/db-password"
  description = "EKS cluster DB admin password"
  type        = "SecureString"
  value       = var.database_master_password
  tags        = local.tags
}