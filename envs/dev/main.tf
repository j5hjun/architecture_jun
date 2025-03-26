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
    cidr_blocks = ["10.0.0.0/16"]  # EKS 내부 통신용 CIDR
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
}

data "aws_eks_cluster" "cluster" {
  name = "dev-eks"

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

resource "kubernetes_namespace" "frontend" {
  metadata {
    name = "frontend"
  }
}

resource "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
  }
}

resource "kubernetes_namespace" "ai" {
  metadata {
    name = "ai"
  }
}

module "alb_controller" {
  source             = "../../modules/alb_controller"
  cluster_name       = module.eks.cluster_name
  region             = "ap-northeast-2"
  vpc_id             = module.vpc.vpc_id
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.oidc_provider_url
  name_prefix        = var.name_prefix
}

module "frontend_ingress" {
  source        = "../../modules/ingress"
  name_prefix   = "frontend"
  namespace     = "frontend"
  service_name  = "frontend-service"
  service_port  = 80
}

module "argocd" {
  source    = "../../modules/argocd"
  namespace = "argocd"
}

