terraform {
  backend "s3" {
    bucket         = "terraform-architecture-jun-state"  # S3 버킷 이름
    key            = "dev/terraform.tfstate"         # 상태 파일 경로
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-architecture-jun-lock"                # DynamoDB 테이블 이름
  }
}
