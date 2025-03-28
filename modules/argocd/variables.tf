variable "namespace" {
  type    = string
  default = "argocd"
}

variable "enable_ingress" {
  description = "Whether to enable ALB ingress for ArgoCD UI"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "ACM Certificate ARN to use for Ingress TLS"
  type        = string
}
