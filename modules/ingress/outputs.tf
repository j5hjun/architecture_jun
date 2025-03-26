output "ingress_name" {
  value = kubernetes_ingress_v1.app.metadata[0].name
}
