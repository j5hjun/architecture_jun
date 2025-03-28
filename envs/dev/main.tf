module "vpc" {
  source = "../../modules/vpc"

  name_prefix           = var.name_prefix
  vpc_cidr              = var.vpc_cidr
  azs                   = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  cluster_name          = module.eks.cluster_name
}

module "eks" {
  source = "../../modules/eks"

  name_prefix        = var.name_prefix
  private_subnet_ids = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1]]
  cluster_role_arn   = var.cluster_role_arn
  node_role_arn      = var.node_role_arn
}

module "rds" {
  source = "../../modules/rds"

  name_prefix        = var.name_prefix
  private_subnet_ids = [module.vpc.private_subnet_ids[2], module.vpc.private_subnet_ids[3]]
  db_sg_id           = aws_security_group.rds_sg.id
  db_username        = var.db_username
  db_password        = var.db_password
  db_name            = var.db_name
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow access to RDS from EKS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.eks_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }

  depends_on = [module.eks]
}

resource "kubernetes_namespace" "frontend" {
  metadata {
    name = "frontend"
  }
  depends_on = [module.eks]
}

resource "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
  }
  depends_on = [module.eks]
}

resource "kubernetes_namespace" "ai" {
  metadata {
    name = "ai"
  }
  depends_on = [module.eks]
}

module "alb_controller" {
  source             = "../../modules/alb_controller"
  cluster_name       = module.eks.cluster_name
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.oidc_provider_url
  name_prefix        = var.name_prefix

  depends_on = [module.eks]
}

module "route53" {
  source        = "../../modules/route53"
  domain_name   = var.domain_name
  name_prefix   = var.name_prefix
}

module "acm" {
  source          = "../../modules/acm"
  domain_name     = "argocd.${var.domain_name}"
  name_prefix     = var.name_prefix
  route53_zone_id = module.route53.zone_id

  depends_on = [module.route53]
}

module "argocd" {
  source          = "../../modules/argocd"
  namespace       = "argocd"
  enable_ingress  = true
  certificate_arn = module.acm.certificate_arn

  depends_on = [module.eks]
}

module "route53_records" {
  source        = "../../modules/route53/records"
  zone_id       = module.route53.zone_id
  alb_dns_name  = module.argocd.alb_dns_name
  domain_name   = var.domain_name
}
