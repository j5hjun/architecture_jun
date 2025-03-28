output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value = try(
    kubernetes_ingress_v1.argocd_ingress[0].status[0].load_balancer[0].ingress[0].hostname,
    "pending.alb.local"
  )
}
