variable "domain_name" {
  type        = string
  description = "Fully qualified domain name (ex: argocd.example.com)"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 hosted zone ID"
}
