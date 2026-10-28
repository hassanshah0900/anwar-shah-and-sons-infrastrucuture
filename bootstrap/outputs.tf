output "state_bucket_name" {
  description = "The name of the S3 bucket used for Terraform remote state."
  value       = aws_s3_bucket.state.id
}
