resource "aws_s3_bucket" "tf_state" {
  count         = var.create_s3_bucket ? 1 : 0
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
    count  = var.create_s3_bucket ? 1 : 0
    bucket        = aws_s3_bucket.tf_state[0].id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
    count  = var.create_s3_bucket ? 1 : 0
    bucket        = aws_s3_bucket.tf_state[0].id

    rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
    }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
    count  = var.create_s3_bucket ? 1 : 0
    bucket                      = aws_s3_bucket.tf_state[0].id
    block_public_acls           = true
    block_public_policy         = true
    ignore_public_acls          = true
    restrict_public_buckets     = true
}

resource "aws_dynamodb_table" "tf_lock" {
  count          = var.create_dynamodb_table ? 1 : 0
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
  }
} 

