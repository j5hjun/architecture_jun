resource "aws_eks_cluster" "this" {
  name     = "${var.name_prefix}-eks"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  version = "1.30"

  tags = {
    Name = "${var.name_prefix}-eks"
  }
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name_prefix}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  tags = {
    Name = "${var.name_prefix}-node-group"
  }
}

resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10df6"]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  
  depends_on = [aws_eks_cluster.this]
}
