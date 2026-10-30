variable "project_name" {
  type        = string
  description = "The name of the project used for resource naming and tagging."
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., prod, staging, dev)."
}

variable "backend_alb_domain_name" {
  type        = string
  description = "The DNS name of the Application Load Balancer serving as the backend origin."
}
