locals {
  node_iam_role_name = module.eks_blueprints_addons.karpenter.node_iam_role_name

  # NOTE: You might need to change this less number of AZs depending on the region you're deploying to
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    blueprint = var.project_name
  }
}

