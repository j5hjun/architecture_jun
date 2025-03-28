resource "aws_route53_zone" "this" {
  name = var.domain_name
  comment = "Hosted zone for ${var.domain_name}"

  tags = {
    Name = "hosted-zone-${var.name_prefix}"
  }
}