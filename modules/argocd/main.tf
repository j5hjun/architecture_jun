resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.2"

  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "kubernetes_ingress_v1" "argocd_ingress" {
  count = var.enable_ingress ? 1 : 0

  metadata {
    name      = "argocd-ingress"
    namespace = var.namespace

    annotations = {
  "kubernetes.io/ingress.class"                    = "alb"
  "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
  "alb.ingress.kubernetes.io/target-type"          = "ip"
  "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTPS\": 443}]"
  "alb.ingress.kubernetes.io/group.name"           = "argocd"
  "alb.ingress.kubernetes.io/certificate-arn"       = var.certificate_arn
  }
  }

  spec {
    rule {
      host = "argocd.junjo.kro.kr"
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "argocd-server"
              port {
                number = 443
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}
