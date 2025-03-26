variable "name_prefix" {
  type        = string
  description = "이름 앞에 붙는 prefix (예: dev)"
}

variable "cluster_name" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR 블록"
}

variable "azs" {
  type        = list(string)
  description = "사용할 가용 영역 리스트 (예: ['ap-northeast-2a', 'ap-northeast-2c'])"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "퍼블릭 서브넷 CIDR 리스트"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "프라이빗 서브넷 CIDR 리스트"
}
