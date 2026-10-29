variable "project_name" {
  type        = string
  description = "Name of the project used for resource naming prefix"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)"
}

variable "db_arn" {
  type        = string
  description = "ARN of the Aurora database for IAM access control"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where network resources are deployed"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the application launch template"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the Application Load Balancer"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the Auto Scaling Group"
}
