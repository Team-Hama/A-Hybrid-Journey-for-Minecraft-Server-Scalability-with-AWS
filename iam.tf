 variable "admin_users" {
   description = "List of admin users"
   type        = set(string)
   default     = ["admin_1", "admin_2"]
 }
#
# variable "dev_team_a_users" {
#   description = "List of developer group A users"
#   type        = set(string)
#   default     = ["dev_a_1", "dev_a_2", "dev_a_3", "dev_a_4", "dev_a_5"]
# }
#
 module "eks_admins" {
   for_each = toset(var.admin_users)

   source  = "terraform-aws-modules/iam/aws//modules/iam-user"
   version = "5.44.0"

   name                          = each.key
   create_user                   = true
   create_iam_access_key         = false
   create_iam_user_login_profile = true
   force_destroy                 = true

   password_length         = 8
   password_reset_required = false
 }
#
# module "eks_dev_team_a_users" {
#   for_each = toset(var.dev_team_a_users)
#
#   source  = "terraform-aws-modules/iam/aws//modules/iam-user"
#   version = "5.44.0"
#
#   name                          = each.key
#   create_user                   = true
#   create_iam_access_key         = false
#   create_iam_user_login_profile = true
#   force_destroy                 = true
#
#   password_length         = 8
#   password_reset_required = false
# }
#
 module "admin_team" {
   source = "aws-ia/eks-blueprints-teams/aws"

   name = "${var.project_name}-admin-team"

   # Enables elevated, admin privileges for this team
   enable_admin = true
   users        = [for user in module.eks_admins : user.iam_user_arn]
   cluster_arn  = module.eks.cluster_arn

   tags = local.tags

   depends_on = [
     module.eks.cluster_arn,
     module.eks_admins
   ]
 }
#
# module "development_team" {
#   source = "aws-ia/eks-blueprints-teams/aws"
#
#   name = "${var.project_name}-development-team-A"
#
#   users             = [for user in module.eks_dev_team_a_users : user.iam_user_arn]
#   cluster_arn       = module.eks.cluster_arn
#   oidc_provider_arn = module.eks.oidc_provider_arn
#
#   # Labels applied to all Kubernetes resources
#   # More specific labels can be applied to individual resources under `namespaces` below
#   labels = {
#     team = "development_team_a"
#   }
#
#   # Annotations applied to all Kubernetes resources
#   # More specific labels can be applied to individual resources under `namespaces` below
#   annotations = {
#     team = "development_team_a"
#   }
#
#   namespaces = {
#     default = {
#       # Provides access to an existing namespace
#       create = false
#     }
#
#     development = {
#       labels = {
#         projectName = "project-A",
#       }
#
#       resource_quota = {
#         hard = {
#           "requests.cpu"    = "1000m",
#           "requests.memory" = "4Gi",
#           "limits.cpu"      = "2000m",
#           "limits.memory"   = "8Gi",
#           "pods"            = "10",
#           "secrets"         = "10",
#           "services"        = "10"
#         }
#       }
#
#       limit_range = {
#         limit = [
#           {
#             type = "Pod"
#             max = {
#               cpu    = "200m"
#               memory = "1Gi"
#             }
#           },
#           {
#             type = "PersistentVolumeClaim"
#             min = {
#               storage = "24M"
#             }
#           },
#           {
#             type = "Container"
#             default = {
#               cpu    = "50m"
#               memory = "24Mi"
#             }
#           }
#         ]
#       }
#
#       network_policy = {
#         pod_selector = {
#           match_expressions = [{
#             key      = "name"
#             operator = "In"
#             values   = ["webfront", "api"]
#           }]
#         }
#
#         ingress = [{
#           ports = [
#             {
#               port     = "http"
#               protocol = "TCP"
#             },
#             {
#               port     = "53"
#               protocol = "TCP"
#             },
#             {
#               port     = "53"
#               protocol = "UDP"
#             }
#           ]
#
#           from = [
#             {
#               namespace_selector = {
#                 match_labels = {
#                   name = "default"
#                 }
#               }
#             },
#             {
#               ip_block = {
#                 cidr = "10.0.0.0/8"
#                 except = [
#                   "10.0.0.0/24",
#                   "10.0.1.0/24",
#                 ]
#               }
#             }
#           ]
#         }]
#
#         egress = [] # single empty rule to allow all egress traffic
#
#         policy_types = ["Ingress", "Egress"]
#       }
#     }
#   }
#
#   tags = merge({
#     dev_team = "development_team_a"
#   }, local.tags)
# }
#
#
# ################################################################################
# # admin_team outputs
# ################################################################################
 output "namespaces" {
   description = "Map of Kubernetes namespaces created and their attributes"
   value       = module.admin_team.namespaces
 }
 output "rbac_group" {
   description = "The name of the Kubernetes RBAC group"
   value       = module.admin_team.rbac_group
 }
 output "aws_auth_configmap_role" {
   description = "Dictionary containing the necessary details for adding the role created to the `aws-auth` configmap"
   value       = module.admin_team.aws_auth_configmap_role
 }
 output "iam_role_name" {
   description = "The name of the IAM role"
   value       = module.admin_team.iam_role_name
 }
 output "iam_role_arn" {
   description = "The Amazon Resource Name (ARN) specifying the IAM role"
   value       = module.admin_team.iam_role_arn
 }
 output "iam_role_unique_id" {
   description = "Stable and unique string identifying the IAM role"
   value       = module.admin_team.iam_role_unique_id
 }