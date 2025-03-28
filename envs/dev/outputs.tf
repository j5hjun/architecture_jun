output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_sg_id" {
  value       = aws_security_group.rds_sg.id
}

output "oidc_provider_url" {
  value = module.eks.oidc_provider_url
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}

output "argocd_dns" {
  value = module.route53_records.record_fqdn
}