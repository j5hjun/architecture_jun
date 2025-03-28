output "record_fqdn" {
  value       = try(aws_route53_record.argocd.fqdn, "")
  description = "Route53 레코드의 FQDN"
}
