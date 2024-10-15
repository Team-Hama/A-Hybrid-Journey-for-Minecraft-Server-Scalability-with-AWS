resource "helm_release" "kube_ops_view" {
  name       = "kube-ops-view"
  repository = "https://geek-cookbook.github.io/charts/"
  chart      = "kube-ops-view"
  version    = "1.2.2" # 사용할 버전 지정

  namespace  = "monitoring" # kube-ops-view를 설치할 네임스페이스
  depends_on = [ module.eks, module.vpc ]
}

resource "kubernetes_ingress_v1" "kube_ops_ingress" {
  metadata {
    name = "kube-ops-ingress"
    namespace = "monitoring"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kube-ops-view"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }

  depends_on = [ helm_release.kube_ops_view, module.eks, module.vpc]
}