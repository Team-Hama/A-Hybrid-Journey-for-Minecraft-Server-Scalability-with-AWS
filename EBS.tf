resource "aws_ebs_volume" "wild_ebs" {
  availability_zone = "${var.deploy_region}a"
  size              = 100

  tags = {
    Name = "wild"
  }
}
resource "aws_ebs_volume" "farm_ebs" {
  availability_zone = "${var.deploy_region}c"
  size              = 100

  tags = {
    Name = "farm"
  }
}

resource "kubernetes_namespace_v1" "game_namespace" {
  metadata {
    name = "game"
  }

  depends_on = [ module.eks ]
}

resource "kubectl_manifest" "karpenter_wild_pv" {
  yaml_body = templatefile("${path.module}/storage/karpenter_pv_template.tftpl", {
    name                                = "wild"
    volume_id                           = "${aws_ebs_volume.wild_ebs.id}"
    region                              = "${var.deploy_region}a"
  })

  depends_on = [
    aws_ebs_volume.wild_ebs,
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
    kubectl_manifest.karpenter_default_ec2_node_class,
    kubernetes_namespace_v1.game_namespace
  ]
}

resource "kubectl_manifest" "karpenter_wild_pvc" {
  yaml_body = templatefile("${path.module}/storage/karpenter_pvc_template.tftpl", {
    name                                = "wild"
  })

  depends_on = [
    aws_ebs_volume.wild_ebs,
    kubectl_manifest.karpenter_wild_pv,
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
    kubectl_manifest.karpenter_default_ec2_node_class,
    kubernetes_namespace_v1.game_namespace
  ]
}

resource "kubectl_manifest" "karpenter_farm_pv" {
  yaml_body = templatefile("${path.module}/storage/karpenter_pv_template.tftpl", {
    name                                = "farm"
    volume_id                           = "${aws_ebs_volume.farm_ebs.id}"
    region                              = "${var.deploy_region}c"
  })

  depends_on = [
    aws_ebs_volume.farm_ebs,
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
    kubectl_manifest.karpenter_default_ec2_node_class,
    kubernetes_namespace_v1.game_namespace
  ]
}

resource "kubectl_manifest" "karpenter_farm_pvc" {
  yaml_body = templatefile("${path.module}/storage/karpenter_pvc_template.tftpl", {
    name                                = "farm"
  })

  depends_on = [
    aws_ebs_volume.farm_ebs,
    kubectl_manifest.karpenter_farm_pv,
    module.eks.cluster_id,
    module.eks_blueprints_addons.karpenter,
    kubectl_manifest.karpenter_default_ec2_node_class,
    kubernetes_namespace_v1.game_namespace
  ]
}