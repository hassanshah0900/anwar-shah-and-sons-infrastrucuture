variable "project_name" {
  type        = string
  description = "The name of the project used for resource naming and tagging."
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., prod, staging, dev)."
}

variable "cloudfront_distribution_arn" {
  type        = string
  description = "The ARN of the CloudFront distribution allowed to read objects from this frontend bucket via OAC."
}
