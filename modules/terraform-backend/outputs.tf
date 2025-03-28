output "s3_bucket_name" {
  value = var.create_s3_bucket ? aws_s3_bucket.tf_state[0].id : var.bucket_name
}

output "dynamodb_table_name" {
  value = var.create_dynamodb_table ? aws_dynamodb_table.tf_lock[0].name : var.dynamodb_table_name
}