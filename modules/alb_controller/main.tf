resource "aws_iam_policy" "alb_ingress" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for ALB Ingress Controller"
  path        = "/"
  policy      = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role" "alb_sa_role" {
  name = "${var.name_prefix}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_sa_role.name
  policy_arn = aws_iam_policy.alb_ingress.arn
}

resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_sa_role.arn
    }
  }

  depends_on = [aws_iam_role_policy_attachment.alb_attach]

  lifecycle {
    prevent_destroy = false
  }
}

resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.1"

  values = [
    yamlencode({
      clusterName = var.cluster_name
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.alb_sa.metadata[0].name
      }
      region = var.region
      vpcId  = var.vpc_id
    })
  ]

  depends_on = [kubernetes_service_account.alb_sa]
}
