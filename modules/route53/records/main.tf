resource "aws_route53_record" "argocd" {
  zone_id = var.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300

  records = [var.alb_dns_name]
}