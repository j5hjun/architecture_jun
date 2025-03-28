variable "zone_id" {
  type        = string
  description = "The Route53 Hosted Zone ID"
}

variable "domain_name" {
  type        = string
  description = "The root domain name (e.g., junjo.kro.kr)"
}

variable "alb_dns_name" {
  type        = string
  description = "The DNS name of the ALB"
}

variable "subdomain" {
  type        = string
  default     = "argocd"
  description = "하위 도메인 이름 (예: argocd)"
}