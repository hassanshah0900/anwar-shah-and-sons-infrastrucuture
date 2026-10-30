variable "project_name" {
  type        = string
  description = "The name of the project used for resource naming and tagging."
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., prod, staging, dev)."
}

variable "frontend_bucket_regional_domain_name" {
  type = string
}

variable "storage_bucket_regional_domain_name" {
  type = string
}

variable "backend_alb_domain_name" {
  type = string
}
