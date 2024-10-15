# Karpenter settings
# https://github.com/aws-samples/karpenter-blueprints/blob/main/cluster/terraform/karpenter.tf
###########################################################
## default
###########################################################
resource "kubectl_manifest" "karpenter_default_ec2_node_class" {
  yaml_body = templatefile("${path.module}/karpenter/karpenter_ec2_node_class.tftpl", {
    name = "default"
    node_iam_role_name = local.node_iam_role_name
    project_name       = var.project_name
  })

  depends_on = [
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
  ]
}

resource "kubectl_manifest" "karpenter_default_node_pool" {
  yaml_body = templatefile("${path.module}/karpenter/karpenter_node_pool_template.tftpl", {
    name                                = "default"
    karpenter_arch_choices              = var.default_arch_choices
    karpenter_instance_cpu_choices      = var.default_instance_cpu_choices
    karpenter_capacity_type_choices     = var.default_capacity_type_choices
    karpenter_instance_category_choices = var.default_instance_category_choices
    karpenter_instance_az               = ["${var.deploy_region}a","${var.deploy_region}c"]
  })

  depends_on = [
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
    kubectl_manifest.karpenter_default_ec2_node_class,
  ]
}

###########################################################
## farm
###########################################################
resource "kubectl_manifest" "karpenter_farm_ec2_node_class" {
  yaml_body = templatefile("${path.module}/karpenter/karpenter_ec2_node_class.tftpl", {
    name = "farm"
    node_iam_role_name = local.node_iam_role_name
    project_name       = var.project_name
  })

  depends_on = [
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
  ]
}

resource "kubectl_manifest" "karpenter_farm_node_pool" {
  yaml_body = templatefile("${path.module}/karpenter/karpenter_node_pool_template.tftpl", {
    name                                = "farm"
    karpenter_arch_choices              = var.farm_arch_choices
    karpenter_instance_cpu_choices      = var.farm_instance_cpu_choices
    karpenter_capacity_type_choices     = var.farm_capacity_type_choices
    karpenter_instance_category_choices = var.farm_instance_category_choices
    karpenter_instance_az               = var.farm_instance_az
  })

  depends_on = [
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
    kubectl_manifest.karpenter_farm_ec2_node_class,
  ]
}

###########################################################
## wild
###########################################################
resource "kubectl_manifest" "karpenter_wild_ec2_node_class" {
  yaml_body = templatefile("${path.module}/karpenter/karpenter_ec2_node_class.tftpl", {
    name = "wild"
    node_iam_role_name = local.node_iam_role_name
    project_name       = var.project_name
  })

  depends_on = [
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
  ]
}

resource "kubectl_manifest" "karpenter_wild_node_pool" {
  yaml_body = templatefile("${path.module}/karpenter/karpenter_node_pool_template.tftpl", {
    name                                = "wild"
    karpenter_arch_choices              = var.wild_arch_choices
    karpenter_instance_cpu_choices      = var.wild_instance_cpu_choices
    karpenter_capacity_type_choices     = var.wild_capacity_type_choices
    karpenter_instance_category_choices = var.wild_instance_category_choices
    karpenter_instance_az               = var.wild_instance_az
  })

  depends_on = [
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
    kubectl_manifest.karpenter_wild_ec2_node_class,
  ]
}