resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = var.namespace
  version    = "5.51.5" # 최신 안정 버전 확인 가능

  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
          ports = {
            http = 80
            https = 443
          }
        }
        ingress = {
          enabled     = true
          ingressClassName = "alb"
          annotations = {
            "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
            "alb.ingress.kubernetes.io/target-type"  = "ip"
            "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}]"
          }
          paths = ["/"]
          pathType = "Prefix"
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
}