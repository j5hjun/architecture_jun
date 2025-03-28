output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "kubeconfig" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.oidc.url
}

output "raw_oidc_url" {
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
  description = "EKS OIDC Provider URL"
}
