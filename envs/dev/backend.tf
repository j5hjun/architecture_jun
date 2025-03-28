module "backend" {
  source              = "../../modules/terraform-backend"
  bucket_name         = "terraform-architecture-jun-state"
  dynamodb_table_name = "terraform-architecture-jun-lock"
  create_s3_bucket        = false
  create_dynamodb_table   = false
}