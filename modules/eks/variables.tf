variable "name_prefix" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_role_arn" {
  type = string
  description = "EKS 클러스터용 IAM Role ARN"
}

variable "node_role_arn" {
  type = string
  description = "노드 그룹용 IAM Role ARN"
}
