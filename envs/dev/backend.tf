module "backend" {
  source              = "../../modules/terraform-backend"
  bucket_name         = "terraform-architecture-jun-state"
  dynamodb_table_name = "terraform-architecture-jun-lock"
  create_s3_bucket        = false
  create_dynamodb_table   = false
}

terraform {
  backend "s3" {
    bucket         = "terraform-architecture-jun-state"
    key            = "envs/dev/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-architecture-jun-lock"
    encrypt        = true
  }
}